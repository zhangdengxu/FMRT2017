//
//  FMTradeNoteNewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/12.
//  Copyright © 2016年 yk. All rights reserved.
//
#define kNavTitleImageViewTag   10009

#define KFMTradeNoteNewControllerFlag @"FMTradeNoteNewController"
#import "FMMyJoinDetailTypeController.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "FMTradeNoteTableViewCell.h"
#import "FMTradeNoteModel.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "XMAlertTimeView.h"
#import "FMTradeNoteModel.h"
#import "NSDate+CategoryPre.h"

//ceshi
@interface FMMyJoinDetailTypeController ()<UITableViewDelegate,UITableViewDataSource,FMNavigateMenuDelegate,XMAlertTimeViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;


@property (nonatomic, assign) NSInteger currentIndexType;
@property (nonatomic,copy) NSString *currentDataInterval;

@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮

@property (nonatomic, strong) NSMutableArray  * titleDataSource;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;

@property (nonatomic, strong) UIButton * tableViewHeaderView;
@property (nonatomic, strong) UIImageView * zeroImageView;
@end

@implementation FMMyJoinDetailTypeController


-(UIImageView *)zeroImageView
{
    if (!_zeroImageView) {
        _zeroImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, self.view.bounds.size.height - 49)];
        _zeroImageView.image = [UIImage imageNamed:@"未标题-1"];
        [self.view addSubview:_zeroImageView];
        [self.view sendSubviewToBack:_zeroImageView];
    }
    return _zeroImageView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMTradeNoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KFMTradeNoteNewControllerFlag forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    //    cell.tradeNote = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)configureCell:(FMTradeNoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    //cell.tradeNote = self.dataSource[indexPath.row];
    cell.joinDetail = self.dataSource[indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heigh = [tableView fd_heightForCellWithIdentifier:KFMTradeNoteNewControllerFlag  configuration:^(FMTradeNoteTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    if (heigh >= 100) {
        return heigh;
    }else
    {
        return 100;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    self.currentIndexType = self.typeWithJoin;
    [self settingNavTitle:@"奖励明细"];
    
    
    [self getNavigationDataSource];
    
}




-(void)getNavigationDataSource
{
    [self.titleDataSource removeAllObjects];
    

    FMTradeNoteModelCateId * titleModel = [[FMTradeNoteModelCateId alloc]init];
    titleModel.title = @"全部";
    titleModel.type_id = @"0";
    [self.titleDataSource addObject:titleModel];
    
    FMTradeNoteModelCateId * titleModel2 = [[FMTradeNoteModelCateId alloc]init];
    titleModel2.title = @"现金奖励";
    titleModel2.type_id = @"1";
    [self.titleDataSource addObject:titleModel2];
    
    FMTradeNoteModelCateId * titleModel3 = [[FMTradeNoteModelCateId alloc]init];
    titleModel3.title = @"红包奖励";
    titleModel3.type_id = @"2";
    [self.titleDataSource addObject:titleModel3];
    

    [self settingNavigationBar];
}

-(void)getDataSourceFromNetWork
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    
    FMTradeNoteModelCateId * titleModelAll;
    if (self.titleDataSource.count > self.currentIndexType) {
        titleModelAll = self.titleDataSource[self.currentIndexType];
    }
    
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithInt:self.currentPage] forKey:@"PageNum"];

    
    
    [parameters setObject:@"huiyuan" forKey:@"AppId"];
    
    [parameters setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"UserId"];
    
    [parameters setObject:[NSNumber numberWithInt:timestamp] forKey:@"AppTime"];
    
    [parameters setObject:tokenlow forKey:@"Token"];
    
    
    if (titleModelAll) {
        [parameters setObject:titleModelAll.type_id forKey:@"AwardType"];
    }
    
    if (!self.currentDataInterval) {
        NSDate * dateLinshi = [NSDate date];
        
        NSString * currentString =  [dateLinshi retCurrentdateWithYYYY_MM_DD];
        //NSArray * dateArray = [dateLinshi getLastTwentyDayWithDayStringAndToday:currentString];
        
        self.currentDataInterval = [NSString stringWithFormat:@"%@－%@",@"2014-01-01",currentString];
        [self.tableViewHeaderView setTitle:self.currentDataInterval forState:UIControlStateNormal];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    if (self.currentDataInterval) {
        NSArray *array = [self.currentDataInterval componentsSeparatedByString:@"－"];
        
        if (array.count >=2) {
            
            NSString * firstString = [[array firstObject]  stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDate * dateTime = [NSDate retNSStringToNSdate:firstString];
            NSInteger interNetDate = [dateTime timeIntervalSince1970];//服务器返回的时间戳；
            [parameters setObject:[NSString stringWithFormat:@"%zi",interNetDate] forKey:@"StartTime"];//timestop
            
            
            NSString * secondString = [[array lastObject]  stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDate * seconddateTime = [NSDate retNSStringToNSdate:secondString];
            NSInteger secondinterNetDate = [seconddateTime timeIntervalSince1970];//服务器返回的时间戳；
            [parameters setObject:[NSString stringWithFormat:@"%zi",secondinterNetDate] forKey:@"EndTime"];
            
        }
        
    }

    
   
    
    NSString * stringMuHtml = kXZUniversalTestUrl(@"GetInviterAwardList");
    

    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:stringMuHtml parameters:parameters completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            
            if ([status integerValue] == 0) {
                NSDictionary * dictAll = response.responseObject[@"data"];
                NSArray * oldArray = dictAll[@"Detail"];
                if (_isAddData) {
                    
                    _isAddData = NO;
                }else
                {
                    [self.dataSource removeAllObjects];
                }
                
                if (oldArray.count != 0 && ![oldArray isMemberOfClass:[NSNull class]]) {
                    
                    for(NSDictionary * dict in oldArray) {
                        
                        FMJoinDetalPrizeNewModel * model = [[FMJoinDetalPrizeNewModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        [self.dataSource addObject:model];
                    }
                    
                    [self notZeroViewToShow];
                    [self.tableView reloadData];
                    
                }else
                {
                    if (self.dataSource.count == 0) {
                        [self createAZeroView];
                    }
                }
                
                
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
}
-(void)notZeroViewToShow
{
    
    self.tableView.hidden = NO;
    self.zeroImageView.hidden = YES;
    [self.view sendSubviewToBack:self.zeroImageView];

}
-(void)createAZeroView
{
    //self.tableView.hidden = YES;
    [self.tableView reloadData];
    self.zeroImageView.hidden = NO;
    [self.view bringSubviewToFront:self.zeroImageView];
}

#pragma mark -设置导航栏
- (void) settingNavigationBar
{
    //设置导航栏
    UIButton *navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navTitleButton.frame = CGRectMake(0, 2, 140, 40);
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateHighlighted];
    [navTitleButton addTarget:self action:@selector(navTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ////设置标题
    [navTitleButton setTitleColor:[HXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [navTitleButton setTitleColor:[HXColor colorWithHexString:@"aaaaaa"] forState:UIControlStateHighlighted];
    if (self.typeWithJoin == 0) {
        [navTitleButton setTitle:@"奖励明细" forState:UIControlStateNormal];

    }else if (self.typeWithJoin == 1)
    {
        [navTitleButton setTitle:@"现金奖励" forState:UIControlStateNormal];

    }else if (self.typeWithJoin == 2)
    {
        [navTitleButton setTitle:@"红包奖励" forState:UIControlStateNormal];

    }else
    {
        [navTitleButton setTitle:@"奖励明细" forState:UIControlStateNormal];

    }
    navTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    
    ////下拉箭头
    UIImageView *titleIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 13,16,16)];
    titleIndicatorImageView.tag = kNavTitleImageViewTag;
    [titleIndicatorImageView setImage:[FontAwesome imageWithIcon:FMIconPullDown
                                                       iconColor:[HXColor colorWithHexString:@"#333333"]
                                                        iconSize:16.0]];
    [navTitleButton addSubview:titleIndicatorImageView];
    self.navigationItem.titleView = navTitleButton;
    self.navTitleButton = navTitleButton;
    
    
//    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
//    [rightButton setTitle:@"日期" forState:UIControlStateNormal];
//    
//    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    
//    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.currentIndexType =self.typeWithJoin;
    
    [self getDataSourceFromNetWork];
    
}
-(void)rightButtonOnClick
{
    XMAlertTimeView * alterView = [[XMAlertTimeView alloc]init];
    alterView.title.text = @"请选择日期";
    alterView.delegate = self;
    
    if (!self.currentDataInterval) {
        [alterView showAlertVeiw];
    }else
    {
        [alterView showAlertVeiwWithAllString:self.currentDataInterval];
        
    }
    
}

-(void)headerButtonOnClick
{
    XMAlertTimeView * alterView = [[XMAlertTimeView alloc]init];
    alterView.title.text = @"请选择日期";
    alterView.delegate = self;
    
    [alterView showAlertVeiwWithAllString:self.currentDataInterval];
}
-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;
{
    
    [self.tableViewHeaderView setTitle:time forState:UIControlStateNormal];
    [self.dataSource removeAllObjects];
    self.currentPage = 1;
    self.isAddData = NO;
    [self.tableView reloadData];
    self.currentDataInterval = time;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
    
    
    
}



#pragma mark -标题视图按钮点击时
- (void) navTitleClicked:(id) sender
{
    UIButton *titleButton = (UIButton *)sender;
    //旋转箭头
    UIImageView *arrowImageView = (UIImageView *)[titleButton viewWithTag:kNavTitleImageViewTag];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    arrowImageView.transform = transform;
    [UIView commitAnimations];
    
    //弹出菜单
    FMNavigateMenu* menu = [[FMNavigateMenu alloc] initWithNav:self.navigationController];
    for (FMTradeNoteModelCateId * titleModel in self.titleDataSource) {
        [menu addMenuItem:titleModel.title];
    }
    
    menu.delegate = self;
    [menu showMenu:CGPointMake(0, 0) curIndex:self.currentIndexType];
}

#pragma mark-- FMNavigateMenuDelegate
- (void)didItemSelected:(NSInteger)index
{
    //旋转箭头
    UIImageView *arrowImageView = (UIImageView *)[self.navTitleButton viewWithTag:kNavTitleImageViewTag];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    arrowImageView.transform = transform;
    [UIView commitAnimations];
    
    if(index < 0)
        return;
    
    if (self.titleDataSource.count > index) {
        FMTradeNoteModelCateId * titleModelAll = self.titleDataSource[index];
        [self.navTitleButton setTitle:titleModelAll.title forState:UIControlStateNormal];
        
    }
    
    
    
    self.currentIndexType = index;
    [self.dataSource removeAllObjects];
    self.currentPage = 1;
    self.isAddData = NO;
    [self.tableView reloadData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"FMTradeNoteTableViewCell" bundle:nil] forCellReuseIdentifier:KFMTradeNoteNewControllerFlag];
        [self.view addSubview:_tableView];
        
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            [self getDataSourceFromNetWork];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage = _currentPage + 1;
            _isAddData = YES;
            [self getDataSourceFromNetWork];
        }];
        
        
    }
    return _tableView;
}
-(NSMutableArray *)titleDataSource
{
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray array];
        
    }
    return _titleDataSource;
}

-(UIButton *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        [_tableViewHeaderView addTarget:self action:@selector(headerButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewHeaderView setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:UIControlStateNormal];
        _tableViewHeaderView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, KProjectScreenWidth, 5)];
        lineView.backgroundColor = [HXColor colorWithHexString:@"e7eaef"];
        [_tableViewHeaderView addSubview:lineView];
        [_tableViewHeaderView setTitleColor:[HXColor colorWithHexString:@"#07408f"] forState:UIControlStateNormal];
        [_tableViewHeaderView setBackgroundColor:[HXColor colorWithHexString:@"#e7eaef"]];

        self.tableView.tableHeaderView = _tableViewHeaderView;
        
    }
    return _tableViewHeaderView;
}
@end
