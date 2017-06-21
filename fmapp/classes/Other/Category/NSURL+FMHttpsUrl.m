//
//  NSURL+FMHttpsUrl.m
//  fmapp
//
//  Created by runzhiqiu on 2016/12/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "NSURL+FMHttpsUrl.h"
#import<objc/runtime.h>

@implementation NSURL (FMHttpsUrl)

+(void)load
{
    
    // 运行时交换两个方法的实现
    Method m1 = class_getClassMethod([NSURL class], @selector(URLWithString:));
    Method m2 = class_getClassMethod([NSURL class], @selector(URLWithStringWithCreate:));
    method_exchangeImplementations(m1, m2);
}

+(instancetype)URLWithStringWithCreate:(NSString *)string;
{

    if (([string hasPrefix:@"http://www.qdygo.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)) {
        
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://www.qdygo.com/" withString:@"https://www.rongtuojinrong.com/qdy/"];
        
       
        return [self URLWithStringWithCreate:strUrl];
        
    }else if(([string hasPrefix:@"http://qdygo.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)){
        
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://qdygo.com/" withString:@"https://www.rongtuojinrong.com/qdy/"];
        
        
        return [self URLWithStringWithCreate:strUrl];

    
    }else if(([string hasPrefix:@"http://api.rongtuojinrong.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)){
        
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://api.rongtuojinrong.com/" withString:@"https://www.rongtuojinrong.com/java/"];
        
        
        return [self URLWithStringWithCreate:strUrl];
    
    }else if(([string hasPrefix:@"http://p2p.rongtuojinrong.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)){
    
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://p2p.rongtuojinrong.com/" withString:@"https://www.rongtuojinrong.com/"];
        
        
        return [self URLWithStringWithCreate:strUrl];
    }else if(([string hasPrefix:@"http://ww.rongtuojinrong.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)){
        
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://ww.rongtuojinrong.com/" withString:@"https://www.rongtuojinrong.com/"];
        
        return [self URLWithStringWithCreate:strUrl];
    }else if(([string hasPrefix:@"http://www.rongtuojinrong.com"])&& ([string rangeOfString:@".jpg"].location != NSNotFound||[string rangeOfString:@".png"].location != NSNotFound||[string rangeOfString:@".jpeg"].location != NSNotFound)){
        
        NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"http://www.rongtuojinrong.com" withString:@"https://www.rongtuojinrong.com"];
        
        return [self URLWithStringWithCreate:strUrl];
    }else
    {
        return [self URLWithStringWithCreate:string];
    }
    
}


@end
