//
//  XZRechargeSuccessView.h
//  fmapp
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZBankRechargeUserModel;
@interface XZRechargeSuccessView : UIView

@property (nonatomic, copy) void(^blockSureRecharge)();

// 电子账户信息
@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;

@end
