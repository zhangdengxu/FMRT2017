//
//  SJChartLineView.m
//  SJChartViewDemo
//
//  Created by Jaesun on 16/9/9.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import "SJChartLineView.h"
#import "SJCircleView.h"

// Tag 基初值
#define BASE_TAG_COVERVIEW 100
#define BASE_TAG_CIRCLEVIEW 200
#define BASE_TAG_POPBTN 300

@interface SJChartLineView() {
   
    NSMutableArray *pointArray;
    NSInteger lastSelectedIndex;
}

@end

@implementation SJChartLineView

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
}

- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
}


- (void)setValueArray:(NSArray *)valueArray {
    _valueArray = valueArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectedIndex = - 1;
        pointArray = [NSMutableArray array];
        self.yAxis_L = frame.size.height;
        self.xAxis_L = frame.size.width;
      
    }
    return  self;
}

- (void)mapping {
   
    [super mapping];
    
    [self drawChartLine];
    [self drawGradient];
    
    [self setupCircleViews];
    [self setupCoverViews];
}

- (void)reloadDatas {
    
    [super reloadDatas];
    
    [self clearView];
    [self mapping];
}

#pragma mark 画折线图
- (void)drawChartLine{
        UIBezierPath *pAxisPath = [[UIBezierPath alloc] init];
        
        for (int i = 0; i < self.valueArray.count; i ++) {
            
            CGFloat point_X = self.xScaleMarkLEN * i + self.startPoint.x;
            
            CGFloat value = [self.valueArray[i] floatValue]/100000000;
            
            CGFloat percent = (value- self.minValue) / (self.maxValue - self.minValue);
            CGFloat point_Y = self.yAxis_L * (1 - percent) + self.startPoint.y;
            
            CGPoint point = CGPointMake(point_X, point_Y);
            
            // 记录各点的坐标方便后边添加渐变阴影 和 点击层视图 等
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            
            if (i == 0) {
                [pAxisPath moveToPoint:point];
            }
            else {
                [pAxisPath addLineToPoint:point];
            }
        }

        CAShapeLayer *pAxisLayer = [CAShapeLayer layer];
        pAxisLayer.lineWidth = 2.0;
        pAxisLayer.strokeColor = [UIColor colorWithHexString:@"#0099e9"].CGColor;
        pAxisLayer.fillColor = [UIColor clearColor].CGColor;
        pAxisLayer.path = pAxisPath.CGPath;
        [self.layer addSublayer:pAxisLayer];
}

#pragma mark 渐变阴影
- (void)drawGradient {
        
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#0099e9"alpha:0.3].CGColor,(__bridge id)[UIColor colorWithHexString:@"#0099e9"alpha:0.3].CGColor];

    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1);
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    [gradientPath moveToPoint:CGPointMake(self.startPoint.x, self.yAxis_L + self.startPoint.y)];
    
    for (int i = 0; i < pointArray.count; i ++) {
        [gradientPath addLineToPoint:[pointArray[i] CGPointValue]];
    }
    
    CGPoint endPoint = [[pointArray lastObject] CGPointValue];
//    endPoint = CGPointMake(endPoint.x + self.startPoint.x, self.yAxis_L + self.startPoint.y);
    endPoint = CGPointMake(endPoint.x , self.yAxis_L + self.startPoint.y);

    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.layer addSublayer:gradientLayer];

}

#pragma mark 折线上的圆环
- (void)setupCircleViews {
    
    for (int i = 0; i < pointArray.count; i ++) {
        
        SJCircleView *circleView = [[SJCircleView alloc] initWithCenter:[pointArray[i] CGPointValue] radius:3];
        circleView.frameCenter = [pointArray[i] CGPointValue];
        circleView.tag = i + BASE_TAG_CIRCLEVIEW;
        circleView.borderColor = [UIColor colorWithHexString:@"#0099e9"];
        circleView.borderWidth = 1.0;
        [self addSubview:circleView];
    }
}

#pragma mark 覆盖一层点击图层
- (void)setupCoverViews {

    for (int i = 0; i < pointArray.count; i ++) {
        
        UIView *coverView = [[UIView alloc] init];
        coverView.tag = BASE_TAG_COVERVIEW + i;
                
        if (i == 0) {
            
            coverView.frame = CGRectMake(self.startPoint.x, self.startPoint.y, self.xScaleMarkLEN  / 2, self.yAxis_L);
            [self addSubview:coverView];
        }
        else if (i == pointArray.count - 1 && pointArray.count == self.xMarkTitles.count) {
            CGPoint point = [pointArray[i] CGPointValue];
            coverView.frame = CGRectMake(point.x - self.xScaleMarkLEN / 2, self.startPoint.y, self.xScaleMarkLEN  / 2, self.yAxis_L);
            [self addSubview:coverView];
        }
        else {
            CGPoint point = [pointArray[i] CGPointValue];
            coverView.frame = CGRectMake(point.x - self.xScaleMarkLEN / 2, self.startPoint.y, self.xScaleMarkLEN, self.yAxis_L);
            [self addSubview:coverView];
        }
        UITapGestureRecognizer *gesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesutreAction:)];
        [coverView addGestureRecognizer:gesutre];
    }
}

#pragma mark- 点击层视图的点击事件
- (void)gesutreAction:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag - BASE_TAG_COVERVIEW;
    
    if (lastSelectedIndex != -1) {
        
        SJCircleView *lastCircleView = (SJCircleView *)[self viewWithTag:lastSelectedIndex + BASE_TAG_CIRCLEVIEW];
        lastCircleView.borderWidth = 1;
        lastCircleView.radius = 3;
        UIButton *lastPopBtn = (UIButton *)[self.superview viewWithTag:lastSelectedIndex + BASE_TAG_POPBTN];
        [lastPopBtn removeFromSuperview];
    }
    
    SJCircleView *circleView = (SJCircleView *)[self viewWithTag:index + BASE_TAG_CIRCLEVIEW];
    circleView.borderWidth = 4;
    circleView.radius = 4;
    CGPoint point = [pointArray[index] CGPointValue];
    UIButton *popBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    popBtn.tag = index + BASE_TAG_POPBTN;
    
    
    if (index == self.valueArray.count-1) {
        popBtn.frame = CGRectMake(point.x - 150, point.y + 10, 130, 53.5);

    }else{
        popBtn.frame = CGRectMake(point.x + 10, point.y + 10, 130, 53.5);
    }
    
    popBtn.titleLabel.numberOfLines = 0;
    [popBtn setBackgroundImage:[UIImage imageNamed:@"平台数据_黑框_1702"] forState:UIControlStateNormal];
    [popBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    popBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    double money = [self.valueArray[index] doubleValue];
    
//    NSString *ttt = [NSString stringWithFormat:@"%.f",money];
//    
//    long mmm = [ttt doubleValue];
//    
    NSNumber *number = [NSNumber numberWithDouble:money];

    NSString *test = [self countNumAndChangeformat:[NSString stringWithFormat:@"%@",number]];
    
    [popBtn setTitle:[NSString stringWithFormat:@"%@\n%@",self.despArray[index],test] forState:(UIControlStateNormal)];
    
    [self.superview addSubview:popBtn];

    lastSelectedIndex = index;
}

- (NSString *)countNumAndChangeformat:(NSString *)num{
    
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0){        count++;        a /= 10;    }    NSMutableString *string = [NSMutableString stringWithString:num];    NSMutableString *newstring = [NSMutableString string];    while (count > 3) {        count -= 3;        NSRange rang = NSMakeRange(string.length - 3, 3);        NSString *str = [string substringWithRange:rang];        [newstring insertString:str atIndex:0];        [newstring insertString:@"," atIndex:0];        [string deleteCharactersInRange:rang];    }    [newstring insertString:string atIndex:0];
    return newstring;
}

#pragma mark- 清空视图
- (void)clearView {
    [self removeSubviews];
    [self removeSublayers];
}

#pragma mark 移除 点击图层 、圆环 、数值标签
- (void)removeSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark 移除折线
- (void)removeSublayers {
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}



@end
