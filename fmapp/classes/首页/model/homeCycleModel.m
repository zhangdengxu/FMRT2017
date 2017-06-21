//
//  homeCycleModel.m
//  fmapp
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "homeCycleModel.h"

@implementation homeCycleModel


- (instancetype)initWithData:(id)data{
    
    if (self = [super init]) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary * dic = (NSDictionary *)data;
        if (dic.count ==0) {
            return nil;
        }
        self.pic = dic[@"pic"];
        self.lianjie = dic[@"lianjie"];
        self.biaoti = dic[@"biaoti"];

    }
    return self;
}

+ (instancetype)objectWithData:(id)data {
    
    return [[self alloc]initWithData:data];
}

+ (NSArray *)homeCycleArrayWithDataArr:(NSArray *)dataArr {
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dict in dataArr) {
        if (dict) {
            if (dict[@"pic"]) {
                NSString * imageUrl = dict[@"pic"];
                [array addObject:imageUrl];
            }
        }
    }
    
    return array;
}

+ (NSArray *)homeCycleUrlArrayWithDataArr:(NSArray *)dataArr {
    
    NSMutableArray * array = [NSMutableArray new];
    for (NSDictionary * dict in dataArr) {
        if (dict) {
                NSString * imageUrl = dict[@"lianjie"];
                [array addObject:imageUrl];
        }
    }
    return array;
}

+ (NSArray *)homeCycleTitleArrayWithDataArr:(NSArray *)dataArr {
    
    NSMutableArray * array = [NSMutableArray new];
    for (NSDictionary * dict in dataArr) {
        if (dict) {
            if (dict[@"biaoti"]) {
                NSString * url = dict[@"biaoti"];
                [array addObject:url];
            }
        }
    }
    return array;
}

@end
