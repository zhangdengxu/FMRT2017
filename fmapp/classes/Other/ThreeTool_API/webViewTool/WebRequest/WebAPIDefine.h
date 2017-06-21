//
//  WepAPIDefine.h
//  FM_CZFW
//
//  所有FM_CZFW Rest服务的API地址
//
//  Created by liyuhui on 14-4-1.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#ifndef CZFW_WebAPIDefine_h
#define CZFW_WebAPIDefine_h

#define KUserName    @"userName"
#define kBaseAPIURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/"
#define kDataKeyData          @"data"
#define kImageUpload          @"user/updateHeadImg.json"
#define KMeKeyUserPhoneNumber           @"mobile"                               ///用户个人手机号
#define KMeKeyUserSecurityCode          @"code"
#define KDataKeyUserMobile              @"mobile"

#pragma mark - common key
#define kDataKeyPageIndex      @"page"
#define kDataKeyPageSize       @"page_size"
#define kDataKeyData           @"data"
#define kDataKeyId             @"id"
#define kDataKeyLastId         @"lastid"
#define kDataKeyType           @"type"
#define kDataKeyPageCount      @"totalPage"
#define kDataKeyDataCount      @"count"
#define kDataKeyUserId         @"userId"
#define kDataKeyLongitude      @"longitude"
#define kDataKeyLatitude       @"latitude"
#define KDataKeyAudio          @"audio"
#define KDataKeyAvatar         @"avatar"
#define KDataKeyPublic          @"is_public"
#define KDataKeyUserSignature           @"signature"
#define KDataKeyUserNewPasword          @"newPassword"



#define KUserFatelcodeURL            @"User/fatelcode"       ///发送验证码（注册时）
#define KAboutUsURL                  @"Helpzhongxin/guanyu"  ///关于我们
#define KUserCktelcode               @"User/cktelcode"       ///验证手机验证码（注册时)
#define KUserRegisterURL             @"User/do_register"     ///注册

#define KUserRegisterxindeURL        @"User/do_registerxinde"     ///新的注册
#define KUserLoginURL                @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/do_login"        ///登录
#define KUserFindPassWordURL         @"User/zhaohuimima"     ///找回密码

#define KFatelcodeTelURL             @"User/fatelcodetel"    
#define KUserCkoldshoujiURL          @"User/ckoldshouji"
#define KUserCktelcodeURL            @"User/xiugaitel"

#define KLendLiebiaoURL              @"Lend/liebiaoyijiu"
#define KLenddanbaoURL               @"Lend/danbaoyijiu"
#define KLenfDiyaURL                 @"Lend/diyayijiu"
#define KLenfBaoliURL                @"Lend/baoliyijiu"
#define KProjectDetailURL            @"Lend/infoshow"
#define KLenZhaiquanURL              @"Lend/zhaiquanyijiu"
#define KClaimAreaURL                @"Lend/zhaiquaninfo"
#define KRecommendURL                @"Lend/tjliebiaoxinde"
#define KProjectJingyingdai          @"lend/jingying"


#define KLunBoPicURL                 @"Helpzhongxin/indexpic"
#define KletterURL                   @"Usercenter/zhanneixin"
#define KQuxianURL                   @"Usercenter/shouyiqixian"
#define KMeSetupPasswordURL          @"User/change_password"              //登录后修改密码
#define KMyShouYiURL                 @"Usercenter/yuqifinace"
#define KUserPostZhenshi             @"Usercenter/postZhenshi"
#define KUserGetZhenshi              @"Usercenter/getZhenshi"
#define KlingqianguanURL             @"Usercenter/lingqianguansanshi"
#define KAlerDataURL                 @"Usercenter/appindexad"
#define KFirstLingURL                @"lend/lingqianguan"

#define KDidMessageURL               @"Usercenter/zhanneixinbiaoji"

#define KLendZhaiquanURL             @"Lend/zhaiquanyijiu"
#define KMyClaimURL                  @"Usercenter/lczhaiquan"

#define KRongZiQiXianURL             @"Borrowkuan/rongzhiqixian"
#define KRongZiFangShiURL            @"Borrowkuan/rongzhifangshi"

#define KBorrowkuanURL               @"Borrowkuan/shenqing"

#define KFeedBackURL                 @"User/liuyantj"
#endif
