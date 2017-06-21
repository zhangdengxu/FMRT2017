//
//  FMShareModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/7/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShareModel.h"

@implementation FMShareModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(instancetype)initWithShareModelDictionary:(NSDictionary *)dictionary
{
    FMShareModel * shareModel = [[FMShareModel alloc]init];
    [shareModel setValuesForKeysWithDictionary:dictionary];
    return shareModel;
}


@end
