//
//  XMWebViewControllerRM.m
//  fmapp
//
//  Created by runzhiqiu on 16/2/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMWebViewControllerRM.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WXApi.h"
#import "UIButton+Bootstrap.h" //修改右侧button14104

#define SHAREButtonTag  1000
#define FMHTTPClient [HTTPClient sharedHTTPClient]
//大转盘
@interface XMWebViewControllerRM ()<UIWebViewDelegate,UMSocialUIDelegate>
{
    UIView *infoView;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton  *leftButton;

@property (nonatomic, strong) UILabel * titleTextLabel;

@end

@implementation XMWebViewControllerRM

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:(241/255.0) green:(73/255.0) blue:(71/255.0) alpha:1];
    UIWebView * webView = [[UIWebView alloc]init];
    webView.delegate = self;
    self.webView = webView;
    self.webView.backgroundColor = [UIColor colorWithRed:(241/255.0) green:(73/255.0) blue:(71/255.0) alpha:1];
    self.webView.frame = CGRectMake(0, 44, KProjectScreenWidth, KProjectScreenHeight - 44);
    
    //进入时泉都优界面
    //    获取url
    if (self.shareURL) {
        NSURL *url = [NSURL URLWithString:self.shareURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
        [self.webView setScalesPageToFit:YES];
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    infoView.hidden = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSubViews)];
    [infoView addGestureRecognizer:singleTap];
    
    [self createWebViewNavigationUI];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
    if (webTtitleString.length > 0) {
        self.titleTextLabel.text = webTtitleString;

    }else
    {
        self.titleTextLabel.text = self.title;
    }


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void)createWebViewNavigationUI
{
    UIView * navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 64)];
    [self.view addSubview:navBar];
    [self.view bringSubviewToFront:navBar];
    navBar.backgroundColor = [UIColor colorWithRed:(241/255.0) green:(73/255.0) blue:(71/255.0) alpha:1];
    
    
    if (self.navTitle) {
        CGRect rcTileView = CGRectMake(0, 20, KProjectScreenWidth - 2*60 - 45, 44);
        UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: rcTileView];
        titleTextLabel.backgroundColor = [UIColor clearColor];
        titleTextLabel.textAlignment = NSTextAlignmentCenter;
//        [[ThemeManager sharedThemeManager].skin navigationTextColor]
        titleTextLabel.textColor = [UIColor whiteColor];
        [titleTextLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [titleTextLabel setText:self.navTitle];
        [navBar addSubview:titleTextLabel];
        self.titleTextLabel = titleTextLabel;
        titleTextLabel.center = CGPointMake(KProjectScreenWidth * 0.5, 20 + 22);
    }
    //    左侧button
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(10, 20, 44, 44)];
    navButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    // [FMThemeManager.skin navigationTextColor]
    [navButton simpleButtonWithImageColor:[UIColor whiteColor]];
    [navButton addAwesomeIcon:FMIconLeftArrow beforeTitle:YES];
    
    [navButton addTarget:self  action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:navButton];
    
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(64, 20 + (44 - 35) * 0.5, 35, 35) ];
    [leftButton addTarget:self action:@selector(closeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"俱乐部_大转盘关闭_36"] forState:UIControlStateNormal];
    
    self.leftButton = leftButton;
    [navBar addSubview:leftButton];
    
    
    
    //    右侧button
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [rightItemButton setFrame:CGRectMake(KProjectScreenWidth-50, 25, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:rightItemButton];
    
    
    self.leftButton.hidden = YES;
}

-(void)closeButtonOnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)leftButtonOnClick
{
    
    if ([self.webView canGoBack]) {
        
        if (self.leftButton.hidden) {
            self.leftButton.hidden = NO;
        }
        
        [self.webView goBack];
        
        
        return;
    }
    
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
//    int timestamp = [[NSDate date]timeIntervalSince1970];
//    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shi jian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//    NSString *tokenlow=[token lowercaseString];
//    NSString *leixing = @"8";
    
    NSString *shareUrl = self.shareURL;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.sharepic]];
    UIImage *image = [UIImage imageWithData:data];
    //
  
    NSString * html1 = [NSString stringWithFormat:@"%@&from=1",shareUrl];
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url =html1;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =html1;
    [UMSocialData defaultData].extConfig.qqData.url =html1;
    [UMSocialData defaultData].extConfig.qzoneData.url =html1;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = html1;
    if (button.tag == SHAREButtonTag) {
        //    新浪微博
        NSString * sharetrlText = [NSString stringWithFormat:@"%@%@",self.neirong,html1];
        [[UMSocialControllerService defaultControllerService] setShareText:sharetrlText shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        [self removeFromSubViews];
    }else if (button.tag == SHAREButtonTag+1){
        //   朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.navTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.neirong] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else if (button.tag == SHAREButtonTag+2){
        //   微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.navTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.neirong] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else{
        //   QQ
        [UMSocialData defaultData].extConfig.qqData.title = self.navTitle;
        
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@",self.neirong] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
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
        
        [self babyPlanAddScore];
    }
}



-(void)babyPlanAddScore
{
    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    }else
    {
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
    }
    
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter;
    if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        parameter = @{@"appid":@"huiyuan",@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"8"};
    }else
    {
        parameter = @{@"appid":@"huiyuan",@"user_id":@"0",@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"8"};
    }
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou" parameters:parameter completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                if (response.responseObject[@"msg"]) {
                    NSString * showMsg = [NSString stringWithFormat:@"分享成功"];
                    ShowAutoHideMBProgressHUD(weakSelf.view,showMsg);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"分享成功");
                }
                
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"分享成功");
            }
        });
    }];
    
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
