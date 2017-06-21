//
//  FMFavoriteModel.h
//  fmapp
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMFavoriteModel : NSObject

@property (strong, nonatomic) NSString  *imageName;
@property (strong, nonatomic) NSString  *title;
//@property (strong, nonatomic) NSString  *price;
@property (assign, nonatomic) BOOL      selectState;
@property (strong, nonatomic) NSString  *num;
@property (nonatomic, strong) NSString  *color;
@property (nonatomic, strong) NSString  *box;
@property (nonatomic, strong) NSString  *oldPrice;
@property (assign, nonatomic) BOOL      navSelectState;

/**
 *  正式参数模型spec_info


{
    gid = 3601;
    image = "";
    mktprice = 0;
    name = "<null>";
    price = 0;
    "product_id" = "<null>";
    "spec_desc_info" = "<null>";
    "spec_info" = "<null>";
    store = "<null>";
},
 
  */
@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, assign)  float price;
@property (nonatomic, assign) float mktprice;
@property (nonatomic, copy)  NSString *product_id;
@property (nonatomic, copy ) NSString *store;
@property (nonatomic, copy)   NSString *spec_info;

//-(instancetype)initWithDict:(NSDictionary *)dict;

@end
