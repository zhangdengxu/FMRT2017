//
//  ViewController.m
//  scrollTest
//
//  Created by leetangsong_macbk on 16/5/19.
//  Copyright © 2016年 macbook. All rights reserved.


#import "FMMyRecommentCalendarViewController.h"
#import "LTSCalendarDayView.h"
#import "LTSCalendarContentView.h"

#import "LTSCalendarEventSource.h"
#import "LTSCalendarMonthView.h"
#import "LTSCalendarWeekView.h"
#import "FMCalenderHeaderView.h"
#import "NSDate+CategoryPre.h"
#import "FMCalenderTypesALLTableViewCell.h"
#import "FMCalenderTypesSingleTableViewCell.h"
#import "HooDatePicker.h"
#import "NSString+Extension.h"


#define kTopBarWithStatusHeight 64
#define KTopCalenderHeaderView 50
#define CriticalHeight 50  //滚动的 临界高度
@interface FMMyRecommentCalendarViewController ()<UITableViewDelegate,UITableViewDataSource,LTSCalendarEventSource,HooDatePickerDelegate>{
    NSMutableDictionary *eventsByDate;
}


@property (nonatomic,strong) UIView *headerView;
// 手指触摸 开始滚动 tableView 的offectY
@property (nonatomic,assign)CGFloat dragStartOffectY;
// 手指离开 屏幕 tableView 的offectY
@property (nonatomic,assign)CGFloat dragEndOffectY;

@property (nonatomic, strong) FMCalenderHeaderView * calenderHeaderView;
@property (nonatomic,copy) NSString *currentMonth;


@property (nonatomic, strong) NSMutableDictionary * dataSource;
@property (nonatomic, strong) FMMonthDateModel * dateModelMonth;
@property (nonatomic, strong) NSMutableArray * dateMonthDaySource;
@property (nonatomic, strong) HooDatePicker *datePicker;

@end

@implementation FMMyRecommentCalendarViewController

static NSString * FMCalenderTypesALLTableViewCellRegister = @"FMCalenderTypesALLTableViewCellRegister";
static NSString * FMCalenderTypesSingleTableViewCellRegister = @"FMCalenderTypesSingleTableViewCellRegister";

-(NSMutableArray *)dateMonthDaySource
{
    if (!_dateMonthDaySource) {
        _dateMonthDaySource = [NSMutableArray array];
    }
    return _dateMonthDaySource;
}


-(void)calendarDidLoadPage:(LTSCalendarManager *)calendar
{
    self.dateModelMonth = nil;
    [self.dateMonthDaySource removeAllObjects];
    
    self.currentMonth =  [calendar.currentDateSelected retCurrentdateWithYYYY_MMNianyue];
    self.calenderHeaderView.currentString = self.currentMonth;
    
    [self getDateSourceFromNetWork:self.currentMonth withLastOrRight:0];
}
-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary new];
    }
    return _dataSource;
}

-(HooDatePicker *)datePicker
{
    if (!_datePicker) {
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        _datePicker = [[HooDatePicker alloc] initWithSuperView:keyWindow];
        _datePicker.delegate = self;
        _datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
        NSDate *minDate = [dateFormatter dateFromString:@"1990-01-01"];
        
        
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
    }
    return _datePicker;
}


- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.currentMonth = value;
    self.calenderHeaderView.currentString = value;
    self.calendar.currentDate = date;
    [self getDateSourceFromNetWork:self.currentMonth withLastOrRight:0];
}


//头部点击事件；
-(void)headerViewCalenderButtonOnClick:(NSInteger)index
{
    if (index == 1) {
        
        //中间
        if (self.currentMonth.length > 0) {
            
            [self.datePicker setDate:[NSDate retNSStringToNSdateWithYYYY_MM_Nianyue:self.currentMonth] animated:YES];
            
            [self.datePicker show];
        }
        

        
    }else if(index == 2)
    {
        //左边
       
        [self.calendar loadPreviousPage];
        
    }else if(index == 3)
    {
        //右边
        
        [self.calendar loadNextPage];
        
    }
    
    
}

-(void)createCalenderView
{
    __weak __typeof(&*self)weakSelf = self;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //日历 加事件的 容器  方便 做悬浮效果
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
    self.containerView.frame = CGRectMake(0, WEEK_DAY_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - (64 + 49 + 30));
    [self.view addSubview:self.containerView];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
    
    //添加 日历事件 表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KTopCalenderHeaderView, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
    [self.containerView addSubview:self.tableView];
    
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
    
    [self.tableView registerClass:[FMCalenderTypesALLTableViewCell class] forCellReuseIdentifier:FMCalenderTypesALLTableViewCellRegister];
    [self.tableView registerClass:[FMCalenderTypesSingleTableViewCell class] forCellReuseIdentifier:FMCalenderTypesSingleTableViewCellRegister];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    LTSCalendarManager *calendar = [LTSCalendarManager new];
    calendar.calendarAppearance.calendar.firstWeekday = 2;
    self.calendar = calendar;

    
    
    
    
    //初始化星期几！！
    //初始化weekDayView
    LTSCalendarWeekDayView *weekDayView = [LTSCalendarWeekDayView new];
    weekDayView.backgroundColor = [UIColor whiteColor];
    weekDayView.frame = CGRectMake(0, KTopCalenderHeaderView, self.view.frame.size.width, WEEK_DAY_VIEW_HEIGHT);
    calendar.calendarAppearance.weekDayTextFont = [UIFont systemFontOfSize:17];
    
    
    self.calendar.weekDayView = weekDayView;
    LTSCalendarSelectedWeekView *weekView = [LTSCalendarSelectedWeekView new];
    
    weekView.pagingEnabled = YES;
    [calendar setSelectedWeekView:weekView];
    weekView.frame = CGRectMake(0, 400, self.view.frame.size.width, 50);
    
    
    //初始化  contentViw
    LTSCalendarContentView *view= [LTSCalendarContentView new];
    
    [calendar setContentView:view];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:view];
    [headerView addSubview:weekView];
    
    self.headerView = headerView;
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    
    self.calendar.eventSource = self;
    calendar.currentDate = [NSDate date];
    calendar.calendarAppearance.weekDayTextColor = DarkText;//[HXColor colorWithHexString:@"#f8f8f8"]
    calendar.calendarAppearance.backgroundColor = [UIColor whiteColor];
    calendar.calendarAppearance.dayCircleColorSelected= [HXColor colorWithHexString:@"#0159d5"];//RGBCOLOR(251, 52, 65);
    calendar.calendarAppearance.dayTextColor = DarkText;
    //其他月份的农历颜色
    calendar.calendarAppearance.lunarDayTextColorOtherMonth = [UIColor orangeColor];//PrimaryText;
    //本月农历文字颜色
    calendar.calendarAppearance.lunarDayTextColor = [UIColor blueColor];// PrimaryText;
    //下一个月或上一个月的文字颜色
    calendar.calendarAppearance.dayTextColorOtherMonth = [UIColor purpleColor];//PrimaryText;
    //背景色
    calendar.calendarAppearance.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
    
    //都是与底部的小红点有关的，
    //底部小红点的默认颜色
    calendar.calendarAppearance.dayDotColor = [UIColor greenColor];//PrimaryText;
    //底部小红点在选中状态下的颜色
    calendar.calendarAppearance.dayDotColorSelected = [UIColor yellowColor];//PrimaryText;
    calendar.calendarAppearance.dayTextColorSelected = [UIColor redColor];
    
    
    calendar.calendarAppearance.currentDayTextColor = [UIColor whiteColor];
    ///  当天日期背景颜色
    calendar.calendarAppearance.currentDayBackgroundColor = [UIColor lightGrayColor];
    //设置显示的样式
    calendar.calendarAppearance.isShowLunarCalender = NO;
    calendar.calendarAppearance.isShowOtherMonthDay = NO;
    calendar.calendarAppearance.isShowHotDotPoint   = NO;
    
    //选中状态下的颜色
    calendar.calendarAppearance.dayCircleColorSelected = [HXColor colorWithHexString:@"#0159d5"];
    
    
    [self.calendar reloadAppearance];
    //数据加载完
    [self.calendar reloadData];
    //初始化 第一项数据  初始数据
    //self.calendar.currentDateSelected = [NSDate date];
    
    self.calendar.lastSelectedWeekOfMonth = [self.calendar getWeekFromDate:self.calendar.currentDateSelected];
    
    
    
    
    
    [self.view addSubview:weekDayView];
    [self.view bringSubviewToFront:weekDayView];
    
    
    
    self.view.backgroundColor = self.calendar.calendarAppearance.backgroundColor;
    
    
    //创建头部点击
    FMCalenderHeaderView * calenderHeaderView = [[FMCalenderHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KTopCalenderHeaderView)];
    calenderHeaderView.backgroundColor = [UIColor whiteColor];
    calenderHeaderView.currentString = self.currentMonth;
    self.calenderHeaderView = calenderHeaderView;
    calenderHeaderView.buttonBlock = ^(NSInteger index){
        [weakSelf headerViewCalenderButtonOnClick:index];
    };
    [self.view addSubview:calenderHeaderView];
    [self.view bringSubviewToFront:calenderHeaderView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"我的推荐"];
    self.currentMonth = [[NSDate date] retCurrentdateWithYYYY_MMNianyue];
    
    [self createCalenderView];
    [self getDateSourceFromNetWork:self.currentMonth withLastOrRight:0];
    
}

-(void)addshijian
{
    //添加事件
    
    [self.calendar reloadData];
}

- (NSString *)deleteCurrentMonth:(NSString *)currentMonth
{
    NSString *retString;//yyyy年MM月
    retString = [currentMonth stringByReplacingOccurrencesOfString:@"年" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString:@"月" withString:@""];
    return retString;
}
-(void)getDateSourceFromNetWork:(NSString *)currentMonth withLastOrRight:(NSInteger)ordict
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"yuefen":[self deleteCurrentMonth:currentMonth]
                                 };

    
    NSString * stringHtml = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/yongjinriliyuefenliuer");//
    //@"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/yongjinriliyuefen";
    
    //NSString * stringHtml = kXZUniversalTestUrl(@"RequestMonth");
    
    __block NSInteger fangxiang = ordict;
    [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];

    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.containerView animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                
                NSString * yuefen = dict[@"yuefen"];
                NSMutableString * xinString = [NSMutableString stringWithString:yuefen];
                NSString * month;
                if (yuefen.length == 6) {
                    [xinString insertString:@"-"atIndex:4];
                    month = xinString;
                }else
                {
                    month = [[NSDate date]turnToThisDateYearAndmonthWithFormat];
                }
                
                [self retContinData:dict[@"comisdays"] WithCurrentMonth:month ];
                
                
                
                if (fangxiang == 0) {
                    [self addshijian];
                }else if(fangxiang == 1)
                {
                    [self.calendar loadPreviousPage];
                }else if(fangxiang == 2)
                {
                    [self.calendar loadNextPage];
                }
                
                
                self.dateModelMonth = [[FMMonthDateModel alloc]init];
                self.dateModelMonth.maturas = dict[@"Maturas"];
                self.dateModelMonth.commispabl = dict[@"Commispabl"];
                self.dateModelMonth.isDay = NO;
                
                
                [self.tableView reloadData];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.containerView, @"参数错误，请稍后重试！");
            }
            
        }else
        {
            
            [self.tableView reloadData];

            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.containerView, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.containerView, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.containerView, @"网络不好，请稍后重试！");
                
            }        }
        
    }];
}
///
-(void )retContinData:(NSMutableArray *)array WithCurrentMonth:(NSString *)month
{
    
    for (NSString * dayString in array) {
        
        NSString * key = [NSString stringWithFormat:@"%@-%@",month,dayString];
        [self.dataSource setObject:key forKey:key];
    }
    
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    //初始化插入  第一个WeekView
    [self.calendar sendSubviewToSelectedWeekViewWithIndex:self.calendar.currentSelectedWeekOfMonth];
    self.calendar.currentDate = self.calendar.currentDate;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dateModelMonth) {
        if (!self.dateModelMonth.isDay) {
            return (KProjectScreenHeight - 150)/80;;

        }else
        {
            NSInteger count = (KProjectScreenHeight - 150 - 40 * self.dateMonthDaySource.count)/80;
            if (count < 1) {
                count = 2;
            }
            
            return count + self.dateMonthDaySource.count;
        }
        
    }else
    {
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dateModelMonth) {
        
        if (indexPath.row == 0) {
            FMCalenderTypesALLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FMCalenderTypesALLTableViewCellRegister forIndexPath:indexPath];
            cell.isRecommendType = 1;
            
            cell.dateModel = self.dateModelMonth;
            if (!self.dateModelMonth.isDay) {
                cell.type = FMCalenderTypesALLTableViewCellTypeMonth;

            }else
            {
                if (self.dateMonthDaySource.count > 0) {
                    cell.type = FMCalenderTypesALLTableViewCellTypeHaveDate;

                }else
                {
                    cell.type = FMCalenderTypesALLTableViewCellTypeNoneDate;
                }
            }
            
            return cell;
        }else if(indexPath.row != 0 && indexPath.row < self.dateMonthDaySource.count + 1)
        {
            if (self.dateModelMonth.isDay) {
                
                
                FMCalenderTypesSingleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FMCalenderTypesSingleTableViewCellRegister forIndexPath:indexPath];
                cell.isReturnMoney = 1;
                cell.dateModel = self.dateMonthDaySource[indexPath.row - 1];
                return cell;
                
                
                
                
            }else
            {
                //占位
                UITableViewCell *cell =[UITableViewCell new];
                cell.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else
        {
            //占位
            UITableViewCell *cell =[UITableViewCell new];
            cell.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    //占位
    UITableViewCell *cell =[UITableViewCell new];
    cell.backgroundColor = [HXColor colorWithHexString:@"#f8f8f8"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat  heigh = 80;
        if (self.dateModelMonth.isDay) {
            heigh = 80 + 44;
            if (self.dateMonthDaySource.count > 0) {
                
                return heigh;
            }else
            {
                return heigh;
            }
        }else
        {
            return heigh;
        }
            
    }else if(indexPath.row != 0 && indexPath.row < self.dateMonthDaySource.count + 1)
    {
        if (self.dateModelMonth.isDay) {
            
            CGFloat widthCell = 100;
            if (KProjectScreenWidth < 375) {
                widthCell = 135;
            }else if(KProjectScreenWidth < 400)
            {
                widthCell = 165;
            }else
            {
                widthCell = 185;
            }


            
            FMRecommendDayDateModel * model = self.dateMonthDaySource[indexPath.row - 1];
            CGSize sizeModel ;
            
            sizeModel =  [NSString getStringCGSizeWithMaxSize:CGSizeMake(widthCell, MAXFLOAT) WithFont:[UIFont systemFontOfSize:KCellFontDefault] WithString:model.jiekuantitle];
            
             return sizeModel.height + 8 > 40 ? sizeModel.height + 8 : 40;
            
            
        }else
        {
            //占位
            return 80;
        }
    }else
    {
        //占位
        return 80;
    }
    return 80;
    
}
//占位





- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}
#pragma mark - JTCalendarDataSource
// 该日期是否有事件
- (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(self.dataSource[key]){
        NSString * keying = self.dataSource[key];
        if (keying.length > 0) {
            return YES;
        }
        
    }
    if (self.dataSource) {
        //NSLog(@"%@",eventsByDate);
    }
    //
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    NSDate * nextDay = date;//[date nextMonthMiddleDay];
    NSString *key = [[self dateFormatter] stringFromDate:nextDay];
    
    NSString * middleString = [key substringToIndex:7];
    
    middleString = [middleString stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    middleString = [NSString stringWithFormat:@"%@月",middleString];
    
    
    
    self.calenderHeaderView.currentString = middleString;
    if ([self.calendar.dataCache haveEvent:date]) {
        
        [self getDayDataSourceFromNetWorkWithNSString:key];

    }else
    {
        self.dateModelMonth = nil;
        [self.dateMonthDaySource removeAllObjects];
        
        self.dateModelMonth = [[FMMonthDateModel alloc]init];
        self.dateModelMonth.maturas = @"0.00";
        self.dateModelMonth.commispabl = @"0.00";
        self.dateModelMonth.isDay = YES;
        
        
        [self.tableView reloadData];
    
    }
    
    
}
-(void)getDayDataSourceFromNetWorkWithNSString:(NSString *)key
{
    
    
    NSString* deleteString = [key stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"riqi":deleteString
                                 };
    

    NSString * stringHtml = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/yongjinrilitianliuer");
    
    //@"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/yongjinrilitian";
    
    //NSString * stringHtml = kXZUniversalTestUrl(@"RequestDate");
    
    [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];

    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.containerView animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                
                
                NSArray * listArray = dict[@"list"];
                if (![listArray isMemberOfClass: [NSNull class]]) {
                    [self.dateMonthDaySource removeAllObjects];
                    for (NSDictionary * dict in listArray) {
                        
                        FMRecommendDayDateModel * dateModel = [[FMRecommendDayDateModel alloc]init];
                        
                        [dateModel setValuesForKeysWithDictionary:dict];
                        
                        [self.dateMonthDaySource addObject:dateModel];
                        
                    }
                    
                    
                }
                
                self.dateModelMonth = [[FMMonthDateModel alloc]init];
                self.dateModelMonth.maturas = dict[@"Maturas"];
                self.dateModelMonth.commispabl = dict[@"Commispabl"];
                self.dateModelMonth.isDay = YES;
                
                [self.tableView reloadData];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试！");
            }
            
        }else
        {
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.containerView, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.containerView, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.containerView, @"网络不好，请稍后重试！");
                
            }
        }
        
    }];
}


//当tableView 滚动完后  判断位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat startSingleOriginY = self.calendar.calendarAppearance.weekDayHeight*5;
    
    self.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    
    //用于判断滑动方向
    CGFloat distance = self.dragStartOffectY - self.dragEndOffectY;
    
    
    if (self.tableView.contentOffset.y > CriticalHeight ) {
        if (self.tableView.contentOffset.y < startSingleOriginY) {
            if (self.tableView.contentOffset.y > startSingleOriginY-CriticalHeight) {
                [self showSingleWeekView:YES];
                return;
            }
            //向下滑动
            if (distance < 0) {
                [self showSingleWeekView:YES];
            }
            
            else [self showAllView:YES];
        }
        
        
    }
    else if (self.tableView.contentOffset.y > 0)
        [self showAllView:YES];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.containerView.backgroundColor = self.calendar.calendarAppearance.backgroundColor;
    
    CGFloat startSingleOriginY = self.calendar.calendarAppearance.weekDayHeight*5;
    
    self.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    CGFloat distance = self.dragStartOffectY - self.dragEndOffectY;
    
    
    if (self.tableView.contentOffset.y>CriticalHeight ) {
        if (self.tableView.contentOffset.y<startSingleOriginY) {
            if (self.tableView.contentOffset.y>startSingleOriginY - CriticalHeight) {
                [self showSingleWeekView:YES];
                return;
            }
            if (distance<0) {
                [self showSingleWeekView:YES];
            }
            else [self showAllView:YES];
        }
        
        
    }
    else if (self.tableView.contentOffset.y > 0)
        [self showAllView:YES];
    
    
    
    
}

//当手指 触摸 滚动 就 设置 上一次选择的 跟当前选择的 周 的index 相等
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.dragStartOffectY  = scrollView.contentOffset.y;
    
    self.calendar.lastSelectedWeekOfMonth = self.calendar.currentSelectedWeekOfMonth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    CGFloat offectY = scrollView.contentOffset.y;
    
    CGRect contentFrame = self.calendar.contentView.frame;
    
    
    //  当 offectY 大于 滚动到要悬浮的位置
    if ( offectY>self.calendar.startFrontViewOriginY) {
        
        self.containerView.backgroundColor = [UIColor whiteColor];
        contentFrame.origin.y = -self.calendar.startFrontViewOriginY + KTopCalenderHeaderView;
        
        self.calendar.contentView.frame = contentFrame;
        
        
        //把 selectedView 插入到 containerView 的最上面
        [self.containerView insertSubview:self.calendar.selectedWeekView atIndex:999];
        // 把tableView 里的 日历视图 插入到 表底部
        [self.containerView insertSubview:self.calendar.contentView atIndex:0];
        
    }else{
        self.containerView.backgroundColor = self.calendar.calendarAppearance.backgroundColor;
        contentFrame.origin.y = 0;
        self.calendar.contentView.frame = contentFrame;
        
        [self.headerView insertSubview:self.calendar.selectedWeekView atIndex:1];
        [self.headerView insertSubview:self.calendar.contentView atIndex:0];
        
    }
    
    
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}
//回到全部显示初始位置
- (void)showAllView:(BOOL)animate{
    
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:animate];
    
    
}
//滚回到 只显示 一周 的 位置
- (void)showSingleWeekView:(BOOL)animate{
    
    [self.tableView setContentOffset:CGPointMake(0, self.calendar.calendarAppearance.weekDayHeight*5) animated:animate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

