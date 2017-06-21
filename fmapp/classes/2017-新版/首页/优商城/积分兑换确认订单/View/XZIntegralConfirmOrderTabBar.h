//
//  XZIntegralConfirmOrderTabBar.h
//  fmapp
//
//  Created by admin on 16/12/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZConfirmOrderModel;
@interface XZIntegralConfirmOrderTabBar : UIView
@property (nonatomic, copy) void(^blockClickConfirmOrder)(UIButton *);
// 当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModelCoins;
@end
