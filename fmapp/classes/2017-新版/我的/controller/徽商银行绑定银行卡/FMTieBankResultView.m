//
//  FMTieBankResultView.m
//  fmapp
//
//  Created by runzhiqiu on 2017/6/1.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMTieBankResultView.h"

@interface FMTieBankResultView ()


@property (nonatomic, strong) UIView * backGroundButton;
@property (nonatomic, strong) UIView  * whiteViewContent;
@property (nonatomic, strong) UILabel * bottomLabel;

@property (nonatomic,strong)NSTimer *timer;//创建定时器

@property (nonatomic, assign) NSInteger count;
@property (nonatomic,copy) tieBankResultViewButtonOnClickBlock block;
@property (nonatomic,copy) NSString *showString;

@end

@implementation FMTieBankResultView
-(UIView *)backGroundButton
{
    if (!_backGroundButton) {
        _backGroundButton = [[UIView alloc]init];
        _backGroundButton.userInteractionEnabled = YES;
        
        _backGroundButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
        [_backGroundButton addGestureRecognizer:tapGesture];
        
        
    }
    return _backGroundButton;
}
-(void)setUpTimeDate
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimeReturnDown) userInfo:nil repeats:YES];
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
    self.count -- ;
    if (self.count >=0) {
        self.bottomLabel.text = [NSString stringWithFormat:@"%zi秒后自动跳转",self.count];
        
    }else
    {
        [self pauseTimeInView];
        [self closeView];
        
    }
}
- (instancetype)initWithStatus:(NSString *)statusString WithBlock:(tieBankResultViewButtonOnClickBlock)block
{
    self = [super init];
    if (self) {
        self.count = 4;
        self.block = block;
        
        self.showString = statusString;
        [self setUpTimeDate];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        
        [self addSubview:self.backGroundButton];
        [self.backGroundButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        
        UIView * whiteViewContent = [[UIView alloc]init];
        whiteViewContent.layer.cornerRadius = 7.0;
        whiteViewContent.layer.masksToBounds = YES;
        whiteViewContent.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteViewContent];
        CGFloat radioHeigh;
        if (KProjectScreenWidth < 350) {
            radioHeigh = 0.25;
        }else if (KProjectScreenWidth < 400)
        {
            radioHeigh = 0.23;
        }else
        {
            radioHeigh = 0.21;
        }
        [whiteViewContent makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(35);
            make.right.equalTo(self.mas_right).offset(-35);
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY).offset(-30);
            make.height.equalTo(self.height).multipliedBy(radioHeigh);
            
        }];
        
        
        UIImageView * iconImageView = [[UIImageView alloc]init];
        iconImageView.image = [UIImage imageNamed:@"微商_弹窗_对号"];
        [self addSubview:iconImageView];
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteViewContent.mas_top);
            make.centerX.equalTo(whiteViewContent.mas_centerX);
        }];
        
        UILabel * middleLabel = [[UILabel alloc]init];
        middleLabel.text = self.showString;
        middleLabel.textColor = [UIColor blackColor];
        middleLabel.font = [UIFont systemFontOfSize:18];
        middleLabel.textAlignment = NSTextAlignmentCenter;
        [whiteViewContent addSubview:middleLabel];
        [middleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(whiteViewContent);
            make.centerY.equalTo(whiteViewContent.mas_centerY);
            
        }];
        
        UILabel * bottomLabel = [[UILabel alloc]init];
        self.bottomLabel = bottomLabel;
        bottomLabel.text = [NSString stringWithFormat:@"%zi秒后自动跳转",self.count];
        bottomLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        bottomLabel.font = [UIFont systemFontOfSize:15];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [whiteViewContent addSubview:bottomLabel];
        [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(whiteViewContent);
            make.bottom.equalTo(whiteViewContent.mas_bottom).offset(-25);
        }];
        
        
        UIButton * bottomButtonClose = [[UIButton alloc]init];
       
        [bottomButtonClose setImage:[UIImage imageNamed:@"微商_注册:取现_关闭"] forState:UIControlStateNormal];
        [bottomButtonClose addTarget:self action:@selector(bottomButtonCloseOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomButtonClose];
        
        [bottomButtonClose makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(whiteViewContent.mas_bottom).offset(45);
        }];
        [self bringSubviewToFront:iconImageView];
        
        [self startTimeInView];

    }
    return self;
}
-(void)bottomButtonCloseOnClick:(UIButton *)bottom
{
     [self closeView];
}

-(void)removeAllViewFromSuperView
{
     [self closeView];
}
-(void)backGroundButtonOnClick:(UITapGestureRecognizer *)tap
{
     [self closeView];
}
-(void)closeView
{
    [self pauseTimeInView];
    [_timer invalidate];
    _timer = nil;
    if (self.block) {
        self.block();
    }
    [self removeFromSuperview];
}


+(instancetype)showFMTieBankResultViewWithStatus:(NSString *)status Success:(tieBankResultViewButtonOnClickBlock)block;
{
    FMTieBankResultView * success = [[FMTieBankResultView alloc]initWithStatus:status WithBlock:block];
    
    return success;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
