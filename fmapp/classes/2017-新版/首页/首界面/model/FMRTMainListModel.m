//
//  FMRTMainListModel.m
//  fmapp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTMainListModel.h"
#import "FMIndexHeaderModel.h"

@implementation FMRTMainListModel

- (instancetype)init{
    self = [super init];
    if (self) {

        self.tanchuangArr = [NSMutableArray array];
    }
    return self;
}

@end

@implementation FMRTLunboModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSArray *)lunboArrWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];

    if ([dic objectForKey:@"lubodata"]) {
        id lunbodata = [dic objectForKey:@"lubodata"];
        if ([lunbodata isKindOfClass:[NSArray class]]) {
            NSArray *lunboArr = (NSArray *)lunbodata;
            if (lunboArr.count) {
                for (NSDictionary *lunboDic in lunboArr) {
                    FMIndexHeaderModel *model = [[FMIndexHeaderModel alloc]init];
                    [model setValuesForKeysWithDictionary:lunboDic];
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;
}

@end

@implementation FMRTXiangmuModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


+(NSArray *)xiamgmudataArrWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([dic objectForKey:@"xiangmudate"]) {
        id xaingmudata = [dic objectForKey:@"xiangmudate"];
        if ([xaingmudata isKindOfClass:[NSArray class]]) {
            NSArray *xiangmuArr = (NSArray *)xaingmudata;
            if (xiangmuArr.count) {
                for (NSDictionary *xaingmuDic in xiangmuArr) {
                    FMRTXiangmuModel *model = [[FMRTXiangmuModel alloc]init];
                    [model setValuesForKeysWithDictionary:xaingmuDic];
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;
}

@end


@implementation FMRTTanchuangModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

