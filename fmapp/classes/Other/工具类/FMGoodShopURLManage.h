//
//  FMGoodShopURLManage.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMGoodShopURLManage : NSObject

+(NSString *)getNewNetWorkURLWithBaseURL:(NSString *)baseUrl;
+(NSString *)getNewNetWorkURLWithBaseData;

@end
