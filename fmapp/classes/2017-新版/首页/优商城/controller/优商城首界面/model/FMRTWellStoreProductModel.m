//
//  FMRTWellStoreProductModel.m
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreProductModel.h"

@implementation FMRTWellStoreProductModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSArray *)dataSourceWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];
    if ([dic objectForKey:@"cates"]) {
        id cates = [dic objectForKey:@"cates"];
        if ([cates isKindOfClass:[NSArray class]]) {
            NSArray *cateArr = (NSArray *)cates;
            if (cateArr.count) {
                for (NSDictionary *dict in cateArr) {
                    FMRTWellStoreProductModel *model = [[FMRTWellStoreProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arr addObject:model.name];
                }
            }
        }
    }
    return arr;
}

+(NSArray *)cateidArrWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];
    if ([dic objectForKey:@"cates"]) {
        id cates = [dic objectForKey:@"cates"];
            if ([cates isKindOfClass:[NSArray class]]) {
                NSArray *cateArr = (NSArray *)cates;
                if (cateArr.count) {
                    for (NSDictionary *dict in cateArr) {
                    FMRTWellStoreProductModel *model = [[FMRTWellStoreProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arr addObject:[NSString stringWithFormat:@"%@", model.cateid]];
                }
            }
        }
    }
    return arr;
}


@end

@implementation FMRTWellScroModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSArray *)scrollArrWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];
    if ([dic objectForKey:@"slides"]) {
        id slides = [dic objectForKey:@"slides"];
        if ([slides isKindOfClass:[NSArray class]]) {
            NSArray *slideArr = (NSArray *)slides;
            if (slideArr.count) {
                for (NSDictionary *dict in slideArr) {
                    FMRTWellScroModel *model = [[FMRTWellScroModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;
}

@end

@implementation FMRTWellCollectionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSArray *)collectionArrWithDic:(NSDictionary *)dic{
    
    NSMutableArray *arr = [NSMutableArray array];
    if ([dic objectForKey:@"data"]) {
        id data = [dic objectForKey:@"data"];
        if ([data isKindOfClass:[NSArray class]]) {

            NSArray *dataArr = (NSArray *)data;
            if (dataArr.count) {
                for (NSDictionary *dict in dataArr) {
                    FMRTWellCollectionModel *model = [[FMRTWellCollectionModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arr addObject:model];
                }
            }

        }
    }
    return arr;
}

@end


@implementation wellShareModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

@implementation wellHuodongModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSArray *)huodongArrWithDic:(NSDictionary *)dic{
    NSMutableArray *arr = [NSMutableArray array];
    if ([dic objectForKey:@"huodong"]) {
        id data = [dic objectForKey:@"huodong"];
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *huodongArr = (NSArray *)data;
            if (huodongArr.count) {
                for (NSDictionary *dict in huodongArr) {
                    wellHuodongModel *model = [[wellHuodongModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;
}

@end
