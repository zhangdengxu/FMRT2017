//
//  ShowMessageInfoView.m
//  fmapp
//
//  Created by runzhiqiu on 15/12/31.
//  Copyright © 2015年 yk. All rights reserved.
//
#define KMarGionDefault 10
#define KMarGionLabelDefaultLeft 10
#define KMarGionLabelDefaultTop 5
#define KSingleWidth 9
#define KStateSecond 3
#define KContentFont 12
#import "ShowMessageInfoView.h"


//typedef void(^InfoViewChangeFrame) (CGSize,CGRect);

@interface ShowMessageInfoView ()

@property (nonatomic,weak)UIImageView * arrowImageView;
@property (nonatomic,weak)UIImageView * backImageView;
@property (nonatomic,weak)UILabel * showLabel;

//@property (nonatomic,copy)InfoViewChangeFrame changeFrame;

@property (nonatomic,strong)NSTimer * time;

@property (nonatomic, assign) NSInteger secondCount;

@property (nonatomic, assign) BOOL isOnWindow;
@end

@implementation ShowMessageInfoView

-(void)createTime
{
    _time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimeThisView) userInfo:nil repeats:YES];
     _time.fireDate = [NSDate distantFuture];
}

-(void)showTimeThisView
{
    self.secondCount ++;
    if (self.secondCount > 3) {
        self.isOnWindow = NO;
        [self removeFromSuperview];//distantPast
        _time.fireDate = [NSDate distantFuture];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage * backImage = [UIImage imageNamed:@"您每日将损失圆角矩形"];
        UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - KSingleWidth)];
        backImageView.image = backImage;
        self.backImageView = backImageView;
        [self addSubview:backImageView];
        
        
        UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(KMarGionLabelDefaultLeft, KMarGionLabelDefaultTop, backImageView.bounds.size.width - KMarGionLabelDefaultLeft * 2, backImageView.bounds.size.height - KMarGionLabelDefaultTop * 2)];
        [self addSubview:showLabel];
        self.showLabel = showLabel;
        
        
        UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSingleWidth, KSingleWidth)];
        arrowImageView.center = CGPointMake(self.center.x, CGRectGetMaxY(self.backImageView.frame) + KSingleWidth * 0.5);
        arrowImageView.image = [UIImage imageNamed:@"您每日将损失下方三角"];
        self.arrowImageView = arrowImageView;
        [self addSubview:arrowImageView];
        

        [self createTime];
    }
    return self;
}

+ (instancetype)showMessageinfoViewOnThisViewLocation:(ShowMessageInfoViewLocation) location;
{
    UIImage * image = [UIImage imageNamed:@"您每日将损失圆角矩形"];
    NSString * contentString = @"    ";
    CGSize size = [contentString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, image.size.height) WithFont:[UIFont systemFontOfSize:12]];
    
    ShowMessageInfoView * showView = [[ShowMessageInfoView alloc]initWithFrame:CGRectMake(0, 0, size.width + KMarGionLabelDefaultLeft * 2, image.size.height * 0.6 + KMarGionLabelDefaultLeft * 2 + KSingleWidth)];
    return showView;
}
-(void)showMessageInfoViewWilldealloc;
{
    _time.fireDate = [NSDate distantFuture];
    [_time invalidate];
    _time  = nil;
    [self removeFromSuperview];
}

-(void)dealloc
{
    _time.fireDate = [NSDate distantFuture];
    [_time invalidate];
    _time  = nil;
}
-(void)showMessageInfoViewWithString:(NSString *)contentString showString:(NSString *)showString showView:(UIView *)fatherView;
{

    if (!showString) {
        return;
    }
    if (!contentString) {
        return;
    }
    if (contentString.length <= 0) {
        self.secondCount = 100;
    }else{
        self.secondCount = 0;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [fatherView convertRect:fatherView.frame toView:window];
    
    self.showLabel.font = [UIFont systemFontOfSize:KContentFont];
    
    self.showLabel.text = contentString;
    
    CGSize size = [showString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.frame.size.height) WithFont:[UIFont systemFontOfSize:self.font]];
    
    CGSize contentSize = [contentString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.frame.size.height) WithFont:[UIFont systemFontOfSize:KContentFont]];
    [self changeFramewithSize:size withCGrect:rect withContentFontSize:contentSize];
    if (!self.isOnWindow) {
        [window addSubview:self];
        [window bringSubviewToFront:self];
        self.isOnWindow = YES;
        _time.fireDate = [NSDate distantPast];
    }

}

-(void)showMessageInfoViewWithString:(NSString *)contentString showView:(UIView *)fatherView ;
{
    if (!contentString) {
        return;
    }
    if (contentString.length <= 0) {
        self.secondCount = 100;
    }else{
        self.secondCount = 0;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [fatherView convertRect:fatherView.frame toView:window];
 
    self.showLabel.font = [UIFont systemFontOfSize:KContentFont];

    self.showLabel.text = contentString;
    CGSize size = [contentString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.frame.size.height) WithFont:[UIFont systemFontOfSize:self.font]];
    
    
    CGSize contentSize = [contentString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.frame.size.height) WithFont:[UIFont systemFontOfSize:KContentFont]];
    [self changeFramewithSize:size withCGrect:rect withContentFontSize:contentSize];
    if (!self.isOnWindow) {
        [window addSubview:self];
        [window bringSubviewToFront:self];
        self.isOnWindow = YES;
        _time.fireDate = [NSDate distantPast];
    }
    
    
}

-(void)changeFramewithSize:(CGSize)stringSize withCGrect:(CGRect)fatherRect withContentFontSize:(CGSize)contentSize
{
        CGRect oldRect = self.frame;
        self.frame = CGRectMake(0, fatherRect.origin.y - oldRect.size.height - 4 , contentSize.width + KMarGionLabelDefaultLeft * 2, oldRect.size.height);
    
    
        self.center = CGPointMake(fatherRect.origin.x - 50 + stringSize.width, self.center.y);
    
        self.backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - KSingleWidth);
        
        self.showLabel.frame = CGRectMake(KMarGionLabelDefaultLeft, KMarGionLabelDefaultTop, contentSize.width,contentSize.height);
        
        self.arrowImageView.center = CGPointMake(self.frame.size.width * 0.5, CGRectGetMaxY(self.backImageView.frame) + KSingleWidth * 0.5);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
