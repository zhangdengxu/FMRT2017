//
//  XZPayOrder.m
//  fmapp
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZPayOrder.h"
#import "NSString+FontAwesome.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "TestJSObject.h"

#import "WXModel.h"
/**
 *  支付宝
 */
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

/**
 *  微信支付
 */
#import "WXApi.h"
#import "WXApiObject.h"
#import "WechatAuthSDK.h"
#import "NSString+Hash.h"
#import "AFNetworking.h"
#import "lhSharePay.h"


#import "NSString+Hash.h"
#import "FMGoodShopURLManage.h"

@interface XZPayOrder ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) Order *orderInfo;
@property (nonatomic, strong) WXModel *wxmodel;;
@end

@implementation XZPayOrder
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(payUserInfoResult:)
                                                     name: KPAYINFOWITHSUCCESSORFAIL
                                                   object: nil];
    }
    return self;
}

/**
 *  JS调用OC方法（支付宝支付）
 */
- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6
{
    
    Log(@"shopID:%@  title:%@   detail:%@   price:%@   url:%@   Returl:%@",shopID,message2,message3,message4,message5,message6);
    Order * orderInfo = [[Order alloc]init];
    self.orderInfo = orderInfo;
    
    orderInfo.tradeNO = shopID;
    orderInfo.productName = [NSString stringWithFormat:@"优商城：%@",message2];
    orderInfo.productDescription = message3;
    orderInfo.amount = message4;
    orderInfo.notifyURL = message5;
    orderInfo.ret_notify = message6;
    
    
    [self payMoneyForShopWithAliay];
}

/**
 *  JS调用OC方法（支付宝支付）,回调类型不同//type类型最好要大于10
 */
- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger)type;
{
    
    Log(@"shopID:%@  title:%@   detail:%@   price:%@   url:%@   Returl:%@",shopID,message2,message3,message4,message5,message6);
    Order * orderInfo = [[Order alloc]init];
    self.orderInfo = orderInfo;
    
    orderInfo.tradeNO = shopID;
    orderInfo.productName = [NSString stringWithFormat:@"优商城：%@",message2];
    orderInfo.productDescription = message3;
    orderInfo.amount = message4;
    orderInfo.notifyURL = message5;
    orderInfo.ret_notify = message6;
    
    orderInfo.type = type;
    [self payMoneyForShopWithAliay];
}
- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger)type withendTime:(NSString *)endTime;
{
    Order * orderInfo = [[Order alloc]init];
    self.orderInfo = orderInfo;
    
    orderInfo.tradeNO = shopID;
    orderInfo.productName = [NSString stringWithFormat:@"优商城：%@",message2];
    orderInfo.productDescription = message3;
    orderInfo.amount = message4;
    orderInfo.notifyURL = message5;
    orderInfo.ret_notify = message6;
    orderInfo.endTime = endTime;
    orderInfo.type = type;
    [self payMoneyForShopWithAliay];
}



-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger )type withEndTime:(NSString *)endTime;
{
    
    WXModel * wxmodel = [[WXModel alloc]init];
    self.wxmodel = wxmodel;
    wxmodel.out_trade_no = shopID;
    wxmodel.notify_url = message5;
    wxmodel.boby = [NSString stringWithFormat:@"优商城：%@", message3];
    wxmodel.total_fee = [NSString stringWithFormat:@"%d", (int)([message4 floatValue] * 100)];
    wxmodel.ret_notify = message6;
    wxmodel.type = type;
    wxmodel.endTime = endTime;
    [wxmodel retSignWithWx];
    [self payMoneyForShopWithWX];
}

/**
 *  JS调用OC方法（微信支付）
 *  @param shopID   shopID
 *  @param message2 title
 *  @param message3 detail
 *  @param message4 price
 *  @param message5 url
 */
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6
{
    
     Log(@"shopID:%@  title:%@   detail:%@   price:%@   url:%@   Returl:%@",shopID,message2,message3,message4,message5,message6);
    
    WXModel * wxmodel = [[WXModel alloc]init];
    self.wxmodel = wxmodel;
    wxmodel.out_trade_no = shopID;
    wxmodel.notify_url = message5;
    wxmodel.boby = [NSString stringWithFormat:@"优商城：%@", message3];
    wxmodel.total_fee = [NSString stringWithFormat:@"%d", (int)([message4 floatValue] * 100)];
    wxmodel.ret_notify = message6;
    
    [wxmodel retSignWithWx];
    [self payMoneyForShopWithWX];
    
}

/**
*  JS调用OC方法（微信支付）
*  @param shopID   shopID
*  @param message2 title
*  @param message3 detail
*  @param message4 price
*  @param message5 url
*/
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger )type;
{
    
    Log(@"shopID:%@  title:%@   detail:%@   price:%@   url:%@   Returl:%@",shopID,message2,message3,message4,message5,message6);
    
    WXModel * wxmodel = [[WXModel alloc]init];
    self.wxmodel = wxmodel;
    wxmodel.out_trade_no = shopID;
    wxmodel.notify_url = message5;
    wxmodel.boby = message3;
    wxmodel.total_fee = [NSString stringWithFormat:@"%d", (int)([message4 floatValue] * 100)];
    wxmodel.ret_notify = message6;
    wxmodel.type = type;
    [wxmodel retSignWithWx];
    [self payMoneyForShopWithWX];
    
}



/**
 *  支付宝支付
 */
-(void)payMoneyForShopWithAliay
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的==================================*/
    /*============================================================================*/
    NSString *partner = @"2088211061179714";
    NSString *seller = @"rongtuojinrong@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKsVFebL/yJ2mtQ53+Fm7Y80UChVZ6wYqyA5rx2ePCuFcTk5JLo/YEvGzwYHALhNQgL5vIu6luPpVH/5AV4eH1qrf3atKhuKUExJZGfqlAdS3F9JUCNyBYp/v+FNfJm48ETuV23MELsbAQKwXjnDysa1dnYQbGVyeMg10O4pTRjJAgMBAAECgYA99PbnjH0rR/SuYv83LAVgVTuqP7O52X0vwHQwr7tur3bfmFg6svT2vFsA/cw+8ouzdCnaGIrIoxmc9tqN8S69GVycIdzpqxEZlLyzPWhks2w8HrU+6duGNsbDbWU17mKiKuwzlortBDDXogXdWdUHCDc8dEI+oFoIFJxcpZ8t2QJBAOFHxByc2t8mcGHimHSpZwnDseeubeaH24OssJXVDeBztrUcGVeXmA6TUZDlxfaIGnB3042Wmzeseu+yDkdi9kMCQQDCaVdUaws2XLK+8qfwUooRYuQvzmPGAyE6n9yl3zXcwHWoSFqo6QQqlphZNCkqGqWRkuqckECiYbq5uPPsZpIDAkBV7C1cTGceXWbXrrk/Ja1rB/y+xMSd/Is4+ZCQVSZpyTiScxknU2ZniMC/ZyPOF7Md2lYR1rN01JA/A8Z2a8RJAkAdmWA8cBfC7RYh0FwVUNvIjd/kD25NZYiXnmM/td5Df+Hp/yoecWu6+Da1ziU+TdRLd6zUrXnJv0ton2oz4eH1AkEA2jKXJLoWALMAWG6Jjk2XKLSUSU+S16YFxQQTwCazvYpKBpg9r1Ntl6lCut71AbruymwNa+XLbA+Y11zACoiyXw==";
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderInfo.tradeNO; //订单ID（由商家自行制定）
    order.productName = self.orderInfo.productName; //商品标题
    order.productDescription = self.orderInfo.productDescription; //商品描述
    order.amount = self.orderInfo.amount; //商品价格
    order.notifyURL =  self.orderInfo.notifyURL; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";

    if (self.orderInfo.endTime) {
        order.itBPay = self.orderInfo.endTime;
    }else
    {
        order.itBPay = @"5m";
    }
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"rongtuojinrongappAliPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    Log(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        __weak typeof(self) wself = self;
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            Log(@"===>%@",resultDic);
            
            if (self.orderInfo.type == 11||self.orderInfo.type == 12) {
                //由竞拍或秒杀进入的支付
                [wself postKillAndJingPaiUrlInfo:resultDic[@"resultStatus"]];
                
            }else if(order.type == 22)
            {
                //由夺宝进入的支付
            }else
            {
                 [wself postUrlInfo:resultDic[@"resultStatus"]];
            }
            
           
            
            
        }];
    }
}

//1代表成功  2代表失败
-(void)conteResult:(NSUInteger)rest
{
    if ([self.delegate respondsToSelector:@selector(XZPayOrderResult:)]) {
        [self.delegate XZPayOrderResult:rest];
    }
}


/**
 *  支付宝支付完成后回调通知服务器
 */
-(void)postKillAndJingPaiUrlInfo:(NSString *)status
{
    if ([self.delegate respondsToSelector:@selector(XZPayOrderResultWithStatus:)]) {
        [self.delegate XZPayOrderResultWithStatus:status];
    }
}


/**
 *  支付宝支付完成后回调通知服务器
 */
-(void)postUrlInfo:(NSString *)status
{
    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString * tokenAll = [NSString stringWithFormat:@"out_trade_no=%@&total_fee=%@&status=%@&time=%d&alipaySecret&time=%d",self.orderInfo.tradeNO,self.orderInfo.amount,status,timestamp,timestamp];
    
    NSString *token=tokenAll.md5String;
    NSDictionary * dataSource = @{@"out_trade_no":self.orderInfo.tradeNO,
                                  @"total_fee":self.orderInfo.amount,
                                  @"status":status,
                                  @"time":[NSNumber numberWithInt:timestamp],
                                  @"token":token};
    NSString * httpUrl = [NSString stringWithFormat:@"%@%@",self.orderInfo.ret_notify, [FMGoodShopURLManage getNewNetWorkURLWithBaseData]];
    [FMHTTPClient postPath:httpUrl parameters:dataSource completion:^(WebAPIResponse *response) {
        Log(@"===>%@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject[@"msg"]) {
                NSString * staMsg = response.responseObject[@"msg"];
                if ([staMsg isEqualToString:@"ok"]) {
                    [self conteResult:1];
                }else
                {
                    [self conteResult:2];
                }
            }else
            {
                 [self conteResult:2];
            }
        }else
        {
             [self conteResult:2];
        }
        
    }];
}


-(void)payMoneyForShopWithWX
{
    
    if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"您未安装微信,请重新选择支付方式！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alter.tag = 6000;
        [alter show];
        return;
    }
    
    [self getInterFaceFromNetWork];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 6000) {
        if ([self.delegate respondsToSelector:@selector(XZPayOrderResultWithStatus:)]) {
            [self.delegate XZPayOrderResultWithStatus:@"0"];
        }
        
    }
}

-(void)getInterFaceFromNetWork
{
   
    
    
    NSDictionary * payDic = @{
                              @"api_key":self.wxmodel.keyShanghu,
                              @"app_id":self.wxmodel.appid,
                              @"mch_id":self.wxmodel.mch_id,
                              @"notify_url":self.wxmodel.notify_url};
    
    NSDictionary * orderDic;
    
    long long timeNew = [[NSString retNSStringToNSdateWithYYYY_MM_DD_HH_MM_SS_WithBeijing:[NSDate date]] longLongValue];
    
    
    long long timeAfter = [[NSString retNSStringToNSdateWithYYYY_MM_DD_HH_MM_SS_WithBeijing:[NSDate dateWithTimeIntervalSinceNow:6 * 60]] longLongValue];
    
    
    if (self.wxmodel.type == 11) {

        if (self.wxmodel.endTime) {
            orderDic = @{
                         @"id":self.wxmodel.out_trade_no,
                         @"money":self.wxmodel.total_fee,
                         @"orderCode":self.wxmodel.out_trade_no,
                         @"productName":self.wxmodel.boby,
                         @"productDescription":self.wxmodel.boby,
                         @"pay_type_Shop":[NSNumber numberWithInteger:self.wxmodel.type],
                         @"time_start":[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:timeNew]],
                         @"time_expire":self.wxmodel.endTime
                         };
        }else
        {
            orderDic = @{
                         @"id":self.wxmodel.out_trade_no,
                         @"money":self.wxmodel.total_fee,
                         @"orderCode":self.wxmodel.out_trade_no,
                         @"productName":self.wxmodel.boby,
                         @"productDescription":self.wxmodel.boby,
                         @"pay_type_Shop":[NSNumber numberWithInteger:self.wxmodel.type],
                         @"time_start":[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:timeNew]],
                         @"time_expire":[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:timeAfter]]
                         };
        }
        
      
    }else
    {
        orderDic = @{
                     @"id":self.wxmodel.out_trade_no,
                     @"money":self.wxmodel.total_fee,
                     @"orderCode":self.wxmodel.out_trade_no,
                     @"productName":self.wxmodel.boby,
                     @"productDescription":self.wxmodel.boby,
                     @"pay_type_Shop":[NSNumber numberWithInteger:self.wxmodel.type]
                     };
    }
    
   
    
    //下单成功，调用微信支付
    [[lhSharePay sharePay]wxPayWithPayDic:payDic OrderDic:orderDic];
}

-(void)payUserInfoResult:(NSNotification *) notification
{
    
    if (self.wxmodel.type == 11 ||self.wxmodel.type == 12) {
        if ([self.delegate respondsToSelector:@selector(XZPayOrderResultWithStatus:)]) {
            
            NSDictionary * userInfo = notification.userInfo;
            NSNumber * result = userInfo[@"result"];
            
            //1成功，0失败
            [self.delegate XZPayOrderResultWithStatus:[NSString stringWithFormat:@"%@",result]];
        }
        
        
    }else
    {
        NSDictionary * userInfo = notification.userInfo;
        NSNumber * result = userInfo[@"result"];
        if ([result intValue] == 1) {
            
            [self waPayResult:1];
        }else
        {
            
            [self conteResult:2];
        }
    }
   
}
-(void)waPayResult:(NSInteger)result
{
    NSString * httpUrl = [NSString stringWithFormat:@"%@%@",self.wxmodel.ret_notify, [FMGoodShopURLManage getNewNetWorkURLWithBaseData]];
    [FMHTTPClient postPath:httpUrl parameters:nil completion:^(WebAPIResponse *response) {
        Log(@"===>%@",response.responseObject);
        
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject[@"msg"]) {
                NSString * staMsg = response.responseObject[@"msg"];
                if ([staMsg isEqualToString:@"ok"]) {
                    [self conteResult:1];
                }else
                {
                    [self conteResult:2];
                }
            }else
            {
                [self conteResult:2];
            }
        }else
        {
            [self conteResult:2];
        }
        
    }];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
