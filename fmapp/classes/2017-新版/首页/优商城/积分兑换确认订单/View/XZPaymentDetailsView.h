//
//  XZPaymentDetailsView.h
//  fmapp
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZConfirmOrderModel;
@interface XZPaymentDetailsView : UIView
@property (nonatomic, copy) void(^blockDidClickClosed)();
// 当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModelCoins;
@end
