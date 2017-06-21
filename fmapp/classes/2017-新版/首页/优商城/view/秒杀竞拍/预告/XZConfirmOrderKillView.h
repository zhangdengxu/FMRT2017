//
//  XZConfirmOrderKillView.h
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZShoppingOrderAddressModel;
@class FMSelectShopInfoModel;
// 优惠券
typedef void(^blockChooseAddress)();
@interface XZConfirmOrderKillView : UIView

@property (nonatomic, copy) blockChooseAddress blockChooseAddress;

- (void)sendDataWithModel:(XZShoppingOrderAddressModel *)model;

@property (nonatomic, strong) FMSelectShopInfoModel *modelProduct;
@end