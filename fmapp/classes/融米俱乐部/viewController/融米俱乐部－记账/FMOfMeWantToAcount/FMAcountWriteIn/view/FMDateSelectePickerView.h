//
//  FMDateSelectePickerView.h
//  fmapp
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMDateSelectePickerViewDelegate <NSObject>

-(void)didFinishPickView:(NSString*)date;

@end

@interface FMDateSelectePickerView : UIView

/**
 *  日期选择标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  当前时间
 */
@property (nonatomic, strong) NSDate*curDate;

/**
 *  标题栏背景颜色 (默认灰色)
 */
@property (nonatomic, strong) UIColor *titleBackgroundColor;

/**
 * 标题栏上标题以及按钮的字体颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  日期背景颜色（默认白色）
 */
@property (nonatomic, strong) UIColor *dateBackgroundColor;

/**
 *  取消按钮字体颜色
 */
@property (nonatomic, strong) UIColor *cancelButtonTintColor;

/**
 *  确定按钮字体颜色
 */
@property (nonatomic, strong) UIColor *sureButtonTintColor;

@property (nonatomic, strong) id<FMDateSelectePickerViewDelegate>delegate;

- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
@end
