//
//  FMRTWellStoreSaledDealViewController.h
//  fmapp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class XZMyOrderGoodsModel;
@interface FMRTWellStoreSaledDealViewController : FMViewController

@property (nonatomic, copy)NSString *orderID;
@property (nonatomic, strong)XZMyOrderGoodsModel *model;

@end
