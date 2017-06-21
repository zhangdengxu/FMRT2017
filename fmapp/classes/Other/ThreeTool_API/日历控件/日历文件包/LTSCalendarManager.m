//
//  LTSCalendarManager.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  

#import "LTSCalendarManager.h"
#import "LTSCalendarMonthView.h"
#import "NSDate+CategoryPre.h"
#define NUMBER_PAGES_LOADED 5
@implementation LTSCalendarManager{
    float _lastPosition;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentDate = [NSDate date];
        _calendarAppearance = [LTSCalendarAppearance new];
        _dataCache = [LTSCalendarDataCache new];
        _dataCache.calendarManager = self;
        _currentDateSelected = [NSDate date];
        
               
        
    }
    return self;
}

- (void)setSelectedWeekView:(LTSCalendarSelectedWeekView *)selectedWeekView{
    [_selectedWeekView setDelegate:nil];
    [_selectedWeekView setCalendarManager:nil];
    _selectedWeekView = selectedWeekView;
    
    [_selectedWeekView setDelegate:self];
    [_selectedWeekView setCalendarManager:self];
    
    
    
}
- (void)setContentView:(LTSCalendarContentView *)contentView
{
    
    
//    self.midMonthView = contentView.monthsViews[2];
    
    [_contentView setDelegate:nil];
    [_contentView setCalendarManager:nil];
    
    _contentView = contentView;
    [_contentView setDelegate:self];
    [_contentView setCalendarManager:self];
    
    [self.contentView setCurrentDate:self.currentDate];
    [self.contentView reloadAppearance];
    
    
    
    
}

- (void)setWeekDayView:(LTSCalendarWeekDayView *)weekDayView{
    _weekDayView = weekDayView;
    _weekDayView.calendarManager = self;
}

- (void)reloadData
{
    // Erase cache
    [self.dataCache reloadData];
    
    [self repositionViews];
    [self.contentView reloadData];
}

- (void)reloadAppearance
{
    
    [self.weekDayView reloadAppearance];
    
    [self.contentView reloadAppearance];
    
    [self setCurrentDate:self.currentDate];
    
}
- (void)setCurrentDateSelected:(NSDate *)currentDateSelected{
    
    _currentDateSelected = currentDateSelected;
    
    self.currentSelectedWeekOfMonth = [self getWeekFromDate:currentDateSelected];
    
    [self.eventSource calendarDidDateSelected:self date:currentDateSelected];
   
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate, @"LTSCalendar currentDate cannot be null");
    
    self->_currentDate = currentDate;
    
    [self.contentView setCurrentDate:currentDate];
    
    [self repositionViews];
    //刷新数据
    [self.contentView reloadData];
    
}

- (void)setLastSelectedWeekOfMonth:(NSInteger)lastSelectedWeekOfMonth{
   
    if (lastSelectedWeekOfMonth && _lastSelectedWeekOfMonth) {
       
        [self sendSubviewToMonthViewWithIndex:self.lastSelectedWeekOfMonth];
        [self sendSubviewToSelectedWeekViewWithIndex:lastSelectedWeekOfMonth];
       
        
    }
    
    CGRect frame = self.selectedWeekView.frame;
    frame.size.height = lastSelectedWeekOfMonth *self.calendarAppearance.weekDayHeight;
    self.selectedWeekView.frame = frame;
    _lastSelectedWeekOfMonth = lastSelectedWeekOfMonth;
}
//获取是第几周
- (NSInteger)getWeekFromDate:(NSDate *)date{
    NSDateComponents *comps;
    
    NSInteger weak = [self getNowWeekdayWith:date];
    
    comps = [self.calendarAppearance.calendar components:NSCalendarUnitWeekOfMonth fromDate:date];
    
    
    if (weak == 1) {
        
        comps = [self.calendarAppearance.calendar components:NSCalendarUnitWeekOfMonth fromDate:[date getNextDayWithDayDate]];

    }else
    {
        comps = [self.calendarAppearance.calendar components:NSCalendarUnitWeekOfMonth fromDate:date];
    }
    
    
    
    return comps.weekOfMonth;
    
    
    
}

-(NSInteger)firstDayWeak:(NSDate *)dateNew
{
    NSCalendar*calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents*comps = [calendar components:NSCalendarUnitWeekday fromDate:dateNew];
    
    NSInteger weekday = [comps weekday];
    return weekday;
}



/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
///*
// 获取当前是星期几
- (NSInteger)getNowWeekdayWith:(NSDate *)dateNew {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:dateNew];
    return [comps weekday];
}//*/

- (NSInteger)howManyDaysInThisDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    UIEdgeInsets inset = scrollView.contentOffset;
    if (scrollView == self.selectedWeekView) {
        self.contentView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    }
    else {
       self.selectedWeekView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    }
    
    
    
    
}
//点击滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSDate *currentDate = [self getNewCurrentData];
    if (currentDate) {
        self.currentDateSelected = currentDate;
    }
    
    [self updatePage];
    if (self.eventSource && [self.eventSource respondsToSelector:@selector(calendarDidLoadPage:)]) {
        [self.eventSource calendarDidLoadPage:self];
    }
}
//手指滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    self.currentSelectedWeekView.backgroundColor = [UIColor clearColor];
    //如通过手指滑动更换月份  则默认选中 与当前日期相等的 日子
    NSDate *currentDate = [self getNewCurrentData];
    if (currentDate) {
        self.currentDateSelected = currentDate;
    }
    
    
    [self updatePage];
    
    if (self.eventSource && [self.eventSource respondsToSelector:@selector(calendarDidLoadPage:)]) {
        [self.eventSource calendarDidLoadPage:self];
    }
    
}



- (NSDate *)getNewCurrentData{
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat fractionalPage = self.contentView.contentOffset.x / pageWidth;
    
    int currentPage = roundf(fractionalPage);
    
    if (currentPage == (NUMBER_PAGES_LOADED / 2)){
        self.contentView.scrollEnabled = YES;
        return nil;
    }
    
    NSCalendar *calendar = self.calendarAppearance.calendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    dayComponent.month = 0;
    dayComponent.day = 0;
    dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    
    
    
    
    NSDate *currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    return currentDate;
}
- (void)updatePage
{
   
    NSDate *currentDate = [self getNewCurrentData];
    if (!currentDate) {
        return;
    }
    
    [self setCurrentDate:currentDate];
    
    
   

    
}

- (void)repositionViews
{

    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    _lastPosition = pageWidth * ((NUMBER_PAGES_LOADED / 2));
    self.contentView.contentOffset = CGPointMake(pageWidth * ((NUMBER_PAGES_LOADED / 2)), self.contentView.contentOffset.y);
   
   
   
    self.currentSelectedWeekOfMonth = [self getWeekFromDate:self.currentDateSelected];

   
    //更新位置完成后 要重置 事件视图的View
    
    
}

- (void)loadNextPage
{
   
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
    
}

- (void)loadPreviousPage
{
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}



/// 将序号为多少的WeekView 放到SelectedWeekView 的里面
- (void)sendSubviewToSelectedWeekViewWithIndex:(NSInteger)index{
   [self.contentView sendSubviewToSelectedWeekViewWithIndex:index];
}

/// 将序号为多少的WeekView 放到回到monthView 的里面
- (void)sendSubviewToMonthViewWithIndex:(NSInteger)index{
   [self.contentView sendSubviewToMonthViewWithIndex:index];
}



@end
