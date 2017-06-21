//
//  FMShowPayStatus.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShowPayStatus.h"

@interface FMShowPayStatus ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *successButton;

//@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (nonatomic, assign) __block int timeout;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, copy) NSString *currentTitle;
@end

@implementation FMShowPayStatus
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"FMShowPayStatus" owner:self options:nil] firstObject];
        self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
        
       
    }
    return self;
}

-(void)showSuccessWithView:(UIView *)view;
{
    
//    self.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.7, KProjectScreenHeight * 0.7);
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    [window addSubview:self.backGroundView];
    [window bringSubviewToFront:self.backGroundView];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    [self.iconImage setImage:[UIImage imageNamed:@"对号Shop_03"]];
    self.successButton.text = @"支付成功" ;
    self.currentTitle = @"支付成功";
//    [self.orderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [self.shopButton setTitle:@"返回商城首页" forState:UIControlStateNormal];
    [self afterDidButton];
   
}
-(void)afterDidButton
{
    _timeout = 3;
    __weak __typeof(&*self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(_timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //这里写倒计时结束button的处理
                [weakSelf lookOrderButton:nil];
                
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //这里写倒计时期间button的处理（重设button的tiitle、用户交互等）
                NSString * title =[NSString stringWithFormat:@"%@(%ds)",self.currentTitle,_timeout];
                weakSelf.successButton.text = title;
            });
            
            _timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    

}
-(void)showFaileWithView:(UIView *)view;
{
    
//    self.frame = CGRectMake(0, 0, view.bounds.size.width * 0.7, view.bounds.size.height * 0.7);
    UIWindow * window = [UIApplication sharedApplication].keyWindow;

    self.center = CGPointMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5);
    
    [window addSubview:self.backGroundView];
    [window bringSubviewToFront:self.backGroundView];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    [self.iconImage setImage:[UIImage imageNamed:@"错号Shop_03"]];
    self.successButton.text = @"支付失败";
    self.currentTitle = @"支付失败";
//    [self.orderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [self.shopButton setTitle:@"返回商城首页" forState:UIControlStateNormal];
    [self afterDidButton];
}



- (IBAction)lookOrderButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(FMShowPayStatusPayResult:)]) {
        [self.delegate FMShowPayStatusPayResult:1];
    }
    [self hiddenView];
    
}
- (IBAction)retShopIndexButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(FMShowPayStatusPayResult:)]) {
        [self.delegate FMShowPayStatusPayResult:2];
        self.delegate = nil;
    }
    [self hiddenView];
    
}
-(void)hiddenView
{
    [self.backGroundView removeFromSuperview];
    [self removeFromSuperview];
    
}

-(void)dealloc
{
//    NSLog(@"消失");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
