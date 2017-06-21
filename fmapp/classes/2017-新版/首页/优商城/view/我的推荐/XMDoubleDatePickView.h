//
//  XMDoubleDatePickView.h
//  UIpick
//
//  Created by runzhiqiu on 15/12/28.
//  Copyright © 2015年 runzhiqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMDoubleDatePickView;


typedef enum : NSUInteger {
    XMDoubleDatePickViewTypeyyyyMMdd,
    XMDoubleDatePickViewTypeyyyyMM,
    
} XMDoubleDatePickViewType;

@protocol XMDoubleDatePickViewDelegate <NSObject>

@optional

-(void)XMDoubleDatePickView:(XMDoubleDatePickView *)pickView didSelectRowStart:(NSString *) startDate didSelectRowEnd:(NSString *)endDate;

@end

@interface XMDoubleDatePickView : UIView


@property (nonatomic, assign) XMDoubleDatePickViewType pickViewType;
@property (nonatomic, weak) id <XMDoubleDatePickViewDelegate> delegate;
-(void)setUpSelectToday;
-(void)setUpStartTime:(NSDate *)startDate withEndTime:(NSDate *)endDate;
@end
