//
//  XMTradeTableviewHeader.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMOrderDetailLocationModel;

typedef void(^blocksCopyBtn)();

@interface XMTradeTableviewHeader : UIView

@property (nonatomic, strong) FMOrderDetailLocationModel * headerModel;

- (instancetype)initWithorderModel:(FMOrderDetailLocationModel *)headerModel;

@property (nonatomic,copy) blocksCopyBtn blockBtn;
@end
