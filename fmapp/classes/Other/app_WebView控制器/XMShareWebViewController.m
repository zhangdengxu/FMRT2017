//
//  XMShareWebViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMShareWebViewController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

#import "UIImageView+WebCache.h"
#import "UIButton+Bootstrap.h" //修改右侧button
#import "FMBeautifulModel.h"
#define SHAREButtonTag  1000
@interface XMShareWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate,UMSocialUIDelegate>

@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic,copy) NSString *shareUrlWithNoUserInfo;
@property (nonatomic,copy) NSString *content;


@property (nonatomic , weak) UIWebView           *webShareWebView;
@property (nonatomic, strong) UIView * infoView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NSData * umShareImage;

@property (nonatomic, strong) UIButton  *leftButton;


@end

@implementation XMShareWebViewController

-(instancetype)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl WithShareUrlWithNoUserInfo:(NSString *)shareUrlWithNoUserInfo withContent:(NSString *)content
{
    self=[super init];
    if (self) {
        
        self.title=title;
        
        NSString *urlstr=shareUrl;
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
        
        self.shareUrl=urlstr;
        self.content = content;
        self.shareUrlWithNoUserInfo = shareUrlWithNoUserInfo;
        
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
    
    
    
    
    __weak typeof(self) wself = self;
    
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        //             NSLog(@"下载图片1----%@",[NSThread currentThread]);
        if (wself.dataSource) {
            wself.umImage = [[UIImageView alloc]init];
            
            
            if (wself.laiyaun == 1) {
                wself.umShareImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.rongtuojinrong.com%@", wself.dataSource.videoThumb] ]];
            }else{
                wself.umShareImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", wself.dataSource.thumb] ]];
            }
            
            
            [wself.umImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.rongtuojinrong.com%@", wself.dataSource.videoThumb] ] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //            wself.umShareImage = image;
                
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [wself creatRightButton];
                    
                });
                
            }];
        }
        
    });
    
    
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
    
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    self.infoView.hidden = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSubViews)];
    [self.infoView addGestureRecognizer:singleTap];
}
-(void)removeFromSubViews
{
    self.infoView.hidden = YES;
    for (UIView *button in self.view.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }

}


- (void)setInfoViewFrame{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.infoView.backgroundColor = [UIColor blackColor];
        self.infoView.alpha = 0.6;
        [self.view addSubview:self.infoView];
        [self creatSubButton];
    }];
}

//创建分享button
-(void)creatSubButton{
    
    for (int i = 0; i < 4; i++) {
        CGFloat length = 70;
        if (self.view.frame.size.width<330) {
            length = 50;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.alpha = 1.0;
        [button setFrame:CGRectMake((KProjectScreenWidth-length)/2, 100+(length+20)*i, length, length)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"未标题-1_%d.png",i]] forState:UIControlStateNormal];
        button.tag = SHAREButtonTag + i;
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)shareAction:(UIButton *)button{
    
    NSString *shareUrl = self.shareUrlWithNoUserInfo;
    [UMSocialData defaultData].extConfig.wechatSessionData.url =shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareUrl;
    [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url =shareUrl;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = shareUrl;

    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    if (button.tag == SHAREButtonTag) {
        //    新浪微博
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.content,shareUrl] shareImage:self.umShareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        [self removeFromSubViews];
    }else if (button.tag == SHAREButtonTag+1){
        //   朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.content] shareImage:self.umShareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else if (button.tag == SHAREButtonTag+2){
        //   微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.content] shareImage:self.umShareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else{
        //   QQ
         [UMSocialData defaultData].extConfig.qqData.title = self.title;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.content] shareImage:self.umShareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
    }
    
}

#pragma mark -
#pragma mark - 初始化右侧可编辑按键
- (void)rightNavBtnClick
{

    if (self.infoView.hidden == YES) {
        [self setInfoViewFrame];
        self.infoView.hidden = NO;
    }else{
            
        [self removeFromSubViews];
    }

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
        //        [self settingNavTitle:webTtitleString];
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
