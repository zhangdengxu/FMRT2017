//
//  XZEarningsCalculatorController.m
//  fmapp
//
//  Created by admin on 16/11/26.
//  Copyright © 2016年 yk. All rights reserved.
//  收益计算器

#import "XZEarningsCalculatorController.h"

@interface XZEarningsCalculatorController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollBottom;
// 到期本息
@property (nonatomic, strong) UILabel *labelPrincipalMoney;
// 利息
@property (nonatomic, strong) UILabel *labelInterestMoney;
// 月均收息金额
@property (nonatomic, strong) UILabel *labelIntMonthMoney;
// 输入金额
@property (nonatomic, strong) NSString *textInputMoney;
// 预期年利率
@property (nonatomic, strong) NSString *textYearRate;
// 期限
@property (nonatomic, strong) NSString *textTimeLimit;

@end

@implementation XZEarningsCalculatorController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    [self createEarningsCalculatorChildView];
}

- (void)createEarningsCalculatorChildView {
    __weak __typeof(&*self)weakSelf = self;
    // view到期本息
    UIView *topView = [[UIView alloc] init];
    [self.scrollBottom addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollBottom);
        make.width.equalTo(KProjectScreenWidth);
        make.top.equalTo(weakSelf.scrollBottom);
        make.height.equalTo(@130);
    }];
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *(^BlockCreateLabel)(UIColor *,NSString *) = ^(UIColor *color,NSString *text) {
        UILabel *lable = [[UILabel alloc] init];
        [topView addSubview:lable];
        lable.font = [UIFont systemFontOfSize:15.0f];
        lable.text = text;
        lable.textColor = color;
        return lable;
    };
    
    // 中间线
    UILabel *lableMidLine = BlockCreateLabel(nil,nil);
    [lableMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView);
        make.height.equalTo(@(130 - 40));
        make.width.equalTo(@0.5);
    }];
    lableMidLine.backgroundColor = XZBackGroundColor;
    
    // label到期本息
    UILabel *labelPrincipal = BlockCreateLabel(nil,@"到期本息（元）");
    [labelPrincipal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView).offset(-KProjectScreenWidth / 4.0).priorityHigh();
        make.width.equalTo(@130);
    }];
    
    // 到期本息金额
    UILabel *labelPrincipalMoney = BlockCreateLabel([UIColor redColor],@"0.00");
    [labelPrincipalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_centerY).offset(5);
        make.left.equalTo(labelPrincipal.mas_left);
        make.right.equalTo(lableMidLine.mas_left);
    }];
    self.labelPrincipalMoney = labelPrincipalMoney;
    
    // 月均收息（元）
    UILabel *labelInterestMonth =  BlockCreateLabel(nil,@"月均收息（元）");
    [labelInterestMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPrincipalMoney);
        make.centerX.equalTo(topView).offset(KProjectScreenWidth / 4.0).priorityHigh();
        make.width.equalTo(@130);
    }];
    
    // 月均收息金额
    UILabel *labelIntMonthMoney =  BlockCreateLabel([UIColor redColor],@"0.00");
    [labelIntMonthMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelInterestMonth.mas_bottom).offset(5);
        make.left.equalTo(labelInterestMonth);
        make.right.equalTo(topView);
    }];
    self.labelIntMonthMoney = labelIntMonthMoney;
    
    // 利息
    UILabel *labelInterest =  BlockCreateLabel(nil,@"利息（元）");
    [labelInterest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labelPrincipal.mas_top).offset(-5);
        make.left.equalTo(labelInterestMonth);
        make.width.equalTo(@130);
    }];
    
    // 利息金额
    UILabel *labelInterestMoney =  BlockCreateLabel([UIColor redColor],@"0.00");
    [labelInterestMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelInterest.mas_bottom).offset(5);
        make.left.equalTo(labelInterestMonth).priorityHigh();
        make.right.equalTo(topView);
    }];
    self.labelInterestMoney = labelInterestMoney;
    
    // “输入投资金额” UITextField *tfInputMoney =
    [self createViewWithWithTopView:topView text:@"输入金额（元）" placeholder:@"输入投资金额" tag:501 offSet:1];
    
    // “输入预期年利率” UITextField *tfYearRate =
    [self createViewWithWithTopView:topView text:@"预期年利率（%）" placeholder:@"输入预期年利率" tag:502 offSet:52];
    // “输入投资期限” UITextField *tfTimeLimit =
    UITextField *tfTimeLimit = [self createViewWithWithTopView:topView text:@"期限（天）" placeholder:@"输入投资期限" tag:503 offSet:103];
    
    // 注意
    UILabel *labelAttention = [[UILabel alloc] init];
    [self.scrollBottom addSubview:labelAttention];
    [labelAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.scrollBottom);
        make.top.equalTo(tfTimeLimit.mas_bottom).offset(30);
        make.width.equalTo(@(KProjectScreenWidth - 20));
//        make.right.equalTo(weakSelf.scrollBottom).offset(-10);
    }];
    labelAttention.text = @"注：计算结果仅供参考，并不构成任何形式的法律或金融意见和承诺";
    labelAttention.textColor = [UIColor lightGrayColor];
    labelAttention.numberOfLines = 0;
    labelAttention.font = [UIFont systemFontOfSize:13];
    
    //
    UIButton *btnCalculator = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollBottom addSubview:btnCalculator];
    [btnCalculator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollBottom).offset(10);
        make.width.equalTo(@(KProjectScreenWidth - 20));
        make.height.equalTo(@45);
        make.top.equalTo(labelAttention.mas_bottom).offset(30);
    }];
    btnCalculator.layer.masksToBounds = YES;
    btnCalculator.layer.cornerRadius = 3.0f;
    [btnCalculator setTitle:@"计算" forState:UIControlStateNormal];
    [btnCalculator addTarget:self action:@selector(didClickCalculatorButton) forControlEvents:UIControlEventTouchUpInside];
    [btnCalculator setBackgroundColor:XZColor(14, 93, 210)];
}

// 点击"计算"
- (void)didClickCalculatorButton {
    [self.view endEditing:YES];
    
    if (self.textInputMoney.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入投资金额");
        return;
    }else if (self.textYearRate.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入预期年利率");
        return;
    }else if (self.textTimeLimit.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入投资期限");
        return;
    }
    // 利息
    CGFloat interest = [self.textInputMoney integerValue] * [self.textYearRate floatValue] * [self.textTimeLimit integerValue] / (100.0 * 365.0);
    self.labelInterestMoney.text = [NSString stringWithFormat:@"%.2f",interest];
    // 月均收息
    CGFloat interestMonth = [self.textInputMoney integerValue] * [self.textYearRate floatValue] * 30 / (100.0 * 365.0);
    self.labelIntMonthMoney.text = [NSString stringWithFormat:@"%.2f",interestMonth];
    // 到期本息
    CGFloat money =  interest + [self.textInputMoney integerValue];
    self.labelPrincipalMoney.text = [NSString stringWithFormat:@"%.2f",money];
}

// 创建view/label/textField
- (UITextField *)createViewWithWithTopView:(UIView *)topView text:(NSString *)text placeholder:(NSString *)placeholder tag:(NSInteger)tag offSet:(CGFloat)offSet {
    __weak __typeof(&*self)weakSelf = self;
    //
    UIView *backgroudView = [[UIView alloc] init];
    [self.scrollBottom addSubview:backgroudView];
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollBottom);
        make.top.equalTo(topView.mas_bottom).offset(offSet);
        make.width.equalTo(KProjectScreenWidth);
        make.height.equalTo(@50);
    }];
    backgroudView.backgroundColor = [UIColor whiteColor];
    
    //
    UILabel *label = [[UILabel alloc] init];
    [backgroudView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroudView).offset(10);
        make.centerY.equalTo(backgroudView);
    }];
    label.text = @"输入金额";
    label.text = text;
    label.font = [UIFont systemFontOfSize:15.0f];
    
    //
    UITextField *textField = [[UITextField alloc] init];
    [backgroudView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.right.equalTo(backgroudView).offset(-10);
        make.centerY.equalTo(backgroudView);
    }];
    textField.tag = tag;
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.placeholder = placeholder;
    if (tag == 502) { // 利率，可以小数
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }else {// 天数和金额不能小数
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentRight;
    return textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }else {
        if (textField.tag == 501) { // 输入金额
            if (textField.text.length < 9) {
                return YES;
            }else {
                ShowAutoHideMBProgressHUD(self.view, @"最多只能输入9位呦");
                return NO;
            }
        }else if (textField.tag == 502) { // 预期年利率
            if (textField.text.length < 5) {
                return YES;
            }else {
                ShowAutoHideMBProgressHUD(self.view, @"最多只能输入5位呦");
                return NO;
            }
        }else { // 期限
            if (textField.text.length < 4) {
                return YES;
            }else {
                ShowAutoHideMBProgressHUD(self.view, @"最多只能输入4位呦");
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark ---- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 501) { // 输入金额
        self.textInputMoney = textField.text;
//        NSLog(@"输入金额:%@------%@",textField.text,self.textInputMoney);
    }else if (textField.tag == 502) { // 预期年利率
        self.textYearRate = textField.text;
//        NSLog(@"预期年利率:%@------%@",textField.text,self.textYearRate);
    }else { // 期限
        self.textTimeLimit = textField.text;
//        NSLog(@"期限:%@------%@",textField.text,self.textTimeLimit);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UIScrollView *)scrollBottom {
    if (!_scrollBottom) {
        _scrollBottom = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        _scrollBottom.delegate = self;
        _scrollBottom.contentSize = CGSizeMake(0, KProjectScreenHeight + 130); // + 45
        _scrollBottom.showsVerticalScrollIndicator = YES;
        _scrollBottom.backgroundColor = XZBackGroundColor;
        [self.view addSubview:_scrollBottom];
    }
    return _scrollBottom;
}

@end
