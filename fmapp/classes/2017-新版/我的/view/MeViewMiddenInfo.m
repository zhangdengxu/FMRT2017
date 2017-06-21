//
//  MeViewMiddenInfo.m
//  fmapp
//
//  Created by runzhiqiu on 15/12/30.
//  Copyright © 2015年 yk. All rights reserved.
//
#define KDefinePeriod 20

#import "MeViewMiddenInfo.h"

@interface MeViewMiddenInfo ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *thirdActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fourActivity;

@property (nonatomic,assign) CGFloat shouCount;
@end

@implementation MeViewMiddenInfo

-(void)setArray:(NSArray *)array
{
    _array = array;
    
    
    NSString * second = array[1] == nil ? @"0.00" : array[1];
    NSString * third = array[2] == nil ? @"0.00" : array[2];
    NSString * four = array[3] == nil ? @"0.00" : array[3];
    _secondLabel.text = second;
    _thirdLabel.text = third;
    _fourLabel.text = four;
    
    [self.firstActivity stopAnimating];
    [self.secondActivity stopAnimating];
    [self.thirdActivity stopAnimating];
    [self.fourActivity stopAnimating];
    __weak typeof(self) wself = self;
    
    
    
    if (array[0] == nil ||[array[0] isEqualToString:@""] ||[array[0] isEqualToString:@"0"] || [array[0] isEqualToString:@"0.00"]) {
        
        _firstLabel.text = @"0.00";
        
    }else
    {
        
        CGFloat danwei = (1000 * 10);//作为1秒的单位。
        __block CGFloat count = [wself.array[0] floatValue];
        CGFloat stadio = (CGFloat)((count * 100) / (danwei));
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 1
            NSTimeInterval period = 0.01; //设置时间间隔
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{ //在这里执行事件
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    
                    
                    if (wself.shouCount < (count - 10 * stadio)) {
                        wself.firstLabel.text = [NSString stringWithFormat:@"%.2lf",wself.shouCount];
                    }else
                    {
                        wself.firstLabel.text = wself.array[0];
                    }
                });
                
            });
            dispatch_resume(_timer);
            
            
            //NSEC_PER_MSEC表示毫秒
            
            while (wself.shouCount < count) {
                wself.shouCount += stadio;
                
                [NSThread sleepForTimeInterval:0.01];
            }
        });
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
