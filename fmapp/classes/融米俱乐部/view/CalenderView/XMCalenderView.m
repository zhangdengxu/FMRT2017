//
//  XMCalenderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultDayInMonth 42
#define KDefaultCalenderCell @"XMCalenderCellMonthIdent"
#import "XMCalenderView.h"
#import "XMCalenderCellMonth.h"
#import "XMCalenderModel.h"
#import "NSDate+CategoryPre.h"

@interface XMCalenderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,XMCalenderCellMonthDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, weak)  UIPageControl * pageController;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, strong) NSArray * lastArray;
@property (nonatomic, strong) NSArray * currentArray;
@property (nonatomic, strong) NSArray * nextArray;
@property (nonatomic, assign) NSInteger presentMonth;
@property (nonatomic, assign) NSInteger presentDayNum;

@end

@implementation XMCalenderView


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        NSString * lastTime = [[self lastMonth:[NSDate date]] turnToThisDateYearAndmonthWithFormat];
        NSString * currentTime = [[NSDate date] turnToThisDateYearAndmonthWithFormat];
        NSString * nextTime = [[self nextMonth:[NSDate date]]turnToThisDateYearAndmonthWithFormat];
        
        NSString * currentMonth = [NSString stringWithFormat:@"%d",[self.titleArray[1] intValue]];
        NSString * nextMonth = [NSString stringWithFormat:@"%d",[self.titleArray[2] intValue]];
        
        _dataSource = [NSMutableArray array];
        
        
        /**
         *  先加载头一个月
         */
        [_dataSource addObject:[self createDataSource:[self lastMonth:[NSDate date]] withSignArray:self.lastArray isCurrentDay:0 withPresentDay:0 withMonth:lastTime]];
        /**
         *  再加载本月
         */
        if (self.presentMonth == [currentMonth integerValue]) {
            [_dataSource addObject:[self createDataSource:[NSDate date] withSignArray:self.currentArray isCurrentDay:[[[NSDate date] retCurrentTodayInteger] integerValue]withPresentDay:self.presentDayNum withMonth:currentTime]];
        }else
        {
            [_dataSource addObject:[self createDataSource:[NSDate date] withSignArray:self.currentArray isCurrentDay:[[[NSDate date] retCurrentTodayInteger] integerValue]withPresentDay:0 withMonth:currentTime]];
        }
        
        /**
         *  最后加载下个月
         */
        if (self.presentMonth == [nextMonth integerValue]) {
            [_dataSource addObject:[self createDataSource:[self nextMonth:[NSDate date]]withSignArray:self.nextArray isCurrentDay:0 withPresentDay:self.presentDayNum withMonth:nextTime]];
        }else
        {
            [_dataSource addObject:[self createDataSource:[self nextMonth:[NSDate date]]withSignArray:self.nextArray isCurrentDay:0 withPresentDay:0 withMonth:nextTime]];
        }
        
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
}
-(void)contuePresentDay
{
    //2016-03-16
    if (self.presentDay) {
        self.presentMonth = [[self.presentDay substringWithRange:NSMakeRange(5, 2)] integerValue];
        self.presentDayNum = [[self.presentDay substringWithRange:NSMakeRange(8, 2)] integerValue];
    }else
    {
        self.presentMonth = 0;
        self.presentDayNum = 0;
    }
}
-(void)setDataDict:(NSArray *)dataDict
{
    _dataDict = dataDict;
    
    [self contuePresentDay];
    
    [self setUpAllArray];
    
    [self createCollectionView];
    [self createPageController];
}
-(void)setUpAllArray
{
//    NSLog(@"%@",self.dataDict);
    
    NSString * lastMonth = [NSString stringWithFormat:@"%d",[self.titleArray[0] intValue]];
    NSArray * lastMonthArray;
    for (NSDictionary * first in self.dataDict) {
        if ([first[@"monthNum"] integerValue] == [lastMonth integerValue]) {
            lastMonthArray = first[@"listMonth"];
            break;
        }
    }
    
//    if (self.dataDict.count <= 0) {
//        return;
//    }
//    
//    NSDictionary * monthList0 = self.dataDict[0];
//    NSArray * lastMonthArray = monthList0[@"listMonth"];
    
    self.lastArray = [lastMonthArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        NSInteger first = [obj1[@"day"] integerValue];
        NSInteger second = [obj2[@"day"] integerValue];
        if (first > second) {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
        
    }];
    
//    if (self.dataDict.count <= 1) {
//        return;
//    }
    
    NSArray * currentMonthArray;
    NSString * currentMonth = [NSString stringWithFormat:@"%d",[self.titleArray[1] intValue]];
    
    for (NSDictionary * first in self.dataDict) {
        if ([first[@"monthNum"] integerValue] == [currentMonth integerValue]) {
            currentMonthArray = first[@"listMonth"];
            break;
        }
    }
    
//    NSDictionary * monthList1 = self.dataDict[1];
//    NSArray * currentMonthArray = monthList1[@"listMonth"];
    self.currentArray = [currentMonthArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        NSInteger first = [obj1[@"day"] integerValue];
        NSInteger second = [obj2[@"day"] integerValue];
        if (first > second) {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
        
    }];
//    NSLog(@"%@",self.currentArray);
//    if (self.dataDict.count <= 2) {
//        return;
//    }
    
    NSString * nextMonth = [NSString stringWithFormat:@"%d",[self.titleArray[2] intValue]];
    NSArray * nextMonthArray;
    for (NSDictionary * first in self.dataDict) {
        if ([first[@"monthNum"] integerValue] == [nextMonth integerValue]) {
            nextMonthArray = first[@"listMonth"];
            break;
        }
    }
//    NSDictionary * monthList2 = self.dataDict[2];
//    NSArray * nextMonthArray = monthList2[@"listMonth"];
    self.nextArray = [nextMonthArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        NSInteger first = [obj1[@"day"] integerValue];
        NSInteger second = [obj2[@"day"] integerValue];
        if (first > second) {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
        
    }];
    //    NSLog(@"%@",self.currentArray);
    
}

-(void)createCollectionView
{
    CGRect rect = CGRectMake(0,0 , self.frame.size.width, self.frame.size.height );
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionLayout.minimumLineSpacing = 0.0;//行间距(最小值)
    collectionLayout.minimumInteritemSpacing = 0.0;//item间距(最小值)
    collectionLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView * collection = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:collectionLayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = KDefaultOrBackgroundColor;
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    collection.alwaysBounceVertical = YES;
    [collection registerNib:[UINib nibWithNibName:@"XMCalenderCellMonth" bundle:nil] forCellWithReuseIdentifier:KDefaultCalenderCell];
    self.contentCollect = collection;
    collection.pagingEnabled = YES;
    collection.bounces = NO;
    collection.showsHorizontalScrollIndicator = NO;
    collection.showsVerticalScrollIndicator = NO;
    [self addSubview:collection];
}

-(void)createPageController
{
    UIPageControl * pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 20, 100, 15)];
    pageController.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 20);
    pageController.numberOfPages = 3;
    pageController.currentPage = 0;
    //    [pageController addTarget:self action:@selector(pageControllerValueChange:) forControlEvents:UIControlEventValueChanged];
    pageController.pageIndicatorTintColor = [UIColor whiteColor];
    pageController.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageController = pageController;
    [self addSubview:pageController];
}
-(void)showCurrentMonth;
{
    self.contentCollect.contentOffset = CGPointMake(self.frame.size.width, 0);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageFloat = scrollView.contentOffset.x / self.frame.size.width;
    int currentPage = (int)(pageFloat + 0.5);
    if (self.lastPage == currentPage) {
        return;
    }
    self.pageController.currentPage = currentPage;
    self.lastPage = currentPage;
    [self pageControllerValueChange:self.pageController];
}
-(void)pageControllerValueChange:(UIPageControl *)pageControl
{
    NSString * currentMonth;
    switch (pageControl.currentPage) {
        case 0:
        {
            currentMonth = [[self lastMonth:[NSDate date]] turnToThisDateYearAndmonth];
        }
            break;
        case 1:
        {
            
            currentMonth = [[NSDate date] turnToThisDateYearAndmonth];
        }
            break;
        case 2:
        {
            currentMonth = [[self nextMonth:[NSDate date]] turnToThisDateYearAndmonth];
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(XMCalenderViewDidSelectMonth:withMonthAndYear:)]) {
        [self.delegate XMCalenderViewDidSelectMonth:self withMonthAndYear:currentMonth];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"%zi",self.dataSource.count);
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCalenderCellMonth * cell = (XMCalenderCellMonth *) [collectionView dequeueReusableCellWithReuseIdentifier:KDefaultCalenderCell forIndexPath:indexPath];
    cell.sizeCell = CGSizeMake(self.frame.size.width, self.frame.size.width);
    cell.delegate = self;
    cell.dataSource = self.dataSource[indexPath.item];
    return cell;
}
/**
 *  选中某一项后的代理方法，需要在此处做一些处理
 */
-(void)XMCalenderCellMonthDidSelectItem:(XMCalenderCellMonth *)calenderCell withModel:(XMCalenderModel *)model;
{
//    if (model.isShowRepairSignIn) {
        if ([self.delegate respondsToSelector:@selector(XMCalenderViewDidSelectItem:withModel:withCalenderCell:)]) {
            [self.delegate XMCalenderViewDidSelectItem:self withModel:model withCalenderCell:calenderCell];
        }
//    }r
    
}

-(NSMutableArray *)createDataSource:(NSDate *)date withSignArray:(NSArray *)signArray isCurrentDay:(NSInteger)currentDay withPresentDay:(NSInteger)presentDay withMonth:(NSString *)month
{
    NSInteger oldDay = 0;
    
    NSInteger daysInThisMonth = [self totaldaysInMonth:date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:date];
    NSMutableArray * dataArray = [NSMutableArray array];
    NSInteger firstItem = 0;
    for (int i = 0; i < KDefaultDayInMonth; i++) {
        
        XMCalenderModel * model = [[XMCalenderModel alloc]init];
        NSInteger day = 0;
        if (i < firstWeekday) {
            model.isShowbackImage = NO;
            model.isShowOldMark = NO;
            model.isShowRepairSignIn = NO;
            model.isShowPresentBox = NO;
        }else if(i > firstWeekday + daysInThisMonth - 1)
        {
            model.isShowbackImage = NO;
            model.isShowOldMark = NO;
            model.isShowRepairSignIn = NO;
            model.isShowPresentBox = NO;
        }else
        {
            /**
             *  正确存在日期的地方
             */
            day = i - firstWeekday + 1;
            NSDictionary * dict;
            if (firstItem >= signArray.count) {
                dict = signArray[0];
            }else{
                dict = signArray[firstItem];
            }
            if (dict) {
                
                while (oldDay == [dict[@"day"] integerValue]) {
                    firstItem ++;
                    
                    if (firstItem >= signArray.count) {
                        dict = nil;
                    }else{
                        dict = signArray[firstItem];
                    }
                    
                }
                if (day ==[dict[@"day"] integerValue]) {
                    oldDay = [dict[@"day"] integerValue];
                }
                
            }
//            
//            NSLog(@"%zi == %zi   ==>%zi",day,[dict[@"day"] integerValue],oldDay);
            
            if (day == [dict[@"day"] integerValue]) {
                firstItem ++;
                NSNumber * type = dict[@"buqian"];
                if ([type integerValue] == 1) {
                    //1  补签
                    model.isShowOldMark = NO;
                    model.isShowRepairSignIn = YES;
                    model.isShowPresentBox = NO;
                }else
                {
                    //正常签到
                    model.isShowOldMark = YES;
                    model.isShowRepairSignIn = NO;
                    model.isShowPresentBox = NO;
                }
                
            }else
            {
                
                
                model.isShowOldMark = NO;
                model.isShowRepairSignIn = NO;
                model.isShowPresentBox = NO;
            }
            /**
             *  是否显示背景（是否是当天）
             */
            if (currentDay != 0) {
                if(currentDay == day)
                {
                    model.isShowbackImage = YES;
                }else
                {
                    model.isShowbackImage = NO;
                }
            }else
            {
                model.isShowbackImage = NO;
            }
            
            /**
             *  是否显示礼物
             */
            if (presentDay == day) {
                model.isShowPresentBox = YES;
            }
            model.currentTime = month;
            model.dayNumber = [NSNumber numberWithInteger:day];
        }
        [dataArray addObject:model];
    }
    return dataArray;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


@end
