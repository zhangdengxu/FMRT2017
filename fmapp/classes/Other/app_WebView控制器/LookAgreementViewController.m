//
//  LookAgreementViewController.m
//  fmapp
//
//  Created by runzhiqiu on 15/12/30.
//  Copyright © 2015年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#import "LookAgreementViewController.h"

#import "TestJSObject.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIButton+Bootstrap.h" //修改右侧button

@interface LookAgreementViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,TestJSObjectDelegate>

@property (nonatomic, strong) TestJSObject *testJO;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIButton  *leftButton;


@end

@implementation LookAgreementViewController

-(void)initWithUserDismissModalViewControllerAnimated
{
    if ([self.webShareWebView canGoBack]) {
        
        if (self.leftButton.hidden) {
            self.leftButton.hidden = NO;
        }
        
        [self.webShareWebView goBack];
        
        
        return;
    }
    
    if (self.isGoBackLogin) {
        LoginController *loginVc = [[LoginController alloc] init];
        loginVc.isGoBackLogin = YES;
        [self.navigationController pushViewController:loginVc animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)closeButtonOnClick:(UIButton *)button
{
    if (self.isGoBackLogin) {
        LoginController *loginVc = [[LoginController alloc] init];
        loginVc.isGoBackLogin = YES;
        [self.navigationController pushViewController:loginVc animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }}


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
    [self settingNavTitle:self.navTitle];
    
    [self setLeftNavButton];
    self.view.backgroundColor = KDefaultBackGround;
    [self createWebViewOnthisView:self.shareURL];
    
    // 广告页跳入的注册
    __weak __typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^() {
        if (weakSelf.isGoBackLogin) {
            LoginController *loginVc = [[LoginController alloc] init];
            loginVc.isGoBackLogin = YES;
            [weakSelf.navigationController pushViewController:loginVc animated:YES];
        }else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
