//
//  XZOptimalMallSubmitOrderTabBar.h
//  fmapp
//
//  Created by admin on 16/12/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZConfirmOrderModel;
@interface XZOptimalMallSubmitOrderTabBar : UIView
@property (nonatomic, copy) void(^blockClickConfirmOrder)(UIButton *);


//- (void)sendModelToTabBar:(XZConfirmOrderModel *)model;

@property (nonatomic, strong) XZConfirmOrderModel *confirmModel;
@end
