//
//  CalculatorBabyPlanView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "CalculatorBabyPlanView.h"

@interface CalculatorBabyPlanView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *monthMoney;
@property (weak, nonatomic) IBOutlet UITextField *addYearCount;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, weak) UIView * backgroundView;
@property (nonatomic, strong) NSDictionary * dataSource;
@property (nonatomic, weak) UIView * alertView;
@end

@implementation CalculatorBabyPlanView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CalculatorBabyPlanView" owner:self options:nil] lastObject];
        

        
        self.userInteractionEnabled = YES;
        self.resultLabel.layer.borderWidth = 1;
        self.resultLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.resultLabel.layer.cornerRadius = 2.0;
        [self readDataSource];
        self.monthMoney.delegate = self;
    }
    return self;
}

-(void)readDataSource
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoneyCoefficient" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataSource = dictionary[@"data"];
}

-(void)showCalculateBabyPlayView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    
    [window bringSubviewToFront:backgroundView];
    


    CGRect rect = self.frame;
    
    if (KProjectScreenWidth == 320) {
        rect.size.width = rect.size.width * (320.0/375.0);
    }else if(KProjectScreenWidth > 375 )
    {
        rect.size.width = rect.size.width * (414 / 375);
    }
    
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.4);
    UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, CGRectGetMaxY(rect) + 60, rect.size.width, 80)];
    [self addSubview:alertView];
    self.alertView = alertView;
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
}


- (IBAction)closeThisView:(id)sender {
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
    
    
}

- (IBAction)calculateThisNumber:(id)sender {
    [self endEditing:YES];
    
    if ([self judgeCurrentEnvironment]) {
        NSInteger monthMoney = [self.monthMoney.text integerValue];
        int addYearCount = [self.addYearCount.text intValue];
        NSString * index = [NSString stringWithFormat:@"%d",addYearCount];
        CGFloat count = [[self.dataSource objectForKey:index] floatValue];
        self.resultLabel.text = [NSString stringWithFormat:@"  %.2lf",count * monthMoney];
    }
    
}
-(BOOL)judgeCurrentEnvironment
{
    if (self.monthMoney.text.length == 0) {
        self.monthMoney.text = @"1000";
    }
    if (self.addYearCount.text.length == 0) {
        self.addYearCount.text = @"10";
    }
    
     __weak __typeof(&*self)weakSelf = self;
    NSInteger monthMoney = [self.monthMoney.text integerValue];
    NSInteger addYearCount = [self.addYearCount.text integerValue];
    if ((monthMoney % 100) != 0) {
        ShowAutoHideMBProgressHUD(weakSelf.alertView,@"每月本金需是100的倍数!");
        return NO;
    }
    
    if (monthMoney < 500) {
        ShowAutoHideMBProgressHUD(weakSelf.alertView,@"每月本金必须大于等于500 !");
        return NO;
    }
    
    if (addYearCount > 30) {
        ShowAutoHideMBProgressHUD(weakSelf.alertView,@"加入年数必须小于30年 !");
        return NO;
    }
    
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * contentString;
    
    if (string.length == 0 ) {
        if (textField.text.length > 0) {
            contentString = [textField.text substringToIndex:textField.text.length - 1];
            
        }else
        {
            contentString = nil;
        }
    }else{
        contentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    if (contentString.length > 6) {
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
