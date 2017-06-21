//
//  Fm_Tools.m
//  fmapp
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "Fm_Tools.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation Fm_Tools

+(void)registerModeForNotificationWithOptions:(NSDictionary *)launchOptions With:(AppDelegate *)delegate{
    /***极光推送***/
    
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSString * enterpriseVersion = kRecommendPersonNamePhoneNumber;
    
    if (enterpriseVersion.length > 1) {
        //此情况为企业版，无需判断版本。//使用企业版证书
        //Required
        [JPUSHService setupWithOption:launchOptions appKey:@"91c63262d6e36192e1563868"
                              channel:@"Publish channel"
                     apsForProduction:NO
                advertisingIdentifier:nil];
        
    }else{
        //Required
        [JPUSHService setupWithOption:launchOptions appKey:@"9e24de0b7ed8427658548c56"
                              channel:@"Publish channel"
                     apsForProduction:NO
                advertisingIdentifier:nil];
        
    }
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            //            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            //            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

+(void)initUMSocialAndUMTrack {
    
    [MobClick startWithAppkey:kUmengKey];//AppStore
    [UMFeedback setAppkey:kUmengKey];
    [UMOpus setAudioEnable:YES];
    [MobClick checkUpdate];//检查更新
    [MobClick setLogEnabled:NO];//是否打印Log
    
    [UMSocialData setAppKey:kUmengKey];
    
    [UMSocialConfig hiddenNotInstallPlatforms:nil];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWeiXinKey appSecret:KWeiXinAPPSecretKey url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1103554971" appKey:@"qFCyaFUHqVPTa8Fu" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}

+ (UIImage *)QRcodeWithUrlString:(NSString *)urlString {
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSString *dataString = urlString;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    //size大小
    CGFloat size = 300;
    CIImage *image = outputImage;
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

+(UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale {
    UIGraphicsBeginImageContext(image.size);

    const CGFloat whiteSize = 5.f;
    CGSize brinkSize = CGSizeMake(image.size.width / 4, image.size.height / 4);
    CGFloat brinkX = (image.size.width - brinkSize.width) * 0.5;
    CGFloat brinkY = (image.size.height - brinkSize.height) * 0.5;
    
    CGSize imageSize = CGSizeMake(brinkSize.width - 2 * whiteSize, brinkSize.height - 2 * whiteSize);
    CGFloat imageX = brinkX + whiteSize;
    CGFloat imageY = brinkY + whiteSize;
    UIImage * whiteBG = [UIImage imageNamed: @"whiteBG"];

    UIGraphicsBeginImageContext(image.size);
    [image drawInRect: (CGRect){ 0, 0, (image.size) }];
    [whiteBG drawInRect: (CGRect){ brinkX, brinkY, (brinkSize) }];
    [icon drawInRect: (CGRect){ imageX, imageY, (imageSize) }];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+(NSString *)getTimeFromString:(NSString *)time{
    
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSString *)getTotalTimeFromString:(NSString *)time{
    
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSString *)getHourDataFromString:(NSString *)time{
    
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+ (NSDate *)currentDayOfDateWithHour:(NSInteger )hour{
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:hour];
    [dateComponentsForDate setMinute:00];
    
    NSDate *date = [greCalendar dateFromComponents:dateComponentsForDate];
    
    return date;
}

+(NSString *)getTotalTimeWithSecondsFromString:(NSString *)time {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+(NSString *)getYYTotalTimeWithSecondsFromString:(NSString *)time {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSString *)getTheTotalTimeWithSecondsFromString:(NSString *)time{
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSString *)hourTimeWithFromString:(NSString *)time{
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


+(NSString *)getTotalTimeWithString:(NSString *)time andFormatter:(NSString *)formatter {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSDate *)dateFromDateString:(NSString *)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate

    NSDate *date=[formatter dateFromString:time];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return date;
}

+(NSDate *)dateFromDatesssString:(NSString *)time{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:time];
    return date;
}


+ (NSString *)toolsGenerateMillisecondWithYTD:(NSString *)yearToDate dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSDate *dateValue = [formatter dateFromString:yearToDate];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateValue timeIntervalSince1970]];
    return timeSp;
}

+(NSDictionary *)stringCutFromAppdelegateForShareMessageWith:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@"?"];
    
    NSString *flagStr = [array lastObject];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    if ([flagStr rangeOfString:@"&"].location != NSNotFound) {
        
        NSArray *params =[flagStr componentsSeparatedByString:@"&"];
        
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempDic setObject:decodeValue forKey:dicArray[0]];
            }
        }
    }else{
        
        NSArray *dicArray = [flagStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }

    return tempDic;
}


+(NSString *)dateStringFromString:(NSString *)string{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str= [outputFormatter stringFromDate:inputDate];

    return str;
}


+(NSString *)hourStringFromString:(NSString *)string{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *str= [outputFormatter stringFromDate:inputDate];
    
    return str;
}
+(NSString *)YYminStringFromString:(NSString *)string{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str= [outputFormatter stringFromDate:inputDate];
    
    return str;
}

+(NSString *)headerStringFromDate:(NSDate *)date{
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}

+(NSString *)dateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}

+(NSString *)monthDateStringFromDate:(NSDate *)date{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyyMM"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}

+(NSString *)calendarDayDateStringFromDate:(NSDate *)date{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyyMMdd"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}



+(NSString *)yyTimeWithSMMddHHmmFromString:(NSString *)time {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+(NSString *)yyTimeWithSMMddFromString:(NSString *)time {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+(NSString *)yyTimeWithSHHmmFromString:(NSString *)time {
    NSTimeInterval ti=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+(NSString *)calendarMonthStringFromDate:(NSString *)date{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMM"];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy/MM"];
    NSString *str= [outputFormatter stringFromDate:inputDate];

    return str;
}


+(NSString *)calendarScrollDateStringFromDate:(NSDate *)date{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy/MM"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}

+(NSString *)hourMinuteStringFromDate:(NSDate *)date{
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}



@end
