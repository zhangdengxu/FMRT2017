//
//  WLKeHuViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//
#define KDefaultHeaderViewHeigh 38 + 38

#import "WLKeHuViewController.h"
#import "WLKeHuTableVIewCellTableViewCell.h"
#import "FMRTTuijianModel.h"
#import "WLSearchKeHuViewController.h"
#import "XMAlertTimeView.h"
#import "FMShowMenuBottomView.h"

#define IMPUT_MAX 11
@interface WLKeHuViewController ()<UITableViewDelegate,UITableViewDataSource,XMAlertTimeViewDelegate>
{
    bool _show;

}
@property(nonatomic,strong)UIView *bjView;
@property(nonatomic,strong)UISearchBar *customSearchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FMRTTuijianModel *dataModel;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)BOOL isAddData;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UILabel *timeTitileLabel;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property (nonatomic, strong)UIImageView  * backGroundImage;


@property (nonatomic, strong) CAShapeLayer *indicator;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, weak) UIView * bottomView;
@property (nonatomic, strong) FMShowMenuBottomView * menuBottomView;

@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation WLKeHuViewController

-(FMShowMenuBottomView *)menuBottomView
{
    if (!_menuBottomView) {
        _menuBottomView = [[FMShowMenuBottomView alloc]initWithFrameContent:CGRectMake(0, KDefaultHeaderViewHeigh, KProjectScreenWidth, self.titleArray.count * KDefaultMenuHeigh) WithMenuArray:@[@"全部",@"已投资",@"未投资"]];
        [self.view addSubview:_menuBottomView];
        [self.view bringSubviewToFront:_menuBottomView];
         __weak __typeof(&*self)weakSelf = self;
        _menuBottomView.selectBlock = ^(NSInteger index)
        {
            [weakSelf selectMenuAndDown:index];
        };
        _menuBottomView.closeBlock = ^(){
            [weakSelf animateWithIndicator:NO];
        };
        _menuBottomView.hidden = YES;
    }
    return _menuBottomView;
}

-(void)selectMenuAndDown:(NSInteger)currentSelectIndex
{
    self.currentSelectIndex = currentSelectIndex;
    [self.menuBottomView menuViewHidden];
    _show = NO;
    [self bottomViewChangeColorToOrigin];

    [self animateWithIndicator:NO];
    
     [self loadMoreListData];

    
}
-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KDefaultHeaderViewHeigh, KProjectScreenWidth, self.view.bounds.size.height - KDefaultHeaderViewHeigh) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage ++;
            _isAddData = YES;
            [weakSelf loadMoreListData];
            
        }];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            
            [weakSelf loadMoreListData];
        }];
 
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * titleArray = @[@"姓名",@"注册时间",@"状态"];
    self.titleArray = titleArray;
    
    
    [self settingNavTitle:@"我推荐的客户"];
    self.currentPage = 1;
    //self.startTime = [self timeStringToDateValue:[self monthAgoDate]];
    self.startTime = @"2014-01-01";
    self.endTime = [self timeStringToDateValue:[self getNowTime]];
    [self creatContentViews];
    [self.view addSubview:self.tableView];
    [self createHeaderView];
    [self loadMoreListData];
}

-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, KDefaultHeaderViewHeigh, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [_backGroundImage setImage:[UIImage imageNamed:@"暂无数据"]];
        [_backGroundImage setBackgroundColor:[UIColor redColor]];
        [self.tableView addSubview:_backGroundImage];
    }
    return _backGroundImage;
}

-(void)contueNullDataSource
{
//    self.tableView.hidden = YES;
    self.backGroundImage.hidden = NO;
    
}

- (void)loadMoreListData{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *userId;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        userId = [CurrentUserInformation sharedCurrentUserInfo].userId;
    }else{
        userId = @"0";
    }
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":@"10",
                                 @"kaishijian":self.startTime,
                                 @"jiezhishijian":self.endTime,
                                 @"toubiaoshu":[NSString stringWithFormat:@"%zi",self.currentSelectIndex]
                                 

                                 };
    
    __weak __typeof(self)weakSelf = self;
    NSString * urlLish = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/myrecommperslistliuer");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:urlLish parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.code==WebAPIResponseCodeSuccess) {
            if (_isAddData) {
                
                _isAddData = NO;
            }else
            {
                if (self.currentPage == 1) {
                    [weakSelf.dataArr removeAllObjects];
                }

            }
            NSArray  *arr = [response.responseObject objectForKey:@"data"];
            if (arr.count>0) {
                for (NSDictionary *dic in arr) {
                    FMRTTuijianModel *model = [[FMRTTuijianModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
//        else{
//            ShowAutoHideMBProgressHUD(weakSelf.view, [response.responseObject objectForKey:@"msg"]);
//            [weakSelf.dataArr removeAllObjects];
            
//        }
        if (weakSelf.dataArr.count == 0) {
            [self contueNullDataSource];
        }else{
            self.backGroundImage.hidden = YES;
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];

}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (FMRTTuijianModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTTuijianModel alloc]init];
    }
    return _dataModel;
}

- (void)loadView
{
    
    
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
}

-(void)createHeaderView{

    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KDefaultHeaderViewHeigh)];
    [bjView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:bjView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 38)];
    [titleLabel setBackgroundColor:KDefaultOrBackgroundColor];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[HXColor colorWithHexString:@"#0159d6"]];
    [titleLabel setText:[NSString stringWithFormat:@"%@ － %@",@"2014-01-01",[self getNowTime]]];
    [bjView addSubview:titleLabel];
    self.timeTitileLabel = titleLabel;
    
    titleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [titleLabel addGestureRecognizer:labelTapGestureRecognizer];
    
  
    [bjView addSubview:[self createtitleView]];
    
}

-(UIView *)createtitleView
{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, KProjectScreenWidth, 38)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
    [bottomView addGestureRecognizer:tapGesture];

    CGFloat textLayerInterval = self.view.frame.size.width / ( self.titleArray.count * 2);
    
    UIColor * menuColor = [UIColor colorWithRed:164.0/255.0 green:166.0/255.0 blue:169.0/255.0 alpha:1.0];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        CGPoint position = CGPointMake( (i * 2 + 1) * textLayerInterval , bottomView.frame.size.height / 2);
        CATextLayer *title = [self creatTextLayerWithNSString:self.titleArray[i] withColor:[HXColor colorWithHexString:@"#333"] andPosition:position];
        [bottomView.layer addSublayer:title];
        
        if (i == self.titleArray.count - 1) {
            CAShapeLayer *indicator = [self creatIndicatorWithColor:menuColor andPosition:CGPointMake(position.x + title.bounds.size.width / 2 + 8, bottomView.frame.size.height / 2)];
            [bottomView.layer addSublayer:indicator];
            self.indicator = indicator;
        }
        
    }
    return bottomView;
}

-(void)bottomViewChangeColorToShadow
{
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.1];//[UIColor colorWithRed:(224.0/255.0) green:(230.0/255.0) blue:(236.0/255.0) alpha:0.9];
}


-(void)bottomViewChangeColorToOrigin
{
    self.bottomView.backgroundColor = [UIColor whiteColor];
}

// 处理菜单点击事件.
- (void)tapMenu:(UITapGestureRecognizer *)paramSender
{
    
    if (_show) {
        _show = NO;

        [self animateWithIndicator:NO];
        [self.menuBottomView menuViewHidden];
        [self bottomViewChangeColorToOrigin];
       
        
    } else {
        
        _show = YES;
        
        [self animateWithIndicator:YES];
        
        [self.menuBottomView menuViewShow];
        [self bottomViewChangeColorToShadow];

        [self.menuBottomView selectMenuIndex:self.currentSelectIndex];


    }
    
    
    
}

-(void)animateWithIndicator:(BOOL)forward
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [self.indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [self.indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    self.indicator.fillColor = forward ?  [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1].CGColor: [UIColor colorWithRed:164.0/255.0 green:166.0/255.0 blue:169.0/255.0 alpha:1.0].CGColor;
    [CATransaction commit];
}


- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}


- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.view.frame.size.width / self.titleArray.count) - 25) ? size.width : self.view.frame.size.width / self.titleArray.count - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 18.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 18.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}


-(void)rightButtonOnClick:(UIButton *)button
{
    
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
//    NSLog(@"被点击了");
    XMAlertTimeView * alterView = [[XMAlertTimeView alloc]init];
    alterView.timeViewType = XMAlertTimeViewTypeyyyyMMdd;
    alterView.title.text = @"请选择日期";
    alterView.delegate = self;
    
    NSString *netString = [self.timeTitileLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *array = [netString componentsSeparatedByString:@"－"];
    
    NSString * cuttentButton = [NSString stringWithFormat:@"%@ － %@",array[0],array[1]];
    [alterView showAlertVeiwWithAllString:[self changduanxianToNianyue:cuttentButton]];
    
    
}

-(void)creatContentViews{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"我的推荐_搜索icon_1702"]
                               forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 25, 25)];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)rightNavBtnClick{
    
    WLSearchKeHuViewController *vc = [[WLSearchKeHuViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"KeHuCell";
    
    WLKeHuTableVIewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WLKeHuTableVIewCellTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<self.dataArr.count) {
       cell.model = self.dataArr[indexPath.row];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

#pragma mark - XMAlertTimeViewDelegate

-(NSString *)changduanxianToNianyue:(NSString *)time
{
    NSString *strUrl = [time stringByReplacingOccurrencesOfString:@"至" withString:@"－"];
    return strUrl;
    
}
-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;
{
//    NSString *strUrl = [time stringByReplacingOccurrencesOfString:@"－" withString:@"至"];
    [self.timeTitileLabel setText:time];
    
    NSString *netString = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *array = [netString componentsSeparatedByString:@"－"];
    if (array.count > 1) {
        self.startTime = [self timeStringToDateValue:array[0]];
        self.endTime = [self timeStringToDateValue:array[1]];
        self.currentPage = 1;
        [self.dataArr removeAllObjects];
        [self loadMoreListData];
 
    }
}

-(NSString *)getNowTime{

    NSDate *senddate = [NSDate date];
    
//    NSLog(@"date1时间戳 = %ld",time(NULL));
//    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
//    NSLog(@"date2时间戳 = %@",date2);
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date1 = [dateformatter stringFromDate:senddate];
//    NSLog(@"获取当前时间   = %@",date1);
    return date1;
    
}

-(NSString *)monthAgoDate{

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate*nowDate = [NSDate date];
    NSTimeInterval  interval =24*60*60*30; //1:天数
    NSDate*date1 = [nowDate initWithTimeIntervalSinceNow:-interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date1]];
}

#pragma mark ----- 日期转换成时间戳
- (NSString *)timeStringToDateValue:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateValue = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)       [dateValue timeIntervalSince1970]];
    return timeSp;
}

@end



#pragma mark - CALayer Category

@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}


@end

