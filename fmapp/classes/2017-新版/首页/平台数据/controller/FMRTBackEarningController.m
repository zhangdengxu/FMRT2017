//
//  FMRTBackEarningController.m
//  fmapp
//
//  Created by apple on 2017/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTBackEarningController.h"
#import "FSCalendar.h"
#import "Fm_Tools.h"
#import "FMRTBackEarningCell.h"
#import "FMRTBackEarningSectionView.h"
#import "FMRTBackEarnHeaderView.h"
#import "FMRTBackEariningModel.h"

@interface FMRTBackEarningController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,UIGestureRecognizerDelegate>
{
    void * _KVOContext;
}
@property (nonatomic, weak)   FSCalendar *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic)   UIButton *previousButton,*nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic, strong) FMRTBackEarnHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *fillDefaultColors;
@property (strong, nonatomic) UIDatePicker *datepicker;

@property (strong, nonatomic)  UITextField *date;
@end

@implementation FMRTBackEarningController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}

- (FMRTBackEarnHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[FMRTBackEarnHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 80)];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fillDefaultColors = [NSMutableDictionary dictionary];

    [self settingNavTitle:@"我的推荐"];
    [self createContentView];
    [self setRightNavButton:@"今天" withFrame:CGRectMake(KProjectScreenWidth - 80, 20, 80, 30) actionTarget:self action:@selector(aaaaa) color:[UIColor redColor]];
    [self createPreAndNextBtn];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];

    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeMonth;
    self.calendar.accessibilityIdentifier = @"calendar";
    
    [self requesetDataEachMonthWithDateString:[Fm_Tools monthDateStringFromDate:[NSDate date]]];
}

- (void)requesetDataEachMonthWithDateString:(NSString *)dateString{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString * shareUrlHtml = @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/yongjinriliyuefen";
    
    NSString *yuefen = dateString;
        NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                     @"appid":@"huiyuan",
                                     @"shijian":[NSNumber numberWithInt:timestamp],
                                     @"token":tokenlow,
                                     @"yuefen":yuefen
                                     };
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:shareUrlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            [weakSelf.dataSource removeAllObjects];
            
            if (response.code ==WebAPIResponseCodeSuccess) {
                
                [weakSelf.fillDefaultColors removeAllObjects];
                if ( [response.responseObject objectForKey:@"data"]) {
                    NSDictionary *dataDict = [response.responseObject objectForKey:@"data"];
                    if ([dataDict objectForKey:@"comisdays"]) {
                        id comisdaysArr = [dataDict objectForKey:@"comisdays"];
                        if ([comisdaysArr isKindOfClass:[NSArray class]]) {
                            NSArray *dataArr = (NSArray *)comisdaysArr;
                            
                            if (dataArr.count) {
                                for (NSString *str in dataArr) {
                                    NSString *dateStr = [NSString stringWithFormat:@"%@/%@",[Fm_Tools calendarMonthStringFromDate:dateString],str];
                                    [weakSelf.fillDefaultColors setObject:[UIColor redColor] forKey:dateStr];
                                }
                            }
                        }
                    }
                    if ([dataDict objectForKey:@"Maturas"] &&[dataDict objectForKey:@"Commispabl"]) {
                        
                        FMRTBackEariningModel *model = [FMRTBackEariningModel new];
                        model.Maturas = ObjForKeyInUnserializedJSONDic(dataDict,@"Maturas");
                        model.Commispabl = ObjForKeyInUnserializedJSONDic(dataDict,@"Commispabl");
                        weakSelf.headerView.model = model;
                    }
                }
                
                [weakSelf.tableView reloadData];
                [weakSelf.calendar reloadData];
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
    }];
}

- (void)createPreAndNextBtn{
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(10, 8, 20, 28);
    [previousButton setImage:[UIImage imageNamed:@"回款计划_左箭头_1702"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendar addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(KProjectScreenWidth-30, 8, 20, 28);
    [nextButton setImage:[UIImage imageNamed:@"回款计划_右箭头_1702"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendar addSubview:nextButton];
    self.nextButton = nextButton;
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.frame = CGRectMake(KProjectScreenWidth/2-50, 8, 100, 28);
    [centerButton addTarget:self action:@selector(centerButtonclick) forControlEvents:UIControlEventTouchUpInside];
    [self.calendar addSubview:centerButton];
}

- (void)centerButtonclick{

    self.datepicker = [[UIDatePicker alloc] init];
    _datepicker.backgroundColor = [UIColor whiteColor];
    self.date = [[UITextField alloc]init];
    [self.view addSubview:self.date];
    self.datepicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    
    self.date.inputView = self.datepicker;

    UIView *toolbar = [[UIView alloc] init];
    toolbar.backgroundColor = [UIColor grayColor];

    toolbar.bounds = CGRectMake(0, 0, KProjectScreenWidth, 44);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(KProjectScreenWidth-60, 8, 60, 28);
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [toolbar addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 8, 60, 28);
    [cancelBtn addTarget:self action:@selector(cacelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [toolbar addSubview:cancelBtn];
    
    self.date.inputAccessoryView = toolbar;
    [self.date becomeFirstResponder];
}
- (void)sureAction{
    
    [self.calendar selectDate:self.datepicker.date scrollToDate:YES];
    [self requestDataWithTableWith:[Fm_Tools calendarDayDateStringFromDate:self.datepicker.date]];

    [self.date resignFirstResponder];
}
- (void)cacelAction{
    [self.date resignFirstResponder];
}

- (void)previousClicked:(id)sender{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self requesetDataEachMonthWithDateString:[Fm_Tools monthDateStringFromDate:previousMonth]];
    
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self requesetDataEachMonthWithDateString:[Fm_Tools monthDateStringFromDate:nextMonth]];

    [self.calendar setCurrentPage:nextMonth animated:YES];
}

- (void)createContentView{
    
    FSCalendar *calendar = [[FSCalendar alloc]init];
    [self.view addSubview:calendar];
    [calendar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(KProjectScreenWidth);
        make.top.equalTo(self.view.top);
    }];
    calendar.delegate = self;
    calendar.dataSource = self;

    //    calendar.appearance.titleSelectionColor = [UIColor redColor];
    calendar.calendarWeekdayView.backgroundColor = [UIColor whiteColor];
    calendar.calendarHeaderView.backgroundColor = [UIColor whiteColor];
    calendar.backgroundColor = XZColor(249, 249, 249);
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.todayColor = [UIColor lightGrayColor];
    calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"#333"];
    calendar.appearance.weekdayTextColor = [UIColor colorWithHexString:@"#333"];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.titlePlaceholderColor = [UIColor clearColor];

    self.calendar = calendar;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(calendar.bottom);
        make.bottom.equalTo(self.view.bottom);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{

    [calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bounds.size.height));
    }];
    
    [self.view layoutIfNeeded];
}


#pragma mark FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
//    NSLog(@"selected dates is %@",selectedDates);
//    NSLog(@"selected dates is %@",[Fm_Tools calendarDayDateStringFromDate:date]);
    [self requestDataWithTableWith:[Fm_Tools calendarDayDateStringFromDate:date]];
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)requestDataWithTableWith:(NSString *)dateStr{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
    NSString *tokenlow=[token lowercaseString];
    NSString * shareUrlHtml = @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/yongjinrilitian";
    
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"riqi":dateStr
                                 };
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:shareUrlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            
//            NSLog(@"====%@===",response.responseObject);
            
            if (response.code ==WebAPIResponseCodeSuccess) {
                
                if ( [response.responseObject objectForKey:@"data"]) {
                    
                    
                    
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
    }];
    
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", @"",@"",@"",@"",@"",nil];
    [self.tableView reloadData];
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{

    return nil;
}

/**
 * Asks the delegate for a fill color in selected state for the specific date.
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    
    return nil;
}

/**
 * Asks the delegate for day text color in unselected state for the specific date.
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    NSString *key = [Fm_Tools dateStringFromDate:date];
    if ([_fillDefaultColors.allKeys containsObject:key]) {
        return _fillDefaultColors[key];
    }
    return nil;

}

/**
 * Asks the delegate for day text color in selected state for the specific date.
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    return nil;

}

/**
 Tells the delegate the calendar is about to change the current page.
 */
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    
    [self requesetDataEachMonthWithDateString:[Fm_Tools calendarScrollDateStringFromDate:calendar.currentPage]];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.dataSource.count) {
        FMRTBackEarningSectionView *secView = [[FMRTBackEarningSectionView alloc]init];
        return secView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSource.count?40:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FMRTBackEarningCell";
    FMRTBackEarningCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMRTBackEarningCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)aaaaa{
//    if (self.calendar.scope == FSCalendarScopeMonth) {
//
//        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
//        
//    } else {
//        
//        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
//    }
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
//    [self calendar:self.calendar didSelectDate:[NSDate date]atMonthPosition:(nil)];
    [self.calendar reloadData];
    [self requestDataWithTableWith:[Fm_Tools calendarDayDateStringFromDate:[NSDate date]]];

}

- (void)dealloc{
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
//        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                NSLog(@"FSCalendarScopeMonth  %zi",velocity.y < 0);
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                NSLog(@"FSCalendarScopeWeek  %zi",velocity.y > 0);

                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

@end
