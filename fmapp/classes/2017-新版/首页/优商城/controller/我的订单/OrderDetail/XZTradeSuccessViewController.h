//
//  XZTradeSuccessViewController.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/27.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "FMViewController.h"
@class XZMyOrderModel;
typedef void(^blockOrderInfo)(NSInteger status);
@interface XZTradeSuccessViewController : FMViewController

@property (nonatomic, strong) XZMyOrderModel * orderModel;

@property (nonatomic, assign) BOOL isShowComment;
@property (nonatomic, copy) blockOrderInfo blockInfo;

@end
