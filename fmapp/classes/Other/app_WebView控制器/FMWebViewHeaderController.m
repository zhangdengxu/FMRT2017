//
//  FMWebViewHeaderController.m
//  fmapp
//
//  Created by runzhiqiu on 16/9/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMWebViewHeaderController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Bootstrap.h" //修改右侧button
#import "WLPublishSuccessViewController.h"
#import "FMIndexHeaderModel.h"
#import "XZActivityModel.h"

@interface FMWebViewHeaderController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate,UMSocialUIDelegate>

@property (nonatomic,copy)NSString *shareUrl;


@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@property (nonatomic, strong) FMIndexHeaderModel * headerModel;
@property (nonatomic, strong) UIButton  *leftButton;

@end

@implementation FMWebViewHeaderController

-(instancetype)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl WithModel:(FMIndexHeaderModel *)headerModel;
{
    self=[super init];
    if (self) {
        
        self.title=title;
        self.headerModel = headerModel;
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
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.view.bounds.size.height - 44)];
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
    
    
            
    [self creatRightButton];
    
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
-(void)rightNavBtnClick
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    
    WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
    XZActivityModel *m = [XZActivityModel new];
    m.sharetitle = self.headerModel.fenxiangbiaoti;
    m.sharepic = self.headerModel.fenxiangpic;
    if (self.statusInt == 5) {
        m.shareurl = self.headerModel.fenxianglianjie;

    }else
    {
        m.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@",self.headerModel.fenxianglianjie,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];

    }
    m.sharecontent = self.headerModel.fenxiangneirong;
    shareVC.modelActivity = m;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    Log(@"self.webShareTtitleString is %@",webTtitleString);
    
    if (!IsStringEmptyOrNull(webTtitleString)) {
        //        [self settingNavTitle:webTtitleString];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL shouldStartLoad = YES;
    
    
    return shouldStartLoad;
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
