//
//  FMJSAndOCWebController.m
//  fmapp
//
//  Created by runzhiqiu on 16/9/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMJSAndOCWebController.h"

#import "TestJSObject.h"
//#import "FMTradeSuccessOrFailController.h" ====XZ
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIButton+Bootstrap.h" //修改右侧button
//#import "LingQianNewViewController.h" ====XZ
#import "FMRTWellStoreViewController.h"
@interface FMJSAndOCWebController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,copy) NSString *titles;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation FMJSAndOCWebController


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
-(instancetype)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl
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
    
    
    if (self.isShowRightButton > 0) {
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 60, 30) ];
        [rightButton addTarget:self action:@selector(rightButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"返回账户"  forState:UIControlStateNormal];
        [rightButton setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:UIControlStateNormal];
        
        UIBarButtonItem *navItemRight= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = navItemRight;

    }
    
    
}
-(void)rightButtonButtonOnClick:(UIButton *)button
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
}

-(void)createRightButton
{
    UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"close_iv"] forState:UIControlStateNormal];
    UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItem = searchBar;

}

-(void)adsActivitybuttonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  注册JS调用OC方法
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.webShareWebView animated:YES];
    
    
}
- (void)rightNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    NSString * url = request.URL.absoluteString;
    
    
    if ([url isEqualToString:@"https://www.rongtuojinrong.com/borrow/index/lingqianguanTurnAutomaticSuccess"]) {
        [self retToLeftController];
        
        return NO;
    }
    
    
    
    BOOL shouldStartLoad = YES;
    return shouldStartLoad;
}

-(void)retToLeftController
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
