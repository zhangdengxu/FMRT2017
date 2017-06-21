//
//  TestJSObject.h
//  webViewCeshi
//
//  Created by runzhiqiu on 16/3/18.
//  Copyright © 2016年 runzhiqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@class TestJSObject;
@protocol TestJSObjectDelegate <NSObject>

@optional
-(void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6;

/**
 *
 *
 *  @param shopID   shopID
 *  @param message2 title
 *  @param message3 detail
 *  @param message4 price
 *  @param message5 url
 */
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5  Returl:(NSString *)message6;


- (void)ProjectSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4;

- (void)ProjectFailMoney:(NSString *)message1  Title:(NSString *)message4;



//- (void)Babyplaninputsuccess:(NSString *)message;
//- (void)Babyplayinputfail:(NSString *)message;

/**
 *  宝贝计划加入成功
 */
- (void)BabyPlayInputSuccess:(NSString *)message;


/**
 *  <#Description#>
 *
 *  @param message <#message description#>
 */
- (void)BabyPlayInputfail:(NSString *)message;



/**
 *  调取优商城，无参数
 */
- (void)ActivityYoushangcheng;
/**
 *  调取零钱贯，两个参数，一个是获得金额，一个是来源
 *
 *  @param message <#message description#>
 */
- (void)ActivityLingqianguan:(NSString *)huodejine Laiyuan:(NSString *)laiyuan;


//零钱贯开通自动投标调用
- (void)LingqianguanTurnAutomaticSuccess;

@end

//首先创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocol <JSExport>


-(void)Alipay:(NSString *)message1 Title:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5  Returl:(NSString *)message6;



-(void)WXpay:(NSString *)message1 Title:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5  Returl:(NSString *)message6;

//项目投标成功调用
- (void)PJSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4;
- (void)PJFailMoney:(NSString *)message1 Title:(NSString *)message4;
//项目投标成功调用
- (void)PJSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3;
- (void)PJFailMoney:(NSString *)message1;

//宝贝计划成功调用
- (void)BabyPlayInputSuccess:(NSString *)message;
- (void)BabyPlayInputfail:(NSString *)message;

//活动弹窗调用
- (void)ActivityYoushangcheng;
- (void)ActivityLingqianguan:(NSString *)huodejine Laiyuan:(NSString *)laiyuan;

//零钱贯开通自动投标调用
- (void)LingqianguanTurnAutomaticSuccess;

// 我的推荐二维码
- (void)Jump:(NSString *)title Title:(NSString *)shareTitle Content:(NSString *)shareContent Image:(NSString *)imageUrl Url:(NSString *)shareUrl Type:(NSString *)linkUrl;

/**
 *  注册成功后返回首页方法
 */
-(void)backToTheHomePage;
/**
 *  全民夺宝首页--获取夺宝币方法
 */
-(void)receiveMoreCoins;
/**
 *  全民夺宝首页--常见问题
 */
-(void)frequentlyAskedQuestions;
/**
 *  更多服务--新手指引--马上赚钱
 */
-(void)MakeMoneyJustNow;

// 首页轮播图跳转优商城
- (void)JumpToYouShangCheng;
//跳转底部tabbar选项
- (void)JumptotabbarIndex:(NSString *)selectIndex;
//跳转优商城商品详情
- (void)JumptoyoushangchengDetail:(NSString *)product_id;
//打开分享界面
- (void)opentoShareviewcontroller;
//打开新版积分兑换记录界面
- (void)Jumptoscorenoteview;

/**
 我的推荐----我的销售订单----查看详情
 */
- (void)Onemoreagainwithproductid:(NSString *)productid Iscoin:(BOOL)coinPay;


//新版项目投标成功之后的跳转
-(void)Pmakesuccess:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4 Projectid:(NSString *)projectId Peojectimage:(NSString *)imageUrl Projectdetail:(NSString *)detail;

// 回调到提现
-(void)JumpToAccomplish;

//打开修改交易密码
- (void)JumpToTheTradePassWordViewcontroller;
@end

//让我们创建的类实现上边的协议
@interface TestJSObject : NSObject<TestJSObjectProtocol>
@property (nonatomic, weak) id <TestJSObjectDelegate> delegate;

@property (nonatomic, copy) void(^blockRecommand)(NSString *,NSString *,NSString *,NSString *,NSString *,NSString *);
@property (nonatomic, copy) void(^blockToTheHomePage)();
@property (nonatomic, copy) void(^blockReceiveMoreCoins)();
@property (nonatomic, copy) void(^blockFrequentlyAskedQuestions)();
@property (nonatomic, copy) void(^blockMakeMoney)();
// 首页轮播图跳转优商城
@property (nonatomic, copy) void(^blockJumpToYouShangCheng)();
//跳转底部tabbar选项
@property (nonatomic, copy) void(^blockJumpToTabbarIndex)(NSString *);
//跳优商城商品详情
@property (nonatomic, copy) void(^blockJumpToyoushangchengDetail)(NSString *);
//跳新版积分兑换记录界面
@property (nonatomic, copy) void(^blockJumpToScorenoteview)();
//打开分享界面
@property (nonatomic, copy) void(^blockJumpToShareviewcontroller)();
//打开修改交易密码
@property (nonatomic, copy) void(^blockJmpToChangeTraderPassWord)();
//完成按钮方法
@property (nonatomic, copy) void(^blockJmpToAccomplish)();
/** 点击再来一单 */
@property (nonatomic, copy) void(^blockClickOneMoreAgain)(NSString *, BOOL);
/** 点击再来一单 */
@property (nonatomic, copy) void(^blockProjectMakeSuccessInfoBlock)(NSString * message1, NSString * message2,NSString * message3,NSString * message4,NSString * projectId,NSString * imageUrl,NSString * detail);

@end
