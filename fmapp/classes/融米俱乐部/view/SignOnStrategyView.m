//
//  SignOnStrategyView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/2/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "SignOnStrategyView.h"
@interface SignOnStrategyView()

@property (nonatomic, weak) UIView * backgroundView;

@end

@implementation SignOnStrategyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setFrame:CGRectMake(0, 0, 350, 370)];
        
    }
    return self;
}

-(void)showSignView{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    
    [window bringSubviewToFront:backgroundView];
    
   
    
    CGRect rect = self.frame;
    
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(50, 25, self.frame.size.width-100, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
    [headerView.layer setCornerRadius:6.0f];
    [headerView.layer setMasksToBounds:YES];
    [self addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    titleLabel.text = @"签到攻略";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [headerView addSubview:titleLabel];
    
  
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 310, self.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
    [self addSubview:lineView];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setBackgroundColor:[UIColor clearColor]];
    [bottomButton setTitle:@"我知道了" forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [bottomButton setTitleColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton setFrame:CGRectMake(0, 310, self.frame.size.width, 60)];
    [self addSubview:bottomButton];
    
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    NSString *textString = @"1) 每日签到随机奖励1-6积分；\n2) 连续签到30天，可获得额外积分或红包奖励；\n3) 忘记签到，10个积分可以补签到（补签的情况就是在签到日历的前一天有补签小按钮，点击补签后，系统自动化成对号，扣10个积分；）\n4) 累计360天，可获得额外1000积分；";

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(35, 55, self.frame.size.width-60, 270)];
    label1.text = textString;
    label1.lineBreakMode = kCTLineBreakByCharWrapping;
    label1.numberOfLines = 0;
    label1.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [self addSubview:label1];
    
}

-(void)hiddenSignView{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)btn{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}




@end
