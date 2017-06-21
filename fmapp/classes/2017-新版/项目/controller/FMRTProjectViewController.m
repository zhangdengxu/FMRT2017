//
//  FMRTProjectViewController.m
//  fmapp
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTProjectViewController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
//#import "ProjectDetailController.h"
#import "ClaimsAreaController.h"
#import "DataPage.h"
#import "SVPullToRefresh.h"
#import "WLNewProjectDetailViewController.h"
#import "FMRTHomeTableViewCell.h"
#import "FMRTMainListModel.h"
#import "FMShowWaitView.h"
#define kNavTitleImageViewTag   10009

@interface FMRTProjectViewController ()<FMNavigateMenuDelegate,UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,weak)UIButton *navTitleButton; //问题类型按钮
@property(nonatomic,assign)int projectType;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FMRTXiangmuModel *dataModel;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,assign)BOOL isAddData;
@property(nonatomic,assign)BOOL isFirstRefresh;
@property(nonatomic,strong)NSMutableArray *dataArr;
// 整体覆盖的view
@property (nonatomic, strong) FMShowWaitView *showWait;

@end

@implementation FMRTProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.projectType=0;
    }
    return self;
}

- (FMRTXiangmuModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTXiangmuModel alloc]init];
    }
    return _dataModel;
}

- (FMShowWaitView *)showWait{
    if (!_showWait) {
        _showWait = [[FMShowWaitView alloc] init];
        _showWait.waitType = FMShowWaitViewTpyeFitALL;
    }
    return _showWait;
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.currentPage = 1;
    [self requestGetUserGradeInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFirstRefresh = YES;
    [self settingNavTitle:@"项目列表"];
    [self createLeftBtn];
    [self settingNavigationBar];
    if (self.isFirstRefresh) {
        [self.showWait showViewWithFatherView:self.view];
    }
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage ++;
            _isAddData = YES;
            [weakSelf requestGetUserGradeInfo];
        }];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            
            [weakSelf requestGetUserGradeInfo];
        }];
        //        self.tableView = tbView;
        self.tableView.hidden = NO;
        
    }
    return _tableView;
}


-(void)createLeftBtn{
    /**
     *重写左侧button
     */
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(10, 20, 44, 44)];
    navButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    self.navigationItem.leftBarButtonItem = rightItem;
}

#pragma mark -
#pragma mark - 初始化右侧可编辑按键
- (void)initWithHeaderNavigationRightButton{
    UIBarButtonItem *savePassword = [[UIBarButtonItem alloc]initWithTitle:@"债权专区" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavBtnClick)];
    [savePassword setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:savePassword];
}

- (void)rightNavBtnClick
{
    ClaimsAreaController *viewController=[[ClaimsAreaController alloc]init];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)requestGetUserGradeInfo{
    
    NSString *str = @"";
    if (self.projectType==0)
    {
        str = @"rongtuoxinsoc/Lend/liebiaoyijiuliuer";

    }
    else if (self.projectType==1)
    {
        str = @"ongtuoxinsoc/Lend/danbaoyijiuliuer";
        
    }
    else if (self.projectType==2)
    {
        str = @"rongtuoxinsoc/Lend/diyayijiuliuer";
        
    }
    else if(self.projectType==4)
    {
        str = @"rongtuoxinsoc/Lend/jingyingliuer";
        
    }else if (self.projectType == 7)
    {
        str = @"rongtuoxinsoc/Lend/baoliyijiuliuer";

    }else{
        
        
    }
    NSString *userId;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        userId = [CurrentUserInformation sharedCurrentUserInfo].userId;
    }else{
        userId = @"0";
    }
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.currentPage],
                                 @"page_size":@"6"
                                 };
    FMWeakSelf;
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(str) parameters:parameter completion:^(WebAPIResponse *response) {
        [weakSelf.showWait hiddenGifView];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (_isAddData) {
                _isAddData = NO;
            }else
            {
                [weakSelf.dataArr removeAllObjects];
            }
            if (response.code==WebAPIResponseCodeSuccess) {
                if (!weakSelf.isFirstRefresh) {
                    weakSelf.isFirstRefresh = NO;
                }
                id dataList = [response.responseObject objectForKey:kDataKeyData];
                if ([dataList isKindOfClass:[NSArray class]]) {
                    
                    NSArray *xiangmuArr = dataList;
                    
                    if (xiangmuArr.count) {
                        for (NSDictionary *xaingmuDic in xiangmuArr) {
                            FMRTXiangmuModel *model = [[FMRTXiangmuModel alloc]init];
                            [model setValuesForKeysWithDictionary:xaingmuDic];
                            model.start_time = [NSString retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:model.start_time];
                            model.kaishi = model.kaishicha;
                            [weakSelf.dataArr addObject:model];
                        }
                    }else{

                        if (weakSelf.dataArr.count == 0) {

                            [weakSelf.showWait showLoadDataFail:weakSelf.view];
                            weakSelf.showWait.loadBtn = ^(){
                                [weakSelf requestGetUserGradeInfo];
                            };
                        }else{
                            
                            ShowAutoHideMBProgressHUD(weakSelf.view, @"暂无数据");
                        }
                    }
                }else{
                    if (weakSelf.dataArr.count == 0) {
                        [weakSelf.showWait showLoadDataFail:weakSelf.view];
                        weakSelf.showWait.loadBtn = ^(){
                            [weakSelf requestGetUserGradeInfo];
                        };
                    }else{
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"暂无数据");
                    }
                }
                //避免服务器返回数据异常导致loadmore循环加载
                [weakSelf.tableView reloadData];
            }else if (response.code==WebAPIResponseCodeFailed)
            {

                if (weakSelf.dataArr.count == 0) {

                    [weakSelf.showWait showLoadDataFail:weakSelf.view];
                    weakSelf.showWait.loadBtn = ^(){
                        [weakSelf requestGetUserGradeInfo];
                    };
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
                }

            }else{
                if (weakSelf.dataArr.count == 0) {

                    [weakSelf.showWait showLoadDataFail:weakSelf.view];
                    weakSelf.showWait.loadBtn = ^(){
                    [weakSelf requestGetUserGradeInfo];
                    };
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
                }
            }
            self.tableView.hidden = NO;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        });

    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"QuestionCell";
    
    FMRTHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FMRTHomeTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    if (self.dataArr.count) {
       cell.model = self.dataArr[indexPath.row];
    }
    
        
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArr.count) {
        FMRTXiangmuModel *model=[self.dataArr objectAtIndex:(indexPath.row)];
        
        if([model.zhuangtai isEqualToString:@"8"])
        {
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
            viewController.rongzifangshi = model.rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        else if([model.zhuangtai integerValue] == 4||[model.zhuangtai integerValue] == 6)
        {
            
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
            viewController.rongzifangshi = model.rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            if ([model.kaishicha integerValue]>0) {
                
                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:model.jie_id];
                viewController.rongzifangshi = model.rongzifangshi;
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                
                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:2 WithProjectId:model.jie_id];
                viewController.rongzifangshi = model.rongzifangshi;
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
        }

    }
    
}
- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataArr count]) {
        return;
    }
    
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        
   return 120;

}

#pragma mark -设置导航栏
- (void) settingNavigationBar
{
    //设置导航栏
    UIButton *navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navTitleButton.frame = CGRectMake(0, 2, 140, 40);
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
    [navTitleButton addTarget:self action:@selector(navTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ////设置标题
    [navTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [navTitleButton setTitle:@"项目列表" forState:UIControlStateNormal];
    navTitleButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    
    
    ////下拉箭头
    UIImageView *titleIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 13,16,16)];
    titleIndicatorImageView.tag = kNavTitleImageViewTag;
    [titleIndicatorImageView setImage:[FontAwesome imageWithIcon:FMIconPullDown
                                                       iconColor:[UIColor blackColor]
                                                        iconSize:16.0]];
    [navTitleButton addSubview:titleIndicatorImageView];
    self.navigationItem.titleView = navTitleButton;
    self.navTitleButton = navTitleButton;
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
    [menu addMenuItem:@"全部项目"];
    [menu addMenuItem:@"融担保"];
    [menu addMenuItem:@"融抵押"];
    [menu addMenuItem:@"融保理"];
    [menu addMenuItem:@"经营贷"];
    menu.delegate = self;
    [menu showMenu:CGPointMake(0, 0) curIndex:self.projectType];
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
    
    if (index == 0) {
        [self.navTitleButton setTitle:@"项目列表" forState:UIControlStateNormal];
    }else if (index == 1) {
        [self.navTitleButton setTitle:@"融担保" forState:UIControlStateNormal];
    }else if (index == 2) {
        [self.navTitleButton setTitle:@"融抵押" forState:UIControlStateNormal];
    }else if (index == 3) {
        [self.navTitleButton setTitle:@"融保理" forState:UIControlStateNormal];
    }else if (index == 4) {
        [self.navTitleButton setTitle:@"经营贷" forState:UIControlStateNormal];
        
    }else if (index == 5) {
        
        [self.navTitleButton setTitle:@"债权专区" forState:UIControlStateNormal];
    }
    
    if (index == 3) {
        //7代表连接时候请求融保理
        self.projectType = 7;
    } else if (index == 5)
    {
        //3代表连接时候请求债权转区
        self.projectType = 3;
    }else{
        
        self.projectType=(int)index;
    }
    _currentPage = 1;
    _isAddData = NO;

    [self requestGetUserGradeInfo];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


@end
