//
//  InteractionViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "InteractionViewController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
#import "ProjectDetailController.h"
#import "ClaimsAreaController.h"
#import "DataPage.h"
#import "SVPullToRefresh.h"
#import "WLNewProjectDetailViewController.h"
#define kNavTitleImageViewTag   10009

@interface InteractionViewController ()<FMNavigateMenuDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮
@property (nonatomic,assign)int       projectType;
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;
@property (nonatomic, strong) FMShowWaitView * showWait;
@end


@implementation InteractionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.projectType=ProjectResquestTypeAll;
        self.dataSource = [DataPage page];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self settingNavTitle:@"项目列表"];
    [self settingNavigationBar];
//    [self initWithHeaderNavigationRightButton];
    
    UITableView* tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.backgroundColor = [UIColor clearColor];
    tbView.dataSource = self;
    tbView.delegate = self;
    [self.view addSubview:tbView];
    self.tableView = tbView;
   
    // 加载动画
    [self showGitImage];
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(void){
        [weakSelf refreshListData];
    }];
    ConfiguratePullToRefreshViewAppearanceForScrollView(self.tableView);
    [self.tableView triggerPullToRefresh];
   
}

-(void)showGitImage
{
    FMShowWaitView * showWait = [[FMShowWaitView alloc]init];
    self.showWait = showWait;
    [showWait showViewWithFatherView:self.view];
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

- (void)refreshListData
{
    self.loadMore=YES;
    //停掉当前未完成的请求操作
    //清空当前数据源中所有数据
    [self.dataSource cleanAllData];                      
    [self.tableView reloadData];
    [self loadMoreListData];
}
- (void)loadMoreListData
{
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getQuestionType:self.projectType pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
        [self.showWait hiddenGifView];
//        NSLog(@"%@",response.responseObject);
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        {
            UpdateLastRefreshDataForPullToRefreshViewOnView([weakSelf tableView]);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {

                NSMutableArray *questionList = [NSMutableArray array];
                NSArray* dataList = [response.responseObject objectForKey:kDataKeyData];
                if ([dataList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in dataList)
                    {
                        ProjectModel *question = [ProjectModel modelWithUnserializedJSONDic:dic];
                        if (question) {
                            
                        [questionList addObject:question];
                            
                        }
                    }
                }
                //避免服务器返回数据异常导致loadmore循环加载
                if ([questionList count] == 0) {
                    
                    self.loadMore=NO;
                }
                [weakSelf.dataSource appendPage:questionList];
                [weakSelf.tableView reloadData];
                
            }else if (response.code==WebAPIResponseCodeFailed)
            {
//                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                // 重新加载
                self.showWait.loadBtn = ^(){
                    [weakSelf loadMoreListData];
                };
                [self.showWait showLoadDataFail:self.view];
                
                if (self.loadMoreCell) {
                    [self.loadMoreCell stopLoadingAnimation];
                    self.loadMoreCell.textLabel.text = LOADMORE_LOADOVER;
                }
                
            }else {
                // 重新加载
                self.showWait.loadBtn = ^(){
                    [weakSelf loadMoreListData];
                };
                [self.showWait showLoadDataFail:self.view];
            }
            
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
    return [self.dataSource count] + 1; //添加一行显示“正在加载”或“加载完毕”;
}
- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    if ([cellIdentifier isEqualToString:kHUILoadMoreCellIdentifier])
    {
        return CreateLoadMoreCell();
        
    }
    ProjectCell* cell = [[ProjectCell alloc] init];
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"QuestionCell";
    BOOL isLoadMoreCell = [self _isLoadMoreCellAtIndexPath:indexPath];
    cellIdentifier = isLoadMoreCell? kHUILoadMoreCellIdentifier: cellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [self createCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!isLoadMoreCell)
        [self _configureCell:cell forRowAtIndexPath:indexPath];
    else
    {
        self.loadMoreCell = (HUILoadMoreCell*)cell;
        if (self.loadMore&&[self.dataSource count])
        {
            
            __weak __typeof(&*self)weakSelf = self;
            [(HUILoadMoreCell*)cell setLoadMoreOperationDidStartedBlock:^{
                [weakSelf loadMoreListData];
            }];
            [(HUILoadMoreCell*)cell startLoadMore];
        }
        else
        {
            
            if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
                cell.textLabel.text = LOADMORE_LOADING;
            }else{
                cell.textLabel.text = LOADMORE_LOADOVER;
            }
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self _isLoadMoreCellAtIndexPath:indexPath])
        return;
    
    ProjectModel *model=[self.dataSource.data objectAtIndex:(indexPath.row)];
    
    if(model.projectStyle==8)
    {
    ProjectDetailController *viewController=[[ProjectDetailController alloc]initWithUserOperationStyle:ProjectFinishOperationStyle WithProjectId:model.projectId];
    viewController.rongzifangshi = model.rongzifangshi;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(model.projectStyle==4||model.projectStyle==6)
    {
//        ProjectDetailController *viewController=[[ProjectDetailController alloc]initWithUserOperationStyle:ProjectFinishOperationStyle WithProjectId:model.projectId];
//        viewController.rongzifangshi = model.rongzifangshi;
//        viewController.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:viewController animated:YES];
        
        
        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.projectId];
        viewController.rongzifangshi = model.rongzifangshi;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        if (model.kaishicha>0) {
//            ProjectDetailController *viewController=[[ProjectDetailController alloc]initWithUserOperationStyle:ProjectStartOperationStyle WithProjectId:model.projectId];
//            viewController.rongzifangshi = model.rongzifangshi;
//            viewController.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:viewController animated:YES];
            
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:model.projectId];
            viewController.rongzifangshi = model.rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            ProjectDetailController *viewController=[[ProjectDetailController alloc]initWithUserOperationStyle:ProjectInprogressOperationStyle WithProjectId:model.projectId];
            viewController.rongzifangshi = model.rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    
    ProjectModel *question = [self.dataSource.data objectAtIndex:(indexPath.row)];
    ProjectCell* questionCell = (ProjectCell* )cell;
    [questionCell displayQuestion:question];
    
}

#pragma mark - UITableViewDelegate
- (BOOL)_isLoadMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == [self.dataSource count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self _isLoadMoreCellAtIndexPath:indexPath])
        return kSizeLoadMoreCellHeight;
    if (indexPath.row < [self.dataSource.data count]) {
        
        return 140;
    }
    return 40.0;
}

#pragma mark -设置导航栏
- (void) settingNavigationBar
{
    //设置导航栏
    UIButton *navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navTitleButton.frame = CGRectMake(0, 2, 140, 40);
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
//    [navTitleButton setBackgroundImage:createImageWithColor([[ThemeManager sharedThemeManager].skin baseTintColor])
//                              forState:UIControlStateHighlighted];
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
//    [menu addMenuItem:@"债权专区"];
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
        
        self.projectType=(ProjectResquestType)index;
    }
    
    [self.tableView triggerPullToRefresh];
}
/**
 *
 */
@end
