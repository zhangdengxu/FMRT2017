//
//  XMAlertTimeView.m
//  UIpick
//
//  Created by runzhiqiu on 15/12/28.
//  Copyright © 2015年 runzhiqiu. All rights reserved.
//
#define KDefaultWithColor [UIColor colorWithRed:(35.0 / 255) green:(141.0 / 255) blue:(228.0 / 255) alpha:1]
#define KBlackWithColor [HXColor colorWithHexString:@"#1e1e1e"]
#import "XMAlertTimeView.h"
#import "XMDoubleDatePickView.h"

#import "NSDate+CategoryPre.h"
#import "Fm_Tools.h"

#define KDefaultMargionWidth 20
#define KDefaultShowViewHeight 230
@interface XMAlertTimeView ()<XMDoubleDatePickViewDelegate>
@property (nonatomic, weak) UIButton * backgroundView;
@property (strong, nonatomic)  UIView *contentView;
@property (nonatomic, copy) NSString * resultString;
@property (nonatomic,strong) UIView * showView;
@end

@implementation XMAlertTimeView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
       
        
        _showView = [[UIView alloc]initWithFrame:CGRectMake(KDefaultMargionWidth, 0, [UIScreen mainScreen].bounds.size.width - KDefaultMargionWidth * 2, KDefaultShowViewHeight)];
        [self addSubview:_showView];
        _showView.backgroundColor = [UIColor whiteColor];
        _showView.layer.cornerRadius = 5;

        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, _showView.frame.size.width, 30)];
        title.text = @"日期";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = KDefaultWithColor;
        [_showView addSubview:title];
        self.title = title;
        
        UIView * viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 37, _showView.frame.size.width, 1)];
        viewLine1.backgroundColor = KDefaultWithColor;
        [_showView addSubview:viewLine1];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(5, 38, _showView.frame.size.width - 10, 150)];
        [_showView addSubview:_contentView];
        
        UIView * viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 190, _showView.frame.size.width, 1)];
        viewLine2.backgroundColor = KDefaultWithColor;
        [_showView addSubview:viewLine2];
        
        UIButton * buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 195, _showView.frame.size.width * 0.5 - 1, 35)];
        [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [buttonCancel setTitleColor:KBlackWithColor forState:UIControlStateNormal];
        [buttonCancel addTarget:self action:@selector(buttonCancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:buttonCancel];

        
        UIView * viewLine3 = [[UIView alloc]initWithFrame:CGRectMake(_showView.frame.size.width * 0.5 - 1, 195, 1, 30)];
        viewLine3.backgroundColor = KDefaultWithColor;
        [_showView addSubview:viewLine3];
        
        
        UIButton * buttonDetermine = [[UIButton alloc]initWithFrame:CGRectMake(_showView.frame.size.width * 0.5, 195, _showView.frame.size.width * 0.5, 35)];
        [buttonDetermine setTitle:@"确定" forState:UIControlStateNormal];
        [buttonDetermine setTitleColor:KBlackWithColor forState:UIControlStateNormal];
        [buttonDetermine addTarget:self action:@selector(buttonDetermineOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:buttonDetermine];
        
        
       
        
        UIButton * backgroundView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.2;
        [self addSubview:backgroundView];
        [backgroundView addTarget:self action:@selector(backgroundViewOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self sendSubviewToBack:backgroundView];
        self.backgroundView = backgroundView;
    }
    return self;
}

-(void)backgroundViewOnClick
{
    [self hiddenAlertView];
}

-(void)showAlertVeiw;
{
    
    XMDoubleDatePickView * pickView = [[XMDoubleDatePickView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width , self.contentView.frame.size.height)];
    
    if (self.timeViewType == XMAlertTimeViewTypeyyyyMM) {
        pickView.pickViewType = XMDoubleDatePickViewTypeyyyyMM;

    }
    pickView.delegate = self;
    [pickView setUpSelectToday];
    [self.contentView addSubview:pickView];
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = YES;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
}

-(void)showAlertVeiwWithAllString:(NSString *)time;
{
    NSDate * startDate ;
    NSDate * endDate ;
    
    if (time) {
        NSArray *array = [time componentsSeparatedByString:@"－"];

        if (array.count >=2) {
            NSString * yuceString = array[0];
            if (yuceString.length > 8) {
                NSString * startyicunString = [yuceString  stringByReplacingOccurrencesOfString:@" " withString:@""];
                startDate = [NSDate retNSStringToNSdate:startyicunString];
                endDate = [NSDate retNSStringToNSdate:[[array lastObject]  stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }else
            {
                startDate = [NSDate retNSStringToNSdateWithYYYY_MM:[[array firstObject]  stringByReplacingOccurrencesOfString:@" " withString:@""]];
                endDate = [NSDate retNSStringToNSdateWithYYYY_MM:[[array lastObject]  stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            
        }
        
    }
    
    if (!endDate) {
        [self showAlertVeiw];
        return;
    }

    
    XMDoubleDatePickView * pickView = [[XMDoubleDatePickView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width , self.contentView.frame.size.height)];
    if (self.timeViewType == XMAlertTimeViewTypeyyyyMM) {
        pickView.pickViewType = XMDoubleDatePickViewTypeyyyyMM;
        
    }
    pickView.delegate = self;
    [pickView setUpStartTime:startDate withEndTime:endDate];
    [self.contentView addSubview:pickView];
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = YES;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    self.showView.center  = center;
}
-(void)hiddenAlertView;
{
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}
- (IBAction)buttonCancelOnClick:(id)sender {
    self.resultString = nil;
//    if (self.blockCancel) {
//        self.blockCancel();
//    }
    [self hiddenAlertView];
}
- (IBAction)buttonDetermineOnClick:(id)sender {
    if ([self timeCompare:self.resultString]) {
    if ([self.delegate respondsToSelector:@selector(XMAlertTimeView:WithSelectTime:)]) {
        [self.delegate XMAlertTimeView:self WithSelectTime:self.resultString];
    }} else{
        self.title.text =[NSString stringWithFormat:@"左侧时间应小于等于右侧时间"];
        return;
    }
    [self hiddenAlertView];
}
// 判断右边时间是不是大于左边的时间
- (BOOL)timeCompare:(NSString *)string {
    // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
    
    if (self.timeViewType != XMAlertTimeViewTypeyyyyMM) {
        
        NSString *subStr1 = [string substringWithRange:NSMakeRange(0, 10)];
        NSString *subStr2 = [string substringWithRange:NSMakeRange(13, 10)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date1 = [formatter dateFromString:subStr1];
        NSDate *date2 = [formatter dateFromString:subStr2];
        NSComparisonResult result = [date1 compare:date2];
        if ((result == -1) || (result == 0)) {
            return YES;
        }else {
            return NO;
        }
    }else
    {
        
        NSString *subStr1 = [string substringWithRange:NSMakeRange(0, 7)];
        NSString *subStr2 = [string substringWithRange:NSMakeRange(10, 7)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSDate *date1 = [formatter dateFromString:subStr1];
        NSDate *date2 = [formatter dateFromString:subStr2];
        NSComparisonResult result = [date1 compare:date2];
        if ((result == -1) || (result == 0)) {
            return YES;
        }else {
            return NO;
        }
    }
    
    
   
}
-(void)XMDoubleDatePickView:(XMDoubleDatePickView *)pickView didSelectRowStart:(NSString *)startDate didSelectRowEnd:(NSString *)endDate
{
    NSString * result = [NSString stringWithFormat:@"%@ － %@",startDate,endDate];
    self.resultString = result;
}

@end
