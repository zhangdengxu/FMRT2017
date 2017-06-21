//
//  TestJSObject.m
//  webViewCeshi
//
//  Created by runzhiqiu on 16/3/18.
//  Copyright © 2016年 runzhiqiu. All rights reserved.
//

#import "TestJSObject.h"

@implementation TestJSObject


-(void)Alipay:(NSString *)message1 Title:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6
{
    
    if ([self.delegate respondsToSelector:@selector(AliPayShopID:withTitle:Detail:Price:Url: Returl:)]) {
        [self.delegate AliPayShopID:message1 withTitle:message2 Detail:message3 Price:message4 Url:message5 Returl:message6];
    }
}

-(void)WXpay:(NSString *)message1 Title:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6
{
    if ([self.delegate respondsToSelector:@selector(WXPayShopID:withTitle:Detail:Price:Url:Returl:)]) {
        [self.delegate WXPayShopID:message1 withTitle:message2 Detail:message3 Price:message4 Url:message5 Returl:message6];
    }
}


- (void)PJSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4;
{
    if ([self.delegate respondsToSelector:@selector(ProjectSuccessMoney:Profit:Time:Title:)]) {
        [self.delegate ProjectSuccessMoney:message1 Profit:message2 Time:message3 Title:message4];
    }
}
- (void)PJFailMoney:(NSString *)message1 Title:(NSString *)message4;
{
    if ([self.delegate respondsToSelector:@selector(ProjectFailMoney: Title:)]) {
        [self.delegate ProjectFailMoney:message1 Title:message4];
    }
}


//项目投标成功调用
- (void)PJSuccessMoney:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3;
{
    if ([self.delegate respondsToSelector:@selector(ProjectSuccessMoney:Profit:Time:Title:)]) {
        [self.delegate ProjectSuccessMoney:message1 Profit:message2 Time:message3 Title:@"提交成功"];
    }
}
- (void)PJFailMoney:(NSString *)message1;
{
    if ([self.delegate respondsToSelector:@selector(ProjectFailMoney: Title:)]) {
        [self.delegate ProjectFailMoney:message1 Title:@"提交失败"];
    }

}

//
//- (void)Babyplaninputsuccess:(NSString *)message;
//{
//    if ([self.delegate respondsToSelector:@selector(BabyPlayInputSuccess:)]) {
//        [self.delegate BabyPlayInputSuccess:message];
//    }
//}
//- (void)Babyplayinputfail:(NSString *)message;
//{
//    if ([self.delegate respondsToSelector:@selector(BabyPlayInputfail:)]) {
//        [self.delegate BabyPlayInputfail:message];
//    }
//}


- (void)BabyPlayInputSuccess:(NSString *)message;
{
    if ([self.delegate respondsToSelector:@selector(BabyPlayInputSuccess:)]) {
        [self.delegate BabyPlayInputSuccess:message];
    }
}
- (void)BabyPlayInputfail:(NSString *)message;
{
    if ([self.delegate respondsToSelector:@selector(BabyPlayInputfail:)]) {
        [self.delegate BabyPlayInputfail:message];
    }
}
- (void)ActivityYoushangcheng;
{
    if ([self.delegate respondsToSelector:@selector(ActivityYoushangcheng)]) {
        [self.delegate ActivityYoushangcheng];
    }
}
- (void)ActivityLingqianguan:(NSString *)huodejine Laiyuan:(NSString *)laiyuan;
{
    if ([self.delegate respondsToSelector:@selector(ActivityLingqianguan:Laiyuan:)]) {
        [self.delegate ActivityLingqianguan:huodejine Laiyuan:laiyuan];
    }
}

//零钱贯开通自动投标调用
- (void)LingqianguanTurnAutomaticSuccess;
{
    if ([self.delegate respondsToSelector:@selector(LingqianguanTurnAutomaticSuccess)]) {
        [self.delegate LingqianguanTurnAutomaticSuccess];
    }
}

// 我的推荐二维码
- (void)Jump:(NSString *)title Title:(NSString *)shareTitle Content:(NSString *)shareContent Image:(NSString *)imageUrl Url:(NSString *)shareUrl Type:(NSString *)linkUrl{
    if (self.blockRecommand) {
        self.blockRecommand(title,shareTitle,shareContent,imageUrl,shareUrl,linkUrl);
    }
}
/**
 *  注册成功后返回首页方法
 */
-(void)backToTheHomePage{
    if (self.blockToTheHomePage) {
        self.blockToTheHomePage();
    }
}

/**
 *  全民夺宝首页--获取夺宝币方法
 */
-(void)receiveMoreCoins{
    if (self.blockReceiveMoreCoins) {
        self.blockReceiveMoreCoins();
    }
}
/**
 *  全民夺宝首页--常见问题
 */
-(void)frequentlyAskedQuestions{
    if (self.blockFrequentlyAskedQuestions) {
        self.blockFrequentlyAskedQuestions();
    }
}
/**
 *  更多服务--新手指引--马上赚钱
 */
-(void)MakeMoneyJustNow{
    if (self.blockMakeMoney) {
        self.blockMakeMoney();
    }
}

// 首页轮播图跳转优商城
- (void)JumpToYouShangCheng {
    if (self.blockJumpToYouShangCheng) {
        self.blockJumpToYouShangCheng();
    }
}


//跳转底部tabbar选项

- (void)JumptotabbarIndex:(NSString *)selectIndex;
{
    if (self.blockJumpToTabbarIndex) {
        self.blockJumpToTabbarIndex(selectIndex);
    }
}


//跳转优商城商品详情
- (void)JumptoyoushangchengDetail:(NSString *)product_id;
{
    if (self.blockJumpToyoushangchengDetail) {
        self.blockJumpToyoushangchengDetail(product_id);
    }
}


//打开分享界面
- (void)opentoShareviewcontroller;
{
    if (self.blockJumpToShareviewcontroller) {
        self.blockJumpToShareviewcontroller();
    }
}

//打开修改交易密码
- (void)JumpToTheTradePassWordViewcontroller;
{
    if (self.blockJmpToChangeTraderPassWord) {
        self.blockJmpToChangeTraderPassWord();
    }
}

-(void)JumpToAccomplish;
{

    if (self.blockJmpToAccomplish) {
        self.blockJmpToAccomplish();
    }
}

//打开新版积分兑换记录界面
- (void)Jumptoscorenoteview;
{
    if (self.blockJumpToScorenoteview) {
        self.blockJumpToScorenoteview();
    }
}

/** 
 我的推荐----我的销售订单----再来一单
 */
- (void)Onemoreagainwithproductid:(NSString *)productid Iscoin:(BOOL)coinPay {
    if (self.blockClickOneMoreAgain) {
        self.blockClickOneMoreAgain(productid,coinPay);
    }
}


//新版项目投标成功之后的跳转
-(void)Pmakesuccess:(NSString *)message1 Profit:(NSString *)message2 Time:(NSString *)message3 Title:(NSString *)message4 Projectid:(NSString *)projectId Peojectimage:(NSString *)imageUrl Projectdetail:(NSString *)detail;
{
    if (self.blockProjectMakeSuccessInfoBlock) {
        self.blockProjectMakeSuccessInfoBlock(message1,message2,message3,message4,projectId,imageUrl,detail);
    }
}
@end


