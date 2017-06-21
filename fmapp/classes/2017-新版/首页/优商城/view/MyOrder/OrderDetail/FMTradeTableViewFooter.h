//
//  FMTradeTableViewFooter.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMOrderDetailGoodsModel;
typedef void(^blockCopyBtn)(UIButton *button);

@interface FMTradeTableViewFooter : UIView

@property (nonatomic, strong) FMOrderDetailGoodsModel * footerVModel;

- (instancetype)initWithorderModel:(FMOrderDetailGoodsModel *)headerModel;

@property (nonatomic, copy) blockCopyBtn blockCopyBtn;

@end
