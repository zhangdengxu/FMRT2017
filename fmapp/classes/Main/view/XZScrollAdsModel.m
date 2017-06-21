//
//  XZScrollAdsModel.m
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZScrollAdsModel.h"
#import "XZScrollAdsButtonModel.h"

@implementation XZScrollAdsModel
- (void)setScrollAdsModelWithDic:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.btn) {
        XZScrollAdsButtonModel *earning = [[XZScrollAdsButtonModel alloc] init];
        [earning setValuesForKeysWithDictionary:dict];
        [temp addObject:earning];
    }
    self.btn = [NSMutableArray arrayWithArray:temp];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
