//
//  BabyPlanModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyPlanModel : NSObject

@property (nonatomic,copy) NSString *daoqishijian;//
@property (nonatomic,copy) NSString *jiaoyishijian;//
@property (nonatomic,copy) NSString *lilv;//
@property (nonatomic,copy) NSString *mytouziri;//
@property (nonatomic,copy) NSString *qixian;//
@property (nonatomic,copy) NSString *title;//
@property (nonatomic,copy) NSNumber *yicun;//
@property (nonatomic,copy) NSString *yizhuan;//
@property (nonatomic,copy) NSString *zhuangtai;//
@property (nonatomic,copy) NSString *jiner;//
@property (nonatomic,copy) NSString *jie_id;//
@property (nonatomic,copy) NSNumber *bencicunkuanri;
@property (nonatomic,copy) NSNumber *benyueyicun;//
@property (nonatomic,copy) NSString *status;//
@property (nonatomic,copy) NSString *jilu_id;//
@property (nonatomic,copy) NSString *yitoucishu;//
@property (nonatomic,copy) NSString *bencishijian;

@property (nonatomic,copy) NSString *zongshu;

@property (nonatomic,copy) NSString *shijian;//时间戳
@property (nonatomic,copy) NSString *huankuanfangshi;

//@property (nonatomic,copy) NSString *jiaruanniu;

+(instancetype)babyPlayModelCreateWithDictionary:(NSDictionary *)dict;

@end
