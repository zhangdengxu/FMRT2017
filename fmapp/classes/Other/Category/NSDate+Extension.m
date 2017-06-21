//
//  NSDate+Extension.m
//  fmapp
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
static NSDateFormatter *formatter_;
+ (void)load
{
    formatter_ = [[NSDateFormatter alloc] init];
}

/**
 *  获得跟当前时间（now）的差值
 */
- (NSDateComponents *)intervalToNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
@end
