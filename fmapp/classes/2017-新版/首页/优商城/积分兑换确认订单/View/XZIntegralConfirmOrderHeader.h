//
//  XZIntegralConfirmOrderHeader.h
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZShoppingOrderAddressModel;
@interface XZIntegralConfirmOrderHeader : UIView
@property (nonatomic, copy) void(^blockChooseAddress)();

- (void)sendDataWithModel:(XZShoppingOrderAddressModel *)model;

@end
