//
//  FMRTWellStoreProductModel.h
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTWellStoreProductModel : NSObject

@property (nonatomic, copy) NSString *cateid;
@property (nonatomic, copy) NSString *name;

+(NSArray *)dataSourceWithDic:(NSDictionary *)dic;
+(NSArray *)cateidArrWithDic:(NSDictionary *)dic;

@end

@interface FMRTWellScroModel : NSObject

@property (nonatomic, copy) NSString *fenxiangbiaoti;
@property (nonatomic, copy) NSString *fenxianglianjie;
@property (nonatomic, copy) NSString *fenxiangneirong;
@property (nonatomic, copy) NSString *fenxiangpic;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

+(NSArray *)scrollArrWithDic:(NSDictionary *)dic;

@end

@interface FMRTWellCollectionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *mprice;
@property (nonatomic, copy) NSString *guibin_price;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *icon_jifen;
@property (nonatomic, copy) NSString *icon_quan;
@property (nonatomic, copy) NSString *fulljifen_ex;

+(NSArray *)collectionArrWithDic:(NSDictionary *)dic;

@end

@interface wellShareModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *content;

@end

@interface wellHuodongModel : NSObject

@property (nonatomic, copy) NSString *fenxiangbiaoti;
@property (nonatomic, copy) NSString *fenxianglianjie;
@property (nonatomic, copy) NSString *fenxiangneirong;
@property (nonatomic, copy) NSString *fenxiangpic;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

+(NSArray *)huodongArrWithDic:(NSDictionary *)dic;


@end
