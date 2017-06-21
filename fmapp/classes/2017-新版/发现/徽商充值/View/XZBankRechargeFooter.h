//
//  XZBankRechargeFooter.h
//  fmapp
//
//  Created by admin on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZBankRechargeUserModel;
@interface XZBankRechargeFooter : UIView

@property (nonatomic, copy) void(^blockSurePay)(UIButton *);

//@property (nonatomic, strong) XZBankRechargeModel *modelRecharge;

//// 是快捷支付
//@property (nonatomic, assign) BOOL isQuickPay;
// 电子账户信息
@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;
@end
