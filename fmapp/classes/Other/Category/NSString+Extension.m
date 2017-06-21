//
//  NSString+Extension.m
//  iOS谢兴明WB
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NSString+Extension.h"
#import "RegexKitLite.h"

@implementation NSString (Extension)

#pragma -mark ---- java - php 切换接口

static NSString * kJavaChangePhpPortBase = @"https://www.rongtuojinrong.com/";


+(CGSize)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(UIFont *)font WithString:(NSString *)string
{
     
    NSDictionary * attres=@{NSFontAttributeName:font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attres context:nil].size;
    
}
-(CGSize)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(UIFont *)font
{
    
    
    NSDictionary * attres=@{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attres context:nil].size;
    
}
+(instancetype)retStringFromTimeToyyyyYearMMMonthddDay:(NSString *)timeString
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:time];//将时间转化成目标时间字符串
    return retString;
}


+(instancetype)retStringFromTimeToyyyyYearMMMonthddDayHHMMSS_haomiao:(NSString *)timeString
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss sss"];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:time];//将时间转化成目标时间字符串
    return retString;
}


+(instancetype)retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:(NSString *)timeString
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:time];//将时间转化成目标时间字符串
    return retString;}

+(instancetype)retStringFromTimeToyyyyYear_MM_Month_ddDay_HH_MM:(NSString *)timeString
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:time];//将时间转化成目标时间字符串
    return retString;
}
+(instancetype)retStringFrom:(NSString *)format withtimeString:(NSString *)timeString
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:time];//将时间转化成目标时间字符串
    return retString;
}
+(instancetype)retStringFrom:(NSString *)format withTimeString:(NSDate *)timeDate
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];//设置源时间字符串的格式
    
    NSString * retString = [formatter stringFromDate:timeDate];//将时间转化成目标时间字符串
    return retString;
}

- (NSInteger)fileSize {
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否为文件
    BOOL dir = NO;
    BOOL exist = [mgr fileExistsAtPath:self isDirectory:&dir];
    // 文件\文件夹不存在
    if (exist == NO) return 0;
    // 判断是不是文件夹
    if (dir) { // self是一个文件夹
        // 遍历caches里面的所有内容 -- 直接和间接内容
        NSArray *subpaths = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubpath isDirectory:&dir];
            if (dir == NO) { // 文件
                totalByteSize += [[mgr attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalByteSize;
    }else {// self是一个文件
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize]integerValue];
    }
}

+ (NSString *)timeBytesTurnToFormatTimeWithTimeBytes:(NSString *)str
{
    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

-(NSDictionary *)retJsonToDictionary;
{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        Log(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM_DD_HH_MM_SS_WithBeijing:(NSDate *)date
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone:localzone];
    
    return  [dateFormatter stringFromDate:date];
    
}

+(instancetype)retStringWithPlatform:(NSString *)baseUrl withPlatform:(NSString *)platform;
{
    if ([baseUrl rangeOfString:@"?"].location != NSNotFound) {
        return [NSString stringWithFormat:@"%@&plattype=%@",baseUrl,platform];
    }else
    {
        return [NSString stringWithFormat:@"%@?plattype=%@",baseUrl,platform];
    }
}


+(instancetype)retStringWithHttpsUrl:(NSString *)baseUrl;
{
    if ([baseUrl rangeOfString:@"http://"].location != NSNotFound) {
        return baseUrl;
    }
    
    if ([baseUrl rangeOfString:@"https://"].location != NSNotFound) {
        return baseUrl;
    }
    
    return [NSString stringWithFormat:@"https://%@",baseUrl];
}


//判断是否输入了emoji 表情

+ (BOOL)stringContainsEmoji:(NSString *)string;
{
    
    __block BOOL returnValue = NO;
    
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    
                                    if (substring.length > 1) {
                                        
                                        const unichar ls = [substring characterAtIndex:1];
                                        
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            
                                            returnValue = YES;
                                            
                                        }
                                        
                                    }
                                    
                                } else if (substring.length > 1) {
                                    
                                    const unichar ls = [substring characterAtIndex:1];
                                    
                                    if (ls == 0x20e3) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                    
                                    
                                } else {
                                    
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        
                                        returnValue = YES;
                                        
                                    }else if (hs == 0x200d){
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                }
                                
                            }];
    
    
    
    return returnValue;
    
}


//将字符串改为中间四位的改为加密形式
+(NSString *)retNSStringWithSecret:(NSString *)secretString withBegin:(NSInteger)begin withEnding:(NSInteger )ending WithStarCount:(NSInteger)starCount
{
    NSString * strLinshi = @"aa";
    if (secretString.length > (begin + ending)) {
        NSString *string1,*string2,*string3;
        string1 = [secretString substringToIndex:begin];//截取掉下标7之后的字符串
        string2 = [secretString substringFromIndex:(secretString.length - ending)];
        if (starCount == 0) {
             string3 = [strLinshi retSecretString:secretString.length - ending - begin];
        }else
        {
            string3 = [strLinshi retSecretString:starCount];
            
        }
        return [NSString stringWithFormat:@"%@%@%@",string1,string3,string2];
    }
    return @"";
}
-(NSString *)retSecretString:(NSInteger)count
{
    NSMutableString * str = [NSMutableString string];
    for (NSInteger i = 0; i < count; i++) {
        [str appendString:@"*"];
    }
    return str;
}


-(NSString *)retNetWorkCmdidWithKeyValue;
{
    NSArray * contentArray = [self  componentsSeparatedByString:@"&"];
    NSString * middleString;
    for (NSString * contentString in contentArray) {
        if([contentString rangeOfString:@"CmdId="].location !=NSNotFound)
        {
            middleString = contentString;
            break;
        }
        else
        {
            continue;
        }
    }
    if (middleString) {
        NSArray * middleArray = [middleString  componentsSeparatedByString:@"="];
        NSString * portString;
        for (NSString * contentString in middleArray) {
            if([contentString rangeOfString:@"CmdId"].location !=NSNotFound)
            {
                continue;
            }
            else
            {
                
                portString = contentString;
                break;
            }
        }
        
        if(portString)
        {
            //找到端口号
            
            NSString * nextPort ;
            
            //找到对应关系
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PortMatchInfo" ofType:@"plist"];
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
            
            nextPort = data[portString];
            if (nextPort) {
                NSString * retString = [NSString stringWithFormat:@"%@%@",kJavaChangePhpPortBase,nextPort];
                return retString;
                
            }else
            {
                return self;
            }
        
        }else
        {
            return self;
        }
        
        
    }else
    {
        return self;
    }
}

@end
