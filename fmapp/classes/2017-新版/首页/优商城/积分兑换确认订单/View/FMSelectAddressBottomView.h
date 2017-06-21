//
//  FMSelectAddressBottomView.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FMSelectAddressBottomView,XZConfirmOrderModel;

@interface FMSelectAddressBottomView : UIView

// 快递数据
@property (nonatomic, strong) NSMutableArray *arrDistribution;

// 点击关闭按钮
@property (nonatomic, copy) void(^blockDidClickClosed)(XZConfirmOrderModel *);

-(void)showActivity;
-(void)changeActivityViewTitle:(NSString *)title andCloseTitle:(NSString *)closeTitle;

@end
