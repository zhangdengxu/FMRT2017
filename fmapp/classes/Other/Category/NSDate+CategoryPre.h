//
//  NSDate+CategoryPre.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CategoryPre)



+(NSString *)getCurrentTime;
+(instancetype)retNSStringToNSdate:(NSString *)dateString;
+(instancetype)retNSStringYYYY_MMToNSdate:(NSString *)dateString;

/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM:(NSString *)dateString;
/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM_Nianyue:(NSString *)dateString;
+(instancetype)retNSStringToNSdateWithYYYY_MM_DD_HH_MM:(NSString *)dateString;
/**
 *  将NSString转化为NSdate新的
 */
+(instancetype)retNSStringToNSdate_New_WithYYYY_MM_DD_HH_MM:(NSString *)dateString;
-(NSString *)retCurrentdateWithYYYY_MMNianyue;



- (NSString *)turnToThisDate;
- (NSString *)turnToThisDateYearAndmonth;
- (NSDate*)nextMonth;
- (NSDate *)lastMonth;
//前一天
- (NSDate*)nextMonthMiddleDay;
//下一天
- (NSDate*)lastMonthMiddleDay;


//date的下个月 返回2014年03月
- (NSString *)nextMonthWithYYYY_MM;
//date的上个月 返回2014年03月
- (NSString *)lastMonthWithYYYY_MM;
/**
 *  之前三个月
 */
- (NSDate *)lastThreeMonth;
/**
 *  之后三个月
 */
- (NSDate*)nextThreeMonth;

/**
 *  最近三月
 */
- (NSDate *)nearByThreeMonth;
/**
 *  最近六个月
 */
- (NSDate*)nextSixMonth;


- (NSString *)turnToThisDateYearAndmonthWithFormat;
- (NSString *)retCurrentTodayInteger;
/**
 *  将日期转化为制定格式
 */
- (NSString *)retCurrentdateWithYYYY_MM_DD;
- (NSString *)retCurrentdateWithYYYY_MM;
- (NSString *)retCurrentdateWithYYYYMMDD;
/**
 *  返回本周从几号到几号
 */
-(NSArray *)retWeekFirstDayAndEndDay;
/**
 *  返回本月从几号到几号
 */
-(NSArray *)retMonthFirstDayAndEndDay;
/**
 *  返回本季从几号到几号
 */
-(NSArray *)retQuarterFirstDayAndEndDay;

/**
 *  返回上季从几号到几号
 */
-(NSArray *)retlastQuarterFirstDayAndEndDay;

/**
 *  返回某一日期的下一季
 */
-(NSArray *)retNextQuarterFirstDayAndEndDayWithStringDate:(NSString *)dateString;

/**
 *  返回某一日期的上一季
 */
-(NSArray *)retlastQuarterFirstDayAndEndDayWithStringDate:(NSString *)dateString;


/**
 *  返回某一日期的上一年
 */
-(NSArray *)retlastYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;

/**
 *  返回某一日期的下一年
 */
-(NSArray *)retNextYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;

/**
 *  返回某一日期的年初和年尾
 */
-(NSArray *)retYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;

/**
 *  获取前一天
 */
-(NSString *)getLastDayWithDayString:(NSString *)dayString;

/**
 *  获取后一天
 */
-(NSString *)getNextDayWithDayString:(NSString *)dayString;

/**
 *  获取前一周从几号到几号
 */
-(NSArray *)getLastWeekWithDayString:(NSString *)dayString;

/**
 *  获取后一周从几号到几号
 */
-(NSArray *)getNextWeekWithDayString:(NSString *)dayString;
-(NSDate *)getNextDayWithDayDate;


/**
 *  获取前一月从几号到几号
 */
-(NSArray *)getLastMonthWithDayString:(NSString *)dayString;

/**
 *  获取后一月从几号到几号
 */
-(NSArray *)getNextMonthWithDayString:(NSString *)dayString;
/**
 *  获取前三月从几号到几号
 */
-(NSArray *)getLastThreeMonthWithDayString:(NSString *)dayString;

/**
 *  获取后三月从几号到几号
 */
-(NSArray *)getNextThreeMonthWithDayString:(NSString *)dayString;


/**
 *  获取前七天从几号到几号
 */
-(NSArray *)getLastSevenDayWithDayString:(NSString *)dayString;

/**
 *  获取后七天从几号到几号
 */
-(NSArray *)getNextSevenDayWithDayString:(NSString *)dayString;

/**
 *  获取前三十天从几号到几号
 */
-(NSArray *)getLastTwentyDayWithDayString:(NSString *)dayString;

/**
 *  获取后三十天从几号到几号
 */
-(NSArray *)getNextTwentyDayWithDayString:(NSString *)dayString;


/**
 *  获取最近三十天从几号到几号，包括今天
 */
-(NSArray *)getLastTwentyDayWithDayStringAndToday:(NSString *)dayString;

/**
 *  获取后N天
 */
-(NSString *)getNextDayWithDayString:(NSString *)dayString withNumDay:(NSInteger)day;

+(NSString *)stringFromdate:(NSDate *)date;

+(NSString *)stringOfCurrentTime;
-(NSString *)turnToThisDateOnlyYearWithFormat;

+(NSString *)stringOfCurrentTimeWithYYYY_MM_DD_HH_MM_SS;
@end
