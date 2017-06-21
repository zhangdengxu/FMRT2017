//
//  FMTimeKillTableViewSectionHeader.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/8.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultLargeFont 15
#define KDefaultLittleFont 13
#define KDefaultHeaderHeigh 90
#define KdefaultItemWidth (KProjectScreenWidth / 4)

#import "FMTimeKillTableViewSectionHeader.h"
#import "FMTimeKillShopModel.h"

#import "NSDate+CategoryPre.h"
#import "FMTimeKillHeaderItem.h"
#import "Fm_Tools.h"



@interface FMTimeKillTableViewSectionHeader ()

@property (nonatomic, strong) UIImageView * halfKillArea;
@property (nonatomic, strong) UILabel * adsLabel;
@property (nonatomic, strong) UIButton * checkRules;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * miniteLabel;
@property (nonatomic, strong) UIImageView * timeImageView;
@property (nonatomic, strong) UIScrollView * scrollView;



@property (nonatomic, strong) UIView * bottomLineView;

@property (nonatomic,copy) NSString *statusIndex;
@property (nonatomic, strong) NSMutableArray * time_bucket;


@property (nonatomic, strong) NSMutableArray * timeListArray;

@end


@implementation FMTimeKillTableViewSectionHeader

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(KdefaultItemWidth, 38, KdefaultItemWidth * 3, 48)];
        [self.contentView addSubview:_scrollView];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        
        
    }
    return _scrollView;
}

-(NSMutableArray *)time_bucket
{
    if (!_time_bucket) {
        _time_bucket = [NSMutableArray array];
    }
    return _time_bucket;
}
-(NSMutableArray *)timeListArray
{
    if (!_timeListArray) {
        _timeListArray = [NSMutableArray array];
    }
    return _timeListArray;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KDefaultHeaderHeigh);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self tableViewSectionHeaderView];
        //注册通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondReduceOnceWithKillTime:) name:KDefaultSecondReduceOnce object:nil];
    }
    return self;
}


-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    [self contTitleArray];
}

-(void)contTitleArray
{
    
    CGFloat widthItem;
    if (self.titleArray.count > 3) {
        widthItem = ((KProjectScreenWidth - KdefaultItemWidth) / 3);
    }else
    {
        widthItem = ((KProjectScreenWidth - KdefaultItemWidth) / self.titleArray.count);
    }
    
    
    
    NSString * headString = [[NSDate date] retCurrentdateWithYYYY_MM_DD];
    
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];//服务器返回的时间戳；
    
    NSInteger selectIndex = 0;
    
    NSInteger nextDate = 0;
    BOOL isALLWillStart = NO;//是否全部即将开始
    NSInteger firstwillStart = -1;//将要开始的标记
    
     __weak __typeof(&*self)weakSelf = self;
    for (NSInteger index = 0; index < self.titleArray.count; index ++) {
        FMTimeKillHeaderItemModel * model = [[FMTimeKillHeaderItemModel alloc]init];
        model.timeString = self.titleArray[index];
        model.index = index;
        model.status = @"";
        
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        NSInteger delta = [timeZone secondsFromGMT];
//        NSLog(@"%zi",delta);
        NSString * xiaoshi = [NSString stringWithFormat:@"%@ %@:00",headString,model.timeString];
        NSDate * dateTime = [Fm_Tools dateFromDatesssString:xiaoshi];
        NSInteger interNetDate = [dateTime timeIntervalSince1970];//服务器返回的时间戳；
        
       
//        interNetDate = interNetDate + delta;
        //全部即将开始的标记
        
        //数量就一个
        if (self.titleArray.count == 1) {
            if (currentDate < interNetDate) {
                //即将开始（红色）
                model.status = @"12";
                isALLWillStart = YES;
                selectIndex = index;
            }else
            {
                //红色秒杀中
                model.status = @"11";
                selectIndex = index;

                
            }
        }else
        {
            //如果数量为多个的情况。

            
            
            //并且数量为最后一个
            if (index >= (self.titleArray.count - 1)) {
                //最后一个的时间
                nextDate = 0;
                
                if (currentDate < interNetDate) {
                    
                    if (isALLWillStart) {
                        if (firstwillStart == -1) {
                            // 秒杀中（红色）
                            model.status = @"11";
                            firstwillStart = 1;
                            selectIndex = index;

                        }else
                        {
                            // 即将开始（黑色）
                            model.status = @"22";
                        }
                      
                    }else
                    {
                        if (firstwillStart == -1) {
                            // 即将开始（红色）
                             model.status = @"12";
                            selectIndex = index;

                        }else
                        {
                            //黑色即将开始
                            model.status = @"22";
                        }
                    }
                }else
                {
                    //红色秒杀中
                    model.status = @"11";
                    firstwillStart = 1;
                    selectIndex = index;

                }
                
                
            }else
            {
               //非最后一个的情况
                
                //多个的情况
                NSString * xiaoshiNext = [NSString stringWithFormat:@"%@ %@:00",headString,self.titleArray[index + 1]];
                NSDate * dateTimeNext = [Fm_Tools dateFromDatesssString:xiaoshiNext];
                NSInteger interNetDateNext = [dateTimeNext timeIntervalSince1970];//服务器返回的时间戳；
                

                nextDate = interNetDateNext;
                
                
                if (currentDate < interNetDate) {
                    if (index == 0) {
                        isALLWillStart = YES;
                        //黑色等待更新
                        model.status = @"23";
                        
                        
                    }else{
                        
                        if (isALLWillStart) {
                            
                            //黑色即将开始
                            model.status = @"22";
                            
                        }else
                        {
                            if (firstwillStart < 0) {
                                //红色即将开始
                                model.status = @"12";
                                firstwillStart = 1;
                                selectIndex = index;

                            }else
                            {
                                //黑色即将开始
                                model.status = @"22";
                                
                            }
                        }
                        
                        
                    }
                   
                }else if (interNetDate < currentDate && currentDate <nextDate) {
                    //红色秒杀中
                    model.status = @"11";
                    firstwillStart = 1;
                    selectIndex = index;

                }else
                {
                    //次日更新（黑色）
                    model.status = @"24";
                }

                
            }
            
            
        }
        
        
        FMTimeKillHeaderItem * headerItem = [[FMTimeKillHeaderItem alloc]initWithFrame:CGRectMake(index * widthItem, 0, widthItem, self.scrollView.frame.size.height)];
        headerItem.buttonBlock = ^(NSInteger index){
            [weakSelf itemButtonOnClick:index];
        };
        headerItem.timeModel = model;
        [self.scrollView addSubview:headerItem];
        [self.timeListArray addObject:headerItem];
        
    }
    
    
    self.scrollView.contentSize = CGSizeMake(widthItem * self.titleArray.count, self.scrollView.frame.size.height);
    
    [self itemButtonOnClick:selectIndex];
    
}
-(void)itemButtonOnClick:(NSInteger)index
{
    
    for (NSInteger i = 0; i < self.timeListArray.count; i ++) {
        FMTimeKillHeaderItem * headerItem = self.timeListArray[i];
        if (i == index) {
            [headerItem changeRedItem];
        }else
        {
            [headerItem changeBlackItem];
        }
    }
    
    if (self.buttonBlock) {
        self.buttonBlock(50 + index);
    }
}
-(void)tableViewSectionHeaderView
{
    [self adadsLabels];
    [self halfKillArea];
    [self checkRules];
    [self lineView];
    [self miniteLabel];
    
    [self.miniteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        
        make.height.equalTo(24);
    }];
    [self.timeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.miniteLabel.mas_right).offset(5);
        make.centerY.equalTo(self.miniteLabel.mas_centerY);

        make.width.equalTo(10);
        make.height.equalTo(10);
    }];
    
    
    
    [self bottomLineView];
    
}



//-(void)secondReduceOnceWithKillTime:(NSNotification *)notification
//{
//    if (self.time_bucket.count < 3) {
//        return;
//    }
//    NSInteger isChange = 0;
//
//    NSInteger  localHostDate = [[NSDate date] timeIntervalSince1970];
//
//
//    for (FMTimeKillShopSectionHeaderModel * killShopFlag in self.time_bucket) {
//
//        killShopFlag.currentTimeDown ++ ;
//        NSInteger countDownEnd = localHostDate - killShopFlag.startTimeCount - 30 * 60;
//
//        if ((3 > countDownEnd) && (countDownEnd >= 0)) {
//            isChange ++;
//        }
//
//         NSInteger countDownStart = localHostDate - killShopFlag.startTimeCount;
//        if ((3 > countDownStart) && (countDownStart >= 0)) {
//            isChange ++;
//        }
//    }
//
//    if (isChange > 0) {
//        [self changeTitleStatusNOSet];
//        [self changeTitleColor];
//    }
//
//
//}
//-(void)dealloc
//{
//     [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

//-(void)changeTitleStatusNOSet
//{
//    
//    NSString * headString = [[NSDate date] retCurrentdateWithYYYY_MM_DD];
//    NSInteger  localHostDate = [[NSDate date] timeIntervalSince1970];
//    
//    NSInteger endindex = 0;
//    NSInteger startIndex = 0;
//    NSInteger actionIndex = 0;
//    NSDate * xiaoshiDate = [NSDate retNSStringToNSdate:headString];
//    NSInteger  currentDateALL = [xiaoshiDate timeIntervalSince1970] + 24 * 60 * 60;
//    for (FMTimeKillShopSectionHeaderModel * killShopFlag in self.time_bucket) {
//        
//        
//        if (killShopFlag.currentTimeDown < 0) {
//            //时间还没到
//            
//            if (startIndex > 0) {
//                
//                killShopFlag.flag = @"22";
//                
//            }else
//            {
//                if (actionIndex == 0) {
//                    killShopFlag.flag = @"12";
//                }else
//                {
//                    killShopFlag.flag = @"22";
//                }
//                
//            }
//
//            
//            startIndex ++;
//        }else{
//            //时间到了
//            NSInteger thirtyMinuit = localHostDate - (killShopFlag.startTimeCount + 30 * 60);
//            
//            if (thirtyMinuit < 0) {
//                
//                if (actionIndex == 0) {
//                    killShopFlag.flag = @"11";
//                    actionIndex ++;
//                }else
//                {
//                    killShopFlag.flag = @"22";
//                }
//                
//
//            }else
//            {
//                //已结束
//                killShopFlag.flag = @"23";
//                endindex ++;
//                
//            }
//        }
//    }
//    
//    //调用更新页面。
//    
//    if (self.time_bucket.count < 3) {
//        return;
//    }
//    
//    
//    if (endindex == self.time_bucket.count) {
//        
//        if ((currentDateALL - localHostDate) > 0) {
//            //这天已结束；
//            [self changeALLEnd];
//        }else
//        {
//            
//            [self changeAllStart];
//        }
//    }
//
//}

//-(void)changeTitleStatus
//{
//    
//    //获取几月几号的时间，时间格式为2015-02-05
//    NSString * headString = [[NSDate date] retCurrentdateWithYYYY_MM_DD];
//    NSInteger  localHostDate = [[NSDate date] timeIntervalSince1970];
//    
//    
//    
//    NSDate * xiaoshiDate = [NSDate retNSStringToNSdate:headString];
//    NSInteger  currentDateALL = [xiaoshiDate timeIntervalSince1970] + 24 * 60 * 60;
//    
//    NSInteger endindex = 0;
//    NSInteger startIndex = 0;
//    NSInteger actionIndex = 0;
//    for (NSString * str in self.titleArray) {
//        FMTimeKillShopSectionHeaderModel * killShopFlag = [[FMTimeKillShopSectionHeaderModel alloc]init];
//        killShopFlag.timeStr = str;
//        NSString * xiaoshi = [NSString stringWithFormat:@"%@ %@",headString,str];
//        
//        
//        NSDate * dateTime = [NSDate retNSStringToNSdateWithYYYY_MM_DD_HH_MM:xiaoshi];
//        NSInteger interNetDate = [dateTime timeIntervalSince1970];//服务器返回的时间戳；
//        
//        
//        killShopFlag.timeDetail = xiaoshi;
//        killShopFlag.currentTimeDown = localHostDate - interNetDate;
//
//        
//        killShopFlag.startTimeCount = interNetDate;
//        [self.time_bucket  addObject:killShopFlag];
//        
//        if (killShopFlag.currentTimeDown < 0) {
//            //时间还没到
//            
//            if (startIndex > 0) {
//                killShopFlag.flag = @"22";
//            }else
//            {
//                if (actionIndex == 0) {
//                     killShopFlag.flag = @"12";
//                }else
//                {
//                     killShopFlag.flag = @"22";
//                }
//               
//            }
//            
//            startIndex ++;
//            
//           
//        }else{
//            //时间到了
//            NSInteger thirtyMinuit = localHostDate - (interNetDate + 30 * 60);
//            
//            if (thirtyMinuit < 0) {
//                if (actionIndex == 0) {
//                     killShopFlag.flag = @"11";
//                    actionIndex ++;
//                }else
//                {
//                     killShopFlag.flag = @"22";
//                }
//               
//                
//            }else
//            {
//                //已结束
//                killShopFlag.flag = @"23";
//                endindex ++;
//
//            }
//        }
//    }
//    
//    //调用更新页面。
//    
//    if (self.time_bucket.count < 3) {
//        return;
//    }
//    
//    
//    if (endindex == self.time_bucket.count) {
//    
//        if ((currentDateALL - localHostDate) > 0) {
//            //这天已结束；
//            [self changeALLEnd];
//        }else
//        {
//           
//             [self changeAllStart];
//        }
//    }
//}
//
//-(void)changeALLEnd
//{
//    if (self.self.time_bucket.count >= 3) {
//        
//        FMTimeKillShopSectionHeaderModel * headModel1 = self.time_bucket[0];
//        headModel1.flag = @"13";
//        
//        FMTimeKillShopSectionHeaderModel * headModel2 = self.time_bucket[1];
//        headModel2.flag = @"23";
//        
//        FMTimeKillShopSectionHeaderModel * headModel3 = self.time_bucket[2];
//        headModel3.flag = @"23";
//
//    }
//}
//-(void)changeAllStart
//{
//    if (self.self.time_bucket.count >= 3) {
//        FMTimeKillShopSectionHeaderModel * headModel1 = self.time_bucket[0];
//        headModel1.flag = @"12";
//        
//        FMTimeKillShopSectionHeaderModel * headModel2 = self.time_bucket[1];
//        headModel2.flag = @"22";
//        
//        FMTimeKillShopSectionHeaderModel * headModel3 = self.time_bucket[2];
//        headModel3.flag = @"22";
//
//    }
//}
//



//-(void)changeTitleColor
//{
//    if(self.time_bucket.count >=3)
//    {
//        FMTimeKillShopSectionHeaderModel * model1 = self.time_bucket[0];
//        
////        self.firstUpLabel.text = model1.timeStr;
//        
//        FMTimeKillShopSectionHeaderModel * model2 = self.time_bucket[1];
//        
////        self.secondUpLabel.text = model2.timeStr;
//        
//        FMTimeKillShopSectionHeaderModel * model3 = self.time_bucket[2];
////        self.thirdUpLabel.text = model3.timeStr;
//        
//        /**
//         *  改变颜色
//         */
//        NSMutableString * statusMu = [NSMutableString string];
//        
//        for (FMTimeKillShopSectionHeaderModel * model in self.time_bucket) {
//            [statusMu appendString:model.flag];
//        }
//        
//        self.statusIndex = statusMu;
//    }
//
//}


//-(void)setStatusIndex:(NSString *)statusIndex
//{
    //红色为1，黑色为2，
    //秒杀中为1，即将开始为2，次日更新为3
//    _statusIndex = statusIndex;
//    if ([statusIndex isEqualToString:@"112222"]) {
//        
//        //10点秒杀中
//        self.firstDownLabel.text = @"秒杀中";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        
//        self.secondDownLabel.text = @"即将开始";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }else if ([statusIndex isEqualToString:@"231222"])
//    {
//        //12点即将开始
//        self.firstDownLabel.text = @"次日更新";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.secondDownLabel.text = @"即将开始";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }else if ([statusIndex isEqualToString:@"231122"])
//    {
//        //12点已经开始
//        self.firstDownLabel.text = @"次日更新";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.secondDownLabel.text = @"秒杀中";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }else if([statusIndex isEqualToString:@"232312"])
//    {
//        //14点即将开始
//        self.firstDownLabel.text = @"次日更新";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.secondDownLabel.text = @"次日更新";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//    }else if ([statusIndex isEqualToString:@"232311"])
//    {
//        //14点已经开始
//        self.firstDownLabel.text = @"次日更新";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.secondDownLabel.text = @"次日更新";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"秒杀中";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//    }else if([statusIndex isEqualToString:@"132323"])
//    {
//        //14点已经结束
//        self.firstDownLabel.text = @"次日更新";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.secondDownLabel.text = @"次日更新";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"次日更新";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }else if ([statusIndex isEqualToString:@"122323"])
//    {
//        //10点即将开始
//        self.firstDownLabel.text = @"即将开始";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        
//        self.secondDownLabel.text = @"即将开始";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }else
//    {
//        //10点即将开始
//        self.firstDownLabel.text = @"即将开始";
//        self.firstUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        self.firstUpLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        self.firstDownLabel.font = [UIFont systemFontOfSize:KDefaultLargeFont];
//        
//        self.secondDownLabel.text = @"即将开始";
//        self.secondUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.secondDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.secondDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        
//        self.thirdDownLabel.text = @"即将开始";
//        self.thirdUpLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdUpLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//        self.thirdDownLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
//        self.thirdDownLabel.font = [UIFont systemFontOfSize:KDefaultLittleFont];
//    }
    
//}



-(void)checkRulesButtonOnClick:(UIButton *)button
{
    if(self.buttonBlock)
    {
        self.buttonBlock(50 + button.tag);
    }
}


-(void)prepareForReuse
{
    [super prepareForReuse];
}




-(UILabel *)adadsLabels
{
    if (!_adsLabel) {
        _adsLabel = [[UILabel alloc]init];
        _adsLabel.frame = CGRectMake(CGRectGetMaxX(self.halfKillArea.frame) + 15, 0, 100, 38);
        _adsLabel.font = [UIFont systemFontOfSize:14];
        _adsLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        _adsLabel.text = @"先下单先得哦";
        [self.contentView addSubview:_adsLabel];
    }
    return _adsLabel;
}
-(UIButton *)checkRules
{
    if (!_checkRules) {
        _checkRules = [[UIButton alloc]init];
        _checkRules.tag = 446 ;
        _checkRules.frame = CGRectMake(KProjectScreenWidth - 80 - 10, 4, 80, 30);
        [_checkRules setTitle:@"活动规则" forState:UIControlStateNormal];
        [_checkRules setTitleColor:[HXColor colorWithHexString:@"#ff0000"] forState:UIControlStateNormal];
        _checkRules.titleLabel.font = [UIFont systemFontOfSize:13];
        [_checkRules setImage:[UIImage imageNamed:@"活动规则--问号_08"] forState:UIControlStateNormal];
        [_checkRules addTarget:self action:@selector(checkRulesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkRules];
    }
    return _checkRules;
}

-(UIImageView *)halfKillArea
{
    if (!_halfKillArea) {
        _halfKillArea = [[UIImageView alloc]init];
        _halfKillArea.frame = CGRectMake(12, 11.5, 110, 15);
        _halfKillArea.image = [UIImage imageNamed:@"三折秒杀区文字_05"];
        [self.contentView addSubview:_halfKillArea];
        
    }
    return _halfKillArea;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.frame = CGRectMake(0, 38, KProjectScreenWidth, 0.5);
        _lineView.backgroundColor = [UIColor colorWithRed:(225/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}



-(UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.frame = CGRectMake(0, 89.5, KProjectScreenWidth, 0.5);
        _bottomLineView.backgroundColor = [UIColor colorWithRed:(225/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        [self.contentView addSubview:_bottomLineView];
    }
    return _lineView;
}

-(UILabel *)miniteLabel
{
    if (!_miniteLabel) {
        _miniteLabel = [[UILabel alloc]init];
        
        _miniteLabel.font = [UIFont systemFontOfSize:13];
        _miniteLabel.textAlignment = NSTextAlignmentCenter;
        _miniteLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        _miniteLabel.text = @"整点秒杀";
        [self.contentView addSubview:_miniteLabel];
        
    }
    return _miniteLabel;
}


-(UIImageView *)timeImageView
{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]init];
        
        _timeImageView.image = [UIImage imageNamed:@"整点秒杀-闹钟_13"];
        [self.contentView addSubview:_timeImageView];
        
    }
    return _timeImageView;
}



//-(UILabel *)firstUpLabel
//{
//    if (!_firstUpLabel) {
//        _firstUpLabel = [[UILabel alloc]init];
//        _firstUpLabel.textAlignment = NSTextAlignmentCenter;
//        _firstUpLabel.frame = CGRectMake(KdefaultItemWidth, 38 + 5, KdefaultItemWidth, 16);
//        _firstUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        _firstUpLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_firstUpLabel];
//    }
//    return _firstUpLabel;
//}
//-(UILabel *)firstDownLabel
//{
//    if (!_firstDownLabel) {
//        _firstDownLabel = [[UILabel alloc]init];
//        _firstDownLabel.textAlignment = NSTextAlignmentCenter;
//        _firstDownLabel.frame = CGRectMake(KdefaultItemWidth, 38 + 5 + 16, KdefaultItemWidth, 25);
//        _firstDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        //        _firstDownLabel.backgroundColor = [UIColor purpleColor];
//        _firstDownLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_firstDownLabel];
//    }
//    return _firstDownLabel;
//}
//-(UILabel *)secondUpLabel
//{
//    if (!_secondUpLabel) {
//        _secondUpLabel = [[UILabel alloc]init];
//        _secondUpLabel.textAlignment = NSTextAlignmentCenter;
//        _secondUpLabel.frame = CGRectMake(KdefaultItemWidth + KdefaultItemWidth,38 + 5, KdefaultItemWidth, 16);
//        _secondUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        _secondUpLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_secondUpLabel];
//    }
//    return _secondUpLabel;
//}
//-(UILabel *)secondDownLabel
//{
//    if (!_secondDownLabel) {
//        _secondDownLabel = [[UILabel alloc]init];
//        _secondDownLabel.textAlignment = NSTextAlignmentCenter;
//        _secondDownLabel.frame = CGRectMake(KdefaultItemWidth + KdefaultItemWidth, 38 + 5 + 16, KdefaultItemWidth, 25);
//        _secondDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        _secondDownLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_secondDownLabel];
//    }
//    return _secondDownLabel;
//}
//-(UILabel *)thirdUpLabel
//{
//    if (!_thirdUpLabel) {
//        _thirdUpLabel = [[UILabel alloc]init];
//        _thirdUpLabel.textAlignment = NSTextAlignmentCenter;
//        _thirdUpLabel.frame = CGRectMake(KdefaultItemWidth + KdefaultItemWidth + KdefaultItemWidth,38 + 5, KdefaultItemWidth, 18);
//        _thirdUpLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        _thirdUpLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_thirdUpLabel];
//    }
//    return _thirdUpLabel;
//}
//-(UILabel *)thirdDownLabel
//{
//    if (!_thirdDownLabel) {
//        _thirdDownLabel = [[UILabel alloc]init];
//        _thirdDownLabel.textAlignment = NSTextAlignmentCenter;
//        _thirdDownLabel.frame = CGRectMake(KdefaultItemWidth + KdefaultItemWidth + KdefaultItemWidth, 38 + 5 + 16, KdefaultItemWidth, 25);
//        _thirdDownLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
//        _thirdDownLabel.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_thirdDownLabel];
//    }
//    return _thirdDownLabel;
//}
//


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(NSComparisonResult)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: Log(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

@end
