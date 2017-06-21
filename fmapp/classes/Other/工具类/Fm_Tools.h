//
//  Fm_Tools.h
//  fmapp
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Fm_Tools : NSObject

/**
 *  类工具友盟实现相关配置
 */
+ (void)initUMSocialAndUMTrack;

/**
 *  消息推送注册方配置
 */
+(void)registerModeForNotificationWithOptions:(NSDictionary *)launchOptions With:(AppDelegate *)delegate;
/**
 *  QR
 *
 *  @param urlString url
 */
+ (UIImage *)QRcodeWithUrlString:(NSString *)urlString;

+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;

/**
 *  获得对应的时间
*/
+ (NSString *)getTimeFromString:(NSString *)time;

+ (NSString *)getTotalTimeFromString:(NSString *)time;
+ (NSString *)getHourDataFromString:(NSString *)time;
+ (NSDate *)currentDayOfDateWithHour:(NSInteger )hour;
+ (NSString *)getTheTotalTimeWithSecondsFromString:(NSString *)time;
+ (NSString *)getTotalTimeWithSecondsFromString:(NSString *)time;
+ (NSDate *)dateFromDateString:(NSString *)time;
+ (NSDate *)dateFromDatesssString:(NSString *)time;
+(NSString *)getYYTotalTimeWithSecondsFromString:(NSString *)time;

+(NSString *)getTotalTimeWithString:(NSString *)time andFormatter:(NSString *)formatter;

// 转换成时间戳
+ (NSString *)toolsGenerateMillisecondWithYTD:(NSString *)yearToDate dateFormat:(NSString *)dateFormat;

/*
 * 截取字符串
 */
+(NSDictionary *)stringCutFromAppdelegateForShareMessageWith:(NSString *)string;

+(NSString *)hourTimeWithFromString:(NSString *)time;

+(NSString *)dateStringFromString:(NSString *)string;
+(NSString *)hourStringFromString:(NSString *)string;
+(NSString *)YYminStringFromString:(NSString *)string;
+(NSString *)headerStringFromDate:(NSDate *)date;
+(NSString *)dateStringFromDate:(NSDate *)date;

+(NSString *)monthDateStringFromDate:(NSDate *)date;
+(NSString *)calendarDayDateStringFromDate:(NSDate *)date;
+(NSString *)yyTimeWithSMMddHHmmFromString:(NSString *)time;
+(NSString *)yyTimeWithSMMddFromString:(NSString *)time;
+(NSString *)yyTimeWithSHHmmFromString:(NSString *)time;
+(NSString *)calendarMonthStringFromDate:(NSString *)date;
+(NSString *)calendarScrollDateStringFromDate:(NSDate *)date;
+(NSString *)hourMinuteStringFromDate:(NSDate *)date;

@end
