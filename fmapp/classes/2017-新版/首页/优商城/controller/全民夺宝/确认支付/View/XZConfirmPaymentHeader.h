//
//  XZConfirmPaymentHeader.h
//  fmapp
//
//  Created by admin on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class FMSelectShopInfoModel;
@class XZShoppingOrderAddressModel;
@interface XZConfirmPaymentHeader : UIView
@property (nonatomic, copy) void(^blockChooseAddress)();
//@property (nonatomic, strong) FMSelectShopInfoModel *modelProduct;
- (void)sendDataWithModel:(XZShoppingOrderAddressModel *)model;
@end
