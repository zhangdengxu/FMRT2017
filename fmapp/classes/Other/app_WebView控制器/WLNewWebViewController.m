//
//  WLNewWebViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLNewWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "MoneyTiXianViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WLNewWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic , strong)  UIImageView *imagV;

@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation WLNewWebViewController

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
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    UIImageView *imagV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imagV.backgroundColor = [UIColor clearColor];
    [imagV setImage:[UIImage imageNamed:@"加载中.png"]];
    self.imagV = imagV;
    [self.view addSubview:imagV];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.opaque = NO;
    [mainWebView setOpaque:YES];
    mainWebView.scalesPageToFit = YES;
    [mainWebView setUserInteractionEnabled:YES];
    mainWebView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
//    mainWebView.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareUrl]];
//        [self.webShareWebView loadRequest:urlRequest];
//    }];
//    mainWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareUrl]];
//        [self.webShareWebView loadRequest:urlRequest];
//    }];

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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self settingNavTitle:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    Log(@"self.webShareTtitleString is %@",webTtitleString);
    [self settingNavTitle:webTtitleString];
    
    if ([self.JumpWay isEqualToString:@"MyRecommand"]) {
        [self settingNavTitle:webTtitleString];
    }
    // 将加载中图片移除
    [self.imagV removeFromSuperview];
    if (!IsStringEmptyOrNull(webTtitleString)) {

    }
    [self.webShareWebView.scrollView.mj_header endRefreshing];
    [self.webShareWebView.scrollView.mj_footer endRefreshing];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    BOOL shouldStartLoad = YES;
    return shouldStartLoad;
}


@end
