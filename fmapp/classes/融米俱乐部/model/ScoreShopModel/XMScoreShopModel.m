//
//  XMScoreShopModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMScoreShopModel.h"

@implementation XMScoreShopModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


+(instancetype)initWithScoreShopModelWithDictionary:(NSDictionary *)dictionary;
{
    XMScoreShopModel * model = [[XMScoreShopModel alloc]init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

@end
