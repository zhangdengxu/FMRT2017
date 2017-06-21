//
//  XZEarningModel.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZEarningModel.h"
#import "XZEarningInnerModel.h"

@implementation XZEarningModel

//- (void)setEarningInnerWithDic:(NSDictionary *)dic {
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NSDictionary *dict in self.daylist) {
//        XZEarningInnerModel *earning = [[XZEarningInnerModel alloc] init];
//        [earning setValuesForKeysWithDictionary:dict];
//        [temp addObject:earning];
//    }
//    self.daylist = [NSMutableArray arrayWithArray:temp];
//}

- (void)setEarningInnerWithDic:(NSDictionary *)dic andModel:(XZEarningModel *)model{
    [self setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.daylist) {
        XZEarningInnerModel *earning = [[XZEarningInnerModel alloc] init];
        [earning setValuesForKeysWithDictionary:dict];
//        earning.day = model.day;
//        earning.daynum = model.daynum;
//        earning.daytotal = model.daytotal;
        [temp addObject:earning];
    }
    self.daylist = [NSMutableArray arrayWithArray:temp];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   
}

//+(NSDictionary *)mj_objectClassInArray {
//    return @{@"daylist":@"XZEarningInnerModel"};
//}

@end
