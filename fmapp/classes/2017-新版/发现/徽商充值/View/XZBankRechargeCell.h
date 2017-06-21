//
//  XZBankRechargeCell.h
//  fmapp
//
//  Created by admin on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZBankRechargeModel;
//@class XZBankRechargeUserModel;
@interface XZBankRechargeCell : UITableViewCell

@property (nonatomic, strong) XZBankRechargeModel *modelRecharge;

//// 电子账户信息
//@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;


@property (nonatomic, copy) void(^blockImmediateGo)();

@property (nonatomic, copy) void(^blockMoney)(NSString *);
@end
