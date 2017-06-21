//
//  WLPublishSuccessViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLPublishSuccessViewController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WXApi.h"

#import "XZActivityModel.h"
#import "XZRongMiFamilyViewController.h" // 管理
#import "YSStaticShareSkipView.h"
#import "WLDJQTABViewController.h"
#import "ShareViewController.h"



#define SHAREBUTTONTAG 10000
@interface WLPublishSuccessViewController ()<UMSocialUIDelegate>

@end

@implementation WLPublishSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navTitle) {
        [self settingNavTitle:self.navTitle];
    }else {
        [self settingNavTitle:@"分享"]; // 发布成功
    }
   
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self createContentView];
//    [self createRightBtn];
    if (self.hasManage) {
        [self createRightBtn];
    }
}


-(void)createContentView{

    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, (KProjectScreenWidth-20)/4+85-KProjectScreenWidth*18/414+130)];
    [bjView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bjView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [bjView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 70)];
    [titleLabel setText:@"请通过以下方式邀请好友来参与"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bjView addSubview: titleLabel];
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"朋友圈",@"微信好友",@"QQ",@"微博", nil];
    for (int i = 0; i<4; i++) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10+(KProjectScreenWidth-20)/4*i, 85, (KProjectScreenWidth-20)/4, (KProjectScreenWidth-20)/4)];
        [bjView addSubview:backView];
        
        UIImageView *shareImg = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth*18/414, KProjectScreenWidth*18/414, (KProjectScreenWidth-20)/4-KProjectScreenWidth*36/414, (KProjectScreenWidth-20)/4-KProjectScreenWidth*36/414)];
        [shareImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"inviteIcon0%d",i+1]]];
        [backView addSubview:shareImg];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (KProjectScreenWidth-20)/4-KProjectScreenWidth*18/414+10, (KProjectScreenWidth-20)/4, 20)];
        [titleLabel setText:nameArr[i]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [titleLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [backView addSubview: titleLabel];

        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setFrame:CGRectMake(0, 0, (KProjectScreenWidth-20)/4, (KProjectScreenWidth-20)/4)];
        [shareBtn setTag:SHAREBUTTONTAG+i];
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:shareBtn];
    }
    
    
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateHighlighted];
    [personalLogoOutButton addTarget:self
                              action:@selector(userLoginOut:)
                    forControlEvents:UIControlEventTouchUpInside];
    personalLogoOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];

    [personalLogoOutButton setTitle:@"取消"
                               forState:UIControlStateNormal];
    
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    

    [personalLogoOutButton setFrame:CGRectMake(35.0f, (KProjectScreenWidth-20)/4+85-KProjectScreenWidth*18/414+60, KProjectScreenWidth-70, 50.0f)];
    
    
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:8.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrBackgroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [bjView addSubview:personalLogoOutButton];
}

-(void)createRightBtn{
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"管理"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(callModalList)];
    
    rightButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

//管理
-(void)callModalList{
    XZRongMiFamilyViewController *rongMiFamily = [[XZRongMiFamilyViewController alloc]init];
    rongMiFamily.pid = self.modelActivity.pid;
    [self.navigationController pushViewController:rongMiFamily animated:YES];
}

-(void)shareAction:(UIButton *)button{
    if (self.modelActivity) {
        NSString *shareUrl = self.modelActivity.shareurl;
        NSString *shareTitle = self.modelActivity.sharetitle;
        NSString *shareContent = self.modelActivity.sharecontent;
        [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
        
        UIImage *image = [self imageFromURLString:self.modelActivity.sharepic];
        
//        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.modelActivity.sharepic]]; //self.modelActivity.sharepic
        
        // 微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString retStringWithPlatform:shareUrl withPlatform:@"weixin"];
        // 朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString retStringWithPlatform:shareUrl withPlatform:@"wxcircle"];
        // QQ
        [UMSocialData defaultData].extConfig.qqData.url = [NSString retStringWithPlatform:shareUrl withPlatform:@"qq"];
        // 新浪微博
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString retStringWithPlatform:shareUrl withPlatform:@"sina"];
        // QQ空间
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString retStringWithPlatform:shareUrl withPlatform:@"qzone"];
        
        
        if (button.tag == SHAREBUTTONTAG) {
            
            //   朋友圈
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",shareContent,shareUrl] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        if (button.tag == SHAREBUTTONTAG+1) {
            
            //   微信好友
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",shareContent,shareUrl] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        if (button.tag == SHAREBUTTONTAG+2) {
            
            //   QQ
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;

            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",shareContent,shareUrl] shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        if (button.tag == SHAREBUTTONTAG+3) {
            
            //    新浪微博
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",shareContent,shareUrl] shareImage:image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
    }
}

// 实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        if ([self.tag isEqualToString:@"kill"]) { // 限时秒杀
            // 如果是竞拍秒杀结束后的分享,请求一个数据；
            [self getRedEnvelopeFromNetWork:@"share"];
        }
        if ([self.tag isEqualToString:@"duobao"]) {// 夺宝
            
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            
             NSString *url = [NSString stringWithFormat:@"%@/lottery/lottery.html?user_id=%@&token=%@",kXZTestEnvironment,[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
            
            //NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/java/lottery/lottery.html?user_id=%@&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
            
            ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"幸运大抽奖" AndWithShareUrl:url];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
    }
}

// 请求红包数据
- (void)getRedEnvelopeFromNetWork:(NSString *)trenchStr {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"trench":trenchStr
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // @"https://www.rongtuojinrong.com/java/public/ticket/getTicket"
    
    NSString *navUrl =[NSString stringWithFormat:@"%@/public/ticket/getTicket",kXZTestEnvironment];
    

    
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject != nil) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                NSString *money = [NSString stringWithFormat:@"%@",dataDict[@"money"]];
                if (money.floatValue > 0) {
                    YSStaticShareSkipView *vc = [[YSStaticShareSkipView alloc]init];
                    vc.frame = CGRectMake(0 , 0, KProjectScreenWidth, KProjectScreenHeight - 64);
                    vc.blockBtn = ^(UIButton *button) {
                        WLDJQTABViewController *vc = [[WLDJQTABViewController alloc]init];
                        vc.tag = @"";
                        if ([self.tag isEqualToString:@"isSecondKill"]) {
                            vc.flag = self.tag;
                        }
                        vc.state = @"";
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    vc.money = [NSString stringWithFormat:@"%@元",money];
                    [self.view addSubview:vc];
                }else {
                    ShowAutoHideMBProgressHUD(self.view,@"您今日已经领取了抵价券");

                }
            
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }
        }
    }];
}


-(void)userLoginOut:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageFromURLString: (NSString *) urlstring
{
    // This call is synchronous and blocking
    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}


@end
