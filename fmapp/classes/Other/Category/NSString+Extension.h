//
//  NSString+Extension.h
//  iOS谢兴明WB
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)

//将字符串改为中间几位的改为加密形式，secretString传入字符串，begin开始几位，ending结束几位,starCount为*的个数，当为0时，为剩余字符全为*
+(NSString *)retNSStringWithSecret:(NSString *)secretString withBegin:(NSInteger)begin withEnding:(NSInteger )ending WithStarCount:(NSInteger)starCount;


+ (NSString *)timeBytesTurnToFormatTimeWithTimeBytes:(NSString *)str;


+(CGSize)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(UIFont *)font WithString:(NSString *)string;

-(CGSize)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(UIFont *)font;


+(instancetype)retStringFrom:(NSString *)format withtimeString:(NSString *)timeString;


+(instancetype)retStringFromTimeToyyyyYearMMMonthddDay:(NSString *)timeString;

+(instancetype)retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:(NSString *)timeString;

+(instancetype)retStringFrom:(NSString *)format withTimeString:(NSDate *)timeDate;
+(instancetype)retStringFromTimeToyyyyYear_MM_Month_ddDay_HH_MM:(NSString *)timeString;
- (NSInteger)fileSize;
-(NSDictionary *)retJsonToDictionary;

+(instancetype)retNSStringToNSdateWithYYYY_MM_DD_HH_MM_SS_WithBeijing:(NSDate *)date;
+(instancetype)retStringFromTimeToyyyyYearMMMonthddDayHHMMSS_haomiao:(NSString *)timeString;

+(instancetype)retStringWithPlatform:(NSString *)baseUrl withPlatform:(NSString *)platform;
+(instancetype)retStringWithHttpsUrl:(NSString *)baseUrl;



//判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string;


-(NSString *)retNetWorkCmdidWithKeyValue;




@end
