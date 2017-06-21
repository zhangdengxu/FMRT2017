//
//  XZBankRechargeHeader.h
//  fmapp
//
//  Created by admin on 17/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class XZBankRechargeModel;
@class XZBankRechargeUserModel;
@interface XZBankRechargeHeader : UIView

@property (nonatomic, copy) void(^blockRecharge)(UIButton *);

//@property (nonatomic, strong) XZBankRechargeModel *modelRecharge;
// 电子账户信息
@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;

//// 是快捷支付
//@property (nonatomic, assign) BOOL isQuickPay;
@end
