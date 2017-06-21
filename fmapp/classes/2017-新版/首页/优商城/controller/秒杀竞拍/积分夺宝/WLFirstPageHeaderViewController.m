//
//  WLFirstPageHeaderViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/11/14.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#import "WLFirstPageHeaderViewController.h"
#import "TestJSObject.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "XZCommonProblemsController.h"
#import "FMTabBarController.h"
#import "XZGetCoinsNewController.h"
//#import "InteractionViewController.h"
#import "UIButton+Bootstrap.h" //修改右侧button
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "FMRTWellStoreViewController.h" // 优商城
#import "FMPlaceOrderViewController.h"//优商城商品详情
#import "FMScoreTradeNoteNewController.h"
#import "FMRTChangeTradeKeyViewController.h"

@interface WLFirstPageHeaderViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,TestJSObjectDelegate>
@property(nonatomic,strong) TestJSObject *testJO;
@property(nonatomic,weak) UIWebView *webShareWebView;
///进度条内容
@property(nonatomic,copy)NJKWebViewProgress  *progressProxy;
@property(nonatomic,copy)NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation WLFirstPageHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavButton];
    [self settingNavTitle:self.navTitle];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = KDefaultBackGround;
    [self createWebViewOnthisView:self.shareURL];
    
    if (self.headerModel) {
        [self creatRightButton];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)creatRightButton{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"RightItem.png"]
                               forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)rightNavBtnClick{
    
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self checkUserIsLogin];
        return;
    }
    
    
    WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
    XZActivityModel *m = [XZActivityModel new];
    m.sharetitle = self.headerModel.fenxiangbiaoti;
    m.sharepic = self.headerModel.fenxiangpic;
    
    m.shareurl = self.headerModel.fenxianglianjie;
    
    m.sharecontent = self.headerModel.fenxiangneirong;
    shareVC.modelActivity = m;
    [self.navigationController pushViewController:shareVC animated:YES];
}


-(void)adsActivitybuttonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initWithUserDismissModalViewControllerAnimated
{
    if ([self.webShareWebView canGoBack]) {
        
        if (self.leftButton.hidden) {
            self.leftButton.hidden = NO;
        }
        
        [self.webShareWebView goBack];
        
        
        return;
    }
    
    if (self.refreshBackBlock) {
        self.refreshBackBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)closeButtonOnClick:(UIButton *)button
{
    if (self.refreshBackBlock) {
        self.refreshBackBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setLeftNavButton{
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(0, 0, 34, 28) ];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton simpleButtonWithImageColor:[UIColor blackColor]];
    [navButton addAwesomeIcon:FMIconLeftArrow beforeTitle:YES];
    
    [navButton addTarget:self  action:@selector(initWithUserDismissModalViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 15, 15) ];
    [leftButton addTarget:self action:@selector(closeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"签到关闭icon_03"] forState:UIControlStateNormal];
    
    UIBarButtonItem *navItemleft = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.leftButton = leftButton;
    
    self.navigationItem.leftBarButtonItems = @[navItem,navItemleft];
    
    self.leftButton.hidden = YES;
}

-(void)createWebViewOnthisView:(NSString *)shareUrl
{
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    mainWebView.opaque = NO;
    [mainWebView setOpaque:YES];
    mainWebView.scalesPageToFit = YES;
    [mainWebView setUserInteractionEnabled:YES];
    mainWebView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    for (UIView *subView in [mainWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [mainWebView setBackgroundColor:[UIColor clearColor]];
    self.webShareWebView = mainWebView ;
    
    
    mainWebView.dataDetectorTypes=UIDataDetectorTypeNone;

    self.webShareWebView.delegate = self;
    [self.view addSubview:self.webShareWebView];
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webShareWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:shareUrl]];
    [self.webShareWebView loadRequest:urlRequest];
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    return YES;
}

/**
 *  注册JS调用OC方法
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.webShareWebView animated:YES];
    
    //网页加载完成调用此方法
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    self.testJO.delegate = nil;
    self.testJO = nil;
    
    TestJSObject *testJO=[TestJSObject new];
    testJO.delegate = self;
    self.testJO = testJO;
    context[@"testobject"]=testJO;
    __weak __typeof(&*self)weakSelf = self;
    testJO.blockReceiveMoreCoins = ^(){
        
        [weakSelf receiveMoreCoins];
    };
    testJO.blockFrequentlyAskedQuestions = ^(){
        
        [weakSelf frequentlyAskedQuestions];
    };
    testJO.blockMakeMoney = ^(){
        
        [weakSelf MakeMoneyJustNow];
    };
    
    // 首页轮播图跳转优商城
    testJO.blockJumpToYouShangCheng = ^(){
        [weakSelf didClickJumpToYouShangCheng];
    };
    // 首页轮播图跳转优商城
    testJO.blockJumpToTabbarIndex = ^(NSString * selectIndex){
        [weakSelf didClickJumpToTabbarIndex:selectIndex];
    };
    // 首页轮播图跳转优商城商品详情
    testJO.blockJumpToyoushangchengDetail = ^(NSString * product_id){
        [weakSelf didClickJumpToyoushangchengDetail:product_id];
    };
    // 跳新版积分兑换记录界面
    testJO.blockJumpToScorenoteview = ^(){
        [weakSelf jumpJifenViewController];

    };
    testJO.blockJumpToShareviewcontroller = ^(){
        [weakSelf openShareViewController];
    
    };
    testJO.blockJmpToAccomplish = ^(){
        [weakSelf jumpToAccomplish];
        
    };
    testJO.blockJmpToChangeTraderPassWord = ^(){
        [weakSelf jumpToNewTradePage];
    };
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    Log(@"self.webShareTtitleString is %@",webTtitleString);
    //[self settingNavTitle:self.title];
    if (self.navTitle.length == 0) {
        [self settingNavTitle:webTtitleString];
    }
}

/**
 *  获取夺宝币方法
 */
-(void)receiveMoreCoins{


    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self checkUserIsLogin];
        return;
    }
    XZGetCoinsNewController *vc = [[XZGetCoinsNewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  常见问题
 */
-(void)frequentlyAskedQuestions{
    XZCommonProblemsController *vc = [[XZCommonProblemsController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/******更多服务*******/
/**
 *  马上赚钱
 */
-(void)MakeMoneyJustNow {
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self checkUserIsLogin];
    }else{ // 跳转到新的”项目列表“
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
//        InteractionViewController *vc = [[InteractionViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)checkUserIsLogin {
    
//    LoginController *loginController = [[LoginController alloc] init];
//    loginController.isGoBackLogin = YES;
//    loginController.isComFromFirstPage = YES;
//    [self.navigationController pushViewController:loginController animated:YES];
    
    
    LoginController *loginController = [[LoginController alloc] init];
//    loginController.isGoBackLogin = YES;
//    loginController.isComFromFirstPage = YES;
    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:loginController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
    }];
    
}

// 首页轮播图跳转优商城
- (void)didClickJumpToYouShangCheng {
    FMRTWellStoreViewController *goodShopVc = [[FMRTWellStoreViewController alloc] init];
    goodShopVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodShopVc animated:YES];
}

// 首页轮播图跳转优商城
- (void)didClickJumpToTabbarIndex:(NSString *)selectIndex {
    
    NSInteger selectInteger = [selectIndex integerValue];
    
    self.tabBarController.selectedIndex = selectInteger;
    
    [self closeButtonOnClick:nil];
    
    
}
// 首页轮播图跳转优商城商品详情
-(void)didClickJumpToyoushangchengDetail:(NSString *)product_id
{

    FMPlaceOrderViewController * place = [[FMPlaceOrderViewController alloc]init];
    place.goToGoodShopIndex = 2;
    place.isShopFullScore = 1;
    place.product_id = product_id;
    [self.navigationController pushViewController:place animated:YES];
}
//跳新版积分兑换记录界面
- (void)jumpJifenViewController
{
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        [self checkUserIsLogin];
        return;
    }

    
    FMScoreTradeNoteNewController * scroeNode = [[FMScoreTradeNoteNewController alloc]init];
    [self.navigationController pushViewController:scroeNode animated:YES];

}

//跳新版积分兑换记录界面
-(void)jumpToNewTradePage{

    FMRTChangeTradeKeyViewController *vc = [[FMRTChangeTradeKeyViewController alloc]init];
    vc.typeTitle = titleResetting;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)jumpToAccomplish{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshBackBlock) {
            self.refreshBackBlock();
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
             [CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi = @"1";
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)openShareViewController
{
    
    [self rightNavBtnClick];
}

@end
