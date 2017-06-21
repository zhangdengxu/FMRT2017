//
//  FMRTWellStoreViewController.m
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreViewController.h"
#import "ZJScrollPageView.h"
#import "MJRefresh.h"
#import "FMRTProductsDetailViewController.h"
#import "FMRTWellStoreHeaderView.h"
#import "XZMyOrderViewController.h"
#import "FMShoppingListViewController.h"
#import "FMFavoriteViewController.h"
#import "ShareViewController.h"
#import "XMConvertNotesViewController.h"
#import "WLAllklBodyViewController.h"
#import "FMTimeKillShopController.h"
#import "FMRTWellStoreProductModel.h"
#import "WLFirstPageHeaderViewController.h"
#import "FMIndexHeaderModel.h"
#import "FMRTWellStoreSaledDealViewController.h"
#import "RongAroundViewController.h"
#import "WLPublishSuccessViewController.h"
#import "MakeABidWebViewController.h"
#import "XZActivityModel.h"
#import "FMWebViewHeaderController.h"

static CGFloat const segmentViewHeight = 44.0;
static CGFloat const naviBarHeight = 64.0;
NSString *const ZJParentTableViewDidLeaveFromTopNotification = @"ZJParentTableViewDidLeaveFromTopNotification";
@interface ZJCustomGestureTableView : UITableView
@end
@implementation ZJCustomGestureTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end
@interface FMRTWellStoreViewController ()<ZJScrollPageViewDelegate, ZJPageViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray *dataSource,*scrollData,*cateidArr,*huodong;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (weak,   nonatomic) UIView *navView;
@property (strong, nonatomic) FMRTWellStoreHeaderView *headView;
@property (weak,   nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJCustomGestureTableView *tableView;
@property (assign, nonatomic) BOOL isFirst,isBack,isProductCell;
@property (weak,   nonatomic) UIButton *backBtn,*shareBtn;
@property (assign, nonatomic) CGFloat headViewHeight;
@property (nonatomic, assign) NSInteger index;
@end
@implementation FMRTWellStoreViewController
static NSString * const cellID = @"FMRTWellStoreViewControllercellID";

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(wellloginNotification:)
                                                     name: FMUserLoginNotification
                                                   object: nil];
    }
    return self;
}

- (void)wellloginNotification:(NSNotification *)notification{
    [self requestMainWellstoreData];
    [self.tableView reloadData];
}

- (CGFloat)headViewHeight{
    if (!_headViewHeight) {
        if (KProjectScreenWidth<375) {
            _headViewHeight = (CGFloat )(320/3*236/212 + 320 * 348/640 +76);
        }else if (KProjectScreenWidth > 375){
            _headViewHeight = (CGFloat )(414/3*236/212 + 414 * 348/640 +76);
        }else{
            _headViewHeight = (CGFloat )(375/3*236/212 + 375 * 348/640 +76);
        }
    }
    return _headViewHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@""];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];

    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *navView = [[UIView alloc]init];
    self.navView = navView;
    navView.backgroundColor = [HXColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:navView];
    [navView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(naviBarHeight);
    }];
    self.navView.alpha = self.tableView.contentOffset.y/200;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"优商城";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.centerX);
        make.centerY.equalTo(navView.centerY).offset(8);
    }];
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"新版_白色返回_36"] forState:(UIControlStateNormal)];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(wellbackAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.navView.centerY).offset(6);
        make.left.equalTo(self.navView.left).equalTo(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shareBtn setImage:[UIImage imageNamed:@"优商城首页_分享_36"] forState:(UIControlStateNormal)];
    self.shareBtn = shareBtn;
    [shareBtn addTarget:self action:@selector(wellshareAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.navView.centerY).offset(6);
        make.right.equalTo(self.navView.right).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@60);
    }];
    
    UIButton *qqBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [qqBtn setImage:[UIImage imageNamed:@"优商城首页_QQ_36"] forState:(UIControlStateNormal)];
    qqBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [qqBtn addTarget:self action:@selector(qqBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:qqBtn];
    [qqBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.top).offset(self.headViewHeight + 80);
        make.right.equalTo(self.view.right).equalTo(-10);
        make.width.height.equalTo(@50);
    }];
    
    UIButton *telBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [telBtn setImage:[UIImage imageNamed:@"优商城首页_电话_36"] forState:(UIControlStateNormal)];
    [telBtn addTarget:self action:@selector(telBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:telBtn];
    [telBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(qqBtn.bottom).offset(20);
        make.right.equalTo(self.view.right).equalTo(-10);
        make.width.height.equalTo(@50);
    }];
    
    [self requestMainWellstoreData];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isFirst) {
        if (self.isBack) {
            self.isBack = NO;
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        }else{
            if (self.isProductCell) {
                [self.navigationController setNavigationBarHidden:YES animated:NO];

            }else{
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
        }
    }else{
        self.isFirst = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [super viewWillAppear:animated];
    [self.headView.scrollView adjustWhenControllerViewWillAppera];
//    NSLog(@"谁先运行FMRTWellStoreViewController ---- viewWillAppear");
}


- (void)viewWillDisappear:(BOOL)animated{
    if (self.isBack) {
    }else{
        if (self.isProductCell) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];

        }else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if (!parent) {
        self.isBack = YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"谁先运行FMRTWellStoreViewController ---- viewDidAppear");

    if (self.isProductCell) {
        self.isProductCell = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)requestMainWellstoreData{
    
    NSString *string = [NSString stringWithFormat:@"%@?uid=%@",KGoodShop_Index_HeaderView_Url,[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view bringSubviewToFront:self.backBtn];
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
             if (response.code == WebAPIResponseCodeSuccess) {
                if ([response.responseObject objectForKey:@"data"]) {
                    id dicData = [response.responseObject objectForKey:@"data"];
                    
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)dicData;
                        
                        if ([dic objectForKey:@"tuijian"]) {
                            NSString *tuijian = [dic objectForKey:@"tuijian"];
                            weakSelf.headView.tuijian = tuijian;
                        }
                        
                        weakSelf.scrollData = [FMRTWellScroModel scrollArrWithDic:dic];
                        weakSelf.headView.scrollArr = [weakSelf.scrollData copy];
                        weakSelf.cateidArr = [FMRTWellStoreProductModel cateidArrWithDic:dic];
                        weakSelf.titles = [FMRTWellStoreProductModel dataSourceWithDic:dic];
                        weakSelf.huodong = [wellHuodongModel huodongArrWithDic:dic];
                        if (weakSelf.index) {
                            [weakSelf.segmentView setSelectedIndex:weakSelf.index animated:YES];
                            [weakSelf.segmentView adjustUIWithProgress:1 oldIndex:0 currentIndex:weakSelf.index];
                            [weakSelf.contentView reload];
                        }else{
                            [weakSelf.segmentView reloadTitlesWithNewTitles:weakSelf.titles];
                            [weakSelf.contentView reload];
                        }
                        [weakSelf.tableView reloadData];
                    }
                }
            }else{

                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 电话联系
- (void)telBtnAction{
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:@"tel://400-878-8686"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}
#pragma mark - qq聊天
- (void)qqBtnAction{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else{
        
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"打开客服提醒" message:@"您尚未安装QQ，请安装QQ后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
}

#pragma mark - 分享实现
- (void)wellshareAction{

    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self shareDataFromNetBack];

    }else{
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)shareDataFromNetBack{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
    NSString *tokenlow=[token lowercaseString];
    NSString * shareUrlHtml = kDefaultShareUrlBase;
    
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"leixing":@5
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FMWeakSelf;
    [FMHTTPClient postPath:shareUrlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if ([response.responseObject objectForKey:@"data"]) {
                    id data = [response.responseObject objectForKey:@"data"];
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)data;
                        WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
                        wellShareModel *model = [[wellShareModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        XZActivityModel *m = [XZActivityModel new];
                        m.sharetitle = model.title;
                        m.sharepic = model.picurl;
                        m.shareurl = model.url;
                        m.sharecontent = model.content;

                        shareVC.modelActivity = m;
                        [weakSelf.navigationController pushViewController:shareVC animated:YES];
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
    }];
}

#pragma mark - 轮播图点击跳转
- (void)didSelectViewWithIndex:(NSInteger )index{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        FMRTWellScroModel * imageModel = self.scrollData[index];
        if (imageModel.url.length > 5) {
            
            WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];
            viewController.shareURL = imageModel.url;
            viewController.navTitle = imageModel.title ;
            
            FMIndexHeaderModel * headerModel = [FMIndexHeaderModel new];
            headerModel.fenxiangbiaoti = imageModel.fenxiangbiaoti;
            headerModel.fenxiangpic = imageModel.fenxiangpic;
            headerModel.fenxianglianjie = imageModel.fenxianglianjie;
            headerModel.fenxiangneirong = imageModel.fenxiangneirong;
            
            viewController.headerModel = headerModel;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else{
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)ifLogInIopBtnWithCollectionIndex:(NSInteger )index{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self topBtnWithCollectionIndex:index];
    }else{
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - 购物车-收藏-订单等点击
- (void)topBtnWithCollectionIndex:(NSInteger )index{
    switch (index) {
        case 0://订单
        {
            XZMyOrderViewController *myOrder = [[XZMyOrderViewController alloc]init];
            [self.navigationController pushViewController:myOrder animated:YES];
            break;
        }
        case 1://购物车
        {
            FMShoppingListViewController *fmVc = [[FMShoppingListViewController alloc]init];
            [self.navigationController pushViewController:fmVc animated:YES];
            break;
        }
        case 2://收藏
        {
            FMFavoriteViewController *favoriteVC = [[FMFavoriteViewController alloc]init];
            [self.navigationController pushViewController:favoriteVC animated:YES];
            break;
        }
        case 3://兑换记录
        {
            XMConvertNotesViewController *vc = [[XMConvertNotesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;

        }
        case 4://推荐
        {
            int timestamp = [[NSDate date]timeIntervalSince1970];
            NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            
            NSString *urlStr = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/jili/index.php/home/index/index_client?appid=huiyuan&user_id=%@&shijian=%d&token=%@&from=rongtuoapp&tel=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile];
            MakeABidWebViewController *shareVC = [[MakeABidWebViewController alloc]initWithTitle:@"我的推荐" AndWithShareUrl:urlStr];
            shareVC.isOptimalMall = YES;
            [self.navigationController pushViewController:shareVC animated:YES];

            break;
        }
        default:
            break;
    }
}

#pragma mark - 全民夺宝
- (void)allTakeVCForWellStore{

    if (self.huodong.count) {
        if (self.huodong.count >3) {
            wellHuodongModel *model = self.huodong[0];
            FMIndexHeaderModel *headerModel = [[FMIndexHeaderModel alloc]init];
            
            headerModel.fenxiangneirong = model.fenxiangneirong;
            headerModel.fenxianglianjie = model.fenxianglianjie;
            headerModel.fenxiangpic = model.fenxiangpic;
            headerModel.fenxiangbiaoti = model.fenxiangbiaoti;
            
            if (model.url.length > 5) {
                FMWebViewHeaderController *shareVC = [[FMWebViewHeaderController alloc]initWithTitle:model.title AndWithShareUrl:model.url WithModel:headerModel];
                shareVC.statusInt = 5;
                [self.navigationController pushViewController:shareVC animated:YES];
            }else{
                WLAllklBodyViewController *vc = [[WLAllklBodyViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            WLAllklBodyViewController *vc = [[WLAllklBodyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
}

#pragma mark - 秒杀
- (void)killVCForWellStore{
    
    if (self.huodong.count) {
        if (self.huodong.count > 3) {
            wellHuodongModel *model = self.huodong[2];
            FMIndexHeaderModel *headerModel = [[FMIndexHeaderModel alloc]init];
            
            headerModel.fenxiangneirong = model.fenxiangneirong;
            headerModel.fenxianglianjie = model.fenxianglianjie;
            headerModel.fenxiangpic = model.fenxiangpic;
            headerModel.fenxiangbiaoti = model.fenxiangbiaoti;
            
            if (model.url.length > 5) {
                FMWebViewHeaderController *shareVC = [[FMWebViewHeaderController alloc]initWithTitle:model.title AndWithShareUrl:model.url WithModel:headerModel];
                shareVC.statusInt = 5;
                [self.navigationController pushViewController:shareVC animated:YES];
            }else{
                
                FMTimeKillShopController * timeKill = [[FMTimeKillShopController alloc]init];
                [self.navigationController pushViewController:timeKill animated:YES];
            }
        }else{
            FMTimeKillShopController * timeKill = [[FMTimeKillShopController alloc]init];
            [self.navigationController pushViewController:timeKill animated:YES];
        }
    }
}

#pragma mark - 积分兑换
- (void)jinfenVCForWellStore{
  
    if (self.huodong.count) {
        if (self.huodong.count > 3) {
            wellHuodongModel *model = self.huodong[3];
            FMIndexHeaderModel *headerModel = [[FMIndexHeaderModel alloc]init];
            
            headerModel.fenxiangneirong = model.fenxiangneirong;
            headerModel.fenxianglianjie = model.fenxianglianjie;
            headerModel.fenxiangpic = model.fenxiangpic;
            headerModel.fenxiangbiaoti = model.fenxiangbiaoti;
            if (model.url.length > 5) {
                FMWebViewHeaderController *shareVC = [[FMWebViewHeaderController alloc]initWithTitle:model.title AndWithShareUrl:model.url WithModel:headerModel];
                shareVC.statusInt = 5;
                [self.navigationController pushViewController:shareVC animated:YES];
            }else{
                RongAroundViewController * rongAround = [[RongAroundViewController alloc]init];
                [self.navigationController pushViewController:rongAround animated:YES];
            }
        }else{
            RongAroundViewController * rongAround = [[RongAroundViewController alloc]init];
            [self.navigationController pushViewController:rongAround animated:YES];
        }
    }
}

- (void)wellbackAction{
    if (self.leftBackBlock){
        self.leftBackBlock();
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        childVc = [[FMRTProductsDetailViewController alloc] init];
    }
    FMRTProductsDetailViewController *vc = (FMRTProductsDetailViewController *)childVc;
    vc.delegate = self;
    FMWeakSelf;
    self.index = index;
    vc.selectBlock = ^(){
        weakSelf.isProductCell = YES;
    };
    vc.cateID = self.cateidArr[index];
    return vc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index{
//    self.index = index;
    if (self.cateidArr.count && ![self.cateidArr isKindOfClass:[NSNull class]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"chuanzhiID" object:self.cateidArr[index]];
    }
}

#pragma mark- ZJPageViewControllerDelegate
- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    _childScrollView = scrollView;

    if (self.tableView.contentOffset.y < self.headViewHeight-64) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.headViewHeight-64);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.navView.alpha = self.tableView.contentOffset.y/(KProjectScreenWidth * 348/640 - 60);
    
    if (self.childScrollView && self.childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, self.headViewHeight-64);
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < self.headViewHeight-64) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ZJParentTableViewDidLeaveFromTopNotification object:nil];
    }else{
        self.tableView.contentOffset = CGPointMake(0.0f, self.headViewHeight-64);
    }
    
    if (offsetY < (KProjectScreenWidth * 348/640 - 80)) {
        [self.shareBtn setImage:[UIImage imageNamed:@"优商城首页_分享_36"] forState:(UIControlStateNormal)];
        [self.backBtn setImage:[UIImage imageNamed:@"新版_白色返回_36"] forState:(UIControlStateNormal)];
    }else{
        [self.shareBtn setImage:[UIImage imageNamed:@"新版_分享_36"] forState:(UIControlStateNormal)];
        [self.backBtn setImage:[UIImage imageNamed:@"新版_黑色返回_36"] forState:(UIControlStateNormal)];
    }
}

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

#pragma mark- setter getter
- (ZJScrollSegmentView *)segmentView {
    if (_segmentView == nil) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];

        style.showCover = NO;
        style.scrollTitle = YES;
        style.gradualChangeTitleColor = YES;
        style.showLine = YES;
        style.autoAdjustTitlesWidth = YES;
        style.titleFont = [UIFont systemFontOfSize:15];
        style.normalTitleColor = [UIColor colorWithHexString:@"#333333"];
        style.selectedTitleColor = [UIColor colorWithHexString:@"#ff6633"];
        style.scrollLineColor = [UIColor colorWithHexString:@"#ff6633"];

        FMWeakSelf;
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, self.headViewHeight, KProjectScreenWidth, segmentViewHeight) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            
        }];
        segment.backgroundColor = [UIColor whiteColor];
        _segmentView = segment;
        
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (_contentView == nil) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 44) segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

- (FMRTWellStoreHeaderView *)headView {
    if (!_headView) {
        _headView = [[FMRTWellStoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.headViewHeight)];
        _headView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
        FMWeakSelf;
        
        _headView.scroBlock = ^(NSInteger index){
            [weakSelf didSelectViewWithIndex:index];
        };
        _headView.collectionBlock = ^(NSInteger index){
            [weakSelf ifLogInIopBtnWithCollectionIndex:index];
        };
        _headView.allTakeBlcok = ^(){
            [weakSelf allTakeVCForWellStore];
        };
        _headView.killBlock = ^(){
            [weakSelf killVCForWellStore];
        };
        _headView.jinfenBlock = ^(){
            [weakSelf jinfenVCForWellStore];
        };
        _headView.beginBlcok = ^(){
            weakSelf.tableView.scrollEnabled = NO;
        };
        
        _headView.endBlcok = ^(){
            weakSelf.tableView.scrollEnabled = YES;
        };
        
        
    }
    return _headView;
}

- (ZJCustomGestureTableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0, KProjectScreenWidth, KProjectScreenHeight);
        ZJCustomGestureTableView *tableView = [[ZJCustomGestureTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tableHeaderView = self.headView;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = KProjectScreenHeight - 44;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = segmentViewHeight;
        tableView.showsVerticalScrollIndicator = false;
        tableView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];

        FMWeakSelf;
        /// 下拉刷新
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf requestMainWellstoreData];
        }];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
