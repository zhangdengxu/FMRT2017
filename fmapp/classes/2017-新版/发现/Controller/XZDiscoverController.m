//
//  XZDiscoverController.m
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//  发现

#import "XZDiscoverController.h"
#import "XZDiscoverHeaderView.h" // headerView
#import "XZDiscoverCell.h" // 融讯融言部分
#import "XZDiscoverImageCell.h" // 推荐活动部分
#import "FMBeautifulModel.h"
#import "XMRongmiAdsModel.h"
#import "XMShareWebViewController.h" // 融讯融言点击进去界面
#import "XZGetTogetherViewController.h" // 聚一聚
#import "XZStandInsideLetterController.h" //  站内信
//#import "FMAcountMainViewController.h" // 我要记账
#import "XMFinanceNewsViewController.h" // 融讯融言
#import "XMWebViewControllerRM.h" // 推荐活动web页
#import "HelpingCenterViewController.h" // 帮助中心
#import "UITabBar+FMRTTabBarBadge.h" // tabBar的消息
#import "AppDelegate.h"
#import "YYInvestorEducationController.h" //投资者教育
#import "XZAboutUsController.h" //  关于我们
#import "XZDiscoverNewModel.h" // 头部滚动条的model
#import "ShareViewController.h" // 头部点击进入详情
#import "YYLatestInformationViewController.h" // 平台公告
#import "XZFinanceToolsController.h" //  理财小工具

//测试====
#import "XZProjectDetailsController.h" // 项目信息====查看详情
#import "XZTestViewController.h" // 图片
//#import "XZBankRechargeController.h" // 徽商充值页面

// 融讯融言的url
#define XZRongMiClubURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/rxry/p/1"

//// 头部滚动条的url
//#define XZScrollingNewsURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/user/faxianxiaolaba"

@interface XZDiscoverController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableDiscover;

@property (nonatomic, strong) XZDiscoverHeaderView *headerView;
//
@property (nonatomic, assign) BOOL isFirstRefresh;
// 整体覆盖的view
@property (nonatomic, strong) FMShowWaitView *showWait;
// 数据数组
@property (nonatomic, strong) NSMutableArray *arrRongMiClub;
// 大转盘和砸金蛋链接
@property (nonatomic, strong) NSMutableArray *dataSourcePic;
// 接收通知
@property (nonatomic, strong) NSDictionary *shareNotificationDic;
// 头部滚动条数据
@property (nonatomic, strong) NSMutableArray *arrScrollNews;
@end

@implementation XZDiscoverController

- (instancetype)init {
    if (self == [super init]) {
        // 调起app通知
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(roadMainOpenUrlNotification:)
                                                     name: FMShareoOpenUrlNotification
                                                   object: nil];
        // 手势解锁通知
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(roadMainSuccessInGestureViewController:)
                                                     name: KdefaultSuccessInGestureViewController
                                                   object: nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.enableCustomNavbarBackButton = NO;
    
    // 添加小娃娃
    self.isFirstRefresh = NO;
    
    [self settingNavTitle:@"发现"];
    
    [self.view addSubview:self.tableDiscover];
    
    if (!self.isFirstRefresh) {
        [self.showWait showViewWithFatherView:self.view];
    }
    
    // 请求融讯融言的数据
    [self requestRongMiClubDataFromNetWork];
    
    // 请求大转盘和砸金蛋的数据
    [self getRongMicycleAdsInfo];
    
    //
    UIButton *btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(0, 0, 65, 44);
    [btnAboutUs setTitle:@"关于我们" forState:UIControlStateNormal];
    [btnAboutUs.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnAboutUs setTitleColor:KContentTextColor forState:UIControlStateNormal];
    btnAboutUs.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnAboutUs addTarget:self action:@selector(didClickAboutUs) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAboutUs];
}

#pragma mark ---- 关于我们
- (void)didClickAboutUs {
//    // 项目查看详情
//    XZProjectDetailsController *aboutUs = [[XZProjectDetailsController alloc] init];
//    aboutUs.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:aboutUs animated:YES];
    
    XZAboutUsController *aboutUs = [[XZAboutUsController alloc] init];
    aboutUs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUs animated:YES];
    
//    //  徽商充值页面
//    XZBankRechargeController *bankRecharge = [[XZBankRechargeController alloc] init];
//    bankRecharge.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bankRecharge animated:YES];

//    //  图片
//    XZTestViewController *testView = [[XZTestViewController alloc] init];
//    testView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 请求头部滚动条数据
    [self requestScrollingNewsFromNetWork];
    
}

#pragma mark ---- 请求融讯融言的数据
- (void)requestRongMiClubDataFromNetWork {
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:XZRongMiClubURL parameters:nil completion:^(WebAPIResponse *response) {
        [weakSelf.showWait hiddenGifView];
//        NSLog(@"融讯融言的数据：======= %@",response.responseObject);
        
        if (!response.responseObject) {
            if (!weakSelf.isFirstRefresh) {
                [weakSelf.showWait showLoadDataFail:weakSelf.view];
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败!");
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
        }
        else {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (!weakSelf.isFirstRefresh) {
                    weakSelf.isFirstRefresh = YES;
                }
                [weakSelf.arrRongMiClub removeAllObjects];
                if (response.responseObject != nil) {
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        NSArray *dataArray = response.responseObject[@"data"];
                        if (dataArray.count != 0) { // data中有值
                            for (NSDictionary *dict in dataArray) {
                                FMBeautifulModel *modelRongMi = [[FMBeautifulModel alloc]init];
                                [modelRongMi setValuesForKeysWithDictionary:dict];
                                [weakSelf.arrRongMiClub addObject:modelRongMi];
                            }
                        }
                    }
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                }
            }
            else {
                if (!weakSelf.isFirstRefresh) {
                    [weakSelf.showWait showLoadDataFail:weakSelf.view];
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败!");
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    
                }
            }
        }
        [weakSelf.tableDiscover reloadData];
        [weakSelf.tableDiscover.mj_header endRefreshing];
    }];
}

#pragma mark ---- 请求大转盘和砸金蛋的数据
-(void)getRongMicycleAdsInfo
{
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:KRongmiClub_MiddleAdsCycle parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        NSLog(@"大转盘和砸金蛋的数据：======= %@",response.responseObject);
        if (response.responseObject) {
            [weakSelf.dataSourcePic removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSArray *data = response.responseObject[@"data"];
                for (NSDictionary * dic in data) {
                    XMRongmiAdsModel *model = [[XMRongmiAdsModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [weakSelf.dataSourcePic addObject:model];
                }
            }
        }
        [weakSelf.tableDiscover reloadData];
    }];
}

#pragma mark ---- 请求头部滚动数据
- (void)requestScrollingNewsFromNetWork {
    
    __weak __typeof(&*self)weakSelf = self;
    // XZScrollingNewsURL
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/user/faxianxiaolabaliuer") parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            
            [weakSelf.arrScrollNews removeAllObjects];
            
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSArray *dataArray = response.responseObject[@"data"];
                if (response.responseObject != nil) {
                    if (![dataArray isKindOfClass:[NSNull class]]) {
                        if (dataArray.count != 0) {
                            for (NSDictionary *dictionary in dataArray) {
                                XZDiscoverNewModel *model = [[XZDiscoverNewModel alloc] init];
                                [model setValuesForKeysWithDictionary:dictionary];
                                [weakSelf.arrScrollNews addObject:model];
                            }
                        }
                    }
                }
            }
        }
        weakSelf.headerView.arrayNew = weakSelf.arrScrollNews;
    }];
    
}

#pragma mark - APP吊起通知
- (void)roadMainOpenUrlNotification:(NSNotification *)notification {
    NSDictionary *userDic = notification.object;
    // flag > 20 是“发现”
    if ([[userDic objectForKey:@"flag"] integerValue] > 20) {
        
        self.shareNotificationDic = [userDic copy];
        
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            
            [ShareAppDelegate initWithUserAutoLogin];
            
        }else{
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:^{
                self.tabBarController.selectedIndex = 2;
            }];
        }
    }
}

- (void)roadMainSuccessInGestureViewController:(NSNotification *)notification {
    [self shareDicInfoJumpViewControllerWith:self.shareNotificationDic];
}

- (void)shareDicInfoJumpViewControllerWith:(NSDictionary *)shareDic {
    // Flag;// 网页调起app标识 21 砸金蛋 22 大转盘
    self.shareNotificationDic = nil;
    if ([shareDic objectForKey:@"flag"] && ([[shareDic objectForKey:@"flag"] integerValue] > 20)) {
        self.tabBarController.selectedIndex = 2;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        // 判断是否含有当前flag
        BOOL(^blockHasType)(NSString *) = ^BOOL(NSString *type) {
            BOOL hasFlag = NO;
            if (self.dataSourcePic.count > 0) {
                for (int i = 0; i < self.dataSourcePic.count; i++) {
                    XMRongmiAdsModel *model = self.dataSourcePic[i];
                    // 当前数组中含有这个flag
                    if ([model.type isEqualToString:type]) {
                        hasFlag = YES;
                        return hasFlag;
                    }
                }
            }
            return hasFlag;
        };
        
        switch ([[shareDic objectForKey:@"flag"] integerValue]) {
            case 21: // 砸金蛋
            {
                if (self.dataSourcePic.count > 0 && blockHasType(@"jindan")) {
                    // 直接跳转
                    [self pushToShareVcWithIndex:1];
                }
                break;
            }
            case 22: // 大转盘
            {
                if (self.dataSourcePic.count > 0 && blockHasType(@"zhuanpan")) {
                    [self pushToShareVcWithIndex:0];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourcePic.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XZDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZDiscoverCell"];
        if (!cell) {
            cell = [[XZDiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZDiscoverCell"];
        }
        cell.discovers = self.arrRongMiClub;
        
        __weak __typeof(&*self)weakSelf = self;
        // 融讯融言的点击事件
        cell.blockCoverButton = ^{
            XMFinanceNewsViewController *financeNews = [[XMFinanceNewsViewController alloc] init];
            financeNews.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:financeNews animated:YES];
        };
        
        // 点击事件
        if (self.arrRongMiClub.count > 0) {
            cell.blockDidClickItem = ^(NSIndexPath *index) {
                [weakSelf didClickItemAtRongXunRongYan:index];
            };
        }
        return cell;
    }else {
        XZDiscoverImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableDiscoverCell"];
        if (!cell) {
            cell = [[XZDiscoverImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableDiscoverCell"];
        }
        XMRongmiAdsModel *model;
        if (self.dataSourcePic.count > 0) {
            model = self.dataSourcePic[indexPath.row - 1];
        }
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        [self DetermineWhetherTheLogin:^{
            [self pushToShareVcWithIndex:indexPath.row - 1];
        }];
    }
}

// 大转盘跳转web页
- (void)pushToShareVcWithIndex:(NSInteger)index {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    if (self.dataSourcePic.count == 0) {
        return;
    }
    XMRongmiAdsModel *model = self.dataSourcePic[index];
    NSString *flag;
    if ([model.type isEqualToString:@"zhuanpan"]) { // 大转盘
        flag = @"22";
    }else if ([model.type isEqualToString:@"jindan"]) { // 砸金蛋
        flag = @"21";
    }
    NSString *html = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@&flag=%@",model.lianjie,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,flag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XMWebViewControllerRM *shareVc = [[XMWebViewControllerRM alloc]init];
        shareVc.navTitle = model.title;
        shareVc.navColor = [UIColor redColor];
        shareVc.shareURL = html;
        shareVc.lianjie = model.lianjie;
        shareVc.sharepic = model.sharepic;
        shareVc.neirong = model.neirong;
        shareVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVc animated:YES];
    });
}

#pragma mark ----- 点击融讯融言的item
- (void)didClickItemAtRongXunRongYan:(NSIndexPath *)indexPath {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    FMBeautifulModel *modelRongMi = [self.arrRongMiClub objectAtIndex:indexPath.item];
    NSString *news_id = modelRongMi.news_id;

    NSString *html = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",news_id,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];

    NSString *htmlNoInfo = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@",news_id];
    XMShareWebViewController *shareVC = [[XMShareWebViewController alloc]initWithTitle:modelRongMi.title AndWithShareUrl:html WithShareUrlWithNoUserInfo:htmlNoInfo withContent:modelRongMi.shareContent];
    shareVC.dataSource = modelRongMi;
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat height = (KProjectScreenWidth - 24) / 4.0 + 10 + 20 + 30 + 30 + 10 + 20;
        return height; // 200
    }else {
        return (316 / 640.0 * KProjectScreenWidth);
    }
}

#pragma mark ----- 判断是否登录
- (void)DetermineWhetherTheLogin:(void(^)()) block {
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        block();
    }else {// 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
    }
}

#pragma mark ---- 懒加载
- (UITableView *)tableDiscover {
    if (!_tableDiscover) {
        _tableDiscover = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableDiscover.delegate = self;
        _tableDiscover.dataSource  = self;
        _tableDiscover.backgroundColor = KDefaultOrBackgroundColor;
        _tableDiscover.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableDiscover.showsVerticalScrollIndicator = NO;
        _tableDiscover.tableHeaderView = self.headerView;
        __weak __typeof(&*self)weakSelf = self;
        
        _tableDiscover.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 请求融讯融言的数据
            [weakSelf requestRongMiClubDataFromNetWork];
            // 请求大转盘和砸金蛋的数据
            [weakSelf getRongMicycleAdsInfo];
            // 请求头部滚动消息
            [weakSelf requestScrollingNewsFromNetWork];
        }];

    }
    return _tableDiscover;
}

- (XZDiscoverHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XZDiscoverHeaderView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 190)];
        
        __weak __typeof(&*self)weakSelf = self;
        _headerView.blockCoverButton = ^(UIButton *button) {
            if (button.tag == 1001) { // 滚动部分右侧按钮===平台数据
                YYLatestInformationViewController *latestInformation = [[YYLatestInformationViewController alloc] init];
                latestInformation.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:latestInformation animated:YES];
            }
            else if (button.tag == 1003) { // 投资者教育
                YYInvestorEducationController *investorE = [[YYInvestorEducationController alloc]init];
                investorE.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:investorE animated:YES];
            }else if (button.tag == 1004) { // 帮助中心
                HelpingCenterViewController *helpCenter = [[HelpingCenterViewController alloc] init];
                helpCenter.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:helpCenter animated:YES];
            }else if (button.tag == 1005) { // 聚一聚
                XZGetTogetherViewController *getTogher = [[XZGetTogetherViewController alloc] init];
                getTogher.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:getTogher animated:YES];
            }else if (button.tag == 1006) { // 理财小工具
                [weakSelf DetermineWhetherTheLogin:^{
                    XZFinanceToolsController *accountMain = [[XZFinanceToolsController alloc] init];
                    accountMain.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:accountMain animated:YES];
                }];
            }
        };
        
        _headerView.blockClickScroll = ^(NSInteger currentIndex){
            XZDiscoverNewModel *model = weakSelf.arrScrollNews[currentIndex];
//            @"详情" 
            ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:model.title AndWithShareUrl:model.url];
//            shareVc.JumpWay = @"MyRecommand";
            shareVc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:shareVc animated:YES];
        };
    }
    return _headerView;
}

- (NSMutableArray *)arrRongMiClub {
    if (!_arrRongMiClub) {
        _arrRongMiClub = [NSMutableArray array];
    }
    return _arrRongMiClub;
}

- (FMShowWaitView *)showWait{
    if (!_showWait) {
        _showWait = [[FMShowWaitView alloc] init];
        _showWait.waitType = FMShowWaitViewTpyeFitALL;
        __weak __typeof(&*self)weakSelf = self;
        // 点击重新加载
        _showWait.loadBtn = ^{
            // 请求头部滚动条数据
            [weakSelf requestScrollingNewsFromNetWork];
            // 请求大转盘和砸金蛋的数据
            [weakSelf getRongMicycleAdsInfo];
            // 请求融讯融言的数据
            [weakSelf requestRongMiClubDataFromNetWork];
        };
    }
    return _showWait;
}

- (NSMutableArray *)dataSourcePic
{
    if (!_dataSourcePic) {
        _dataSourcePic = [NSMutableArray array];
    }
    return _dataSourcePic;
}
                        
- (NSMutableArray *)arrScrollNews {
    if(!_arrScrollNews) {
        _arrScrollNews = [NSMutableArray array];
    }
    return _arrScrollNews;
}

@end
