//
//  XMAlertTimeView.h
//  UIpick
//
//  Created by runzhiqiu on 15/12/28.
//  Copyright © 2015年 runzhiqiu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMAlertTimeView;

typedef enum : NSUInteger {
    XMAlertTimeViewTypeyyyyMMdd,
    XMAlertTimeViewTypeyyyyMM,
    
} XMAlertTimeViewType;
@protocol XMAlertTimeViewDelegate <NSObject>

@optional

-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;

@end

@interface XMAlertTimeView : UIView


@property (nonatomic, assign) XMAlertTimeViewType timeViewType;

@property (nonatomic, weak) id <XMAlertTimeViewDelegate>  delegate;
/** 日期选择框的文字 */
@property (nonatomic, strong) UILabel * title;
/** 显示日期选择框 */
-(void)showAlertVeiw;
/** 隐藏日期选择框 */
-(void)hiddenAlertView;

/** 显示日期选择框 */
-(void)showAlertVeiwWithAllString:(NSString *)time;

//// 点击取消按钮
//@property (nonatomic, copy) void(^blockCancel)();

@end
