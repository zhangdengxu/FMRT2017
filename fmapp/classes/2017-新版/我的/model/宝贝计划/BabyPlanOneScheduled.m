//
//  BabyPlanOneScheduled.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "BabyPlanOneScheduled.h"

@implementation BabyPlanOneScheduled

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(instancetype)babyPlanOneScheduledModelCreateWithDictionary:(NSDictionary *)dict;
{
    BabyPlanOneScheduled * planDetail = [[BabyPlanOneScheduled alloc]init];
    [planDetail setValuesForKeysWithDictionary:dict];
    return planDetail;
}

@end
