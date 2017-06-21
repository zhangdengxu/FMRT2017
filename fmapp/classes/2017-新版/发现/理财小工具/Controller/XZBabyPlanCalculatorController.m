//
//  XZBabyPlanCalculatorController.m
//  fmapp
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//  宝贝计划控制器

#import "XZBabyPlanCalculatorController.h"

@interface XZBabyPlanCalculatorController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollBottom;
// 每月本金
@property (nonatomic, strong) NSString *textInputMoney;
// 加入年数
@property (nonatomic, strong) NSString *textYearAdd;
// 到期本息
@property (nonatomic, strong) UITextField *tfTimeLimit;
@property (nonatomic, strong) NSDictionary *dataSource;
@end

@implementation XZBabyPlanCalculatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self createBabyPlanCalculatorChildView];
    //
    [self getBabyPlanRateFromLocalPlist];
}

-(void)getBabyPlanRateFromLocalPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoneyCoefficient" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataSource = dictionary[@"data"];
}

- (void)createBabyPlanCalculatorChildView {
    [self.view addSubview:self.scrollBottom];
    __weak __typeof(&*self)weakSelf = self;
    // “输入每月本金” UITextField *tfInputMoney =
    [self createViewWithWithTopView:self.scrollBottom text:@"每月本金（元）" placeholder:@"输入每月本金" tag:510 offSet:1];
    
    // “输入加入年数” UITextField *tfYearRate =
    [self createViewWithWithTopView:self.scrollBottom text:@"加入年数" placeholder:@"输入加入年数" tag:520 offSet:52];
    // “到期本息” UITextField *tfTimeLimit =
    UITextField *tfTimeLimit = [self createViewWithWithTopView:self.scrollBottom text:@"到期本息（元）" placeholder:@"" tag:530 offSet:103];
    self.tfTimeLimit = tfTimeLimit;
    tfTimeLimit.userInteractionEnabled = NO;
    tfTimeLimit.textColor = XZColor(51, 51, 51);
    
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
        ShowAutoHideMBProgressHUD(self.view, @"请输入每月本金");
        return;
    }else if (self.textYearAdd.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入加入年数");
        return;
    }else if([self.textYearAdd integerValue] > 30){
        ShowAutoHideMBProgressHUD(self.view, @"当前只支持30年以内");
        return;
    }
    // 到期本息
    NSInteger monthMoney = [self.textInputMoney integerValue];
    int addYearCount = [self.textYearAdd intValue];
    NSString *index = [NSString stringWithFormat:@"%d",addYearCount];
    CGFloat count = [[self.dataSource objectForKey:index] floatValue];
    self.tfTimeLimit.text = [NSString stringWithFormat:@"%.2lf",count * monthMoney];
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
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentRight;
    return textField;
}

#pragma mark ---- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 510) { // 输入金额
        self.textInputMoney = textField.text;
    }else if (textField.tag == 520) { // 加入年数
        self.textYearAdd = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }else {
        if (textField.tag == 510) { // 输入金额
            if (textField.text.length < 5) {
                return YES;
            }else {
                ShowAutoHideMBProgressHUD(self.view, @"最多只能输入5位呦");
                return NO;
            }
        }else if (textField.tag == 520) { // 加入年数
            if (textField.text.length < 2) {
                return YES;
            }else {
                ShowAutoHideMBProgressHUD(self.view, @"最多只能输入2位呦");
                return NO;
            }
        }
    }
    return YES;
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
    }
    return _scrollBottom;
}

@end
