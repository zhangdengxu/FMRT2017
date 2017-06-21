//
//  XZConfirmOrderTabBar.h
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMSelectShopInfoModel;

@interface XZConfirmOrderTabBar : UIView
@property (nonatomic, copy) void(^blockSubmitOrderBtn)();
@property (nonatomic, strong) FMSelectShopInfoModel *modelProductTab;
/** 金额 */
@property (nonatomic, strong) UILabel *labelTotalMoney;
- (void)setTabBarWithValue:(NSString *)valueStr;
@end
