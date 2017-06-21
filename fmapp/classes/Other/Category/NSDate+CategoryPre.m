//
//  NSDate+CategoryPre.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "NSDate+CategoryPre.h"

@implementation NSDate (CategoryPre)



- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}
-(NSString *)turnToThisDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}
-(NSString *)turnToThisDateYearAndmonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

-(NSString *)turnToThisDateYearAndmonthWithFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

- (NSDate *)lastMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nearByThreeMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -2;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate *)lastThreeMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -3;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate*)nextMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate*)nextMonthMiddleDay
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate*)lastMonthMiddleDay
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSString *)nextMonthWithYYYY_MM;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return [newDate retCurrentdateWithYYYY_MMNianyue];

}
- (NSString *)lastMonthWithYYYY_MM;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return [newDate retCurrentdateWithYYYY_MMNianyue];

}

- (NSDate*)nextThreeMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +3;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate*)nextSixMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +5;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
-(NSString *)retCurrentTodayInteger
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return [destDateString substringFromIndex:8];
}
-(NSString *)retCurrentdateWithYYYY_MM_DD
{
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:localzone];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}

-(NSString *)retCurrentdateWithYYYY_MMNianyue
{
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    [dateFormatter setTimeZone:localzone];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}
-(NSString *)retCurrentdateWithYYYYMMDD
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}
-(NSString *)retCurrentdateWithYYYY_MM
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}

+(NSString *)getCurrentTime {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式 HH:mm:ss
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdate:(NSString *)dateString
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateret = [dateFormat dateFromString:dateString];
    return dateret;
    
}
/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringYYYY_MMToNSdate:(NSString *)dateString
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月"];
    return  [dateFormat dateFromString:dateString];
    
}

/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM_DD_HH_MM:(NSString *)dateString
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    [dateFormatter setTimeZone:localzone];
    
    return  [dateFormatter dateFromString:dateString];
    
}

/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdate_New_WithYYYY_MM_DD_HH_MM:(NSString *)dateString
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:localzone];
    
    return  [dateFormatter dateFromString:dateString];
    
}

/**
 *  将NSString转化为NSdate
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM:(NSString *)dateString
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    return  [dateFormat dateFromString:dateString];
    
}
/**
 *  将NSString转化为NSdate ----只在日期控件中使用---唯一性
 */
+(instancetype)retNSStringToNSdateWithYYYY_MM_Nianyue:(NSString *)dateString
{
    dateString = [NSString stringWithFormat:@"%@03日",dateString];
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
    [NSTimeZone setAbbreviationDictionary:abbs];
    

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];
    return  [dateFormat dateFromString:dateString];
    
}

/**
 *  返回本月从几号到几号
 */
-(NSArray *)retMonthFirstDayAndEndDay;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    [firstDayComp setDay:1];
    
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    [lastDayComp setDay:range.length];
    
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSString * firstDayOfMonth = [firstDayOfWeek retCurrentdateWithYYYY_MM_DD];
    NSString * lastDayOfMonth = [lastDayOfWeek retCurrentdateWithYYYY_MM_DD];
    
    return @[firstDayOfMonth,lastDayOfMonth];
    
}


/**
 *  返回本季从几号到几号
 */
-(NSArray *)retQuarterFirstDayAndEndDay;
{
    NSString * currentYearMonthDay = [self retCurrentdateWithYYYY_MM_DD];
    
    NSArray *dateArray = [currentYearMonthDay componentsSeparatedByString:@"-"];
    NSString * currentYear = dateArray[0];
    NSInteger currentMonth = [dateArray[1] integerValue];
    
    if (currentMonth == 1||currentMonth == 2||currentMonth == 3) {
        return [self retSwitchQuarterFirstDayAndEndDay:1 WithYear:currentYear];
    }else if (currentMonth == 4||currentMonth == 5||currentMonth == 6)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:2 WithYear:currentYear];
    }else if(currentMonth == 7||currentMonth == 8||currentMonth == 9)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:3 WithYear:currentYear];
    }else
    {
        return [self retSwitchQuarterFirstDayAndEndDay:4 WithYear:currentYear];
    }
}

/**
 *  返回某一日期的下一季
 */
-(NSArray *)retNextQuarterFirstDayAndEndDayWithStringDate:(NSString *)dateString;
{
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSInteger  month = [dateArray[1] integerValue];
    NSInteger year = [dateArray[0] integerValue];
    if ((month + 3) > 12) {
        year = year + 1;
        month = (month + 3) - 12;
    }else
    {
        month = month + 3;
    }
    
    NSString * currentYear = [NSString stringWithFormat:@"%zi",year];
    
    NSInteger currentMonth = month;
    
    if (currentMonth == 1||currentMonth == 2||currentMonth == 3) {
        return [self retSwitchQuarterFirstDayAndEndDay:1 WithYear:currentYear];
    }else if (currentMonth == 4||currentMonth == 5||currentMonth == 6)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:2 WithYear:currentYear];
    }else if(currentMonth == 7||currentMonth == 8||currentMonth == 9)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:3 WithYear:currentYear];
    }else
    {
        return [self retSwitchQuarterFirstDayAndEndDay:4 WithYear:currentYear];
    }
    
}



/**
 *  返回某一日期的上一季
 */
-(NSArray *)retlastQuarterFirstDayAndEndDayWithStringDate:(NSString *)dateString;
{
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSInteger  month = [dateArray[1] integerValue];
    NSInteger year = [dateArray[0] integerValue];
    if ((month - 3) < 0) {
        year = year - 1;
        month = 12 + (month - 3);
    }else
    {
        month = month - 3;
    }
    
    NSString * currentYear = [NSString stringWithFormat:@"%zi",year];
    
    NSInteger currentMonth = month;
    
    if (currentMonth == 1||currentMonth == 2||currentMonth == 3) {
        return [self retSwitchQuarterFirstDayAndEndDay:1 WithYear:currentYear];
    }else if (currentMonth == 4||currentMonth == 5||currentMonth == 6)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:2 WithYear:currentYear];
    }else if(currentMonth == 7||currentMonth == 8||currentMonth == 9)
    {
        return [self retSwitchQuarterFirstDayAndEndDay:3 WithYear:currentYear];
    }else
    {
        return [self retSwitchQuarterFirstDayAndEndDay:4 WithYear:currentYear];
    }
    
}


/**
 *  返回NSdate的上季从几号到几号
 */
-(NSArray *)retlastQuarterFirstDayAndEndDay;
{
    NSString * currentYearMonthDay = [self retCurrentdateWithYYYY_MM_DD];
    return  [self retlastQuarterFirstDayAndEndDayWithStringDate:currentYearMonthDay];
    
}
-(NSArray *)retSwitchQuarterFirstDayAndEndDay:(NSInteger)index WithYear:(NSString *)year;
{
    
    if (index == 1) {
        return @[[NSString stringWithFormat:@"%@-01-01",year],[NSString stringWithFormat:@"%@-03-31",year]];
    }else if(index == 2){
        return @[[NSString stringWithFormat:@"%@-04-01",year],[NSString stringWithFormat:@"%@-06-30",year]];
    }else if(index == 3){
        return @[[NSString stringWithFormat:@"%@-07-01",year],[NSString stringWithFormat:@"%@-09-30",year]];;
    }else {
        return @[[NSString stringWithFormat:@"%@-10-01",year],[NSString stringWithFormat:@"%@-12-31",year]];
    }
}


/**
 *  返回本周从几号到几号
 */
-(NSArray *)retWeekFirstDayAndEndDay;
{
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:self];
    /*本周*/
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [dateComponents weekday];
    // 得到几号
    NSInteger day = [dateComponents day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        
        firstDiff = [greCalendar firstWeekday] - weekDay + 1;
        lastDiff = 9 - weekDay - 1;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    
    NSDateComponents *firstDayComp = [greCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [greCalendar dateFromComponents:firstDayComp];
    NSString *firstDayOfWeekString = [firstDayOfWeek retCurrentdateWithYYYY_MM_DD];
    
    
    
    NSDateComponents *lastDayComp = [greCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [greCalendar dateFromComponents:lastDayComp];
    NSString *lastDayOfWeekString = [lastDayOfWeek retCurrentdateWithYYYY_MM_DD];
    
    return @[firstDayOfWeekString,lastDayOfWeekString];
    
}
/**
 *  返回某一日期的年初和年尾
 */
-(NSArray *)retYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;
{
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    return [self retYearStartAndEndDayWithYear:[dateArray[0] integerValue]];
    
}

-(NSArray *)retYearStartAndEndDayWithYear:(NSInteger)year
{
    
    return @[[NSString stringWithFormat:@"%zi-01-01",year],[NSString stringWithFormat:@"%zi-12-31",year]];
}


/**
 *  返回某一日期的上一年
 */
-(NSArray *)retlastYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;
{
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSInteger year = [dateArray[0] integerValue] - 1;
    return [self retYearStartAndEndDayWithYear:year];
}

/**
 *  返回某一日期的下一年
 */
-(NSArray *)retNextYearFirstDayAndEndDayWithStringDate:(NSString *)dateString;
{
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSInteger year = [dateArray[0] integerValue] + 1;
    return [self retYearStartAndEndDayWithYear:year];
}


/**
 *  获取前一天
 */
-(NSString *)getLastDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate * dateLeft = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:currentDateLeft];//前一天
    return [dateLeft retCurrentdateWithYYYY_MM_DD];
}
/**
 *  获取后一天
 */
-(NSString *)getNextDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate * dateLeft = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:currentDateLeft];//后一天
    return [dateLeft retCurrentdateWithYYYY_MM_DD];
}

-(NSDate *)getNextDayWithDayDate;
{
    NSDate * dateLeft = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:self];//后一天
    return dateLeft;
}
/**
 *  获取后N天
 */
-(NSString *)getNextDayWithDayString:(NSString *)dayString withNumDay:(NSInteger)day;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate * dateLeft = [NSDate dateWithTimeInterval:24 * 60 * 60 * day sinceDate:currentDateLeft];//后一天
    return [dateLeft retCurrentdateWithYYYY_MM_DD];
}

/**
 *  获取前一周
 */
-(NSArray *)getLastWeekWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate *lastWeek = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 7 sinceDate:currentDateLeft];//前一周
    return [lastWeek retWeekFirstDayAndEndDay];
    
}

/**
 *  获取后一周
 */
-(NSArray *)getNextWeekWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate *lastWeek = [NSDate dateWithTimeInterval:24 * 60 * 60 * 7 sinceDate:currentDateLeft];//前一周
    return [lastWeek retWeekFirstDayAndEndDay];
}


/**
 *  获取前一月从几号到几号
 */
-(NSArray *)getLastMonthWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate * lastMonth = [currentDateLeft lastMonth];
    return [lastMonth retMonthFirstDayAndEndDay];
    
}

/**
 *  获取后一月从几号到几号
 */
-(NSArray *)getNextMonthWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate * lastMonth = [currentDateLeft nextMonth];
    return [lastMonth retMonthFirstDayAndEndDay];
}



/**
 *  获取前三月从几号到几号
 */
-(NSArray *)getLastThreeMonthWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    //最近三个月
    NSArray * dateArray = [[currentDateLeft lastThreeMonth] retMonthFirstDayAndEndDay];
    NSArray * currentMonthArray = [[currentDateLeft lastMonth] retMonthFirstDayAndEndDay];
    
    return @[dateArray[0],currentMonthArray[1]];
    
}

/**
 *  获取后三月从几号到几号
 */
-(NSArray *)getNextThreeMonthWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    //最近三个月
    NSArray * dateArray = [[currentDateLeft nextThreeMonth] retMonthFirstDayAndEndDay];
    NSArray * currentMonthArray = [[currentDateLeft nextSixMonth] retMonthFirstDayAndEndDay];
    return @[dateArray[0],currentMonthArray[1]];
}


/**
 *  获取前七天从几号到几号
 */
-(NSArray *)getLastSevenDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 7 sinceDate:currentDateLeft];//前一天
    
    NSDate *lastWeek = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 1 sinceDate:currentDateLeft];//前一周
    
    return @[[lastDay retCurrentdateWithYYYY_MM_DD],[lastWeek retCurrentdateWithYYYY_MM_DD]];
}

/**
 *  获取后七天从几号到几号
 */
-(NSArray *)getNextSevenDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24 * 60 * 60 * 7 sinceDate:currentDateLeft];//后一天
    NSDate *nextWeek = [NSDate dateWithTimeInterval:24 * 60 * 60 * 13 sinceDate:currentDateLeft];//后一周
    
    return @[[nextDay retCurrentdateWithYYYY_MM_DD],[nextWeek retCurrentdateWithYYYY_MM_DD]];
}

/**
 *  获取前三十天从几号到几号
 */
-(NSArray *)getLastTwentyDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 1 sinceDate:currentDateLeft];//前一天
    NSDate *lastWeek = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 30 sinceDate:currentDateLeft];//前三十天
    
    return @[[lastWeek retCurrentdateWithYYYY_MM_DD],[lastDay retCurrentdateWithYYYY_MM_DD]];
}

/**
 *  获取后三十天从几号到几号
 */
-(NSArray *)getNextTwentyDayWithDayString:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    NSDate *lastDay = [NSDate dateWithTimeInterval:24 * 60 * 60 * 30 sinceDate:currentDateLeft];//后一天
    NSDate *nextWeek = [NSDate dateWithTimeInterval:24 * 60 * 60 * 59 sinceDate:currentDateLeft];//后三十天
    
    return @[[lastDay retCurrentdateWithYYYY_MM_DD],[nextWeek retCurrentdateWithYYYY_MM_DD]];
}

+(NSString *)stringFromdate:(NSDate *)date{
    
    NSDate *selectedDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    return dateString;
}

+(NSString *)stringOfCurrentTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+(NSString *)stringOfCurrentTimeWithYYYY_MM_DD_HH_MM_SS;
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


-(NSString *)turnToThisDateOnlyYearWithFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}



/**
 *  获取最近三十天从几号到几号，包括今天
 */
-(NSArray *)getLastTwentyDayWithDayStringAndToday:(NSString *)dayString;
{
    NSDate * currentDateLeft = [NSDate retNSStringToNSdate:dayString];
    
    NSDate *lastWeek = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 30 sinceDate:currentDateLeft];//前三十天
    
    return @[[lastWeek retCurrentdateWithYYYY_MM_DD],[currentDateLeft retCurrentdateWithYYYY_MM_DD]];
}
@end
