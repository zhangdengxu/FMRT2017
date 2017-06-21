//
//  XZTransferRechargeView.h
//  fmapp
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZTransferRechargeModel;
@interface XZTransferRechargeView : UIView

@property (nonatomic, strong) XZTransferRechargeModel *modelTransfer;

@property (nonatomic, copy) void(^blockClosed)();
@end
