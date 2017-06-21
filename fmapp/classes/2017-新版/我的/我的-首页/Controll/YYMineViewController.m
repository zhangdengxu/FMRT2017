//
//  YYMineViewController.m
//  fmapp
//
//  Created by yushibo on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYMineViewController.h"
#import "YYMineViewCell.h"
#import "YYMineHeaderView.h"
#import "FMMineModel.h"
#import "MyClaimController.h"  //我的债权
#import "BabyPlanDetailViewController.h" //宝贝计划详情
#import "XZHadEearningViewController.h"  //已赚收益
#import "XZMyScoreController.h" //我的积分
#import "YYCardPackageController.h"  //我的卡券包
#import "YYMyBillController.h" //账单
#import "ShareViewController.h"
#import "BabyPlanModel.h"
#import "FMProfmptBoxView.h"
#import "BabyPlanConfirmViewController.h" //宝贝计划
//#import "XZRechargeController.h"  //充值
#import "XZBankRechargeController.h" // 徽商充值页面
#import "MoneyTiXianViewController.h" //取现
#import "UIButton+WebCache.h"
#import "XZStandInsideLetterController.h" //站内信
#import "FMSignDownNoteView.h"
#import "YYAccountInformationController.h" //账户信息页
#import "FMMyRecommendController.h"  //我的推荐人界面
#import "FMJoinDetailPrizeViewController.h"  //我的邀请界面
#import "FMJionFriendListViewController.h"  //有效好友列表界面
#import "BabyPlanController.h" // 宝贝计划介绍页面
//#import "FMMyRecommentCalendarViewController.h"  //我的推荐界面
#import "FMRefundMoneyViewController.h"
#import "MakeABidWebViewController.h"
#import "UITabBar+FMRTTabBarBadge.h"
#import "WLFirstPageHeaderViewController.h"
#import "XZActivityModel.h"
#import "XZShareView.h"
#import "XZRiskQuestionnaireViewController.h"
#import "FMRTBackEarningController.h"
#import "WLRechargeController.h"
#import "FMTieBankCardViewController.h"
//#import "YYHuiShangTXController.h"  // 徽商银行提现
#import "FMRTAddCardToView.h"
#import "FMRTRebackMoneyController.h"
#import "FMRTChangeTradeKeyViewController.h"



@interface YYMineViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic, strong) FMMineModel *model;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) YYMineHeaderView *headerView;
@property (nonatomic, assign) BOOL isHeadRefresh;
@property (nonatomic, strong) FMShowWaitView *showWait;
// 接收通知
@property (nonatomic, assign) BOOL isGestureFinished;
// 积分
@property (nonatomic, strong) NSString *jifen;
/**  用户风险评估 */
/**  是否完成 */
@property (nonatomic, strong) NSString *IsDone;
/**  是否失效 */
@property (nonatomic, strong) NSString *IsInvalid;
/**  右上角铃铛 */
@property (nonatomic, strong) UIButton *lingdangBtn;
@property (nonatomic, strong) XZShareView * share;



@end

@implementation YYMineViewController
static NSString *ID1 = @"YYMineViewCell";
static NSString *ID2 = @"headerView";

#pragma mark --- 接收通知
- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(YYMineloginNotification:)
                                                     name: FMUserLoginNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(YYMinejifenNotification:)
                                                     name: KdefaultSuccessInGestureViewController
                                                   object: nil];
        // 退出登录通知
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(leftloginOutNotification:)
                                                     name: FMUserLogoutNotification
                                                   object: nil];
    }
    
    return self;
}

- (void)YYMineloginNotification:(NSNotification *)infomition{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.tabBarController.selectedIndex == 3) {
        [self requestGetUserGradeInfo];
        [self requestDatatoCollectionView];
    }
}

- (void)YYMinejifenNotification:(NSNotification *)infomition{
    self.isGestureFinished = YES;
    if (self.tabBarController.selectedIndex == 3) {
        
        [self sendingSignInfo];
    }
}

#pragma mark ---- 退出登录通知
- (void)leftloginOutNotification:(NSNotification *)notification {
    self.isGestureFinished = NO;
}

#pragma mark --- 懒加载
-(NSArray *)titleArray{

    if(!_titleArray){
        _titleArray = [NSArray arrayWithObjects:@"我的债权",@"我的宝贝计划",@"已赚收益",@"我的积分",@"回款计划",@"我的卡券",@"账单",@"我的邀请", nil];
    }
    return _titleArray;
}
-(NSArray *)contentArray{

    if (!_contentArray) {
        _contentArray = [NSArray arrayWithObjects:@"查询我投过的项目",@"查看详情",@"500.16元",@"500.00分",@"哪天回款 一目了然",@"2张",@"每笔交易清晰记录",@"已邀请10位好友", nil];
    }
    return _contentArray;
}

#pragma mark --- 小人跑
-(FMShowWaitView *)showWait{
    if (!_showWait) {
        __weak __typeof(self)weakSelf = self;
        _showWait = [[FMShowWaitView alloc]init];
        _showWait.waitType = FMShowWaitViewTpyeFitALL;
        _showWait.loadBtn = ^(){
            [weakSelf requestDatatoCollectionView];
            [weakSelf getUserIconFromNetWork];
            [weakSelf requestGetUserGradeInfo];
        };
        
    }
    return _showWait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"我的";
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ffffff"],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    self.enableCustomNavbarBackButton = NO;
    
    [self requestGetUserGradeInfo];
    [self setNavItem];
    [self setupCollectionView];
//    [self requestDatatoCollectionView];
//    [self sendingSignInfo];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    // 改变状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //跳转界面改回导航栏白色
    [[ThemeManager sharedThemeManager] applySkinToNavigationBar:self.navigationController.navigationBar withColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[ThemeManager sharedThemeManager] applySkinToNavigationBar:self.navigationController.navigationBar withColor:[HXColor colorWithHexString:@"#0159d5"] shadowColor:[HXColor colorWithHexString:@"#0159d5"]];
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self requestDatatoCollectionView];
        [self requestGetUserGradeInfo];
    }
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    // 请求用户头像数据
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self getUserIconFromNetWork];
        
        if (self.isGestureFinished) {
            if (self.isHeadRefresh) {
                
                // 请求签到数据
                [self sendingSignInfo];
            }
        }
    }
}

#pragma mark ----- 签到提交
-(void)sendingSignInfo {
    int y = (int)(1 + (arc4random() % 6));
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{
                                @"appid":@"huiyuan",
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                @"jifenshu":[NSNumber numberWithInt:y],
                                @"leixing":@"1"
                                };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:KRongmiClub_signArriveAndAddScore parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *infoTextArr = [response.responseObject objectForKey:kDataKeyData];
            if (![infoTextArr isKindOfClass:[NSNull class]]) {
                weakSelf.jifen = [NSString stringWithFormat:@"%@",[response.responseObject objectForKey:@"jifen"]];
                FMSignDownNoteView *signDown = [[FMSignDownNoteView alloc] initWithSignCount:[weakSelf.jifen integerValue]];
                [signDown showViewWithKeyWindow];
                weakSelf.jifen = @""; // 积分置空
            }
        }else{
        
//            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }
    }];
}

#pragma mark ---- 请求用户头像数据
- (void)getUserIconFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"appid":@"huiyuan",
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/commoninfochangliu" parameters:parameter completion:^(WebAPIResponse *response) {
        if (response.responseObject) {
            
            if (response.code == WebAPIResponseCodeSuccess) {
                ShowAutoHideMBProgressHUD(self.view, @"请求头像数据失败");

            }
            
            if (response.code == WebAPIResponseCodeFailed) {
                NSDictionary *data = response.responseObject[@"data"];
                
                [weakSelf setNavgationLeftButton:data[@"avatar"]];
            }
        }
    }];
}


#pragma mark -- 创建左上头像
- (void)setNavgationLeftButton:(NSString *)userIconUrl {
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 35, 35);
    [loginBtn addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 17.5f;
    __weak __typeof(&*self)weakSelf = self;
    [loginBtn sd_setImageWithURL:[NSURL URLWithString:userIconUrl]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
    
        weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
        
    }];
}

- (void)didClickLoginButton:(UIButton *)button{

    YYAccountInformationController *aiv = [[YYAccountInformationController alloc]init];
    aiv.IsDone = self.IsDone;
    aiv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aiv animated:YES];
}

#pragma mark -- 右上角铃铛
- (void)setNavItem{
    
    UIButton *lingdangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lingdangBtn setImage:[UIImage imageNamed:@"首页_铃铛-黑色_1702"] forState:UIControlStateHighlighted];
    [lingdangBtn setImage:[UIImage imageNamed:@"首页_铃铛-白色_1702"] forState:UIControlStateNormal];
    [lingdangBtn sizeToFit];
    [lingdangBtn addTarget:self action:@selector(lingdangClick) forControlEvents:UIControlEventTouchUpInside];
    self.lingdangBtn = lingdangBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lingdangBtn];
    
}

-(void)lingdangClick{

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

#pragma mark ---- 请求GetUserGradeInfo数据 -- 是否显示 去评估
- (void)requestGetUserGradeInfo{
    
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                     @"AppId":@"huiyuan",
                                     @"AppTime":[NSNumber numberWithInt:timestamp],
                                     @"Token":tokenlow,
                                   //  @"CmdId":@"GetUserGradeInfo"
                                     };
    FMWeakSelf;
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"GetUserGradeInfo") parameters:parameter completion:^(WebAPIResponse *response) {
    
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dataDic = [response.responseObject objectForKey:@"data"];
            if ([dataDic isKindOfClass:[NSNull class]]){
               
            }else{
                weakSelf.IsDone = [NSString stringWithFormat:@"%@", dataDic[@"IsDone"]];
                weakSelf.IsInvalid = [NSString stringWithFormat:@"%@", dataDic[@"IsInvalid"]];
                
                [weakSelf.headerView sendDataWithIsDone:weakSelf.IsDone IsInvalid:weakSelf.IsInvalid];
                if ([[CurrentUserInformation sharedCurrentUserInfo].fengxianwenjuanwode integerValue] == 1) {  //显示

                    if ([weakSelf.IsDone isEqualToString:@"0"]) {
                        if (KProjectScreenWidth > 320) {
                            
                            _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 260);
                        }else{
                            _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 260 - 14 - 6);
                            
                        }
                        
                    }else{
                        
                        if ([weakSelf.IsInvalid isEqualToString:@"1"]) {
                            
                            if (KProjectScreenWidth > 320) {
                                
                                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 260);
                            }else{
                                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 260 - 14 -6);
                                
                            }
                            
                            
                        }else{
                            
                            if (KProjectScreenWidth > 320) {
                                
                                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221);
                            }else{
                                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221 - 14 - 6);
                                
                                
                            }
                        }
                    }
                }else{
                    
                    if (KProjectScreenWidth > 320) {
                        
                        _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221);
                    }else{
                        _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221 - 14 - 6);
                        
                    }
                    
                    
                }
                
            }
        }else{
            
//            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }

    }];
}


#pragma mark ---- 请求我的界面整体数据  -- 金额
- (void)requestDatatoCollectionView{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                              //   @"CmdId":@"GetUserInfo"
                                 };
    
//    int timestamp = [[NSDate date] timeIntervalSince1970];
//    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//    NSString *tokenlow=[token lowercaseString];
//    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
//                                 @"appid":@"huiyuan",
//                                 @"shijian":[NSNumber numberWithInt:timestamp],
//                                 @"token":tokenlow};

    if (!self.isHeadRefresh) {
        [self.showWait showViewWithFatherView:self.view];
    }
    [self startWaitting];
    FMWeakSelf;
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"GetUserInfo") parameters:parameter completion:^(WebAPIResponse *response) {
//    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/hfmyindexyiliu" parameters:parameter completion:^(WebAPIResponse *response) {

        [weakSelf stopWaitting];
        if (!response.responseObject) {
            if (!weakSelf.isHeadRefresh) {
                [weakSelf.showWait showLoadDataFail:weakSelf.view];
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败!");
            }
        }else{
            
            if (response.code==WebAPIResponseCodeSuccess) {
                
                if (!weakSelf.isHeadRefresh) {
                    [weakSelf.showWait hiddenGifView];
                    [weakSelf sendingSignInfo];
                }
                weakSelf.isHeadRefresh = YES;
                
                NSDictionary *dataDic = [response.responseObject objectForKey:@"data"];
                if ([dataDic isKindOfClass:[NSNull class]]){
                    if (!weakSelf.isHeadRefresh) {
                        [weakSelf.showWait showLoadDataFail:weakSelf.view];
                    }
                }else{
                    weakSelf.model = [FMMineModel mj_objectWithKeyValues:dataDic];
                    
                    

                    /**
                     *  测试在途资金
                     */
//                    if ([[CurrentUserInformation sharedCurrentUserInfo].userId integerValue] == 191) {
//                        weakSelf.model.dongjiezhong = @"1";
//                    }else{
//                        weakSelf.model.dongjiezhong = @"0";
//
//                    }
                    [weakSelf.headerView sendDataWithmodel:weakSelf.model IsDone:weakSelf.IsDone IsInvalid:weakSelf.IsInvalid];
                    
                    NSString *lingdang = dataDic[@"lingdang"];
          //          NSLog(@"%@",lingdang);
                    if ([lingdang integerValue] > 0) {
                        
                        [weakSelf.lingdangBtn setImage:[UIImage imageNamed:@"首页_铃铛-有消息2_1702"] forState:UIControlStateNormal];
                    }else{
                        
                        [weakSelf.lingdangBtn setImage:[UIImage imageNamed:@"首页_铃铛-白色_1702"] forState:UIControlStateNormal];
                    }
                }
                
            }else{
                if (!weakSelf.isHeadRefresh) {
                    [weakSelf.showWait showLoadDataFail:weakSelf.view];

                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败!");
                }
            }
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];


    }];
}

#pragma mark ---- 创建 UICollectionView
- (void)setupCollectionView{

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    if (KProjectScreenWidth > 320) {
        collectionViewLayout.itemSize = CGSizeMake((KProjectScreenWidth - 1) / 2, 95);
    }else{
        collectionViewLayout.itemSize = CGSizeMake((KProjectScreenWidth - 1) / 2, 75);
    }
    
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.minimumLineSpacing = 1.0;
    collectionViewLayout.minimumInteritemSpacing = 0.5;
    collectionViewLayout.headerReferenceSize = CGSizeMake(KProjectScreenWidth, 221);
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 113) collectionViewLayout:collectionViewLayout];
    [collectionView registerClass:[YYMineViewCell class] forCellWithReuseIdentifier:ID1];
    [collectionView registerClass:[YYMineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ID2];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self.view addSubview:collectionView];
    
    __weak typeof (self)weakSelf = self;

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestGetUserGradeInfo];
        [weakSelf requestDatatoCollectionView];
        [weakSelf getUserIconFromNetWork];
    }];
    
}

#pragma mark ----  UICollectionView 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.titleArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

#pragma mark ----  UICollectionView 代理方法 cell内容赋值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YYMineViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID1 forIndexPath:indexPath];
    if (indexPath.row == 0) { //我的债券
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = self.contentArray[indexPath.row];
    
    }else if (indexPath.row == 1){ //我的宝贝计划
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        
        if ([self.model.baobei.xianshi integerValue] == 0) {
            cell.contentArray.text = @"您尚未持有";
        }else{
            cell.contentArray.text = self.contentArray[indexPath.row];
        }
        
    }else if (indexPath.row == 2){ //已赚收益
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = [NSString stringWithFormat:@"%@元", self.model.yizhuan];
  //      NSLog(@"%@", self.model);
        
    }else if (indexPath.row == 3){ //我的积分
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = [NSString stringWithFormat:@"%.2f分", self.model.Score];
        
    }else if (indexPath.row == 4){ //回款计划
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = self.contentArray[indexPath.row];
        
    }else if (indexPath.row == 5){ //我的卡券
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = [NSString stringWithFormat:@"%d张", self.model.CouponSum];
    
    }else if (indexPath.row == 6){ //账单
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = self.contentArray[indexPath.row];
        
    }else if (indexPath.row == 7){ //我的邀请
        
        cell.titleArray.text = self.titleArray[indexPath.row];
        cell.contentArray.text = [NSString stringWithFormat:@"已邀请%d位好友", self.model.InviteeSum];
    }

    return cell;
}

#pragma mark ----  UICollectionView 代理方法  cell点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //我的债券
        MyClaimController *viewController=[[MyClaimController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 1){ //我的宝贝计划
        
        if ([self.model.baobei.xianshi integerValue] == 0) {
            BabyPlanController *vc = [[BabyPlanController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            BabyPlanDetailViewController * viewController=[[BabyPlanDetailViewController alloc]init];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }else if (indexPath.row == 2){ //已赚收益
        XZHadEearningViewController *vc = [XZHadEearningViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 3){ //我的积分
    
        XZMyScoreController *aboutUs = [[XZMyScoreController alloc] init];
        aboutUs.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutUs animated:YES];

    }else if (indexPath.row == 4){ //回款计划
        FMRefundMoneyViewController * friend = [[FMRefundMoneyViewController alloc]init];
        friend.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friend animated:YES];
        
        
//        FMRTBackEarningController * redound = [[FMRTBackEarningController alloc]init];
//        redound.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:redound animated:YES];
        
    }else if (indexPath.row == 5){ //我的卡券
        YYCardPackageController *cardPackage = [[YYCardPackageController alloc]init];
        cardPackage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cardPackage animated:YES];
    }else if (indexPath.row == 6){ //账单
        YYMyBillController *myBill = [[YYMyBillController alloc]init];
        myBill.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myBill animated:YES];
    }else if (indexPath.row == 7){ //我的邀请
        

//        FMAudioPlayViewController * playAudio = [[FMAudioPlayViewController
//                                                  alloc]init];
//        playAudio.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:playAudio animated:YES];
        
        [self jumpRecommendController];
        
//        FMJoinDetailPrizeViewController * jion = [[FMJoinDetailPrizeViewController
//                                                   alloc]init];
//        jion.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:jion animated:YES];
//        

    }
    
}

#pragma mark ---- 我的邀请 跳转方法
-(void)jumpRecommendController{

    if (self.model.InviterLevel  == 1) {
        // 1：已经邀请过好友的普通用户 2：未邀请过好友的普通用户 3：推荐人用户

        //我的邀请
        FMJoinDetailPrizeViewController * jion = [[FMJoinDetailPrizeViewController
                                                   alloc]init];
        jion.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jion animated:YES];
        


    }else if (self.model.InviterLevel == 2)
    {
        [self getShareDataSourceFromNetWork];

    }else if (self.model.InviterLevel == 3)
    {
       // [self getTuijianrendengji];
        
        //我的推荐
        FMMyRecommendController * recommend = [[FMMyRecommendController alloc ]init];
        recommend.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recommend animated:YES];
    }else
    {
        ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试！");

    }
    
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
    __weak typeof(self)weakSelf = self;
    
    _share.blockShareSuccess = ^ { // 分享成功的回调
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
        NSString *tokenlow=[token lowercaseString];
        NSString *url = [NSString stringWithFormat:@"%@/slots/index.html?user_id=%@&token=%@&trench=share",kXZShareCallBackUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"幸运大抽奖" AndWithShareUrl:url];
        [weakSelf.navigationController pushViewController:shareVC animated:YES];
    };
    return _share;
}

#pragma mark ---- 创建 UICollectionView headerView 代理方法
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (!_headerView) {
            _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ID2 forIndexPath:indexPath];
            if (KProjectScreenWidth > 320) {
                
                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221);
            }else{
                _headerView.frame = CGRectMake(0, 0, KProjectScreenWidth, 221 - 14 - 6);

            }

            
            _headerView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
        }
        
//        _headerView = headerView;
//        headerView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
//        reusableView = _headerView;
        FMWeakSelf
        _headerView.indevertBlock = ^(UIButton *sender){
            [weakSelf indevertWhenMoney];
        };
        
        _headerView.quxianBlock = ^(UIButton *sender){
        
            [weakSelf withDrawMoney];
        };
        _headerView.rechargeBlock = ^(UIButton *sender){
            
            [weakSelf rechageMoney];
        };
        _headerView.goTestBlock = ^(UIButton *sender){
            
            [weakSelf goTestIfPossible];
        };

    }
    return _headerView;
}

#pragma mark -风险评估-去评估
- (void)goTestIfPossible{
    
    XZRiskQuestionnaireViewController *testVC= [XZRiskQuestionnaireViewController new];
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark ----  headerView 高度 代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].fengxianwenjuanwode integerValue] == 1) {  //显示

        if ([self.IsDone isEqualToString:@"0"]) { //0未完成, 1已完成
            if (KProjectScreenWidth > 320) {
                
                return CGSizeMake(KProjectScreenWidth, 260);
            }else{
                return CGSizeMake(KProjectScreenWidth, 260 - 14 - 6);
            }
        }else{
            if ([self.IsInvalid isEqualToString:@"1"]) { //0未失效, 1已失效
                if (KProjectScreenWidth > 320) {
                    
                    return CGSizeMake(KProjectScreenWidth, 260);
                }else{
                    return CGSizeMake(KProjectScreenWidth, 260 - 14 - 6);
                }
            }else{
                if (KProjectScreenWidth > 320) {
                    return CGSizeMake(KProjectScreenWidth, 221);
                }else{
                    return CGSizeMake(KProjectScreenWidth, 221 - 14 - 6);
                }
            }
        }
    }else{
        if (KProjectScreenWidth > 320) {
            return CGSizeMake(KProjectScreenWidth, 221);
        }else{
            return CGSizeMake(KProjectScreenWidth, 221 - 14 - 6);
        }
    }
}

#pragma mark - 资产总额提示
- (void)indevertWhenMoney{
    
    CGFloat height = 0;
    if (KProjectScreenWidth >= 375) {
        height = 180;
    }else {
        height = 190;
    }
    FMProfmptBoxView *signOn = [[FMProfmptBoxView alloc]initWithFrame:CGRectMake(0, 0, 0, height)];
    
    [signOn profmptBoxWithTitle:@"什么是资产总额？" andContent:@"资产总额=投标中资金+宝贝计划（加入金额）+预期收益+冻结中资金+可用余额" andBtnTitle:@"好的" andHadImage:NO];
    [signOn showViewAlertView];
}

#pragma mark - 提现 ---!!!
- (void)withDrawMoney{
    
//    MoneyTiXianViewController * viewController = [[MoneyTiXianViewController alloc]init];
//    viewController.hidesBottomBarWhenPushed=YES;
//    __weak typeof (self)weakSelf = self;
//    viewController.refreshBlcok = ^(){
//        [weakSelf requestDatatoCollectionView];
//    };
    
    //userInfo类  weishangbang  1已绑定徽商0未绑定，jiaoyimshezhi  1设置交易密码0未设置
    if ([[CurrentUserInformation sharedCurrentUserInfo].weishangbang intValue] == 0) {
        
        FMWeakSelf;
        [FMRTAddCardToView showWithAddBtn:^{
            FMTieBankCardViewController *rechargeController = [[FMTieBankCardViewController alloc] init];
            rechargeController.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:rechargeController animated:YES];
        }];
    }else{
        
        if ([[CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi intValue] == 0){
            
            [self checkIFHaveAcctPassword];

        }else{
            
            FMRTRebackMoneyController *rebackVC = [[FMRTRebackMoneyController alloc]init];
            rebackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rebackVC animated:YES];
        }
    }
    
    
//
//    YYHuiShangTXController *viewController = [[YYHuiShangTXController alloc]init];
//    viewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)checkIFHaveAcctPassword{
    
    FMWeakSelf;
    int timestamp = [[NSDate date]timeIntervalSince1970];

    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlString = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@",kXZUniversalTestUrl(@"QueryAcctPasswordIsSet"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlString parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.responseObject) {
                        
            if (response.code == WebAPIResponseCodeSuccess) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    id dicData = [response.responseObject objectForKey:@"data"];
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *data = (NSDictionary *)dicData;
                        if ([data objectForKey:@"IsSet"]) {
                            int isSet = [[data objectForKey:@"IsSet"] intValue];
                           // 0无密码1有密码
                            if (isSet ==0) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为了保障资金安全，请设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                                [alert show];
                            }else{
                                FMRTRebackMoneyController *rebackVC = [[FMRTRebackMoneyController alloc]init];
                                rebackVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:rebackVC animated:YES];
                            }
                        }
                    }
                }
            }else{

                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        FMRTChangeTradeKeyViewController *tradeKeyVC = [[FMRTChangeTradeKeyViewController alloc]init];
        tradeKeyVC.typeTitle = titleSetting;
        tradeKeyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tradeKeyVC animated:YES];
    }
}

#pragma mark - 充值
- (void)rechageMoney{
    if (([[CurrentUserInformation sharedCurrentUserInfo].weishangbang intValue] == 0)) {
        FMWeakSelf;
        [FMRTAddCardToView showWithAddBtn:^{
            FMTieBankCardViewController *rechargeController = [[FMTieBankCardViewController alloc] init];
            rechargeController.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:rechargeController animated:YES];
        }];
    }else{
        XZBankRechargeController *bankRecharge = [[XZBankRechargeController alloc] init];
        bankRecharge.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:bankRecharge animated:YES];
//        XZRechargeController *rechargeController = [[XZRechargeController alloc] init];
//        rechargeController.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:rechargeController animated:YES];
    }
}

@end
