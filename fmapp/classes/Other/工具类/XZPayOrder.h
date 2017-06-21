//
//  XZPayOrder.h
//  fmapp
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZPayOrder;

@protocol XZPayOrderDelegate <NSObject>

@optional
-(void)XZPayOrderResult:(NSInteger)rest;
-(void)XZPayOrderResultWithStatus:(NSString *)resultStatus;
@end

@interface XZPayOrder : NSObject
@property (nonatomic, weak) id <XZPayOrderDelegate> delegate;

/**
 *  JS调用OC方法（支付宝支付）
 */
- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6;
/**
 *  JS调用OC方法（微信支付）
 *  @param shopID   shopID
 *  @param message2 title
 *  @param message3 detail
 *  @param message4 price
 *  @param message5 url
 */
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6;


/**
 *  JS调用OC方法（支付宝支付）,回调类型不同
 */
- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger)type;


- (void)AliPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger)type withendTime:(NSString *)endTime;

/**
 *  JS调用OC方法（微信支付）
 *  @param shopID   shopID
 *  @param message2 title
 *  @param message3 detail
 *  @param message4 price
 *  @param message5 url
 */
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger )type;



/**
 *  JS调用OC方法（微信支付）
 *  @param shopID   shopID
 *  @param message2 title
 *  @param message3 detail
 *  @param message4 price
 *  @param message5 url
 */
-(void)WXPayShopID:(NSString *)shopID withTitle:(NSString *)message2 Detail:(NSString *)message3 Price:(NSString *)message4 Url:(NSString *)message5 Returl:(NSString *)message6 type:(NSInteger )type withEndTime:(NSString *)endTime;

@end
