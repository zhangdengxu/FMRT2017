//
//  XZEarningGroupModel.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZEarningGroupModel.h"
#import "XZEarningModel.h"

@implementation XZEarningGroupModel
- (void)setEarningWithDic:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.Monthlist) {
        XZEarningModel *earning = [[XZEarningModel alloc] init];
        [earning setEarningInnerWithDic:dict andModel:earning];
        [temp addObject:earning];
    }
    self.Monthlist = [NSMutableArray arrayWithArray:temp];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
    }
    return self;
}

//+(NSDictionary *)mj_objectClassInArray {
//    return @{@"Monthlist":@"XZEarningModel"};
//}
@end
