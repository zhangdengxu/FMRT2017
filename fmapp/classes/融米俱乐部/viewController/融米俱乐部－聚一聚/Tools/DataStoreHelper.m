//
//  DataStoreHelper.m
//  TextFastCoding
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 XX. All rights reserved.
//

#import "DataStoreHelper.h"
#import "FastCoder.h"

@implementation DataStoreHelper

+(instancetype)shareDataStore{
    static DataStoreHelper *dataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHelper = [[DataStoreHelper alloc]init];
    });
    return dataHelper;
}

-(void)storeValue:(id)value withKey:(NSString *)key{
    //规定value和key的值不能为空 ，当为空时，报错
    NSParameterAssert(value);
    NSParameterAssert(key);
    //将value的值转换为NSData类型
    NSData *data = [FastCoder dataWithRootObject:value];
    //将data通过key值保存到本地
    if (data) {//如果data有值，保存到本地
        // 写入文件
        [data writeToFile:[self filePath:key] atomically:YES];
    }
}

- (NSString *)filePath:(NSString *)keyStr
{
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES) lastObject];
    return [chachePath stringByAppendingPathComponent:keyStr];
}

-(id)valueWithKey:(NSString *)key {
    //规定key的值不能为空
    NSParameterAssert(key);
    //通过key值获得本地数据data
    NSData *data = [NSData dataWithContentsOfFile:[self filePath:key]];
    //通过FastCoder将data转化为我们保存的数据
    return [FastCoder objectWithData:data];
}



@end
