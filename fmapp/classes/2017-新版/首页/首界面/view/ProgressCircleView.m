//
//  ProgressCircleView.m
//  progressCiricleView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ProgressCircleView.h"

@implementation ProgressCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.progressWidth = 2.0;
        self.pregressColor = [UIColor yellowColor];
        self.pregressValue = 1.0;
    }
    return self;
}

- (void)setPregressColor:(UIColor *)pregressColor{
    _pregressColor = pregressColor;
    [self setNeedsDisplay];
}

- (void)setPregressValue:(float)pregressValue{
    _pregressValue = pregressValue;
    [self setNeedsDisplay];
}

- (void)setProgressWidth:(float)progressWidth{
    _progressWidth = progressWidth;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGFloat viewW = rect.size.width;
    CGFloat viewH = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,self.pregressColor.CGColor);
    CGContextSetLineWidth(context, self.progressWidth);
    
    CGFloat radius = (viewW - 10) * 0.5;
    
    CGFloat endAngle = self.pregressValue * 2 * M_PI - M_PI/2;
    
    CGContextAddArc(context, viewW * 0.5, viewH * 0.5, radius, -M_PI/2, endAngle, 0);
    CGContextStrokePath(context);
    
}


@end
