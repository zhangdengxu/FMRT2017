//
//  FMRTHomeViewController.m
//  fmapp
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTHomeViewController.h"
#import "FMRTWellStoreViewController.h"
#import "FMRTAuctionViewController.h"
#import "FMRTMainTableHeaderView.h"
#import "FMRTMainSectionView.h"
#import "FMRTMainProjectTableViewCell.h"
#import "FMRTMainListModel.h"
#import "FMTabBarController.h"
#import "AppDelegate.h"
#import "FMTimeKillShopController.h"
#import "FMTimeKillShopDetailController.h"
#import "FMRTAuctionViewController.h"
#import "WLAllklBodyViewController.h"
#import "FMRTWellStoreViewController.h"
#import "FMPlaceOrderViewController.h"
#import "FMShopDetailDuobaoViewController.h"
#import "BabyPlanController.h"
#import "ShareViewController.h"
//#import "ProjectDetailController.h"
//#import "LingTransitionViewController.h" ====XZ
#import "FMSettings.h"
#import "FMHomeAlertView.h"
#import "FMWebViewHeaderController.h"
#import "FMIndexHeaderModel.h"
//#import "InteractionViewController.h"
//#import "WLExploreViewController.h"
#import "BabyPlanController.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "XZShareView.h"
#import "YYLatestInformationViewController.h"
#import "WLWenJuanView.h"
#import "XZQuestionnaireViewController.h"
#import "YSImportantNoticeModel.h"
#import "YSImportantNoticeSecondNewView.h"
#import "WLDuoBaoView.h"
#import "MakeABidWebViewController.h"
#import "WLNewProductPushView.h"
#import "NSDate+CategoryPre.h"
#import "WLZhuCeViewController.h"
//#import "LingQianNewViewController.h" ====XZ
#import "WLDJQTABViewController.h"
#import "YSShareSkipView.h"
#import "WLFirstPageHeaderViewController.h"
#import "UITabBar+FMRTTabBarBadge.h"
#import "FMScoreTradeNoteNewController.h"
#import "FMPlaceOrderViewController.h"
#import "WLXieShangViewController.h"
#import "FMRTHomeTableViewCell.h"
#import "FMRTPlatformDataController.h"
#import "XZStandInsideLetterController.h"
#import "FMRTBackEarningController.h"
#import "WLNewProjectDetailViewController.h"
//#import "XZRechargeController.h"
#import "XZBankRechargeController.h" // 徽商充值
#import "FMRTPayOrderViewController.h"
#import "FMRTRegisterAppController.h"
#import "FMTieBankCardViewController.h"
#import "FMRTAddCardToView.h"
#import "FMRTChangeTradeKeyViewController.h"
#define kXZQuestionnaireUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/wenjuansave"


@interface FMRTHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak)   UIView *navView;
@property (nonatomic, strong) FMRTMainListModel *dataModel;
@property (nonatomic, strong) FMRTMainTableHeaderView *headerView;
@property (nonatomic, strong) NSDictionary *shareNotificationDic,*pushDic;
@property (nonatomic, strong) FMShowWaitView *showWait;
@property (nonatomic, assign) BOOL isFirstRefresh,isWellStore,hasNotReading;
@property (nonatomic, strong) FMHomeAlertView *showView;
@property (nonatomic, strong) XZShareView *share;
@property (nonatomic, strong) UIView *tanchuangView;
@property (nonatomic, strong) YSImportantNoticeModel *ImportantNoticeModel;
@property (nonatomic, strong) NSString *money;//第一次抵价券金额
@property (nonatomic, weak)   UIButton *alertBtn;
@property (nonatomic, assign) NSInteger isShowJPush;//如果有极光推送是否显示


@end

@implementation FMRTHomeViewController

- (FMRTMainListModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTMainListModel alloc]init];
    }
    return _dataModel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(leftloginNotification:)
                                                     name: FMUserLoginNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(leftloginOutNotification:)
                                                     name: FMUserLogoutNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(receivePushNotification:)
                                                     name: FMReceivePushNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(showLoginController:)
                                                     name: KdefaultShowLoginControler
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(roadMainOpenUrlNotification:)
                                                     name: FMShareoOpenUrlNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(roadMainSuccessInGestureViewController:)
                                                     name: KdefaultSuccessInGestureViewController
                                                   object: nil];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(roadMainSuccessSetInGestureViewController:)
                                                     name: KdefaultSetGestureViewController
                                                   object: nil];
      
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self settingNavTitle:@""];
    self.enableCustomNavbarBackButton = NO;
    [self createTableView];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    self.isFirstRefresh = NO;
    [self onlyGetNoticTanchuang];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (ShareAppDelegate.isMainVC) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        ShareAppDelegate.isMainVC = NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillAppear:animated];
    
    [self handleWithJPushInfoJifen];

    [self.headerView.scrollView adjustWhenControllerViewWillAppera];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestMainListData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (FMRTMainTableHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[FMRTMainTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 376/640+KProjectScreenWidth/4+KProjectScreenWidth *132/640)];
        FMWeakSelf;
        _headerView.topFourBlock = ^(NSInteger tag){
            [weakSelf topFourButton:tag];
        };
        _headerView.scroBlock = ^(NSInteger index){
            [weakSelf topScroViewSelectIndex:index];
        };
        _headerView.bbBlock = ^(){
            [weakSelf baobeijihuaAction];
        };
        
        _headerView.beginBlcok = ^(){
            weakSelf.tableView.scrollEnabled = NO;
        };
        
        _headerView.endBlcok = ^(){
            weakSelf.tableView.scrollEnabled = YES;
        };
        
    }
    return _headerView;
}

- (FMShowWaitView *)showWait{
    if (!_showWait) {
        _showWait = [[FMShowWaitView alloc]init];
    }
    return _showWait;
}

- (FMHomeAlertView *)showView{
    if (!_showView) {
        _showView = [[FMHomeAlertView alloc]init];
        [self.view addSubview:_showView];
    }
    return _showView;
}

#pragma mark - 首页List网络请求
- (void)requestMainListData{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
//    NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"/Rongtuoxinsoc/indexapp/appindexalljava?%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@",kFMPhpUniversalBaseUrl(@"GetHomePageData"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    if (!self.isFirstRefresh) {

        [self.showWait showViewWithFatherView:self.view];
    }

    FMWeakSelf;
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        [weakSelf.showWait hiddenGifView];

        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (!weakSelf.isFirstRefresh) {
                    weakSelf.isFirstRefresh = YES;
                }
                [weakSelf.dataModel.scrollArr removeAllObjects];
                [weakSelf.dataModel.mainListArr removeAllObjects];
                [weakSelf.dataModel.tanchuangArr removeAllObjects];
                
                if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if ([response.responseObject objectForKey:@"data"]) {
                        
                        id dicData = [response.responseObject objectForKey:@"data"];
                        
                        if ([dicData isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                            
                            weakSelf.dataModel.scrollArr = [NSMutableArray arrayWithArray:[FMRTLunboModel lunboArrWithDic:dic]];
                            weakSelf.dataModel.mainListArr = [NSMutableArray arrayWithArray:[FMRTXiangmuModel xiamgmudataArrWithDic:dic]];
                            
                            if ([dic objectForKey:@"lingdang"]) {
                                NSString *lingdang = [dic objectForKey:@"lingdang"];
                                if ([lingdang integerValue]>0) {
                                    weakSelf.hasNotReading = YES;
                                }else{
                                    weakSelf.hasNotReading = NO;
                                }
                                
                                [weakSelf checkLingDangZhuangtai];
                            }
                            
                            if ([dic objectForKey:@"tanchuangxinwen"]) {
                                id tanchuangArr = [dic objectForKey:@"tanchuangxinwen"];
                                if ([tanchuangArr isKindOfClass:[NSArray class]]) {
                                    NSArray *arr = (NSArray *)tanchuangArr;
                                    if (arr.count) {
                                        id tanchuangxinwen = [arr firstObject];
                                        if ([tanchuangxinwen isKindOfClass:[NSDictionary class]]) {
                                            NSDictionary *tanDic = (NSDictionary *)tanchuangxinwen;
                                            NSInteger oldId=[FMShareSetting.alerDataId integerValue];
                                            NSInteger newId=[StringForKeyInUnserializedJSONDic(tanDic, @"id") integerValue];
                                            if (newId>oldId) {
                                                [weakSelf.showView showViewWithdict:tanDic];
                                                FMShareSetting.alerDataId=StringForKeyInUnserializedJSONDic(tanDic, @"id");
                                            }
                                        }
                                    }
                                }
                            }
                            weakSelf.headerView.scroArr = [weakSelf.dataModel.scrollArr copy];
                        }
                    }
                }
            }else{
                if (!weakSelf.isFirstRefresh) {
                    [weakSelf.showWait showLoadDataFail:weakSelf.view];
                    weakSelf.showWait.loadBtn = ^(){
                        [weakSelf requestMainListData];
                    };
                }else{
                
                    if ([response.responseObject objectForKey:@"msg"]) {
                        
                        NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                        
                        ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                    }else{
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                    }
                
                }
            }
        }else{
            
            if (!weakSelf.isFirstRefresh) {
                [weakSelf.showWait showLoadDataFail:weakSelf.view];
                weakSelf.showWait.loadBtn = ^(){
                    [weakSelf requestMainListData];
                };
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败!");
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navView.alpha = self.tableView.contentOffset.y/160;
    
    [self checkLingDangZhuangtai];
}

- (void)checkLingDangZhuangtai{
    
    if (self.tableView.contentOffset.y >= 100) {
        
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            if (self.hasNotReading) {
                [self.alertBtn setImage:[UIImage imageNamed:@"首页_领导-有消息_1702"] forState:(UIControlStateNormal)];
            }else{
                [self.alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-黑色_1702"] forState:(UIControlStateNormal)];
            }
        }else{
                [self.alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-黑色_1702"] forState:(UIControlStateNormal)];
        }
    }else{
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            if (self.hasNotReading) {
                [self.alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-有消息2_1702"] forState:(UIControlStateNormal)];
                
            }else{
                [self.alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-白色_1702"] forState:(UIControlStateNormal)];
            }
        }else{
            [self.alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-白色_1702"] forState:(UIControlStateNormal)];
        }
    }
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight - 49) style:(UITableViewStylePlain)];
        tableview.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        FMWeakSelf;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestMainListData];
        }];
        tableview;
    });
    [self.view addSubview:_tableView];
    UIView *navView = [[UIView alloc]init];
    self.navView = navView;
    navView.backgroundColor = [HXColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:navView];
    [navView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    UIImageView *tt = [[UIImageView alloc]init];
    tt.contentMode = UIViewContentModeScaleAspectFit;
    tt.image = [UIImage imageNamed:@"首页_logo_36"];
    [self.view addSubview:tt];
    [tt makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.centerX);
        make.width.equalTo(@85);
        make.centerY.equalTo(navView.centerY).offset(5);
    }];
    
    UIButton *alertBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [alertBtn setImage:[UIImage imageNamed:@"首页_铃铛-有消息2_1702"] forState:(UIControlStateNormal)];//首页_铃铛-有消息2_1702
    [self.view addSubview:alertBtn];
    self.alertBtn = alertBtn;
    [alertBtn addTarget:self action:@selector(alertAct) forControlEvents:(UIControlEventTouchUpInside)];
    [alertBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-5);
        make.top.equalTo(self.view.top).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.navView.alpha = self.tableView.contentOffset.y/160;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    
}

#pragma mark - 站内信
- (void)alertAct{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        XZStandInsideLetterController *plactVC = [[XZStandInsideLetterController alloc]init];
        plactVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:plactVC animated:YES];
    }else{
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return self.dataModel.mainListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"FMRTHomeTableViewCell";
    FMRTHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMRTHomeTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.model = self.dataModel.mainListArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataModel.mainListArr.count) {
        FMRTXiangmuModel *model = self.dataModel.mainListArr[indexPath.row];
        if([model.zhuangtai integerValue]==8){
            
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
            viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }else if([model.zhuangtai integerValue]==4||[model.zhuangtai integerValue]==6){

            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
            viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
            
        }else{
            if ([model.kaishicha integerValue] >0) {

                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:model.jie_id];
                viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
                
            }else{

                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:2 WithProjectId:model.jie_id];
                viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FMRTMainSectionView *view = [[FMRTMainSectionView alloc]init];
    FMWeakSelf;
    view.sectionBlock = ^(){
        [weakSelf projectOfMore];
    };
    return view;
}

#pragma mark - 最新优质项目
- (void)projectOfMore{
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - 宝贝计划
- (void)baobeijihuaAction{
    BabyPlanController *vc = [[BabyPlanController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 平台数据-安全保障-优商城-邀请好友
- (void)topFourButton:(NSInteger)tag{
    switch (tag) {
        case 701:
        {
            FMRTPlatformDataController *platformVC = [[FMRTPlatformDataController alloc]init];
            platformVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:platformVC animated:YES];

            break;
        }
        case 702:
        {


            ShareViewController *webViewController=[[ShareViewController alloc]initWithTitle:@"安全保障" AndWithShareUrl:@"https://www.rongtuojinrong.com/rongtuoxinsoc/Gengdfwu/anquanbaozhang"];
            webViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webViewController animated:YES];
//            FMRTBackEarningController *webViewController=[[FMRTBackEarningController alloc]init];
//            webViewController.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:webViewController animated:YES];
//            FMRTPayOrderViewController *webViewController=[[FMRTPayOrderViewController alloc]init];
//            webViewController.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:webViewController animated:YES];
//            
            break;
        }
        case 703:
        {

            FMRTWellStoreViewController *vc = [[FMRTWellStoreViewController alloc]init];
//            FMRTRegisterAppController *vc = [[FMRTRegisterAppController alloc]init];

            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 704:
        {
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
                [self getShareDataSourceFromNetWork];

            }else{
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
}

- (void)topScroViewSelectIndex:(NSInteger)index{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    FMIndexHeaderModel * headerModel = self.dataModel.scrollArr[index];
    
    // 暂时全民夺宝是1
    if ([headerModel.yanzheng integerValue] ==1 ) {
        // 如果是1,判断用户是否登录、未登录跳转到登录界面,在加载web页的url后面加四个参数
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 用户已登录
            if ([headerModel.lianjie isKindOfClass:[NSString class]]) {
                if (headerModel.lianjie.length > 2) {
                    WLFirstPageHeaderViewController *viewController =[[WLFirstPageHeaderViewController alloc]init];
                    NSString *html = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",headerModel.lianjie,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
                    //NSString *html = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",@"https://www.rongtuojinrong.com/rongtuoxinsoc/user/niandihuodongindex",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
                    
                    
                    
                    viewController.shareURL = html;
                    viewController.navTitle = headerModel.biaoti;
                    viewController.headerModel = headerModel;
                    viewController.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
        }else { // 未登录
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:^{
            }];
        }
    }else { // 如果是0,直接进入
        if ([headerModel.lianjie isKindOfClass:[NSString class]]) {
            if (headerModel.lianjie.length > 2) {
                WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];
                viewController.shareURL = headerModel.lianjie;
                viewController.navTitle = headerModel.biaoti;
                viewController.headerModel = headerModel;
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

#pragma mark - 登陆通知
- (void)leftloginNotification:(NSNotification *)notification{
    [self requestMainListData];
    NSDictionary * dict = notification.userInfo;
    if (dict) {
        NSInteger status = [dict[@"status"] integerValue];
        if (status == 1) {
            
        }
    }else{
        /*
         *  调取弹窗数据
         */
        
        [self getFirstDataSourceFromNetWork];
        
    }
}

- (void)leftloginOutNotification:(NSNotification *)notification{
    [self requestMainListData];
    [self.tanchuangView setHidden:YES];
    [self.tanchuangView removeFromSuperview];
    self.tanchuangView = nil;
}

-(void)createAlert{
    
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲爱的融米，我平台已切换至徽商银行进行资金存管，为确保正常投资，请开通徽商存管账户；" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 36699;
    [alter show];
}

-(void)createAnotherAlert{

    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲爱的融米，我平台已切换至徽商银行进行资金存管，为确保正常投资，请设置您的交易密码！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 39999;
    [alter show];
}

#pragma mark - 推送通知
- (void)receivePushNotification:(NSNotification *)notification{
    
    self.pushDic=notification.object;
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(receivePush) userInfo:nil repeats:NO];
}

- (void)receivePush{
    self.tabBarController.selectedIndex = 0;

    NSDictionary *apsDic=self.pushDic;
    NSString *type=StringForKeyInUnserializedJSONDic(apsDic, @"type");
    if ([type isEqualToString:@"1"]) {
        
        [self shareMessageJumpXiangmuBiaoWithInfomation:apsDic];
    }else if([type isEqualToString:@"6"]){
        //活动积分页面；
        self.isShowJPush = 1;
        [self handleWithJPushInfoJifen];
    }else if([type isEqualToString:@"7"])
    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        BabyPlanController * babyPlan  = [[BabyPlanController alloc]init];
        babyPlan.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:babyPlan animated:YES];
        
    }else
    {
        ShareViewController *webViewController=[[ShareViewController alloc]initWithTitle:nil AndWithShareUrl:StringForKeyInUnserializedJSONDic(apsDic, @"url")];
        webViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    //推送消息，跳转站内信
    //XZStandInsideLetterController * stand = [[XZStandInsideLetterController alloc]init];
    //stand.hidesBottomBarWhenPushed=YES;
    //[self.navigationController pushViewController:stand animated:YES];
}


-(void)handleWithJPushInfoJifen
{
    if (self.isShowJPush == 0) {
        return;
    }
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString * webViewIndex = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",@"https://www.rongtuojinrong.com/rongtuoxinsoc/user/niandihuodongindex",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    
    ShareViewController *webViewController1=[[ShareViewController alloc]initWithTitle:@"" AndWithShareUrl:webViewIndex];
    webViewController1.JumpWay = @"MyRecommand";
    webViewController1.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webViewController1 animated:NO];
    FMScoreTradeNoteNewController * scoreTrae = [[FMScoreTradeNoteNewController alloc]init];
    scoreTrae.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:scoreTrae animated:YES];
    self.isShowJPush = 0;
}

- (void)shareMessageJumpXiangmuBiaoWithInfomation:(NSDictionary *)apsDic{
    
    NSInteger projectStyle=IntForKeyInUnserializedJSONDic(apsDic, @"zhuangtai");
    NSString *projectId=StringForKeyInUnserializedJSONDic(apsDic, @"jie_id");
    NSString * rongzifangshi = StringForKeyInUnserializedJSONDic(apsDic, @"rongzifangshi");
    NSInteger kaishicha=IntForKeyInUnserializedJSONDic(apsDic, @"kaishicha");
    
    if(projectStyle==8){
        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:projectId];
        viewController.rongzifangshi = rongzifangshi;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(projectStyle==4||projectStyle==6){
        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:projectId];
        viewController.rongzifangshi = rongzifangshi;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        if (kaishicha>0) {
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:projectId];
            viewController.rongzifangshi = rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:2 WithProjectId:projectId];
            viewController.rongzifangshi = rongzifangshi;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - 指纹解锁
-(void)showLoginController:(NSNotification *)notifi{
    if (notifi.userInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@" 指纹密码未识别,请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 30099;
        [alert show];
    }else{
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 30099){
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        FMTabBarController * tabbar = (FMTabBarController *)window.rootViewController;
        [tabbar setSelectedIndex:0];
        
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
    if (alertView.tag == 36699) {
        if (buttonIndex == 0) {
            
        }else{
            FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
            tieBank.hidesBottomBarWhenPushed = YES;
            
            UINavigationController *nav = self.tabBarController.selectedViewController;

            [nav pushViewController:tieBank animated:YES];
        }
    }
    if (alertView.tag == 39999) {
        if (buttonIndex == 0) {
            
        }else{
            FMRTChangeTradeKeyViewController *vc = [[FMRTChangeTradeKeyViewController alloc]init];
            vc.typeTitle = titleSetting;
            vc.hidesBottomBarWhenPushed = YES;
            UINavigationController *nav = self.tabBarController.selectedViewController;
            [nav pushViewController:vc animated:YES];
            
        }
    }
}

#pragma mark - APP吊起通知
- (void)roadMainOpenUrlNotification:(NSNotification *)notification{
    NSDictionary *userDic = notification.object;
    
    if ([[userDic objectForKey:@"flag"] integerValue] <20) {
        self.shareNotificationDic = [userDic copy];
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            [ShareAppDelegate initWithUserAutoLogin];
        }else{
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:^{
                self.tabBarController.selectedIndex = 0;
            }];
        }
    }
}
#pragma -mark  手势解锁之后处理通知的方法  
/*该方法与下方的方法功能类似
 第一个方法是处理手势解锁成功所走的通知，该出调用原来的shareDicInfoJumpViewControllerWith方法以及调用弹出用户绑卡的弹窗，未做改动
 第二个方法处理设置手势解锁所走的通知，两次设置成功之后，不在弹出绑卡弹窗，因此做下调整
 
 */
- (void)roadMainSuccessInGestureViewController:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self shareDicInfoJumpViewControllerWith:self.shareNotificationDic];
        if (!([[CurrentUserInformation sharedCurrentUserInfo].weishangbang integerValue]== 1)) {
            [self createAlert];//提示开通微商存管账户
        }else if (!([[CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi integerValue]== 1)){
            [self createAnotherAlert];//提示设置交易密码
        }
    });
}
-(void)roadMainSuccessSetInGestureViewController:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self shareDicInfoJumpViewControllerWith:self.shareNotificationDic];
    });
}



- (void)shareDicInfoJumpViewControllerWith:(NSDictionary *)shareDic{
    // Flag;//网页调起app标识1：秒杀首页，2：竞拍首页，3：夺宝首页，4：优商城首页，5:优商城首页(夺宝秒杀结束)，6:零钱贯(去除)，7：宝贝计划，8：项目详情，9：新版本的夺宝
    // product_id;//网页调起app商品标识，有或者无
    self.shareNotificationDic = nil;
    if ([shareDic objectForKey:@"flag"] && ([[shareDic objectForKey:@"flag"] integerValue] < 20)) {
        
        self.tabBarController.selectedIndex = 0;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        switch ([[shareDic objectForKey:@"flag"] integerValue]) {
            case 1:
            {
                if ([shareDic objectForKey:@"product_id"]) {
                    FMTimeKillShopController *viewController=[[FMTimeKillShopController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:NO];
                    
                    FMTimeKillShopDetailController *killVC = [[FMTimeKillShopDetailController alloc]init];
                    killVC.shopDetailStyle = FMTimeKillShopDetailControllerStyleMiaoSha;
                    killVC.actionFlag = [shareDic objectForKey:@"id"];
                    killVC.product_id = [shareDic objectForKey:@"product_id"];
                    killVC.detailURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",[shareDic objectForKey:@"product_id"]];
                    [self.navigationController pushViewController:killVC animated:NO];
                }else{
                    FMTimeKillShopController *viewController=[[FMTimeKillShopController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                break;
            }
            case 2:
            {
                if ([shareDic objectForKey:@"product_id"]) {
                    
                    FMRTAuctionViewController *viewController=[[FMRTAuctionViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:NO];
                    
                    FMTimeKillShopDetailController *killVC = [[FMTimeKillShopDetailController alloc]init];
                    killVC.shopDetailStyle = FMTimeKillShopDetailControllerJingPai;
                    killVC.actionFlag = [shareDic objectForKey:@"id"];
                    killVC.product_id = [shareDic objectForKey:@"product_id"];
                    killVC.detailURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",[shareDic objectForKey:@"product_id"]];
                    [self.navigationController pushViewController:killVC animated:NO];
                }else{
                    FMRTAuctionViewController *viewController=[[FMRTAuctionViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                break;
            }
            case 3:
            {
                WLAllklBodyViewController *mainVC = [[WLAllklBodyViewController alloc]init];
                mainVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mainVC animated:YES];
                
                break;
            }
            case 4:
            {
                if ([shareDic objectForKey:@"product_id"]) {
                    //优商城首页
                    FMRTWellStoreViewController *viewController=[[FMRTWellStoreViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:NO];
                    
                    FMPlaceOrderViewController *fmVC = [[FMPlaceOrderViewController alloc]init];
                    
                    fmVC.product_id = [shareDic objectForKey:@"product_id"];
                    [self.navigationController pushViewController:fmVC animated:NO];
                }else{
                    FMRTWellStoreViewController *viewController=[[FMRTWellStoreViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                break;
            }
            case 5:
            {
                FMRTWellStoreViewController *viewController=[[FMRTWellStoreViewController alloc]init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 6:
            {
                
                break;
            }
            case 7:
            {
                
                BabyPlanController *VC = [[BabyPlanController alloc]init];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];

                break;
            }
            case 8:
            {
                [self shareMessageJumpXiangmuBiaoWithInfomation:shareDic];
                break;
            }
            case 9:
            {
                
                if ([shareDic objectForKey:@"product_id"]) {
                    WLAllklBodyViewController *mainVC = [[WLAllklBodyViewController alloc]init];
                    mainVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mainVC animated:NO];
                    FMShopDetailDuobaoViewController *allTakeVC = [[FMShopDetailDuobaoViewController alloc]init];
                    allTakeVC.won_id = [shareDic objectForKey:@"id"];
                    allTakeVC.product_id = [shareDic objectForKey:@"product_id"];
                    [self.navigationController pushViewController:allTakeVC animated:NO];
                }else{
                    WLAllklBodyViewController *mainVC = [[WLAllklBodyViewController alloc]init];
                    mainVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mainVC animated:YES];
                }
                
                break;
            }
            case 10:
            {
                int timestamp = [[NSDate date] timeIntervalSince1970];
                NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
                NSString *tokenlow=[token lowercaseString];
                
                NSString * webViewIndex = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",@"https://www.rongtuojinrong.com/rongtuoxinsoc/user/niandihuodongindex",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
                
                ShareViewController *webViewController1=[[ShareViewController alloc]initWithTitle:@"" AndWithShareUrl:webViewIndex];
                webViewController1.JumpWay = @"MyRecommand";
                webViewController1.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:webViewController1 animated:NO];
                FMScoreTradeNoteNewController * scoreTrae = [[FMScoreTradeNoteNewController alloc]init];
                [self.navigationController pushViewController:scoreTrae animated:NO];
                
                break;
            }
            case 11:
            {
                
                if ([shareDic objectForKey:@"product_id"]) {
                    
                    FMRTWellStoreViewController *viewController=[[FMRTWellStoreViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:NO];
                    
                    FMPlaceOrderViewController *fmVC = [[FMPlaceOrderViewController alloc]init];
                    fmVC.isShopFullScore = 1;
                    fmVC.product_id = [shareDic objectForKey:@"product_id"];
                    [self.navigationController pushViewController:fmVC animated:NO];
                    
                }else{
                    FMRTWellStoreViewController *viewController=[[FMRTWellStoreViewController alloc]init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getShareDataSourceFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
    NSString *tokenlow=[token lowercaseString];
    NSString * shareUrlHtml = kDefaultShareUrlBase;
    
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"leixing":@4
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FMWeakSelf;
    [FMHTTPClient postPath:shareUrlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                if ([dic objectForKey:@"xiayibu"]) {
                    NSString *xiayibu = [dic objectForKey:@"xiayibu"];
                    if ([xiayibu length] > 5) {
                        
                        FMIndexHeaderModel * headerModel = [FMIndexHeaderModel new];
                        WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];
                        viewController.shareURL = [dic objectForKey:@"xiayibu"];
                        viewController.navTitle = [dic objectForKey:@"xiayibutitle"];
                        headerModel.fenxiangbiaoti = [dic objectForKey:@"title"];
                        NSString *url = [dic objectForKey:@"url"];
                        headerModel.fenxianglianjie = [NSString stringWithFormat:@"%@",url];
                        headerModel.fenxiangpic = [dic objectForKey:@"picurl"];
                        headerModel.fenxiangneirong = [dic objectForKey:@"content"];
                        
                        viewController.headerModel = headerModel;
                        viewController.hidesBottomBarWhenPushed=YES;
                        [weakSelf.navigationController pushViewController:viewController animated:YES];
                        
                    }else{
                        XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
                        
                        modelShare.sharetitle = [dic objectForKey:@"title"];
                        NSString *url = [dic objectForKey:@"url"];
                        modelShare.shareurl = [NSString stringWithFormat:@"%@?user_id=%@&appid=%@&shijian=%@&token=%@",url,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow];
                        
                        modelShare.sharepic = [dic objectForKey:@"picurl"];
                        modelShare.sharecontent = [dic objectForKey:@"content"];
                        weakSelf.share.modelShare = modelShare;
                        
                        [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
                    }
                }else{
                    XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
                    
                    modelShare.sharetitle = [dic objectForKey:@"title"];
                    NSString *url = [dic objectForKey:@"url"];
                    modelShare.shareurl = [NSString stringWithFormat:@"%@?user_id=%@&appid=%@&shijian=%@&token=%@",url,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow];
                    
                    modelShare.sharepic = [dic objectForKey:@"picurl"];
                    modelShare.sharecontent = [dic objectForKey:@"content"];
                    weakSelf.share.modelShare = modelShare;
                    
                    [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败！");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求网络数据失败！");
        }
    }];
}

- (XZShareView *)share{
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        __weak typeof(self.share)weakShare = self.share;
        __weak typeof(self)weakSelf = self;
        
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
    }
    return _share;
}


#pragma mark - 首页弹窗
//调查问卷弹窗
-(void)wenjuanAlert{
    if ([[NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].wenjuanxianshi]isEqualToString:@"1"]) {
        
        [self putUserChooseToNetWork];//已经弹窗
        [self.tanchuangView removeFromSuperview];
        __weak __typeof(&*self)weakSelf = self;
        //判断当天是否显示过调查问卷弹窗
        WLWenJuanView *signView = [[WLWenJuanView alloc]init];
        [self.view addSubview:signView];
        self.tanchuangView = signView;
        signView.blockWenJuanBtn = ^(){
            XZQuestionnaireViewController *vc = [[XZQuestionnaireViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }else{
        
        [self getTanChuangDataSourceFromNetWork];
    }
}

// 将用户的选择提交到服务器
- (void)putUserChooseToNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // zhuangtai:(问卷是否完成1表示未完成,2表示完成)
    NSDictionary *parameter = @{
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"appid":@"huiyuan",
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                @"Zhuangtai":@"1"
                                };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZQuestionnaireUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"问卷调查response.responseObject = %@",response.responseObject);
        if(response.code == WebAPIResponseCodeSuccess){
            [CurrentUserInformation sharedCurrentUserInfo].wenjuanxianshi = @"0";
            [CurrentUserInformation saveUserObjectWithUser:[CurrentUserInformation sharedCurrentUserInfo]];
        }else{
            
        }
    }];
}

/**
 *保存上次时间
 */
-(void)baocunTimeForKey:(NSString *)key{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date1 = [dateformatter stringFromDate:senddate];
    [[NSUserDefaults standardUserDefaults] setObject:date1 forKey:key];
}

/**
 *获取上次时间
 */
-(NSString *)holdOnTimeWithKey:(NSString *)key{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    Log(@"上次打开时间   = %@",[NSString stringWithFormat:@"%@",str]);
    NSString *timeStr = [NSString stringWithFormat:@"%@",str];
    return timeStr;
}

/**
 *获取本次时间
 */
-(NSString *)huoquNoticeTime{
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date1 = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:senddate]];
    return date1;
}

//重要消息弹窗
-(void)onlyGetNoticTanchuang{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0"];
    NSString *urlStr = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/user/apptanchuangindexzhounian";
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0",timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow
                                 };
    
    __weak __typeof(self)weakSelf = self;
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSDictionary *newArray = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
            if (![newArray isKindOfClass:[NSNull class]]) {
                
                NSDictionary *zygonggaoArray =newArray[@"zygonggao"];
                
                if (![zygonggaoArray isMemberOfClass:[NSNull class]]) {
                    
                    YSImportantNoticeModel *importantModel = [[YSImportantNoticeModel alloc]init];
                    
                    [importantModel setValuesForKeysWithDictionary:zygonggaoArray];
                    weakSelf.ImportantNoticeModel = importantModel;
                    
                    if (zygonggaoArray) {
                        if (!weakSelf.tanchuangView) {
                            /**
                             *  重要通知弹窗
                             */
                            if (![[weakSelf huoquNoticeTime]isEqualToString:[self holdOnTimeWithKey:@"zhongyaotanchuang"]]) {
                                YSImportantNoticeSecondNewView *vc = [[YSImportantNoticeSecondNewView alloc]initWithFrame:CGRectMake(0 , 0, KProjectScreenWidth, KProjectScreenHeight )];
                                vc.ImportantNoticeModel = self.ImportantNoticeModel;
                                [weakSelf.tanchuangView removeFromSuperview];
                                [weakSelf.view addSubview:vc];
                                weakSelf.tanchuangView = vc;
                                [weakSelf baocunTimeForKey:@"zhongyaotanchuang"];
                            }
                        }
                    }
                }
            }
        }
    }];
}

//重要消息弹窗
-(void)GetNoticTanchuang{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0"];
    NSString *urlStr = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/user/apptanchuangindexzhounian";
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0",timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow
                                 };
    
    __weak __typeof(self)weakSelf = self;
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSDictionary *newArray = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
            if (![newArray isKindOfClass:[NSNull class]]) {
                
                NSDictionary *zygonggaoArray =newArray[@"zygonggao"];
                
                if (![zygonggaoArray isMemberOfClass:[NSNull class]]) {
                    YSImportantNoticeModel *importantModel = [[YSImportantNoticeModel alloc]init];
                    
                    [importantModel setValuesForKeysWithDictionary:zygonggaoArray];
                    weakSelf.ImportantNoticeModel = importantModel;
                    
                    NSDate *senddate = [NSDate date];
                    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *date1 = [dateformatter stringFromDate:senddate];
                    Log(@"获取当前时间   = %@",date1);
                    
                    if (zygonggaoArray) {
                        if (!weakSelf.tanchuangView) {
                            /**
                             *  重要通知弹窗
                             */
                            if (![[weakSelf huoquNoticeTime]isEqualToString:[self holdOnTimeWithKey:@"zhongyaotanchuang"]]) {
                                YSImportantNoticeSecondNewView *vc = [[YSImportantNoticeSecondNewView alloc]initWithFrame:CGRectMake(0 , 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
                                vc.ImportantNoticeModel = self.ImportantNoticeModel;
                                [weakSelf.view addSubview:vc];
                                weakSelf.tanchuangView = vc;
                                [weakSelf baocunTimeForKey:@"zhongyaotanchuang"];
                            }else{
                                if (!weakSelf.tanchuangView) {
                                    [weakSelf wenjuanAlert];
                                }
                            }
                        }else{
                            if (!weakSelf.tanchuangView) {
                                [weakSelf wenjuanAlert];
                            }
                        }
                    }else{
                        if (!weakSelf.tanchuangView) {
                            [weakSelf wenjuanAlert];
                        }
                    }
                }else{
                    
                    if (!weakSelf.tanchuangView) {
                        [weakSelf wenjuanAlert];
                    }
                }
            }else{
                
                if (!weakSelf.tanchuangView) {
                    [weakSelf wenjuanAlert];
                }
            }
        }else{
            if (!weakSelf.tanchuangView) {
                [weakSelf wenjuanAlert];
            }
        }
    }];
}

#pragma mark --- 弹窗数据网略请求

- (void)getTanChuangDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/user/apptanchuangindexzhounian";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow
                                 };
    __weak __typeof(self)weakSelf = self;
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if(response.code == WebAPIResponseCodeSuccess){
            if (response.responseObject) {
                NSDictionary *newArray = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
                //弹出次数限制
                if (![newArray isKindOfClass:[NSNull class]]) {
                    NSDictionary *Ydic = [newArray objectForKey:@"youshangcheng"];
                    
                    if (Ydic &&![Ydic isKindOfClass:[NSNull class]]){
                        //全民夺宝弹窗
                        NSString *chanpin_id = [NSString stringWithFormat:@"%@",[Ydic objectForKey:@"chanpin_id"]];
                        NSString *cishu = [NSString stringWithFormat:@"%@",[Ydic objectForKey:@"cishu"]];
                        if ([weakSelf canBeTanchuWithCishu:cishu andWithKey:@"quanminduobao"
                             ]) {
                            [weakSelf.tanchuangView removeFromSuperview];
                            WLDuoBaoView *signView = [[WLDuoBaoView alloc]initWithPic:[NSString stringWithFormat:@"%@",[newArray[@"youshangcheng"] objectForKey:@"pic"]] andUrl:[NSString stringWithFormat:@"%@",[newArray[@"youshangcheng"] objectForKey:@"lianjie"]]];
                            [weakSelf.view addSubview:signView];
                            [weakSelf baocunTimeForKey:@"quanminduobao"];
                            signView.block = ^(NSString *url) {
                                
                                if (chanpin_id.length) {
                                    
                                    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
                                    placeOrder.goToGoodShopIndex = 2;
                                    placeOrder.product_id = chanpin_id;
                                    placeOrder.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:placeOrder animated:YES];

                                    
                                }else if(![[NSString stringWithFormat:@"%@",[newArray[@"youshangcheng"] objectForKey:@"lianjie"]] isMemberOfClass:[NSNull class]]){
                                    if ([NSString stringWithFormat:@"%@",[newArray[@"youshangcheng"] objectForKey:@"lianjie"]].length) {
                                        MakeABidWebViewController *shareVC = [[MakeABidWebViewController alloc]initWithTitle:[newArray[@"youshangcheng"] objectForKey:@"title"] AndWithShareUrl:[NSString stringWithFormat:@"%@",[newArray[@"youshangcheng"] objectForKey:@"lianjie"]]];
                                        shareVC.hidesBottomBarWhenPushed = YES;
                                        shareVC.isTanchu = @"1";
                                        [weakSelf.navigationController pushViewController:shareVC animated:YES];
                                    }
                                }
                            };
                            weakSelf.tanchuangView = signView;
                        }else if([newArray objectForKey:@"xinpin"]&&![[newArray objectForKey:@"xinpin"] isKindOfClass:[NSNull class]]){
                            //新品推送弹窗
                            if ([weakSelf canBeTanchuWithCishu:cishu andWithKey:@"xinpintuisong"
                                 ]) {
                                [weakSelf.tanchuangView removeFromSuperview];
                                WLNewProductPushView *signView = [[WLNewProductPushView alloc]initWithDic:newArray[@"xinpin"]];
                                [weakSelf.view addSubview:signView];
                                signView.theXinpinBlock = ^(NSString *xiayibu,NSString *laiyuan,NSString *buttonText){
                                    
                                    [weakSelf newProductPush:xiayibu andTheLaiyuan:laiyuan andButtonText:buttonText];
                                };
                                weakSelf.tanchuangView = signView;
                                [weakSelf baocunTimeForKey:@"xinpintuisong"];
                                
                            }
                        }
                    }
                    else if ([newArray objectForKey:@"xinpin"]&&![[newArray objectForKey:@"xinpin"] isKindOfClass:[NSNull class]]){
                        NSDictionary *Xdic = [newArray objectForKey:@"xinpin"];
                        NSString *cishu = [NSString stringWithFormat:@"%@",[Xdic objectForKey:@"cishu"]];
                        if ([weakSelf canBeTanchuWithCishu:cishu andWithKey:@"xinpintuisong"
                             ]) {
                            //新品推送弹窗
                            [weakSelf.tanchuangView removeFromSuperview];
                            WLNewProductPushView *signView = [[WLNewProductPushView alloc]initWithDic:newArray[@"xinpin"]];
                            [weakSelf.view addSubview:signView];
                            signView.theXinpinBlock = ^(NSString *xiayibu,NSString *laiyuan,NSString *buttonText){
                                
                                [weakSelf newProductPush:xiayibu andTheLaiyuan:laiyuan andButtonText:buttonText];
                            };
                            weakSelf.tanchuangView = signView;
                            [weakSelf baocunTimeForKey:@"xinpintuisong"];
                        }
                    }
                }
            }
        }
    }];
}
/**
 *判断弹窗是否可以弹出
 */
-(BOOL)canBeTanchuWithCishu:(NSString *)cishu andWithKey:(NSString *)key{
    if ([cishu isEqualToString:@"0"]) {
        if (![[self huoquNoticeTime] isEqualToString:[self holdOnTimeWithKey:key]]) {
            return YES;
        }else{
            return NO;
        }
    }else if ([cishu isEqualToString:@"1"]) {
        return YES;
    }else {
        if([cishu intValue] > 1) {
            NSDate * dateLinshi = [NSDate date];
            //N天后的日期
            NSString *daysAfter = [dateLinshi getNextDayWithDayString:[self holdOnTimeWithKey:key] withNumDay:[cishu integerValue]];
            NSDate *daysAfterDate = [NSDate retNSStringToNSdate:daysAfter];//N天后的时间
            NSDate *nowDate = [NSDate retNSStringToNSdate:[self huoquNoticeTime]];//本次时间
            
            return [self compareDate:daysAfterDate andDate:nowDate];
        }else{
            return NO;
        }
    }
}

-(BOOL)compareDate:(NSDate *)date1 andDate:(NSDate *)date2{
    //后边的日期大返回yes
    NSComparisonResult result =  [date1 compare:date2];
    if (result == NSOrderedAscending){
        return YES;
    }else{
        return NO;
    }
}

-(void)newProductPush:(NSString *)xiayibu andTheLaiyuan:(NSString *)laiyuan andButtonText:(NSString *)buttonText{
    
    if ([xiayibu isEqualToString:@"1"]) {
        //实名
        if ([CurrentUserInformation sharedCurrentUserInfo].shiming  == 1) {
            
            ShowImportErrorAlertView(@"您已通过实名认证");
        }
        else
        {
             __weak __typeof(&*self)weakSelf = self;
            [FMRTAddCardToView showWithAddBtn:^{
                FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
                tieBank.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:tieBank animated:YES];
                
                //!!!!!---!!!!
            }];
            
          
            
            
            /*
            int timestamp = [[NSDate date]timeIntervalSince1970];
            NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            NSString *url=[NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@&laiyuan=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,laiyuan];
            WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
            viewController.shareURL = url;
            viewController.navTitle = @"实名认证";
            viewController.comeForm = 0;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
             */
        }
        
    }else if ([xiayibu isEqualToString:@"2"]){
        //充值
//        int timestamp = [[NSDate date]timeIntervalSince1970];
//        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//        NSString *tokenlow=[token lowercaseString];
//        NSString *url=[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chongzhiwebershiyi?user_id=%@&appid=huiyuan&shijian=%d&token=%@&laiyuan=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,laiyuan];
//        MakeABidWebViewController *viewController=[[MakeABidWebViewController alloc]initWithTitle:@"充值" AndWithShareUrl:url];
//        viewController.isTanchu =  @"1";
//        viewController.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:viewController animated:YES];
        
//        XZRechargeController *vc = [[XZRechargeController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
        XZBankRechargeController *viewController=[[XZBankRechargeController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if ([xiayibu isEqualToString:@"3"]){
        
//        //零钱贯 ====XZ
//        LingQianNewViewController *vc = [[LingQianNewViewController alloc]init];
//        vc.laiyuan = @"1";
//        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([xiayibu isEqualToString:@"4"]){
        //自动投标
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&laiyuan=%@",babyNewPlanAutoTenderURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,laiyuan];
        MakeABidWebViewController *viewController=[[MakeABidWebViewController alloc]initWithTitle:@"自动投标" AndWithShareUrl:url];
        viewController.isTanchu = @"1";
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark --- first 抵价券网略请求
- (void)getFirstDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/ticket/getTicket",kXZTestEnvironment];
    
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"trench":@"first"
                                 };
    Log(@"调用");
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        if(response.code == WebAPIResponseCodeSuccess){
            if (response.responseObject) {
                NSDictionary *dict = [NSDictionary dictionary];
                dict = response.responseObject[@"data"];
                if (![dict isKindOfClass:[NSNull class]]) {
                    double ddd = [dict[@"money"] doubleValue];
                    int mm = (int)ddd;
                    weakSelf.money = [NSString stringWithFormat:@"%d",mm];
                    if ([weakSelf.money intValue] > 0) {
                        [weakSelf.tanchuangView removeFromSuperview];
                        YSShareSkipView *vc = [[YSShareSkipView alloc]init];
                        vc.frame = CGRectMake(0 , 0, KProjectScreenWidth, KProjectScreenHeight);
                        vc.money = [NSString stringWithFormat:@"%@元", self.money];
                        vc.blockBtn = ^(UIButton *button){
                            WLDJQTABViewController *vc = [[WLDJQTABViewController alloc]init];
                            vc.flag = @"";
                            vc.tag = @"";
                            vc.state = @"";
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        };
                        [weakSelf.view addSubview:vc];
                    }else{
                        if (!weakSelf.tanchuangView) {
                            [weakSelf GetNoticTanchuang];
                        }
                    }
                }else{
                    
                    if (!weakSelf.tanchuangView) {
                        [weakSelf GetNoticTanchuang];
                    }
                }
            }else{
                
                if (!weakSelf.tanchuangView) {
                    [weakSelf GetNoticTanchuang];
                }
            }
        }else{
            if (!weakSelf.tanchuangView) {
                [weakSelf GetNoticTanchuang];
            }
        }
    }];
}


@end
