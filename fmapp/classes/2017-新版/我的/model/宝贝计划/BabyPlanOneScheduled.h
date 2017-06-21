//
//  BabyPlanOneScheduled.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyPlanOneScheduled : NSObject

@property (nonatomic,copy) NSString *jie_id;

@property (nonatomic,copy) NSString *jilu_id;

@property (nonatomic,copy) NSString *jiner;

@property (nonatomic,copy) NSNumber *leijijiner;

@property (nonatomic,copy) NSString *shangyuelixi;

@property (nonatomic,copy) NSString *shijian;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *toubiaobenjin;

@property (nonatomic,copy) NSString *yuanjie_id;

//@property (nonatomic,copy) NSString *touzibenjin;

+(instancetype)babyPlanOneScheduledModelCreateWithDictionary:(NSDictionary *)dict;
@end
