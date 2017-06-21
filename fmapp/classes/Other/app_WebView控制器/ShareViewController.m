//
//  ShareViewController.m
//  fmapp
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ShareViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "MoneyTiXianViewController.h"
#import "UIButton+Bootstrap.h" //修改右侧button
//#import "LingQianViewController.h" ====XZ
#import <JavaScriptCore/JavaScriptCore.h>
@interface ShareViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic , strong)  UIImageView *imagV;

@property (nonatomic, strong) UIButton  *leftButton;
@end

@implementation ShareViewController

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl
{
    self=[super init];
    if (self) {
        
        self.title=title;
        
//        NSString *urlstr=shareUrl;
//        NSRange range=[shareUrl rangeOfString:@"user_id"];
//        if (range.location==NSNotFound) {
//            NSRange range1=[shareUrl rangeOfString:@"?"];
//            
//            if (range1.location==NSNotFound) {
//                urlstr = [NSString stringWithFormat:@"%@?user_id=%@",shareUrl,[CurrentUserInformation sharedCurrentUserInfo].userId];
//            }
//            else
//            {
//                urlstr = [NSString stringWithFormat:@"%@&user_id=%@",shareUrl,[CurrentUserInformation sharedCurrentUserInfo].userId];
//            }
//            
//        }
        
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

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        if (self.refreshBlock) {
            self.refreshBlock();
        }
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


-(void)closeButtonOnClick:(UIButton *)button
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title isEqualToString:@"充值"]||[self.title isEqualToString:@"提现"]) {
        
        [self initWithHeaderNavigationRightButton];
    }
    [self setLeftNavButton];
    
    //签到关闭icon_03
//    [self settingNavTitle:self.title];
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
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareUrl]];
    [self.webShareWebView loadRequest:urlRequest];
    
}

- (void)setNavRightButton:(NSString *)title {
    // 右侧我的按钮

    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBarButtonItem)];
    barButton.tintColor = [HXColor colorWithHexString:@"#333333"];
    
    self.navigationItem.rightBarButtonItem = barButton;

}
// 右侧”我的“的点击事件
- (void)didClickRightBarButtonItem {
    
    
//    if (self.JumpWay) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    if ([self.JumpWay isEqualToString:@"MyRecommand"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
//    MoneyTiXianViewController * viewController = [[MoneyTiXianViewController alloc]init];
//    viewController.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 初始化右侧可编辑按键
- (void)initWithHeaderNavigationRightButton{
    if (HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)) {
        UIBarButtonItem *savePassword = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavBtnClick)];
        [savePassword setTintColor:[HXColor colorWithHexString:@"#333333"]];
        [self.navigationItem setRightBarButtonItem:savePassword];
    }else{
        ////设置右侧Item
        UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightItemButton setBackgroundImage:[UIImage imageNamed:@"RightItem.png"]
                                   forState:UIControlStateNormal];
        [rightItemButton setFrame:CGRectMake(0, 0, 49, 29)];
        [rightItemButton setTitle:@"我的" forState:UIControlStateNormal];
        [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
        rightItemButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}
- (void)rightNavBtnClick{
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    if ([self.JumpWay isEqualToString:@"recharge"]) { // 充值
        if (self.tabBarController.selectedIndex == 3) {// 从”我的“进入
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {// 从其他页面进入
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initWithUserDismissModalViewControllerAnimated{

    
    if ([self.webShareWebView canGoBack]) {
        
        if (self.leftButton.hidden) {
            self.leftButton.hidden = NO;
        }

        [self.webShareWebView goBack];
        
        
        return;
    }
    if (self.refreshBlock) {
        self.refreshBlock();
    }
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self settingNavTitle:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
//    NSLog(@"self.webShareTtitleString is %@",webTtitleString);
    [self settingNavTitle:self.title];
    if ([self.JumpWay isEqualToString:@"MyRecommand"] || [self.JumpWay isEqualToString:@"recharge"]) {
        [self settingNavTitle:webTtitleString];
    }
    // 将加载中图片移除
    [self.imagV removeFromSuperview];
    if (!IsStringEmptyOrNull(webTtitleString)) {
//        [self settingNavTitle:webTtitleString];
    }
    
    //if ([[NSString stringWithFormat:@"%@",self.isTanchu] isEqualToString:@"1"]) {
      //  JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //定义好JS要调用的方法, share就是调用的share方法名
        //context[@"clickActorShop"] = ^() {
          //  NSLog(@"+++++++Begin Log+++++++");
            //优商城首页
            //NSLog(@"-------End Log-------");
        //};
        
        //context[@"clickLQD"] = ^(NSString *str) {
          //  NSLog(@"+++++++Begin Log+++++++");
            //零钱罐
            //NSLog(@"-------End Log-------");
        //};
    //}
}

-(void)clickActorShop{


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    NSLog(@"%@------",error);

    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = request.URL.absoluteString;
    
    NSLog(@"%@------",url);
    
    BOOL shouldStartLoad = YES;
  
    
    return shouldStartLoad;
}

@end
