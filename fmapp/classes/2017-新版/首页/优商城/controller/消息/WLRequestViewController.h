//
//  WLRequestViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "XZMyOrderGoodsModel.h"
#import "XZMyOrderModel.h"
typedef void(^blockAfterSaleId)(NSString * buobaoStyle);

@interface WLRequestViewController : FMViewController
@property(nonatomic,strong)XZMyOrderGoodsModel *model;
@property(nonatomic,strong)NSString *tag;
@property (nonatomic,copy) blockAfterSaleId buttonSpread;
@end
