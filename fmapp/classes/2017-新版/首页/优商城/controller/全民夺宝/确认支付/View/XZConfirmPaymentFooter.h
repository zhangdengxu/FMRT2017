//
//  XZConfirmPaymentFooter.h
//  fmapp
//
//  Created by admin on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDuobaoClassSelectStyle;
@interface XZConfirmPaymentFooter : UIView
@property (nonatomic, copy) void(^blockPayWay)(UIButton *);
// 支付
@property (nonatomic, copy) void(^blockPay)(UIButton *);
//@property (nonatomic, strong) FMSelectShopInfoModel *modelShopInfo;

@property (nonatomic, strong) FMDuobaoClassSelectStyle *duobaoShop;
/** 账户余额 */
@property (nonatomic, strong) NSString *accountBalance;
@end
