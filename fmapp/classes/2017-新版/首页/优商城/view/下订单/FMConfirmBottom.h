//
//  FMConfirmBottom.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZConfirmOrderModel.h"
@class XZConfirmOrderModel;
// 点击快递信息按钮
typedef void(^blockDetailBtn)(UIButton *);

// 点击footerView中的按钮
typedef void(^blockPrivilegeBtn)(UIButton *);

@interface FMConfirmBottom : UIView

@property (nonatomic, copy) blockPrivilegeBtn blockPrivilegeBtn;
@property (nonatomic, copy) blockDetailBtn blockDetailBtn;
// 从商品详情跳入
@property (nonatomic, strong) XZConfirmOrderModel *confirmModel;
// 从购物车跳入
@property (nonatomic, strong) FMShoppingListModel *shopListModel;
/** 可用积分View */
@property (nonatomic, strong) UIView *viewIntegral;
/** 优惠券View */
@property (nonatomic, strong) UIView *viewCoupons, *viewTotalMoney;

- (void)changeStatusWithModel:(XZConfirmOrderModel *)model withModel2:(XZConfirmOrderModel *)confirmModel Count:(NSInteger)count ;
/** 金额合计 */
@property (nonatomic, strong) UILabel *labelTotalMoney;

@end
