//
//  FMGatherModel.h
//  fmapp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMGatherStyleModel : NSObject

@property (nonatomic, copy) NSString *tab_filter;
@property (nonatomic, copy) NSString *tab_name;

@end



@interface FMGatherModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *store;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *image_default_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *nostore_sell;
@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, strong) NSURL *image;

@end
