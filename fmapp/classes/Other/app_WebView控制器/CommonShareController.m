//
//  CommonShareController.m
//  fmapp
//
//  Created by apple on 15/3/30.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "CommonShareController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIButton+Bootstrap.h" //修改右侧button

@interface CommonShareController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation CommonShareController

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl
{
    self=[super init];
    if (self) {
        self.title=title;
        self.shareUrl=shareUrl;
    }
    return self;
}
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
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
    [self settingNavTitle:self.title];
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
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    Log(@"self.webShareTtitleString is %@",webTtitleString);
    
    if (!IsStringEmptyOrNull(webTtitleString)) {
        [self settingNavTitle:webTtitleString];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL shouldStartLoad = YES;
    
    
    return shouldStartLoad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
