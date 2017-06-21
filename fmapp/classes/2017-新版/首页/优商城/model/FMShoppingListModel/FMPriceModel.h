//
//  FMPriceModel.h
//  fmapp
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMPriceModel : NSObject

/**
 price =                 {
 "buy_price" = "438.000";
 cost = "0.000";
 "member_lv_price" = "438.000";
 price = "598.000";
 
 };
 */

@property (nonatomic, copy)NSString *buy_price;
@property (nonatomic, copy)NSString *cost;
@property (nonatomic, copy)NSString *member_lv_price;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *mktprice;

@end
