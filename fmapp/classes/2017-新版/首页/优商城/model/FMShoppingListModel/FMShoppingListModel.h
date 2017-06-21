//
//  FMShoppingListModel.h
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMPriceModel.h"
#import "MJExtension.h"

@interface FMShoppingListModel : NSObject<MJKeyValue>

@property (assign, nonatomic) BOOL      selectState;
//
@property (nonatomic, strong) NSString  *color;
@property (nonatomic, strong) NSString  *box;
//
@property (nonatomic, strong) NSString  *oldPrice;
@property (nonatomic,copy) NSString *fulljifen_ex;//判断是否全积分兑换
@property (assign, nonatomic) BOOL      navSelectState;

//向下页传递的参数
@property (nonatomic,copy) NSString *md5_cart_info;
@property (nonatomic,copy) NSString *sess_id;
/*
 "goods_id" = 1496;
 image = "https://www.rongtuojinrong.com/qdy/public/images/4e/70/df/fe698ff4c4036dec1d5c0d32e2647857.jpg?1429250098#h";
 name = "\U6c49\U82b3 \U7687\U5bb6\U73ab\U7470\U667a\U80fd\U7115\U767d\U8d85\U7ea7\U7ec4\U54086\U4ef6\U5957";
 price =                 {
 "buy_price" = "438.000";
 cost = "0.000";
 "member_lv_price" = "438.000";
 price = "598.000";
 };
 "product_id" = 13002;
 quantity = 1;
 
 */


@property (nonatomic, copy)     NSString *image;
@property (nonatomic, copy)     NSString *name;
@property (nonatomic, assign)   int quantity;
@property (nonatomic, copy)     NSString * goods_id;
@property (nonatomic, copy)     NSString * product_id;
@property (nonatomic, strong)   FMPriceModel *price;
@property (nonatomic, copy)     NSString *currentStyle;
@property (nonatomic, assign)   NSInteger selectCount;
@property (nonatomic, strong)   NSArray *spec;

/**
 *  样式改变后的
 */
@property (nonatomic, copy)     NSString * modify_Product_id;
@property (nonatomic, copy)     NSString * modify_Goods_id;

@end

