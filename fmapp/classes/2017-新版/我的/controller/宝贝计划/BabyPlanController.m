//
//  BabyPlanController.m
//  fmapp
//
//  Created by runzhiqiu on 15/11/5.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "BabyPlanController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "BabyPlanAccountViewController.h"
#import "WXApi.h"
#import "BabyPlanDetailViewController.h"
#import "BabyPlanViewController.h"
#import "FMShareModel.h"


#define SHAREImageViewTag  2000

#define SHAREButtonTag  1000
#define FMHTTPClient [HTTPClient sharedHTTPClient]
@interface BabyPlanController ()<UIScrollViewDelegate,UMSocialUIDelegate>
{
    
    UIView *infoView;
    UIScrollView *mainScrollView;
    NSMutableData *babyData;
    NSString *_weikaishi;
}
@property(nonatomic,strong)UIButton *button;

@property (nonatomic, strong) UIImageView * shareImage;
@property (nonatomic, strong) FMShareModel * shareModel;
@end

@implementation BabyPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"宝贝计划"];
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    infoView.hidden = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSubViews)];
    [infoView addGestureRecognizer:singleTap];
    [self creatContentView];
    [self loadBabyPlanDataWithHTTPClient];
    [self creatBackButton];
    
}

-(void)loadBabyPlanDataWithHTTPClient
{
    NSString *string = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/baobeijihua";
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSDictionary * dic1 = [response.responseObject objectForKey:kDataKeyData];
                
                _weikaishi = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"weikaishi"]];

                [self.button setTitle:[_weikaishi intValue] == 0 ? @"立即加入" : @"立即预约" forState:UIControlStateNormal];
            }
            else
            {
                [self.button setTitle:@"立即预约" forState:UIControlStateNormal];
                [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.button.enabled = NO;
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
        });
    }];
}


-(void)creatContentView{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight-100)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 730);
    
    [self.view addSubview:mainScrollView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*7/16)];
    [imageV setImage:[UIImage imageNamed:@"宝贝计划_海报_36"]];
    [mainScrollView addSubview:imageV];
    
    UIView *btnContentView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight-124, KProjectScreenWidth, 60)];
    btnContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnContentView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.0f blue:240/255.0f alpha:1];
    [btnContentView addSubview:lineView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 1, KProjectScreenWidth, 50)];
    [button setTag:1000];
    [button setBackgroundColor:[UIColor clearColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:KDefaultOrBackgroundColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cunAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnContentView addSubview:button];
    self.button = button;
    NSArray *imageArray = [NSArray arrayWithObjects:@"宝贝计划_分散投资_36",@"宝贝计划_省心省力_36",@"宝贝计划_超低门槛_36", nil];
    NSArray *lebelTextArray = [NSArray arrayWithObjects:@"分散投资",@"省心省力",@"超低门槛", nil];
    NSArray *textArray = [NSArray arrayWithObjects: @"通过定投宝贝计划，可将闲散资金分散于不同的优质企业债权，安全稳健。",@"选好日期，定好金额，每月存入即可。",@"500元起，每月最高20000元，8号、18号、28号准时开放，等待你的加入。", nil];
    for (int i = 0; i<3; i++) {
        
        UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenWidth*7/16+120.5*i, KProjectScreenWidth, 120)];
        listView.backgroundColor = [UIColor whiteColor];
        [mainScrollView addSubview:listView];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 60, 60)];
        imageV.backgroundColor = [UIColor clearColor];
        [imageV setImage:[UIImage imageNamed:imageArray[i]]];
        [listView addSubview:imageV];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 200, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text = lebelTextArray[i];
        label.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.8];
        label.font=[UIFont boldSystemFontOfSize:18.0f];
        [listView addSubview:label];
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, KProjectScreenWidth-140, 30)];
        if (KProjectScreenWidth == 320) {
            label1.frame = CGRectMake(120, 5, KProjectScreenWidth-140, 30);
        }
        label1.backgroundColor=[UIColor clearColor];
        label1.text = textArray[i];
        label1.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6];
        label1.font=[UIFont boldSystemFontOfSize:14.0f];
        label1.numberOfLines = 0;
        CGSize size = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, MAXFLOAT)];
        label1.frame = CGRectMake(120, 60, KProjectScreenWidth-150, size.height);
        if (KProjectScreenWidth == 320) {
            label1.frame = CGRectMake(120, 60, KProjectScreenWidth-140, size.height);
        }
        [listView addSubview:label1];
        
    }

    UIView *huoqiView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenWidth*7/16+120.5*3, KProjectScreenWidth, 150)];
    huoqiView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:huoqiView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, KProjectScreenWidth-18, 20)];
    titleLabel.text = @"宝贝计划适合四种人群";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    [huoqiView addSubview:titleLabel];
    
    NSArray *bottomImageArr = [NSArray arrayWithObjects:@"钱财冷淡型",@"恐退休型",@"都市漂型人",@"孩子奴型人", nil];
    NSArray *bottomTitleArray = [NSArray arrayWithObjects:@"钱冷淡型人",@"恐退休型人",@"都市漂型人",@"孩子奴型人", nil];
    for (int i = 0; i < 4; i++) {
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(10+(KProjectScreenWidth-20)/4*i, 45, (KProjectScreenWidth-20)/4, 105)];
        [huoqiView addSubview:bjView];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, (KProjectScreenWidth-20)/4-20, (KProjectScreenWidth-20)/4-20)];
        [imageV setImage:[UIImage imageNamed:bottomImageArr[i]]];
        [bjView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (KProjectScreenWidth-20)/4-17, (KProjectScreenWidth-20)/4, 20)];
        label.text = bottomTitleArray[i];
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font=[UIFont systemFontOfSize:12.0f];
        [bjView addSubview:label];
    }
}

-(void)cunAction:(UIButton *)button{
    //    判断是否已经登录
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
//        [self presentModalViewController:navController animated:YES];

        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
//    BabyPlanViewController * viewController=[[BabyPlanViewController alloc]init];
//    
//    viewController.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    BabyPlanAccountViewController * viewController=[[BabyPlanAccountViewController alloc]init];
    viewController.buttonTitle = self.button.currentTitle;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

//创建左右按钮
-(void)creatBackButton{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"RightItem.png"]
                               forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
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

-(void)getShareDataSourceFromNetWork
{
    NSString * shareUrlHtml = kDefaultShareUrlBase;
    NSDictionary * parames = @{@"leixing":@3
                               };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:shareUrlHtml parameters:parames completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            self.shareModel = [FMShareModel initWithShareModelDictionary:data];
            if (self.shareModel.picurl.length > 0) {
                __weak __typeof(&*self)weakSelf = self;
                [self.shareImage sd_setImageWithURL:[NSURL URLWithString:self.shareModel.picurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf shareDataSourceWithShareUrl:self.shareModel withImage:image];
                }];
            }else
            {
                [self shareDataSourceWithShareUrl:self.shareModel withImage:[UIImage imageNamed:@"小图2.png"]];
                
            }
        }else if(response.code == WebAPIResponseCodeFailed)
        {
            NSString * msg = response.responseObject[@"msg"];
            if ([msg isMemberOfClass:[NSNull class]]) {
                ShowAutoHideMBProgressHUD(self.view, @"数据出错，请重试");
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, msg);
            }
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"请求失败");
        }
    }];
}
-(void)shareDataSourceWithShareUrl:(FMShareModel *)shareModel withImage:(UIImage *)image
{
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    UIImage * imageShow = image;
    NSString * shareTitle = shareModel.title;
    NSString * shareText = shareModel.content;
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"weixin"];
    // 朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"wxcircle"];
    // QQ
    [UMSocialData defaultData].extConfig.qqData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"qq"];
    // 新浪微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"sina"];
    // QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"qzone"];
    
    if (self.shareImage.tag == SHAREImageViewTag) {
        //    新浪微博
         NSString * sharetrlText = [NSString stringWithFormat:@"%@%@",shareText,shareModel.url];
        [[UMSocialControllerService defaultControllerService] setShareText:sharetrlText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        [self removeFromSubViews];
    }else if (self.shareImage.tag == SHAREImageViewTag+1){
        //   朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
    }else if (self.shareImage.tag == SHAREImageViewTag+2){
        
        //   微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title =  shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else{
        //QQ
        [UMSocialData defaultData].extConfig.qqData.title =  shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
    }
    
}
-(void)shareAction:(UIButton *)button{
    UIImageView * imageview = [[UIImageView alloc]init];
    self.shareImage = imageview;
    imageview.tag = button.tag + 1000;
    [self getShareDataSourceFromNetWork];
    
}


/** 宝贝计划--分享 */
//-(void)shareAction:(UIButton *)button{
//    
//    NSString *shareUrl = babyPlanShareURL;
//    
//     [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
//    
//    [UMSocialData defaultData].extConfig.wechatSessionData.url =shareUrl;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareUrl;
//    [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
//    [UMSocialData defaultData].extConfig.qzoneData.url =shareUrl;
//    if (button.tag == SHAREButtonTag) {
//        //    新浪微博
//        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"我在定投融托金融的宝贝计划，强制储蓄，零存整取！每月8号、18号、28号准时开放，起投金额500元，你也来存钱吧！%@",shareUrl] shareImage:[UIImage imageNamed:@"小图3.png"] socialUIDelegate:self];        //设置分享内容和回调对象
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        
//        [self removeFromSubViews];
//    }else if (button.tag == SHAREButtonTag+1){
//        //   朋友圈
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"我在定投融托金融的宝贝计划，强制储蓄，零存整取！";
//        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"每月8号、18号、28号准时开放，起投金额500元，你也来存钱吧！ %@",shareUrl] shareImage:[UIImage imageNamed:@"小图3.png"] socialUIDelegate:self];        //设置分享内容和回调对象
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        [self removeFromSubViews];
//        
//            }else if (button.tag == SHAREButtonTag+2){
//        //   微信好友
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"我在定投融托金融的宝贝计划，强制储蓄，零存整取！";
//        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"每月8号、18号、28号准时开放，起投金额500元，你也来存钱吧！ %@",shareUrl] shareImage:[UIImage imageNamed:@"小图3.png"] socialUIDelegate:self];        //设置分享内容和回调对象
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        [self removeFromSubViews];
//           
//    }else{
//        //   QQ
//        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"我在定投融托金融的宝贝计划，强制储蓄，零存整取！%@",shareUrl] shareImage:[UIImage imageNamed:@"小图3.png"] socialUIDelegate:self];        //设置分享内容和回调对象
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        [self removeFromSubViews];
//     
//    }
//    
//}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
        [self babyPlanAddScore];
    }
}
/** 宝贝计划--AddScore */
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
        parameter = @{@"appid":@"huiyuan",@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"4"};

    }else
    {
        parameter = @{@"appid":@"huiyuan",@"user_id":@"0",@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"4"};

    }
        __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:babyPlanAddScoreURL parameters:parameter completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                if (response.responseObject[@"msg"]) {
                    NSString * showMsg = [NSString stringWithFormat:@"分享成功，%@",response.responseObject[@"msg"]];
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

#pragma mark- UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{

//    [_babyWebView animationDidStart:nil];
    _babyWebView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

//    self.navigationItem.leftBarButtonItem.enabled = webView.canGoBack;

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

@end
