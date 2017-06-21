//
//  LTSCalendarAppearance.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LTSCalendarWeekDayFormat) {
    LTSCalendarWeekDayFormatSingle,
    LTSCalendarWeekDayFormatShort,
    LTSCalendarWeekDayFormatFull
};


@interface LTSCalendarAppearance : NSObject

///是否显示农历
@property (nonatomic,assign) BOOL isShowLunarCalender;
///是否显示其他月份
@property (nonatomic, assign) BOOL isShowOtherMonthDay;
///是否显示底部小热点
@property (nonatomic, assign) BOOL isShowHotDotPoint;



@property (nonatomic,assign)CGFloat weekDayHeight;
//day

///  阳历字体大小
@property (nonatomic,strong)UIFont *dayTextFont;

/// 农历字体大小
@property (nonatomic,strong)UIFont *lunarDayTextFont;


///  阳历文本颜色
@property (nonatomic,strong)UIColor *dayTextColor;
///  当天日期颜色
@property (nonatomic,strong)UIColor *currentDayTextColor;
///  当天日期背景颜色
@property (nonatomic,strong)UIColor *currentDayBackgroundColor;


@property (strong,nonatomic)UIColor *dayTextColorSelected;
///  农历文本颜色
@property (nonatomic,strong)UIColor *lunarDayTextColor;
@property (nonatomic,strong)UIColor *lunarDayTextColorSelected;
/// 今天文本颜色
@property (strong, nonatomic) UIColor *dayTextColorToday;

@property (nonatomic,strong)UIColor *lineBgColor;
// 其他月份

/// 其他月份阳历字体大小
@property (nonatomic,strong)UIFont *dayTextFontOtherMonth;
///  其他月份农历字体大小
@property (nonatomic,strong)UIFont *lunarDayTextFontOtherMonth;
///  其他月份阳历文本颜色
@property (nonatomic,strong)UIColor *dayTextColorOtherMonth;
///  其他月份农历文本颜色
@property (nonatomic,strong)UIColor *lunarDayTextColorOtherMonth;


@property (strong, nonatomic) UIColor *dayCircleColorSelected;
@property (nonatomic,strong)  UIColor *dayCircleColorToday;
@property (strong, nonatomic) UIColor *dayBorderColorToday;
/// 有事件 点 的颜色
@property (nonatomic,strong) UIColor *dayDotColor;
@property (nonatomic,strong)UIColor  *dayDotColorSelected;



@property (assign, nonatomic) CGFloat dayCircleSize;

@property (assign, nonatomic) CGFloat dayDotSize;


// Weekday
@property (assign, nonatomic) LTSCalendarWeekDayFormat weekDayFormat;
@property (strong, nonatomic) UIColor *weekDayTextColor;
@property (strong, nonatomic) UIFont *weekDayTextFont;

@property (nonatomic,strong) UIColor *backgroundColor;

- (NSCalendar *)calendar;
- (NSCalendar *)chineseCalendar;

- (void)setDayDotColorForAll:(UIColor *)dotColor;
- (void)setDayTextColorForAll:(UIColor *)textColor;

@end
