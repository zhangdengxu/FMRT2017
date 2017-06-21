//
//  BabyPlanModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "BabyPlanModel.h"

@implementation BabyPlanModel

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{

}

+(instancetype)babyPlayModelCreateWithDictionary:(NSDictionary *)dict;
{
    BabyPlanModel * planDetail = [[BabyPlanModel alloc]init];
    [planDetail setValuesForKeysWithDictionary:dict];
    return planDetail;
}

@end
