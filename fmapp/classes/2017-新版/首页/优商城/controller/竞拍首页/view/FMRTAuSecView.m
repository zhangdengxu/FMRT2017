//
//  FMRTAuSecView.m
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAuSecView.h"

#import "MZTimerLabel.h"
#import "FMRTAucTool.h"
#import "Fm_Tools.h"

@interface FMRTAuSecView ()<MZTimerLabelDelegate>

@property (nonatomic, strong) MZTimerLabel *redStopwatch, *timer;
@property (nonatomic, weak) UIButton *fhbutn,*shbutn,*fmbutn,*smbutn,*fsbutn,*ssbutn;
@property (nonatomic, copy) NSString *beginHour,*endHour;

@end

@implementation FMRTAuSecView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 80);
        self.backgroundColor = [UIColor whiteColor];
        [self createTopView];
    }
    return self;
}

- (void)createTopView{
    
    UIImageView *zeroPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0元竞拍--文字_05"]];
    zeroPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:zeroPhotoView];
    [zeroPhotoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(30);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(zeroPhotoView.mas_bottom).offset(5);
    }];
    
    UIButton *zeroRuleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [zeroRuleBtn setImage:[UIImage imageNamed:@"活动规则--问号_08"] forState:(UIControlStateNormal)];
    [zeroRuleBtn addTarget:self action:@selector(zeroAction) forControlEvents:(UIControlEventTouchUpInside)];
    [zeroRuleBtn setTitle:@"活动规则" forState:(UIControlStateNormal)];
    [zeroRuleBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:UIControlStateNormal];
    [zeroRuleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    zeroRuleBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    zeroRuleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:zeroRuleBtn];
    [zeroRuleBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(zeroPhotoView.mas_centerY);
    }];
    
    UILabel *zeroLabel = [[UILabel alloc]init];
    zeroLabel.text = @"0元起拍，上限7折";
    zeroLabel.font = [UIFont systemFontOfSize:13];
    zeroLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
    [self addSubview:zeroLabel];
    [zeroLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(zeroPhotoView.mas_right).offset(8);
        make.centerY.equalTo(zeroPhotoView.mas_centerY);
        make.right.equalTo(zeroRuleBtn.mas_left).offset(-5).priorityLow();
    }];
    
    UILabel *distanceLabel = [[UILabel alloc]init];
    distanceLabel.text = @"距离竞拍开始: ";
    distanceLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];;
    distanceLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:distanceLabel];
    [distanceLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(lineView.mas_bottom).offset(10);
    }];
    
    UIButton *fhbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [fhbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.fhbutn = fhbutn;
    [fhbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [fhbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [self addSubview:fhbutn];
    [fhbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(distanceLabel.mas_right).offset(5);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UIButton *shbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.shbutn = shbutn;
    [shbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [shbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [self addSubview:shbutn];
    [shbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(fhbutn.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UILabel *sepLabel = [[UILabel alloc]init];
    sepLabel.text = @":";
    [self addSubview:sepLabel];
    [sepLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(shbutn.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
    }];
    
    UIButton *fmbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [fmbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.fmbutn = fmbutn;
    [fmbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [fmbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [self addSubview:fmbutn];
    [fmbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(sepLabel.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UIButton *smbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [smbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.smbutn = smbutn;
    [smbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [smbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [self addSubview:smbutn];
    [smbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(fmbutn.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UILabel *mepLabel = [[UILabel alloc]init];
    mepLabel.text = @":";
    [self addSubview:mepLabel];
    [mepLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(smbutn.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
    }];
    
    UIButton *fsbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [fsbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.fsbutn = fsbutn;
    [fsbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [fsbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [self addSubview:fsbutn];
    [fsbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(mepLabel.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UIButton *ssbutn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [ssbutn setBackgroundImage:[UIImage imageNamed:@"倒计时--外框_03"] forState:UIControlStateNormal];
    self.ssbutn = ssbutn;
    [ssbutn setTitle:@"0" forState:(UIControlStateNormal)];
    [ssbutn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
    [self addSubview:ssbutn];
    [ssbutn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(fsbutn.mas_right).offset(2);
        make.centerY.equalTo(distanceLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@18);
    }];
    
    UIView *bottomlineView = [UIView new];
    bottomlineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:bottomlineView];
    [bottomlineView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
        make.left.right.equalTo(self);
    }];
    
    [self addSubview:self.redStopwatch];

}

-(MZTimerLabel *)timer{
    if (!_timer) {
        _timer = ({
            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
            timer;
        });
    }
    return _timer;
}

- (void)timerForStaticMZTimerLabelWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{
    
    NSComparisonResult result =  [[NSDate date] compare:[Fm_Tools dateFromDateString:beginTime]];
    NSComparisonResult backResult =  [[NSDate date] compare:[Fm_Tools dateFromDateString:endTime]];
    
    if (result == NSOrderedAscending) {
        [self.redStopwatch setCountDownToDate:[Fm_Tools dateFromDateString:beginTime]];
        [self.redStopwatch start];
        
    }else if (result == NSOrderedDescending && backResult == NSOrderedAscending) {
        
        [self.timer setCountDownToDate:[Fm_Tools dateFromDateString:endTime]];
        [self.timer startWithEndingBlock:^(NSTimeInterval countTime) {
            if (self.auctionEndBlcok) {
                self.auctionEndBlcok();
            }
            
            [self.redStopwatch reset];
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[Fm_Tools dateFromDateString:beginTime]];
            [self.redStopwatch setCountDownToDate:nextDate];
            [self.redStopwatch start];
        }];
        
    }else if (backResult == NSOrderedDescending){
        if (self.auctionEndBlcok) {
            self.auctionEndBlcok();
        }
        NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[Fm_Tools dateFromDateString:beginTime]];
        [self.redStopwatch setCountDownToDate:nextDate];
        [self.redStopwatch start];
    }

}

- (MZTimerLabel *)redStopwatch{
    if (!_redStopwatch) {
        _redStopwatch = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
        _redStopwatch.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        _redStopwatch.timeLabel.textColor = [UIColor redColor];
        _redStopwatch.delegate = self;
    }
    return _redStopwatch;
}

#pragma mark - MZTimerLabelDelegate
- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time{
    
    if([timerLabel isEqual:_redStopwatch]){
        int second = (int)time  % 60;
        int minute = ((int)time / 60) % 60;
        int hours = time / 3600;
        
        if (second>=0 && minute >=0 && hours>=0) {
            
            [self.fhbutn setTitle:[NSString stringWithFormat:@"%d",hours/10] forState:(UIControlStateNormal)];
            [self.shbutn setTitle:[NSString stringWithFormat:@"%d",hours%10] forState:(UIControlStateNormal)];
            [self.fmbutn setTitle:[NSString stringWithFormat:@"%d",minute/10] forState:(UIControlStateNormal)];
            [self.smbutn setTitle:[NSString stringWithFormat:@"%d",minute%10] forState:(UIControlStateNormal)];
            [self.fsbutn setTitle:[NSString stringWithFormat:@"%d",second/10] forState:(UIControlStateNormal)];
            [self.ssbutn setTitle:[NSString stringWithFormat:@"%d",second%10] forState:(UIControlStateNormal)];

        }
        
       
        return [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minute,second];
    }
    else
        return nil;
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    if([timerLabel isEqual:_redStopwatch]){

        if (self.auctionStartBlcok) {
            self.auctionStartBlcok();
        }
        
        __weak typeof (self)weakSelf = self;
        MZTimerLabel *timer = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
        [timer setCountDownToDate:[Fm_Tools dateFromDateString:self.endHour]];

        [timer startWithEndingBlock:^(NSTimeInterval countTime) {
            
            if (weakSelf.auctionEndBlcok) {
                weakSelf.auctionEndBlcok();
            }
            [timerLabel reset];
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[Fm_Tools dateFromDateString:self.beginHour]];
            [timerLabel setCountDownToDate:nextDate];
            [timerLabel start];
        }];
        
    }else if ([timerLabel isEqual:_timer]){
        
        if (self.auctionEndBlcok) {
            self.auctionEndBlcok();
        }
        [self.redStopwatch reset];
        NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[Fm_Tools dateFromDateString:self.beginHour]];
        [self.redStopwatch setCountDownToDate:nextDate];
        [self.redStopwatch start];
    }
}

- (void)zeroAction{
    if (self.ruleBlcok) {
        self.ruleBlcok();
    }
}

- (void)setInAuctionTime:(NSInteger)inAuctionTime{
    _inAuctionTime = inAuctionTime;
    
    [self.redStopwatch reset];
    [self.redStopwatch pause];
    self.redStopwatch = nil;
//    self.redStopwatch
}

- (void)setTypeCount:(NSInteger)typeCount{
    _typeCount = typeCount;
    
    [self.redStopwatch reset];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[Fm_Tools dateFromDateString:self.beginHour]];
    [self.redStopwatch setCountDownToDate:nextDate];
    [self.redStopwatch start];
}

- (void)sendDataWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{

    self.beginHour = beginTime;
    self.endHour = endTime;
    [self timerForStaticMZTimerLabelWithBeginTime:beginTime endTime:endTime];
}

@end
