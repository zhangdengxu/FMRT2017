//
//  BabyPlanDetailModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyPlanDetailModel : NSObject
@property (nonatomic,copy) NSString *Jiner;
@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *zongshu;
@property (nonatomic,copy) NSString *yitoushu;
@property (nonatomic,copy) NSString *yizhuan;
@property (nonatomic,copy) NSString *mytouziri;
@property (nonatomic,copy) NSString *cunkuanri;
@property (nonatomic,copy) NSString *Zhuangtai;
@property (nonatomic,copy) NSString *jilu_id;//autot_id
@property (nonatomic,copy) NSString *autot_id;//
@property (nonatomic,strong)NSDictionary * jiekuaninfo;
@property (nonatomic,copy) NSString *jie_id;
@property (nonatomic,copy) NSString *endisornot;//xiugaianniu
@property (nonatomic,copy) NSString *xiugaianniu;//
@property (nonatomic,copy) NSString *tishineirong;//

+(instancetype)babyPlayDetailModelCreateWithDictionary:(NSDictionary *)dict;
@end

@interface BabyPlanTitleModel : NSObject
@property (nonatomic,copy) NSString *type_id;
@property (nonatomic,copy) NSString *title;

@end

