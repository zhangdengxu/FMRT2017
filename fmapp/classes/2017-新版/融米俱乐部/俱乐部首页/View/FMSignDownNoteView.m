//
//  FMSignDownNoteView.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//  signCount

#import "FMSignDownNoteView.h"
#import "AppDelegate.h"


@interface FMSignDownNoteView ()

@property (nonatomic, strong) UIImageView * iconImageView;

@property (nonatomic, strong) UIButton * backGroundView;

@property (nonatomic, strong) UILabel * scoreLabel;

@property (nonatomic, strong) UILabel * detailLabel;

@property (nonatomic, strong) NSTimer * timer;



@property (nonatomic, assign) NSUInteger allCount;

@property (nonatomic, assign) NSUInteger currentCount;
@end


@implementation FMSignDownNoteView
-(void)setUpTimeDate
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(secondTimeReturnDown) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}
-(void)startTimeInView
{
    [_timer setFireDate:[NSDate distantPast]];
}
-(void)pauseTimeInView
{
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)secondTimeReturnDown
{
    NSInteger rand = arc4random() % 100 ;
    
    self.currentCount ++;
    
    if (self.currentCount > self.allCount) {
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%zi",self.signCount];
        [self pauseTimeInView];
        [self performSelector:@selector(hiddenAllViews) withObject:nil afterDelay:3.0];
    }else
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"%zi",rand];
    }
}

-(void)hiddenAllViews
{
    [_timer invalidate];
    _timer = nil;
    self.hidden = YES;
    
    [self removeFromSuperview];
}

- (instancetype)initWithSignCount:(NSInteger)signCount;
{
    self = [super init];
    if (self) {
        [self setUpTimeDate];
        self.signCount = signCount;
        self.allCount = 40;
    }
    return self;
}


-(void)showViewWithCurrentView:(UIView *)currentView;
{
    [currentView addSubview:self];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(currentView);
    }];
    
    
    [self addmassonry];
    
    [self createTimeWithCount];

}

-(void)showViewWithKeyWindow;
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(window);
    }];
    
    
    [self addmassonry];
    
    
    [self createTimeWithCount];
    
    
}


-(void)createTimeWithCount
{
    [self startTimeInView];
}

-(void)addmassonry
{
    [self.backGroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-60);
        make.width.equalTo(KProjectScreenWidth * 0.5);
        make.height.equalTo(self.iconImageView.width).multipliedBy(1.87);

    }];
    
    [self.scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(30);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(15);

    }];
}

-(void)backGroundViewButtonOnClick:(UIButton *)button
{
    self.currentCount = 10000;
    [self pauseTimeInView];
    [self hiddenAllViews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.font = [UIFont systemFontOfSize:54];
        _scoreLabel.textColor = [HXColor colorWithHexString:@"#f9f11d"];
        _scoreLabel.text = @"0";
        [self addSubview:_scoreLabel];
    }
    return _scoreLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:30];
        _detailLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _detailLabel.text = @"恭喜获得签到积分";
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}
-(UIButton *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIButton alloc]init];
        [_backGroundView addTarget:self action:@selector(backGroundViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.65];
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}


-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"俱乐部_签到_36"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

@end
