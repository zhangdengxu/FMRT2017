//
//  XMSignInWebViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/2/20.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KNavBarBackgroundColor [UIColor colorWithRed:(7/255.0) green:(64/255.0) blue:(143/255.0) alpha:1]
#define SHAREButtonTag  1000

#import "XMSignInWebViewController.h"

#import "HTTPClient+Interaction.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "WXApi.h"

@interface XMSignInWebViewController () <UIWebViewDelegate,UMSocialUIDelegate>
{
    UIView *infoView;
}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *lianjie;
@property(nonatomic,strong)NSString *tupian;
@property(nonatomic,strong)NSString *biaoti;
@property(nonatomic,strong)NSString *neirong;
@property(nonatomic,strong)UIView *navBar;
@end

@implementation XMSignInWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KNavBarBackgroundColor;
    UIWebView * webView = [[UIWebView alloc]init];
    webView.delegate = self;
    self.webView = webView;
    self.webView.backgroundColor = KNavBarBackgroundColor;
    self.webView.frame = CGRectMake(0, 44, KProjectScreenWidth, KProjectScreenHeight - 44);
    
    //进入时泉都优界面
    //    获取url
    if (self.shareURL) {
        NSURL *url = [NSURL URLWithString:self.shareURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
        [self.view addSubview:self.webView];
        [self.webView setScalesPageToFit:YES];
    }
    
    [self createWebViewNavigationUI];
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    infoView.hidden = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSubViews)];
    [infoView addGestureRecognizer:singleTap];

    [self getDataFromNetWork];
}

//获取网络数据
-(void)getDataFromNetWork{

    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/juyijuparty/juyijufenxiang";
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient  getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code == WebAPIResponseCodeSuccess)
            {
                NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                self.lianjie = [dic objectForKey:@"lianjie"];
                self.tupian = [dic objectForKey:@"tupian"];
                self.biaoti = [dic objectForKey:@"biaoti"];
                self.neirong = [dic objectForKey:@"neirong"];
                if (self.isJYJ) {
                    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    [rightItemButton setFrame:CGRectMake(KProjectScreenWidth-50, 25, 30, 29)];
                    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
                    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.navBar addSubview:rightItemButton];

                }
              
            }else
            {
             ShowAutoHideMBProgressHUD(weakSelf.view,@"请求数据失败");
            }
        });
    }];

}


-(void)createWebViewNavigationUI
{
    UIView * navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 64)];
    [self.view addSubview:navBar];
    [self.view bringSubviewToFront:navBar];
    navBar.backgroundColor = KNavBarBackgroundColor;
    self.navBar = navBar;
    
    if (self.navTitle) {
        CGRect rcTileView = CGRectMake(0, 20, KProjectScreenWidth - 2*70, 44);
        UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: rcTileView];
        titleTextLabel.backgroundColor = [UIColor clearColor];
        titleTextLabel.textAlignment = NSTextAlignmentCenter;
        titleTextLabel.textColor = [[ThemeManager sharedThemeManager].skin navigationTextColor];
        [titleTextLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [titleTextLabel setText:self.navTitle];
        [navBar addSubview:titleTextLabel];
        titleTextLabel.center = CGPointMake(KProjectScreenWidth * 0.5, 20 + 22);
    }
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isJYJ) {
       [navButton setFrame:CGRectMake(8 , 26, 90, 40)];
    }else{
    
       [navButton setFrame:CGRectMake(KProjectScreenWidth-98 , 26, 90, 40)];
    }
    navButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    navButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [navButton setTitle:@"返回俱乐部" forState:UIControlStateNormal];
    [navButton addTarget:self  action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:navButton];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)leftButtonOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightNavBtnClick{
    
    if (infoView.hidden == YES) {
        [self setInfoViewFrame];
        infoView.hidden = NO;
    }else{
        
        [self removeFromSubViews];
    }
}

- (void)setInfoViewFrame{
    
    [UIView animateWithDuration:0.5 animations:^{
        infoView.backgroundColor = [UIColor blackColor];
        infoView.alpha = 0.6;
        [self.view addSubview:infoView];
        [self creatSubButton];
    }];
}

//创建分享button
-(void)creatSubButton{
    
    if ([WXApi isWXAppInstalled]) {
        
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]]) {
        
    }
    
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
    

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.tupian]];
    UIImage *image = [UIImage imageWithData:data];
    
    NSString * html = self.lianjie;
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url =html;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =html;
    [UMSocialData defaultData].extConfig.qqData.url =html;
    [UMSocialData defaultData].extConfig.qzoneData.url =html;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = html;

    if (button.tag == SHAREButtonTag) {
        //    新浪微博
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.biaoti,html] shareImage:image socialUIDelegate:self];//设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
    }else if (button.tag == SHAREButtonTag+1){
        //   朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.biaoti;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.neirong,html] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else if (button.tag == SHAREButtonTag+2){
        //   微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.biaoti;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.neirong,html] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else{
        //   QQ
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@ %@%@",self.biaoti,self.neirong,html] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }
    
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
       ShowAutoHideMBProgressHUD(self.view,@"分享成功");
    }
}


-(void)removeFromSubViews{
    
    infoView.hidden = YES;
    for (UIView *button in self.view.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
}


@end
