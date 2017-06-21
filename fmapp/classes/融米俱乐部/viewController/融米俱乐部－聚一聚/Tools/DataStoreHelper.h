//
//  DataStoreHelper.h
//  TextFastCoding
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStoreHelper : NSObject
//单例
+(instancetype)shareDataStore;
//保存数据
-(void)storeValue:(id)value withKey:(NSString *)key;
//读取数据
-(id)valueWithKey:(NSString *)key;
@end
