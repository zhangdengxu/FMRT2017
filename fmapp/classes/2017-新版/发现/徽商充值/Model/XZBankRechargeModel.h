//
//  XZBankRechargeModel.h
//  fmapp
//
//  Created by admin on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZBankRechargeModel : NSObject
// 是快捷支付
@property (nonatomic, assign) BOOL isQuickPay;
// 方式
@property (nonatomic, copy) NSString *way;
// 方式名
@property (nonatomic, copy) NSString *wayName;


@end

@interface XZBankRechargeUserModel : NSObject
// 是快捷支付
@property (nonatomic, assign) BOOL isQuickPay;
// 电子交易账户
@property (nonatomic, copy) NSString *cardnbr;
// 开户人
@property (nonatomic, copy) NSString *acctname;
// 账户余额
@property (nonatomic, assign) double acctAmt;

// 开户行
@property (nonatomic, copy) NSString *bankName;
// 手机号
@property (nonatomic, copy) NSString *mobile;
// 绑定银行名称
@property (nonatomic, copy) NSString *signBankName;
// 绑定银行卡号
@property (nonatomic, copy) NSString *signBankCard;
// 单笔限额
@property (nonatomic, assign) double transLimit;
// 单日限额
@property (nonatomic, assign) double dayLimit;
// 限额描述
@property (nonatomic, copy) NSString *limitDesc;
// 账户总额
@property (nonatomic, assign) double acctAmtTotal;

// 充值金额
@property (nonatomic, copy) NSString *moneyRecharge;
@end
