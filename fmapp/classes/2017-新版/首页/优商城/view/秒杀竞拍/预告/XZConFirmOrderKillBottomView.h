//
//  XZConFirmOrderKillBottomView.h
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
//  选择优惠券
typedef void(^blockDetailBtn)(UIButton *);
// 点击footerView中的按钮 支付方式
typedef void(^blockPrivilegeBtn)(UIButton *);

@class FMSelectShopInfoModel;
@interface XZConFirmOrderKillBottomView : UIView
@property (nonatomic, copy) blockPrivilegeBtn blockPrivilegeBtn;
@property (nonatomic, copy) blockDetailBtn blockDetailBtn;
@property (nonatomic, strong) FMSelectShopInfoModel *shopDetailModel;
- (void)setValueWithModel:(FMSelectShopInfoModel *)shopDetailModel;

@end
