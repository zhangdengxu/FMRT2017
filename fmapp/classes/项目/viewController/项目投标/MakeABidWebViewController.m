//
//  MakeABidWebViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/30.
//  Copyright © 2016年 yk. All rights reserved.
//


#import "MakeABidWebViewController.h"
#import "ShareViewController.h"
#import "TestJSObject.h"
#import "XZSaveDetailM.h"
//#import "XMMakeABidSuccessViewController.h"
#import "FMTradeSuccessOrFailController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIButton+Bootstrap.h" //修改右侧button
//#import "LingQianNewViewController.h" ====XZ
#import "FMRTWellStoreViewController.h"
#import "XZRecommandQRCodeController.h" // 我的推荐web
#import "XZActivityModel.h" // 分享
#import "XZOptimalMallRecommendView.h"
#import "FMMakeABadResultStatus.h"
#import "FMPlaceOrderViewController.h" // 商品详情页
#import "WLMessageViewController.h" // 消息框


@interface MakeABidWebViewController ()<TestJSObjectDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,copy) NSString *titles;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@property (nonatomic, strong) TestJSObject *testJO;

@property (nonatomic, strong) UIButton  *leftButton;


@end

@implementation MakeABidWebViewController

-(void)loadView
{
    [super loadView];
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取App名称，我的App有本地化支持，所以是如下的写法
    
    NSString *appName = @"rongtuoappios";
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@", appName, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
    
    
}
-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl
{
    self=[super init];
    if (self) {
        
        self.titles=title;
        
        NSString *urlstr=shareUrl;
        NSRange range=[shareUrl rangeOfString:@"user_id"];
        if (range.location==NSNotFound) {
            NSRange range1=[shareUrl rangeOfString:@"?"];
            
            if (range1.location==NSNotFound) {
                urlstr = [NSString stringWithFormat:@"%@?user_id=%@",shareUrl,[CurrentUserInformation sharedCurrentUserInfo].userId];
            }
            else
            {
                urlstr = [NSString stringWithFormat:@"%@&user_id=%@",shareUrl,[CurrentUserInformation sharedCurrentUserInfo].userId];
            }
            
        }
        
        self.shareUrl=urlstr;
        
    }
    return self;
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

    [self.navigationController popViewControllerAnimated:YES];
}



-(void)closeButtonOnClick:(UIButton *)button
{
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




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setLeftNavButton];
    [self settingNavTitle:self.titles];
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
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
    
    Log(@"web Url is %@",self.shareUrl);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareUrl]];
    [self.webShareWebView loadRequest:urlRequest];
    
    [MBProgressHUD showHUDAddedTo:self.webShareWebView animated:YES];
    
    if ([[NSString stringWithFormat:@"%@",self.isTanchu] isEqualToString:@"1"]){
        
        UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"签到关闭icon_03"] forState:UIControlStateNormal];
        UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        self.navigationItem.rightBarButtonItem = searchBar;
        
    }
    
    
    // 如果是我的推荐跳转过来的右上角的消息
    [self isLoadRecommandView];
}

#pragma mark ----- 是从我的推荐跳入的
- (void)isLoadRecommandView {
    if (self.isOptimalMall) {
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setImage:[UIImage imageNamed:@"优商城_已读消息_36"] forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(didClickMessageButton) forControlEvents: UIControlEventTouchUpInside];
        messageButton.frame = CGRectMake(KProjectScreenWidth - 50, 10, 30, 30);
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
        self.navigationItem.rightBarButtonItem = navItem;
    }
}

#pragma mark ---- 点击右上角消息按钮
- (void)didClickMessageButton {
    WLMessageViewController *messageVC = [[WLMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)adsActivitybuttonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    //    //首先创建我们新建类的对象，将他赋值给js的对象
    //    self.testJO.delegate = nil;
    //    self.testJO = nil;
    
    TestJSObject *testJO = [TestJSObject new];
    testJO.delegate = self;
    self.testJO = testJO;
    context[@"testobject"] = testJO;
    
    __weak typeof(&*self)weakself = self;
    testJO.blockRecommand = ^(NSString *title,NSString *shareTitle,NSString *shareContent,NSString *imageUrl,NSString *shareUrl,NSString *linkUrl) {
        [weakself Jump:title Title:shareTitle Content:shareContent Image:imageUrl Url:shareUrl Type:linkUrl];
    };
    testJO.blockProjectMakeSuccessInfoBlock = ^(NSString * message1, NSString * message2,NSString * message3,NSString * message4,NSString * projectId,NSString * imageUrl,NSString * detail){
    
    
    };
    
    
    
    /** 我的推荐 ------ 我的销售订单 ---- 查看详情 */
    testJO.blockClickOneMoreAgain = ^(NSString *productID,BOOL isCoinPay) {
        [weakself ProductID:productID isCoinPay:isCoinPay];
    };
    
    //    NSString *jsStr = [NSString stringWithFormat:@"parent.testobject.JumpTitleContentImageUrl('哈哈','哈哈','哈哈','哈哈','哈哈')"];
    //
    //    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
}

- (void)rightNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置右侧按钮
- (void)setNavRightButton:(NSString *)title {
    // 右侧我的按钮
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBarButtonItem)];
    barButton.tintColor = [HXColor colorWithHexString:@"#333333"];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

// 右侧”我的“的点击事件
- (void)didClickRightBarButtonItem {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillLayoutSubviews
{
    CGRect rc = self.view.bounds;
    self.webShareWebView.frame = rc;
    
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    
    
    BOOL shouldStartLoad = YES;
    
    
    return shouldStartLoad;
}

-(void)ProjectSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4
{
    
    __weak typeof(&*self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        XZSaveDetailM * saveDetail = [[XZSaveDetailM alloc]init];
        //saveDetail.msg = message4;
        saveDetail.msg = KDefaultFMMakeABadResultStatus;
        saveDetail.jiaoyi = message2;
        saveDetail.tijiao = message3;
        saveDetail.jiner = message1;
        
        
        FMTradeSuccessOrFailController * tradeResult = [[FMTradeSuccessOrFailController alloc]init];
        tradeResult.detail = saveDetail;
        
        [wself.navigationController pushViewController:tradeResult animated:YES];
        

        
    });
    
    
    
}


-(void)JumpProjectSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4  Projectid:(NSString *)projectId Peojectimage:(NSString *)imageUrl Projectdetail:(NSString *)detail
{
    
    __weak typeof(&*self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
  
        
        XZSaveDetailM * saveDetail = [[XZSaveDetailM alloc]init];
        //saveDetail.msg = message4;
        saveDetail.msg = KDefaultFMMakeABadResultStatus;
        saveDetail.jiaoyi = message2;
        saveDetail.tijiao = message3;
        saveDetail.jiner = message1;
        
        
        saveDetail.productId = projectId;
        saveDetail.imageUrl = imageUrl;
        saveDetail.productDetail = detail;

        
        FMTradeSuccessOrFailController * tradeResult = [[FMTradeSuccessOrFailController alloc]init];
        tradeResult.detail = saveDetail;
        [wself.navigationController pushViewController:tradeResult animated:YES];
        
        
        
    });
    
    
    
}
-(void)ProjectFailMoney:(NSString *)message1 Title:(NSString *)message4
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        XZSaveDetailM * saveDetail = [[XZSaveDetailM alloc]init];
        //saveDetail.msg = message4;
        saveDetail.msg = @"投标失败";
        saveDetail.tijiao = message1;
        
        FMTradeSuccessOrFailController * tradeResult = [[FMTradeSuccessOrFailController alloc]init];
        tradeResult.detail = saveDetail;
        
        [wself.navigationController pushViewController:tradeResult animated:YES];
        
        
        //
  
        
    });
    
    
    
    
}


/**
 *  调取优商城，无参数
 */
- (void)ActivityYoushangcheng;
{
     __weak __typeof(&*self)weakSelf = self;
    FMRTWellStoreViewController *vc = [[FMRTWellStoreViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.leftBackBlock = ^(){
    
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
///** ====XZ
// *  调取零钱贯，两个参数，一个是获得金额，一个是来源
// *
// *  @param message message description
// */
//- (void)ActivityLingqianguan:(NSString *)huodejine Laiyuan:(NSString *)laiyuan;
//{
//    //零钱贯
//    LingQianNewViewController *vc = [[LingQianNewViewController alloc]init];
//    vc.isTanchuang = huodejine;
//    vc.laiyuan = @"1";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}


//零钱贯开通自动投标调用
- (void)LingqianguanTurnAutomaticSuccess;
{
    
    self.webShareWebView = nil;
    self.progressProxy = nil;
    self.progressProxy = nil;
    self.testJO.delegate = nil;
    self.testJO = nil;
    
    __weak __typeof(&*self)weakSelf = self;
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
    
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

// 我的推荐跳转到二维码界面;
- (void)Jump:(NSString *)title Title:(NSString *)shareTitle Content:(NSString *)shareContent Image:(NSString *)imageUrl Url:(NSString *)shareUrl Type:(NSString *)linkUrl {
    XZActivityModel *modelActivity = [[XZActivityModel alloc] init];
    modelActivity.sharetitle = shareTitle;
    modelActivity.sharecontent = shareContent;
    modelActivity.sharepic = imageUrl;
    modelActivity.shareurl = shareUrl;
    modelActivity.linkUrl = linkUrl;
    if (self.isOptimalMall) { // 优商城跳转
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;;
                //  优商城的推荐二维码
            XZOptimalMallRecommendView *recommended = [[XZOptimalMallRecommendView alloc] initWithFrame:window.bounds];
            recommended.modelActivity = modelActivity;
            __weak __typeof(&*self)weakSelf = self;
            recommended.blockJumpDetail = ^{
                ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"" AndWithShareUrl:modelActivity.linkUrl];
                shareVc.JumpWay = @"MyRecommand";
                [weakSelf.navigationController pushViewController:shareVc animated:YES];
            };
            [window addSubview:recommended];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            XZRecommandQRCodeController *recommended = [[XZRecommandQRCodeController alloc] init];
            recommended.navTitle = title;
            recommended.modelActivity = modelActivity;
            [self.navigationController pushViewController:recommended animated:YES];
        });
    }
}

/** 我的推荐 ------ 我的销售订单 ---- 查看详情 */
- (void)ProductID:(NSString *)productId isCoinPay:(BOOL)isCoinPay {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 跳转商品详情
        FMPlaceOrderViewController *placeOrder = [[FMPlaceOrderViewController alloc] init];
        placeOrder.product_id = productId ;
        placeOrder.goToGoodShopIndex = 2;
        if (isCoinPay) {// 是积分支付
            placeOrder.isShopFullScore = 1;
        }else {
            placeOrder.isShopFullScore = 0;
        }
        [self.navigationController pushViewController:placeOrder animated:YES];
    });
}
@end
