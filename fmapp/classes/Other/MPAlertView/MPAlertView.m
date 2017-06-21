//
//  MPAlertView.m
//  zgbb
//
//  Created by apple on 13-7-5.
//  Copyright (c) 2013年 9ask.cn. All rights reserved.
//

#import "MPAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface MPAlertView (Private)
//初始化
- (id)initWithTitle:(NSString*)title;
//设置圆角半径
- (void)setRadius:(CGFloat)radius;
//旋转
- (void)rotate;
//显示
- (void)show;
//隐藏
- (void)hide;

@end


#define left 10
#define top 40
#define kWidth 200

static  NSString* const kFontName = @"Helvetica";

@implementation MPAlertView

- (id)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        UIFont* font = [UIFont fontWithName:kFontName size:16];
        
        //设置一个行高上限
        CGSize size = CGSizeMake(kWidth,2000);
        //计算实际frame大小，并将label的frame变成实际大小
        
        CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        //创建新的label
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setNumberOfLines:0];
        [label setText:title];
        [label setFont:font];
        [label setFrame:CGRectMake(left, top, kWidth, labelsize.height)];
        //设置自动行数与字符换行
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        
        CGFloat h = ([UIScreen mainScreen].bounds.size.height - labelsize.height - top*2) / 2;
        CGFloat w = ([UIScreen mainScreen].bounds.size.width - left*2 - kWidth) / 2;
        [self setFrame:CGRectMake(w, h, kWidth+left*2,labelsize.height+top*2)];
        
        [self addSubview:label];
    }
    return self;
}


//公共接口，显示框
- (void)showAlertView:(NSString*)title
{
    [self showAlertView:title withOffsetX:0.0f withOffsetY:0.0f];
}

- (void)showAlertView:(NSString*)title withOffsetX:(CGFloat)dx withOffsetY:(CGFloat)dy
{
    MPAlertView* view = [[MPAlertView alloc] initWithTitle:title];
    [view setRadius:6];
    [view rotate];
    [view show];
    
    [view setFrame:CGRectOffset(view.frame, dx, dy)];
}

- (void)setRadius:(CGFloat)radius
{
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
    [self setOpaque:NO];
}

- (void)rotate
{
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat r = 0.0;
    switch (orient) {
        case UIInterfaceOrientationPortrait: r= 0.0; break;
        case UIInterfaceOrientationLandscapeRight:r= M_PI_2; break;
        case UIInterfaceOrientationPortraitUpsideDown:r= M_PI_4; break;
        case UIInterfaceOrientationLandscapeLeft:r= M_PI_2*3; break;
        default:r=0.0;break;
    }
    
    [self setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, r)];
}

- (void)show
{
    [self setAlpha:0.0];
    [self setTag:1888];
    
    //获取window
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    //获取上一次的弹出框
    UIView* last = [window viewWithTag:1888];
    
    //把当前弹出层展示出来
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    
    //展示动画
    [UIView animateWithDuration:0.0 animations:
     ^{
         self.alpha = 1.0f;
     } completion:
     ^(BOOL finished)
     {
         //移除上一次的弹出框
         if ([last respondsToSelector:@selector(removeFromSuperview)]) {
             [last removeFromSuperview];
         }
         [self performSelector:@selector(hide) withObject:self afterDelay:1];
     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.8 animations:
     ^{
     self.alpha = 0.0f;
     } completion:
     ^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}




@end
