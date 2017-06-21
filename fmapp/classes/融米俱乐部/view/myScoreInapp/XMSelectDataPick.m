//
//  XMSelectDataPick.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMSelectDataPick.h"

@interface XMSelectDataPick ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPickView;
@property (nonatomic, strong) UIView * backGroundView;
@end

@implementation XMSelectDataPick
- (IBAction)selectDataPickView:(id)sender {
    
}
- (IBAction)determineButtonOnClick:(id)sender {
    [self disMissView];
    if ([self.delegate respondsToSelector:@selector(XMSelectDataPickDidSelectTime:withTurnTime:)]) {
        [self.delegate XMSelectDataPickDidSelectTime:self withTurnTime:[self turnNSStringToTime:self.dataPickView.date]];
    }
    
}
- (IBAction)cancelButtonOnClick:(id)sender {
    [self disMissView];
}

-(void)disMissView
{
    [self.backGroundView removeFromSuperview];
    [self removeFromSuperview];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"XMSelectDataPick" owner:self options:nil]lastObject];
        self.layer.cornerRadius = 10;
    }
    return self;
}
-(void)showTimeWithCurrentTime:(NSDate *)date
{
    [self.dataPickView setDate:date];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.8, 250);
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    
    UIView * backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.backGroundView = backGroundView;
    
    [window addSubview:backGroundView];
    [window bringSubviewToFront:backGroundView];
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    
}

-(NSDate *)turnToTimeWithNSString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:string];
}
-(NSString *)turnNSStringToTime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
