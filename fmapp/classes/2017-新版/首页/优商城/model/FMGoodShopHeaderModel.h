//
//  FMGoodShopHeaderModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMGoodShopHeaderModel : NSObject

@property (nonatomic,copy) NSString *cateid;
@property (nonatomic,copy) NSString *name;

@end

@interface FMGoodShopModel : NSObject

@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *mprice;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *fulljifen_ex;


@end

@interface FMshopHeaderImageModel : NSObject
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *fenxiangpic;
@property (nonatomic,copy) NSString *fenxiangbiaoti;
@property (nonatomic,copy) NSString *fenxiangneirong;
@property (nonatomic,copy) NSString *fenxianglianjie;

@end

@interface FMshopHeaderActiveModel : NSObject
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *fenxiangpic;
@property (nonatomic,copy) NSString *fenxiangbiaoti;
@property (nonatomic,copy) NSString *fenxiangneirong;
@property (nonatomic,copy) NSString *fenxianglianjie;



@end
