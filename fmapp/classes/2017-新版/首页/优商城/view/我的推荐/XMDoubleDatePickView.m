//
//  XMDoubleDatePickView.m
//  UIpick
//
//  Created by runzhiqiu on 15/12/28.
//  Copyright © 2015年 runzhiqiu. All rights reserved.
//
#define KDefauleOriginYear 1970
#define KDefaultFontSize 14
#define KDefaultFontSizeIOS7 10
#define KDefaultwidthForComponent 40
#define KDefaultwidthForComponentIOS7 25
#define KDefaultWidthMidView 26
#define KDefaultWithColor [UIColor colorWithRed:(35.0 / 255) green:(141.0 / 255) blue:(228.0 / 255) alpha:1]
#import "XMDoubleDatePickView.h"

@interface XMDoubleDatePickView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic,strong) UIPickerView * pickViewleft;
@property (nonatomic,strong) UIPickerView * pickViewright;
@property (nonatomic, assign) NSInteger leftDayCountInMonth;
@property (nonatomic, assign) NSInteger rightDayCountInMonth;

@end


@implementation XMDoubleDatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        NSDateComponents *comps = [self todayNSDateComponents];
        self.leftDayCountInMonth = [self createFirstMonthDay:[comps month] with:[comps year]];
        self.rightDayCountInMonth = self.leftDayCountInMonth;
        
        UIPickerView * pickViewleft = [[UIPickerView alloc] init];
        pickViewleft.frame =CGRectMake(0, 0, (self.bounds.size.width - KDefaultWidthMidView ) * 0.48, self.bounds.size.height);
        pickViewleft.delegate = self;
        self.pickViewleft = pickViewleft;
        [self addSubview:pickViewleft];
        [self changeUpPickViewStyle:pickViewleft];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KDefaultWidthMidView, 2)];
        lineView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        lineView.backgroundColor = KDefaultWithColor;
        [self addSubview:lineView];
        
        UIPickerView * pickViewright = [[UIPickerView alloc] init];
        pickViewright.frame =CGRectMake(KDefaultWidthMidView * 0.5 + self.bounds.size.width * 0.5 , 0, (self.bounds.size.width - KDefaultWidthMidView ) * 0.48, self.bounds.size.height);
        pickViewright.delegate = self;
        self.pickViewright = pickViewright;
        [self addSubview:pickViewright];
        [self changeUpPickViewStyle:pickViewright];
        
    }
    return self;
}

-(NSDateComponents *)todayNSDateComponentsWithDate:(NSDate *)date
{
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags =   NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

-(NSDateComponents *)todayNSDateComponents
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags =   NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

-(void)setUpStartTime:(NSDate *)startDate withEndTime:(NSDate *)endDate;
{
    NSDateComponents *startComps = [self todayNSDateComponentsWithDate:startDate];
    
    NSInteger startYear=[startComps year];
    NSInteger startMonth = [startComps month];
    NSInteger startDay = [startComps day];

    NSDateComponents *endComps = [self todayNSDateComponentsWithDate:endDate];
    
    NSInteger endYear=[endComps year];
    NSInteger endMonth = [endComps month];
    NSInteger endDay = [endComps day];
    
    if (self.pickViewType == XMDoubleDatePickViewTypeyyyyMM)
    {
        [self.pickViewleft selectRow:(startYear - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewleft selectRow:(startMonth - 1) inComponent:1 animated:YES];
        
        
        [self.pickViewright selectRow:(endYear - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewright selectRow:(endMonth - 1) inComponent:1 animated:YES];

        
        if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
            [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[NSString stringWithFormat:@"%ld-%02ld",(long)startYear,(long)startMonth] didSelectRowEnd:[NSString stringWithFormat:@"%ld-%02ld",(long)endYear,(long)endMonth]];
        }

        
    }else
    {
        [self.pickViewleft selectRow:(startYear - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewleft selectRow:(startMonth - 1) inComponent:1 animated:YES];
        [self.pickViewleft selectRow:(startDay - 1) inComponent:2 animated:YES];
        
        [self.pickViewright selectRow:(endYear - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewright selectRow:(endMonth - 1) inComponent:1 animated:YES];
        [self.pickViewright selectRow:(endDay - 1) inComponent:2 animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
            [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)startYear,(long)startMonth,(long)startDay] didSelectRowEnd:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)endYear,(long)endMonth,(long)endDay]];
        }

    }

    
   
}

-(void)setUpSelectToday
{
    
    NSDateComponents *comps = [self todayNSDateComponents] ;
    
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    if (self.pickViewType == XMDoubleDatePickViewTypeyyyyMM)
    {
        
        [self.pickViewleft selectRow:(year - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewleft selectRow:(month - 1) inComponent:1 animated:YES];
        
        [self.pickViewright selectRow:(year - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewright selectRow:(month - 1) inComponent:1 animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
            [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[NSString stringWithFormat:@"%ld-%02ld",(long)year,(long)month] didSelectRowEnd:[NSString stringWithFormat:@"%ld-%02ld",(long)year,(long)month]];
        }

    }else
    {
        
        [self.pickViewleft selectRow:(year - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewleft selectRow:(month - 1) inComponent:1 animated:YES];
        [self.pickViewleft selectRow:(day - 1) inComponent:2 animated:YES];
        
        [self.pickViewright selectRow:(year - KDefauleOriginYear) inComponent:0 animated:YES];
        [self.pickViewright selectRow:(month - 1) inComponent:1 animated:YES];
        [self.pickViewright selectRow:(day - 1) inComponent:2 animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
            [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)month,(long)day] didSelectRowEnd:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)month,(long)day]];
        }

    }
    
    
}

-(void)changeUpPickViewStyle:(UIPickerView *)pickView
{
    UIView * viewRightUp = [[UIView alloc]initWithFrame:CGRectMake(0, pickView.frame.size.height * 0.384, pickView.frame.size.width, 1)];
    viewRightUp.backgroundColor = KDefaultWithColor;
    [pickView addSubview:viewRightUp];
    viewRightUp.userInteractionEnabled = YES;
    
    UIView * viewRightDown = [[UIView alloc]initWithFrame:CGRectMake(0, pickView.frame.size.height * 0.620, pickView.frame.size.width, 1)];
    viewRightDown.backgroundColor = KDefaultWithColor;
    [pickView addSubview:viewRightDown];
    viewRightDown.userInteractionEnabled = YES;
    
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if (self.pickViewType == XMDoubleDatePickViewTypeyyyyMM)
    {
        return 2;
    }else
    {
        return 3;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (component == 0) {
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            return KDefaultwidthForComponentIOS7 + 10;
        }
        return KDefaultwidthForComponent + 10;
    }else
    {
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            return KDefaultwidthForComponentIOS7 ;
        }
        return KDefaultwidthForComponent;
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return pickerView.frame.size.height * 0.22;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component == 0) {
        return 100;
    }else if(component == 1)
    {
        return 12;
    }else
    {
        if (pickerView == self.pickViewleft) {
            return self.leftDayCountInMonth;
        }else
        {
            return self.rightDayCountInMonth;
        }
        
    }
}

-(NSString *)zeroToString:(NSString *)string
{
    if (string.length <= 2) {
        return [NSString stringWithFormat:@"0%@",string];
    }
    return string;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    switch (component) {
        case 0:
        {
            UILabel * label;
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponentIOS7 + 10, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSizeIOS7];
                label.text = [NSString stringWithFormat:@"%zi年",KDefauleOriginYear + row];
            }else
            {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponent + 10, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSize];
                label.text = [NSString stringWithFormat:@"%zi年",KDefauleOriginYear + row];
            }
            return label;
        }
            
            break;
        case 1:
        {
            UILabel * label;
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponentIOS7, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSizeIOS7];
                NSString * monthString = [NSString stringWithFormat:@"%02zi月",(1 + row)];
                NSString * zeroMonthString = [self zeroToString:monthString];
                label.text = zeroMonthString;
            }else
            {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponent, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSize];
                NSString * monthString = [NSString stringWithFormat:@"%02zi月",(1 + row)];
                NSString * zeroMonthString = [self zeroToString:monthString];
                label.text = zeroMonthString;
            }
            return label;
            
        }
            
            break;
        case 2:
        {
            UILabel * label;
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponentIOS7, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSizeIOS7];
                NSString * dayString = [NSString stringWithFormat:@"%zi日",(1 + row)];

                NSString * zeroMonthString = [self zeroToString:dayString];
                label.text = zeroMonthString;
            }else
            {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KDefaultwidthForComponent, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:KDefaultFontSize];
                NSString * dayString = [NSString stringWithFormat:@"%zi日",(1 + row)];

                NSString * zeroMonthString = [self zeroToString:dayString];
                label.text = zeroMonthString;
            }
            return label;
            
        }
            
            break;
        default:
            break;
    }
    return nil;
}
-(NSString *)pickViewSelectRow:(UIPickerView *)pickView
{
    if (self.pickViewType == XMDoubleDatePickViewTypeyyyyMM)
    {
        return [NSString stringWithFormat:@"%zi-%02zi",([pickView selectedRowInComponent:0] + KDefauleOriginYear),([pickView selectedRowInComponent:1] + 1)];
    }else
    {
        return [NSString stringWithFormat:@"%zi-%02zi-%02zi",([pickView selectedRowInComponent:0] + KDefauleOriginYear),([pickView selectedRowInComponent:1] + 1),([pickView selectedRowInComponent:2] + 1)];
    }
    
    

}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger yearInteger = [pickerView selectedRowInComponent:0];
    NSInteger monthInteger = [pickerView selectedRowInComponent:1];
    

    switch (monthInteger + 1) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            if (pickerView == self.pickViewleft) {
                self.leftDayCountInMonth = 31;
            }else
            {
                self.rightDayCountInMonth = 31;
            }
            
            if (self.pickViewType != XMDoubleDatePickViewTypeyyyyMM) {
                [pickerView reloadComponent:2];
            }
            
            if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
                [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[self pickViewSelectRow:self.pickViewleft] didSelectRowEnd:[self pickViewSelectRow:self.pickViewright]];
            }
            
            
            return;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            if (pickerView == self.pickViewleft) {
                self.leftDayCountInMonth = 30;
            }else
            {
                self.rightDayCountInMonth = 30;
            }
            if (self.pickViewType != XMDoubleDatePickViewTypeyyyyMM) {
                [pickerView reloadComponent:2];
            }
            
            if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
                [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[self pickViewSelectRow:self.pickViewleft] didSelectRowEnd:[self pickViewSelectRow:self.pickViewright]];
            }
            
            return;
            break;
        case 2:
            
            if ([self bissextile:(yearInteger + KDefauleOriginYear)]) {
                if ((monthInteger + 1) == 2)
                {
                    if (pickerView == self.pickViewleft) {
                        self.leftDayCountInMonth = 29;
                    }else
                    {
                        self.rightDayCountInMonth = 29;
                    }
                    if (self.pickViewType != XMDoubleDatePickViewTypeyyyyMM) {
                         [pickerView reloadComponent:2];
                    }
                    if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
                        [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[self pickViewSelectRow:self.pickViewleft] didSelectRowEnd:[self pickViewSelectRow:self.pickViewright]];
                    }
                    return;
                }
            }else{
                if (pickerView == self.pickViewleft) {
                    self.leftDayCountInMonth = 28;
                }else
                {
                    self.rightDayCountInMonth = 28;
                }
                if (self.pickViewType != XMDoubleDatePickViewTypeyyyyMM) {
                    [pickerView reloadComponent:2];
                };
                if ([self.delegate respondsToSelector:@selector(XMDoubleDatePickView:didSelectRowStart:didSelectRowEnd:)]) {
                    [self.delegate XMDoubleDatePickView:nil didSelectRowStart:[self pickViewSelectRow:self.pickViewleft] didSelectRowEnd:[self pickViewSelectRow:self.pickViewright]];
                }
                return;
            }
            break;
        default:
            break;
    }
}

-(NSInteger )createFirstMonthDay:(NSInteger)month with:(NSInteger)year
{
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            
            
            return 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            
            
            return 30;
            break;
        case 2:
            
            if ([self bissextile:year]) {
                if (month == 2)
                {
                    return 29;
                }
            }else{
                return 28;
            }
            break;
        default:
            break;
    }
    return -1;
}
-(BOOL)bissextile:(NSInteger)year {
    if (((year%4==0) && (year %100 !=0)) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
