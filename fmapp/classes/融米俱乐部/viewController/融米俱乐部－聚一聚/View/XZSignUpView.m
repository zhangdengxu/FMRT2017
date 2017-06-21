//
//  XZSignUpView.m
//  fmapp
//
//  Created by admin on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//  报名

#import "XZSignUpView.h"
#import "RegexKitLite.h" // 判断手机号
// 判断是否为iOS8.2
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)

@interface XZSignUpView()<UITextFieldDelegate>
/** 姓名输入框 */
@property (nonatomic, strong) UITextField *textName;
/** 背景图 */
@property (nonatomic, strong) UIView *viewBackGround;
/** 手机号输入框 */
@property (nonatomic, strong) UITextField *textPhoneNumber;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *btnSubmit;
@end

@implementation XZSignUpView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpSignUpView];
        // 添加监听，当键盘出现时收到消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        // 添加监听，当键盘退出时收到消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textName.text.length == 0) { // 键盘弹出
        self.viewBackGround.frame = CGRectMake(0, KProjectScreenHeight-height-300, KProjectScreenWidth, 300);
    }else{
        CGRect rect = CGRectMake(0, KProjectScreenHeight - self.viewBackGround.frame.size.height-height, KProjectScreenWidth, self.viewBackGround.frame.size.height);
        self.viewBackGround.frame = rect;
    }
}

// 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.textName.text.length == 0) {
        self.viewBackGround.frame = CGRectMake(0, KProjectScreenHeight-300, KProjectScreenWidth, 300);
    }else{
        CGRect rect = CGRectMake(0, KProjectScreenHeight - self.viewBackGround.frame.size.height, KProjectScreenWidth, self.viewBackGround.frame.size.height);
        self.viewBackGround.frame = rect;
    }
}

- (void)setUpSignUpView {
    /** 背景图 */
    UIView *viewBackGround = [[UIView alloc]init];
    [self addSubview:viewBackGround];
    [viewBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@300);
    }];
    self.viewBackGround = viewBackGround;
    viewBackGround.backgroundColor = [UIColor whiteColor];
    
    /** 关闭按钮 */
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [viewBackGround addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBackGround.mas_top).offset(20);
        make.right.equalTo(viewBackGround.mas_right).offset(-20);
        make.height.and.width.equalTo(@18);
    }];
    [btnClose addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"签到关闭icon_03"] forState:UIControlStateNormal];
    
    /** 姓名 */
    UILabel *labelName = [[UILabel alloc]init];
    [viewBackGround addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(btnClose.mas_bottom).offset(10);
    }];
    labelName.text = @"姓名";
    
    /** 姓名输入框 */
    UITextField *textName = [[UITextField alloc]init];
    [viewBackGround addSubview:textName];
    [textName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_left);
        make.top.equalTo(labelName.mas_bottom).offset(5);
        make.right.equalTo(btnClose.mas_right);
        make.height.equalTo(@45);
    }];
    self.textName = textName;
    textName.borderStyle = UITextBorderStyleRoundedRect;
    
    /** 手机号 */
    UILabel *labelPhoneNumber = [[UILabel alloc]init];
    [viewBackGround addSubview:labelPhoneNumber];
    [labelPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_left);
        make.top.equalTo(textName.mas_bottom).offset(20);
    }];
    labelPhoneNumber.text = @"手机号";
    
    /** 手机号输入框 */
    UITextField *textPhoneNumber = [[UITextField alloc]init];
    [viewBackGround addSubview:textPhoneNumber];
    [textPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_left);
        make.top.equalTo(labelPhoneNumber.mas_bottom).offset(5);
        make.right.equalTo(btnClose.mas_right);
        make.height.equalTo(textName.mas_height);
    }];
    self.textPhoneNumber = textPhoneNumber;
    textPhoneNumber.delegate = self;
    textPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    textPhoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    
    /** 提交按钮 */
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewBackGround addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textPhoneNumber.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.right.equalTo(textPhoneNumber.mas_right);
        make.height.equalTo(textName.mas_height);
    }];
    self.btnSubmit = btnSubmit;
    [btnSubmit addTarget:self action:@selector(didClickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    if (iOS8) {
         [btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:17 weight:2]];
    }else {
         [btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
    [btnSubmit setBackgroundColor:XZColor(14, 93, 210)];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 5.0f;
    // 
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    [self.btnSubmit setTitle:btnTitle forState:UIControlStateNormal]; // 我要报名
}

// 点击关闭按钮
- (void)didClickCloseButton:(UIButton *)button {
    
    if (self.blockCloseBtn) {
        self.blockCloseBtn(button);
    }
    [self removeFromSuperview];
}

// 点击提交按钮
- (void)didClickSubmitButton:(UIButton *)button {
    [self endEditing:YES];
    if (self.textName.text.length == 0) {
        ShowAutoHideMBProgressHUD(self,@"请输入姓名");
        return;
    }else if (![self.textPhoneNumber.text isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"]) {
        ShowAutoHideMBProgressHUD(self,@"请输入正确手机号");
        return;
    }
    if (self.blockSubmitBtn) {
        self.blockSubmitBtn(self.textName.text,self.textPhoneNumber.text);
    }
    // 发送成功之后清空
    self.textName.text = nil;
    self.textPhoneNumber.text = nil;
    self.viewBackGround.frame = CGRectMake(0, KProjectScreenHeight-300, KProjectScreenWidth, 300);
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 11) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
