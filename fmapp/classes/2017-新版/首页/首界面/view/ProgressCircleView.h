//
//  ProgressCircleView.h
//  progressCiricleView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCircleView : UIView

/**
 *  进度值在 [0,1]
 */
@property (nonatomic, assign) float pregressValue;
/**
 *  进度条宽度
 */
@property (nonatomic, assign) float progressWidth;
/**
 *  进度条颜色
 */
@property (nonatomic, strong) UIColor *pregressColor;


@end
