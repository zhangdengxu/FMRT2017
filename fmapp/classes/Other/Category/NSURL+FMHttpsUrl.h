//
//  NSURL+FMHttpsUrl.h
//  fmapp
//
//  Created by runzhiqiu on 2016/12/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (FMHttpsUrl)

+(instancetype)URLWithStringWithCreate:(NSString *)string;
+(void)load;

@end
