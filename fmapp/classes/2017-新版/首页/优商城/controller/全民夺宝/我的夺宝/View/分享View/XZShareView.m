//
//  XZShareView.m
//  fmapp
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 yk. All rights reserved.
//  分享

#import "XZShareView.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "XZActivityModel.h"


#define kXZSHAREBUTTONTAG 1000

@interface XZShareView ()<UMSocialUIDelegate>
/** 黑色背景 */
@property (nonatomic, strong) UIView *infoView;

@end

@implementation XZShareView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpShareView];
    }
    return self;
}

- (void)setUpShareView {
    [UIView animateWithDuration:0.5 animations:^{
        [self addSubview:self.infoView];
        // 创建分享button
        [self creatSubButton];
    }];
}


-(XZShareView *)retViewWithSelf;
{
    [self setUpShareView];
    return self;
}

//创建分享button
-(void)creatSubButton{
    for (int i = 0; i < 4; i++) {
        CGFloat length = 70;
        if (self.frame.size.width < 330) {
            length = 50;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.alpha = 1.0;
        [button setFrame:CGRectMake((KProjectScreenWidth-length)/2, 100+(length+20)*i, length, length)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"未标题-1_%d.png",i]] forState:UIControlStateNormal];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)shareAction:(UIButton *)button {
    [self removeFromSubViews];
    if (self.blockShareAction) {
        self.blockShareAction(button);
    }
}

-(void)removeFromSubViews {
    for (UIView *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    [self.infoView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark --- UMDelegate
-(void)shareAction:(UIButton *)button handlerDelegate:(id)target {
    if (self.modelShare) {
        NSString *shareUrl = self.modelShare.shareurl;
        NSString *shareTitle = self.modelShare.sharetitle;
        NSString *shareContent = self.modelShare.sharecontent;
        [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
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
        
        if (button.tag == kXZSHAREBUTTONTAG) { // 新浪
            //    新浪微博
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",shareContent,shareUrl] shareImage:[self imageFromURLString:self.modelShare.sharepic] socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(target,[UMSocialControllerService defaultControllerService],YES);
        }
        if (button.tag == kXZSHAREBUTTONTAG+1) {// 朋友圈
            //   朋友圈
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:shareContent,shareUrl] shareImage:[self imageFromURLString:self.modelShare.sharepic] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(target,[UMSocialControllerService defaultControllerService],YES);
            
        }
        if (button.tag == kXZSHAREBUTTONTAG+2) {// 微信好友
            //   微信好友
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:shareContent,shareUrl] shareImage:[self imageFromURLString:self.modelShare.sharepic] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(target,[UMSocialControllerService defaultControllerService],YES);
            
        }
        if (button.tag == kXZSHAREBUTTONTAG+3) {// QQ
            //   QQ
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:shareContent,shareUrl] shareImage:[self imageFromURLString:self.modelShare.sharepic] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(target,[UMSocialControllerService defaultControllerService],YES);

        }
    }
}

// 实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess){
        if (self.blockShareSuccess) { // 分享成功的回调
            self.blockShareSuccess();
        }
    }
}

- (UIImage *)imageFromURLString: (NSString *) urlstring
{
    // This call is synchronous and blocking
    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}

#pragma mark --- 懒加载
- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        _infoView.backgroundColor = [UIColor blackColor];
        _infoView.alpha = 0.6;
    }
    return _infoView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSubViews];
}

// 调用
/**
 - (XZShareView *)share {
 if (!_share) {
 _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
 _share.modelShare = self.modelActivity;
 __weak __typeof(&*self.share)weakShare = self.share;
 __weak __typeof(&*self)weakSelf = self;
 _share.blockShareAction = ^(UIButton *button){
 [weakShare shareAction:button handlerDelegate:weakSelf];
 };
 }
 _share.blockShareSuccess = ^ { // 分享成功的回调
 
 };

 return _share;
 }
 
 // 法一：当分享界面出来的时候，分享按钮还可以点击时的调用方法，
 if (_share == nil) {
     [self.view addSubview:self.share];
 }else {
     [self.share removeFromSuperview];
     _share = nil;
 }
 // 法二：调出分享界面
  [self.view addSubview:self.share];
 */

@end
