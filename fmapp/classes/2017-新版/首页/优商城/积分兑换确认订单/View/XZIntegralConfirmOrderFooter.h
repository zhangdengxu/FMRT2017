//
//  XZIntegralConfirmOrderFooter.h
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZConfirmOrderModel;
@interface XZIntegralConfirmOrderFooter : UIView

@property (nonatomic, copy) void(^blockDidClickButton)(UIButton *);

// 当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModelCoins;

// 用户留言
@property (nonatomic, copy) void(^blockSendUserMsg)(NSString *);
@end
