//
//  WLZhuCeViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/10.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]

#import "WLZhuCeViewController.h"
#import "TestJSObject.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "WLNewProjectDetailViewController.h"
#import "FMTabBarController.h"
#import "UIButton+Bootstrap.h" //修改右侧button
#import "AppDelegate.h"

@interface WLZhuCeViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,TestJSObjectDelegate>
@property (nonatomic, strong) TestJSObject *testJO;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation WLZhuCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavButton];
    [self settingNavTitle:self.navTitle];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = KDefaultBackGround;
    [self createWebViewOnthisView:self.shareURL];
    
    if (self.comeForm == 3) {
        
        UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"close_iv"] forState:UIControlStateNormal];
        UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        self.navigationItem.rightBarButtonItem = searchBar;
        
    }
}

-(void)adsActivitybuttonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWithUserDismissModalViewControllerAnimated
{
    
    if (self.comeForm == 0) {
        if ([self.webShareWebView canGoBack]) {
            [self.webShareWebView goBack];
            return;
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if(self.comeForm == 5){

        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.comeForm == 7){

        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[WLNewProjectDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}



-(void)closeButtonOnClick:(UIButton *)button
{
    if (self.comeForm == 0) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        //            [weakSelf.navigationController popViewControllerAnimated:YES];
        UIWindow * rootWindow =  [UIApplication sharedApplication].keyWindow;
        FMTabBarController * tabbar = (FMTabBarController *) rootWindow.rootViewController;
        tabbar.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    

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




-(void)retuController:(NSString *)jumpIndex
{
    if (self.comeForm == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [ShareAppDelegate createTabBarController];
    }
}

-(void)createWebViewOnthisView:(NSString *)shareUrl
{
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 64)];
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
    //    [self.view bringSubviewToFront:mainWebView];
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
    
    //NSLog(@"%@",request.URL.absoluteString);
    
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
    testJO.blockToTheHomePage = ^(){
        // 开通汇付成功后，点击"立即理财"跳转到“我的”界面
        [weakSelf backToTheHomePage];
    };
    testJO.blockJumpToTabbarIndex = ^(NSString *index){
        [weakSelf jumpToWodeController:index];

    };
}

/**
 * 开通汇付成功后，点击"立即理财"跳转到“我的”界面
 */
-(void)backToTheHomePage{
    
//    [self retuController:@"0"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tabBarController.selectedIndex == 3) {// 从”我的“进入
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {// 从其他页面进入
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    });
}
-(void)jumpToWodeController:(NSString *)index
{
    [self retuController:index];
}


@end
