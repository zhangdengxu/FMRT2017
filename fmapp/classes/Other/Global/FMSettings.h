//
//  FMSettings.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMShareSetting              [FMSettings sharedSettings]


/** 用户信息设置
 
 *@See 获取常用字段内容
 *@See 设置项目参数内容
 **/
@interface FMSettings : NSObject

/*!
 *@breif 互动_表情数据数组
 */
@property (nonatomic, copy)   NSArray        *expressionNameArray;

/*!
 *@breif 互动_表情数据数组
 */
@property (nonatomic, copy)   NSArray        *expressionNameCodeArray;

/*!
 *@breif 事故快处_发生地点数组
 */
@property (nonatomic, copy)   NSArray        *placesNamesArray;

/*!
 *@breif 事故快处_发生地点编号数组
 */
@property (nonatomic, copy)   NSArray        *placeCodesArray;

//是否同意公开位置
@property (nonatomic, assign)BOOL             agreePublicLocation;

@property (nonatomic, assign)BOOL               userShakeAndShakeAudioClosed;

/*!
 *@breif判断是否存在广告
 *
 *@See  若为YES，则存在广告信息，若为NO，则不存在广告信息
 *@See 正式环境下若为不存在，返回NO，测试环境返回YES
 **/
@property (nonatomic ,assign)BOOL               appDelegateAdvertisementBool;


/*!
 *@breif 广告图片地址内容
 *
 *@See  若存在广告内容，则则该信息段必定存在数据
 **/
@property (nonatomic , copy)NSString          *appDelegateAdvertisementImageURL;

/*!
 *@breif 广告图片Size大小
 *
 *@See  若存在广告内容，则则该信息段必定存在数据
 **/
@property (nonatomic , assign)CGSize            appDelegateAdvertisementImageSize;

/*!
 *@breif 广告对应的ID信息
 *
 *@See  用户获取广告详情内容
 **/
@property (nonatomic , copy)NSString            *appDelegateAdvertisementIdentifier;

/*!
 *@breif APP项目版本号内容
 *
 *@See  用户获取广告详情内容
 **/
@property (nonatomic , assign)CGFloat           appProgramiPhoneVersionNumber;


/*!
 *@brief 最新的电台公告_ID_编号
 *
 *@See  用于进行小红点标注
 **/
@property (nonatomic , assign)NSInteger         appPushRadioAnnouncementLatestIdentifier;

/*!
 *@brief 判断是否有最新的电台公告
 *
 *@See  若为YES，则标注小红点，若NO，则不标注小红点，且默认为YES
 **/
@property (nonatomic , assign)BOOL              appPushRadioAnnouncementBool;

/*!
 *@brief 最新的我的奖品_ID_编号
 *
 *@See  用于进行小红点标注我的奖品
 **/
@property (nonatomic , assign)NSInteger         appPushMyPrizeInforLatestIdentifier;

/*!
 *@brief 最新的奖品列表_ID_编号
 *
 *@See  用于进行小红点标注奖品列表中的奖品信息
 **/
@property (nonatomic , assign)NSInteger         appPushPrizeListInforLatestIdentifier;

/*!
 *@brief 判断是否有最新奖品内容
 *
 *@See  若为YES，则标注小红点，若NO，则不标注小红点，且默认为YES
 **/
@property (nonatomic , assign)BOOL              appPushPrizeListInforBool;

/*!
 *@brief 最新的电台活动_ID_编号
 *
 *@See  用于进行小红点标注
 **/
@property (nonatomic , assign)NSInteger         appPushRadioActivityLatestIdentifier;

/*!
 *@brief 判断是否有最新电台活动内容
 *
 *@See  若为YES，则标注小红点，若NO，则不标注小红点，且默认为YES
 **/
@property (nonatomic , assign)BOOL              appPushRadioActivityBool;

/*!
 *@brief 互动中未读消息的总数
 **/
@property (nonatomic , assign)NSInteger         appPushInteractionUnreadMessageCount;

/*!
 *@brief 判断是否有新违章内容
 **/
@property (nonatomic , assign)BOOL              appPushMePersonalViolationMsgInforBool;

/*!
 *@brief 判断是否有最新的二手车评估结果内容
 **/
@property (nonatomic , assign)BOOL              appPushExploreSecondCarResultInforBool;

/*!
 *@brief 判断是否有最新的特约商户信息内容
 **/
@property (nonatomic , assign)BOOL              appPushExploreSpecialBusinessInforBool;

/*!
 *@brief 最新的特约商户_ID_编号
 **/
@property (nonatomic , assign)NSInteger         appPushExploreSpecialBusinessLatestIdentifier;


/*!
 *@brief 选中的主题编号内容
 @See 若没有则默认选中第一个
 **/
@property (nonatomic , assign)NSInteger         appProgramPersonalityThemeIndexInteger;

/*!
 *@brief 用户编辑的发布信息内容
 @See 若没有则返回空字符串
 **/
@property (nonatomic , copy)    NSString        *userPersonalSendEditedContentString;

/*!
 *@brief 支付宝操作回调参数
 */
@property (nonatomic,strong)  NSURL              *userOperationAliPayNSURLInformation;

/****/

/*!
 *@brief IM 通信流水号设置，，
 *@See 该字段为递增设置。
 */
@property (nonatomic , assign)NSInteger         appUserPersonalSEQForIMNSinteger;

/*!
 *@breif SystemMessage系统通知提醒信息ID
 *@See 用于判断是否需要显示未读消息内容
 */
@property (nonatomic , copy)NSString            *appUserSystemMessagePushLatestId;
/*!
 *@breif 系统消息是否已读
 *@See ，未读为YES，已读为NO； 默认为未读YES
 */
@property (nonatomic , assign)BOOL              appUserSystemMessageHasNORead;

/*!
 *@breif 车友聚会通知提醒信息ID
 *@See 用于判断是否需要显示未读消息内容
 */
@property (nonatomic , copy)NSString            *appUserCarFriendsPartyPushLatestId;
/*!
 *@breif 车友聚会是否已读
 *@See ，未读为YES，已读为NO； 默认为未读YES
 */
@property (nonatomic , assign)BOOL              appUserCarFriendsPartyHasNORead;

/*!
 *@breif 精品推荐通知提醒信息ID
 *@See 用于判断是否需要显示未读消息内容
 */
@property (nonatomic , copy)NSString            *appUserBusinessRecommendPushLatestId;
/*!
 *@breif 精品推荐是否已读
 *@See ，未读为YES，已读为NO； 默认为未读YES
 */
@property (nonatomic , assign)BOOL              appUserBusinessRecommendHasNORead;

/*!
 *@breif 朋友圈的圈子ID，即消息中的用户名ID
 *@See 用于判断是否需要显示未读消息内容
 */
@property (nonatomic , copy)NSString            *appUserFriendCirclePushLatestId;


/*!
 *@breif 朋友圈子中问题的ID
 *@See 用于判断是否需要显示未读消息内容
 */
@property (nonatomic , copy)NSString            *appUserFriendCirclePushLatesQuestionID;

/*!
 *@breif 朋友圈是否已读
 *@See ，未读为YES，已读为NO； 默认为未读YES
 */
@property (nonatomic , assign)BOOL              appUserFriendCircleHasNORead;

/*!
 *@breif 已加入的朋友圈中圈内总人数
 *@See 用于展示圈内总人数
 */
@property (nonatomic , assign)NSInteger            appUserFriendCircleCountMemberInteger;

/*!
 *@breif IM中当前聊天的对方用户ID
 *@See 用于判断是否在于别人聊天
 *@See 若 不为空，则表示当前有联系对象，否则为空；
 */
@property (nonatomic , copy)NSString            *appUserPersonalChatUserIdString;

/*!
 *@breif 消息中全部未读消息总数内容
 *@See 用于判断消息Bar中是否消失小红点
 *@See 若 <= 0则消除小红点，若 >= 1, 则显示小红点
 */
@property (nonatomic , assign)NSInteger           appFMUnReadMessageCountForIM;

/*!
 *@breif 互动中未读消息个数
 *@See 用于判断互动刷新后是否需要显示震动
 **/
@property (nonatomic , assign)NSInteger             appFMInteractionUnReadCountInteger;


@property (nonatomic, assign)BOOL             agreeGestures;

@property (nonatomic, copy)NSString             *openGuideView;

@property (nonatomic,assign) NSString         *alerDataId;

// 优商城的确认订单-----从支付宝或者微信直接返回
@property (nonatomic, assign) NSInteger backNumber;
// 积分兑换的确认订单-----从支付宝或者微信直接返回
@property (nonatomic, assign) NSInteger backNumberCoin;

+ (FMSettings *)sharedSettings;



@end
