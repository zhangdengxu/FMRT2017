//
//  WLChangePhoneNumberViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLChangePhoneNumberViewController.h"
#import "RegexKitLite.h"
#import "IQKeyboardManager.h"

@interface WLChangePhoneNumberViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITextField *realNameTextField;//真实姓名
@property(nonatomic,strong)UITextField *identificationTextField;//身份证号
@property(nonatomic,strong)UITextField *PhoneNumberTextField;//手机号
@property(nonatomic,strong)UITextField *coderTextField;//验证码
@property(nonatomic,strong)UIButton *sendingVtn;//发送验证码按钮
@property(nonatomic,strong)UIButton *bottomBtn;//完成修改按钮
@property(nonatomic,strong)UILabel * theTitleLabel;//您现在的电话。。。
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong)NSString *Mophone;
@property (nonatomic,assign) int currentSeconds;
@property (nonatomic,assign) BOOL ishasBeenSend;
@end

@implementation WLChangePhoneNumberViewController
-(void)loadView
{
    [super loadView];
    [self createTimer];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"修改手机号"];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAction)];
    
    [self.view addGestureRecognizer:tapGesture];
    //这里添加判断条件
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming isEqualToString:@"1"]) {
        //实名
        [self createAnotherContentView];
    }else{
        //未实名
        [self createContentView];
    }
    
    [self getDataFromeNet:@"0"];
    
}

-(void)createContentView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 55)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = @"您现在使用的手机号码是：15168968668";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat font = 18;
    if (KProjectScreenWidth<350) {
        titleLabel.font = [UIFont systemFontOfSize:12];
        font = 16;
    }
    titleLabel.textColor = [HXColor colorWithHexString:@"333333"];
    
    self.theTitleLabel = titleLabel;
    [self.view addSubview:self.theTitleLabel];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, KProjectScreenWidth, 110)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:middleView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54.5, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:[HXColor colorWithHexString:@"#f4f5f9"]];
    [middleView addSubview:lineView];
    
    UITextField *newPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, KProjectScreenWidth-20, 55.0f)];
    [newPhoneNumber setReturnKeyType:UIReturnKeyNext];
    [newPhoneNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
    [newPhoneNumber setFont:[UIFont systemFontOfSize:16.0f]];
    [newPhoneNumber setBorderStyle:UITextBorderStyleNone];
    [newPhoneNumber setPlaceholder:@"请输入新的手机号"];
    [newPhoneNumber setDelegate:self];
    newPhoneNumber.tag = 123;
    [newPhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    //    [newPhoneNumber becomeFirstResponder];
    self.PhoneNumberTextField=newPhoneNumber;
    [middleView addSubview:newPhoneNumber];
    
    UITextField *coderTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 55, KProjectScreenWidth-60, 55.0f)];
    [coderTextField setReturnKeyType:UIReturnKeyNext];
    [coderTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [coderTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [coderTextField setBorderStyle:UITextBorderStyleNone];
    [coderTextField setPlaceholder:@"请输入验证码"];
    [coderTextField setDelegate:self];
    [coderTextField setKeyboardType:UIKeyboardTypePhonePad];
    coderTextField.tag = 321;
    self.coderTextField=coderTextField;
    [middleView addSubview:coderTextField];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 60, 55)];
    [codeLabel setTextColor:[HXColor colorWithHexString:@"333333"]];
    [codeLabel setText:@"验证码"];
    [middleView addSubview: codeLabel];
    
    UIButton *sendingIdentifyingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                     forState:UIControlStateNormal];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                     forState:UIControlStateHighlighted];
    
    [sendingIdentifyingBtn setTitle:@"点击获取"
                           forState:UIControlStateNormal];
    [sendingIdentifyingBtn setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [sendingIdentifyingBtn setFrame:CGRectMake((KProjectScreenWidth-88), 69.5, 78, 26)];
    [sendingIdentifyingBtn.layer setBorderWidth:0.5f];
    [sendingIdentifyingBtn.layer setCornerRadius:13.0f];
    [sendingIdentifyingBtn.layer setMasksToBounds:YES];
    sendingIdentifyingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [sendingIdentifyingBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [sendingIdentifyingBtn addTarget:self action:@selector(sendingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendingVtn = sendingIdentifyingBtn;
    [middleView addSubview:sendingIdentifyingBtn];
    
    UIImageView *imagV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 175, 11, 11*9/8)];
    [imagV setImage:[UIImage imageNamed:@"微商_充值_注意"]];
    [self.view addSubview:imagV];
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 167, KProjectScreenWidth-25, 29)];
    [bottomLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [bottomLabel setText:@"注册手机号和银行卡预留手机号必须一致"];
    [bottomLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:bottomLabel];
    [self createBottomButton];
    
}

/**
 *另一种状态下的列表形态
 */
-(void)createAnotherContentView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 55)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = @"您现在使用的手机号码是：15168968668";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat font = 18;
    if (KProjectScreenWidth<350) {
        titleLabel.font = [UIFont systemFontOfSize:12];
        font = 16;
    }
    titleLabel.textColor = [HXColor colorWithHexString:@"333333"];
    
    self.theTitleLabel = titleLabel;
    [self.view addSubview:self.theTitleLabel];
    
    
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, KProjectScreenWidth, 220)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:middleView];
    
    for (int i = 0; i<3; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55*(i+1)-0.5, KProjectScreenWidth, 1)];
        [lineView setBackgroundColor:[HXColor colorWithHexString:@"#f4f5f9"]];
        [middleView addSubview:lineView];
    }
    
    
    /**
     *真实姓名
     */
    UILabel *realNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 55)];
    [realNameLabel setTextColor:[HXColor colorWithHexString:@"333333"]];
    [realNameLabel setText:@"真实姓名"];
    [middleView addSubview: realNameLabel];
    
    UITextField *realNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, KProjectScreenWidth - 90 - 10, 55.0f)];
    [realNameTextField setReturnKeyType:UIReturnKeyNext];
    [realNameTextField setTextAlignment:NSTextAlignmentRight];
    [realNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [realNameTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [realNameTextField setBorderStyle:UITextBorderStyleNone];
    [realNameTextField setPlaceholder:@"请输入您身份证上的姓名"];
    [realNameTextField setDelegate:self];
    realNameTextField.tag = 111;
    //    [realNameTextField setKeyboardType:UIKeyboardTypeDefault];
    //    [newPhoneNumber becomeFirstResponder];
    self.realNameTextField=realNameTextField;
    [middleView addSubview:self.realNameTextField];
    
    /**
     *身份证号
     */
    UILabel *identificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 70, 55)];
    [identificationLabel setTextColor:[HXColor colorWithHexString:@"333333"]];
    [identificationLabel setText:@"身份证号"];
    [middleView addSubview: identificationLabel];
    
    UITextField *identificationTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 55, KProjectScreenWidth - 90 - 10, 55.0f)];
    [identificationTextField setReturnKeyType:UIReturnKeyNext];
    [identificationTextField setTextAlignment:NSTextAlignmentRight];
    [identificationTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [identificationTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [identificationTextField setBorderStyle:UITextBorderStyleNone];
    [identificationTextField setPlaceholder:@"请输入您的身份证号"];
    [identificationTextField setDelegate:self];
    identificationTextField.tag = 222;
    [identificationTextField setKeyboardType:UIKeyboardTypeDefault];
    //    [newPhoneNumber becomeFirstResponder];
    self.identificationTextField=identificationTextField;
    [middleView addSubview:identificationTextField];
    
    /**
     *手机号
     */
    UILabel *newPhoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 60, 55)];
    [newPhoneNumberLabel setTextColor:[HXColor colorWithHexString:@"333333"]];
    [newPhoneNumberLabel setText:@"手机号"];
    [middleView addSubview: newPhoneNumberLabel];
    
    UITextField *newPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(90, 110, KProjectScreenWidth - 90 - 10, 55.0f)];
    [newPhoneNumber setReturnKeyType:UIReturnKeyNext];
    [newPhoneNumber setTextAlignment:NSTextAlignmentRight];
    [newPhoneNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
    [newPhoneNumber setFont:[UIFont systemFontOfSize:16.0f]];
    [newPhoneNumber setBorderStyle:UITextBorderStyleNone];
    [newPhoneNumber setPlaceholder:@"请输入您的手机号"];
    [newPhoneNumber setDelegate:self];
    newPhoneNumber.tag = 123;
    [newPhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    //    [newPhoneNumber becomeFirstResponder];
    self.PhoneNumberTextField=newPhoneNumber;
    [middleView addSubview:newPhoneNumber];
    
    /**
     *验证码
     */
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 165, 60, 55)];
    [codeLabel setTextColor:[HXColor colorWithHexString:@"333333"]];
    [codeLabel setText:@"验证码"];
    [middleView addSubview: codeLabel];
    
    UITextField *coderTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 165, KProjectScreenWidth-60, 55.0f)];
    [coderTextField setReturnKeyType:UIReturnKeyNext];
    [coderTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [coderTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [coderTextField setBorderStyle:UITextBorderStyleNone];
    [coderTextField setPlaceholder:@"请输入验证码"];
    [coderTextField setDelegate:self];
    [coderTextField setKeyboardType:UIKeyboardTypePhonePad];
    coderTextField.tag = 321;
    self.coderTextField=coderTextField;
    [middleView addSubview:coderTextField];
    
    UIButton *sendingIdentifyingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                     forState:UIControlStateNormal];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                     forState:UIControlStateHighlighted];
    
    [sendingIdentifyingBtn setTitle:@"点击获取"
                           forState:UIControlStateNormal];
    [sendingIdentifyingBtn setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [sendingIdentifyingBtn setFrame:CGRectMake((KProjectScreenWidth-88), 179.5, 78, 26)];
    [sendingIdentifyingBtn.layer setBorderWidth:0.5f];
    [sendingIdentifyingBtn.layer setCornerRadius:13.0f];
    [sendingIdentifyingBtn.layer setMasksToBounds:YES];
    sendingIdentifyingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [sendingIdentifyingBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [sendingIdentifyingBtn addTarget:self action:@selector(sendingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendingVtn = sendingIdentifyingBtn;
    [middleView addSubview:sendingIdentifyingBtn];
    
    //    UIImageView *imagV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 285, 11, 11*9/8)];
    //    [imagV setImage:[UIImage imageNamed:@"微商_充值_注意"]];
    //    [self.view addSubview:imagV];
    //    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 277, KProjectScreenWidth-25, 29)];
    //    [bottomLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    //    [bottomLabel setText:@"注册手机号和银行卡预留手机号必须一致"];
    //    [bottomLabel setFont:[UIFont boldSystemFontOfSize:12]];
    //    [self.view addSubview:bottomLabel];
    [self createBottomButton];
}

-(void)createBottomButton{
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setBackgroundColor:[HXColor colorWithHexString:@"0159d5"]];
    [bottomButton setTitle:@"完成修改" forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton setFrame:CGRectMake(10, KProjectScreenHeight-200, KProjectScreenWidth-20, 50)];
    [self.view addSubview:bottomButton];
    bottomButton.tag = 852;
    self.bottomBtn = bottomButton;
}

/**
 *完成修改
 */
-(void)bottomBtnAction{
    
    [self changePhoneNumber];
}

/**
 *查询手机号
 */
-(void)getDataFromeNet:(NSString *)Option{
    [self.theTitleLabel setText:[NSString stringWithFormat:@"您现在使用的手机号码是：%@",[CurrentUserInformation sharedCurrentUserInfo].mobile]];
    CGFloat font = 18;
    if (KProjectScreenWidth<350) {
        self.theTitleLabel.font = [UIFont systemFontOfSize:12];
        font = 16;
    }
    NSString *vStr = self.theTitleLabel.text;
    NSString *Str=[vStr substringFromIndex:12];
    NSRange range=[vStr rangeOfString:Str];
    NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:vStr];
    [mstr addAttribute:NSForegroundColorAttributeName value:[HXColor colorWithHexString:@"ff6633"] range:range];
    [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    self.theTitleLabel.attributedText=mstr;
    //    int timestamp = [[NSDate date]timeIntervalSince1970];
    //    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    //    NSString *tokenlow=[token lowercaseString];
    //   NSDictionary *parameter = @{
    //                 @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
    //                 @"AppId":@"huiyuan",
    //                 @"AppTime":[NSNumber numberWithInt:timestamp],
    //                 @"Mophone":@"",
    //                 @"Token":tokenlow
    //                 };
    //
    //    __weak __typeof(&*self)weakSelf = self;
    //
    //    [FMHTTPClient postPath:kXZUniversalTestUrl(@"QueryPhoneNo") parameters:parameter completion:^(WebAPIResponse *response) {
    //
    //        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
    //
    //        if ([status integerValue] == 0) {
    //
    //                NSDictionary *dic = response.responseObject[@"data"];
    //                self.Mophone = [dic objectForKey:@"Mophone"];
    //                [self.theTitleLabel setText:[NSString stringWithFormat:@"您现在使用的手机号码是：%@",[dic objectForKey:@"Mophone"]]];
    //
    //
    //        }else
    //        {
    //            ShowAutoHideMBProgressHUD(weakSelf.view,[NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
    //
    //        }
    //
    //    }];
    
}

-(void)changePhoneNumber{
    /**
     *验证码校验
     */
    if (!self.PhoneNumberTextField.text.length) {
        ShowAutoHideMBProgressHUD(self.view,@"请输入手机号");
        return;
    }
    if (!self.coderTextField.text.length) {
        ShowAutoHideMBProgressHUD(self.view,@"请输入验证码");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"Code":self.coderTextField.text,
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"TransType":@"1",
                                 @"Token":tokenlow,
                                 @"PhoneNum":self.PhoneNumberTextField.text
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"IdentifyCodeCheck") parameters:parameter completion:^(WebAPIResponse *response) {
        
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        
        if ([status integerValue] == 0) {
            [self finashChange];
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,[NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            
        }
        
    }];
    
}

-(void)finashChange{
    /**
     *修改手机号
     */
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming isEqualToString:@"1"]) {
        if (!self.realNameTextField.text.length) {
            ShowAutoHideMBProgressHUD(self.view,@"请输入真实姓名");
            return;
        }
        if (!self.identificationTextField.text.length) {
            ShowAutoHideMBProgressHUD(self.view,@"请输入身份证号");
            return;
        }
    }
    if (!self.PhoneNumberTextField.text.length) {
        ShowAutoHideMBProgressHUD(self.view,@"请输入手机号");
        return;
    }
    if (!self.coderTextField.text.length) {
        ShowAutoHideMBProgressHUD(self.view,@"请输入验证码");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    __weak __typeof(&*self)weakSelf = self;
    NSDictionary * parameter;
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming isEqualToString:@"1"]){
        
        parameter = @{
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"AppId":@"huiyuan",
                      @"Mophone":self.PhoneNumberTextField.text,
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Name":self.realNameTextField.text,
                      @"IdNo":self.identificationTextField,
                      @"Token":tokenlow
                      
                      };
    }else{
        parameter = @{
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"AppId":@"huiyuan",
                      @"Mophone":self.PhoneNumberTextField.text,
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow
                      
                      };
        
    }
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"ModifyPhoneNo") parameters:parameter completion:^(WebAPIResponse *response) {
        
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        
        if ([status integerValue] == 0) {
            //重新给user类mobile赋值
            [CurrentUserInformation sharedCurrentUserInfo].mobile = self.PhoneNumberTextField.text;
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"手机号码修改成功，下次登录时请使用新手机号登录！" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 1000;
            [alert show];
            
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,[NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            
        }
        
    }];
    
    
}



-(void)resignAction{
    
    [self.view endEditing:YES];
}

-(void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate  distantFuture]];
}
-(void)startTimer
{
    [_timer setFireDate:[NSDate  distantPast]];
}
-(void)stopTimer
{
    [_timer setFireDate:[NSDate  distantFuture]];
}
- (void)timerChange
{
    if (self.currentSeconds==0) {
        [self.sendingVtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.sendingVtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                   forState:UIControlStateNormal];
        [self stopTimer];
        self.sendingVtn.enabled = YES;
    }
    else
    {
        self.currentSeconds--;
        NSString *secondsStr = [NSString stringWithFormat:@"已发送(%ds)",self.currentSeconds];
        self.sendingVtn.titleLabel.text = secondsStr;
        
    }
}

-(void)sendingAction:(UIButton *)button{
    
    
    if (!IsNormalMobileNum(self.PhoneNumberTextField.text)) {
        ShowImportErrorAlertView(@"请输入正确的手机号");
        return;
    }
    if (![self.self.PhoneNumberTextField.text isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"]) {
        ShowImportErrorAlertView(@"请输入正确的手机号");
        return;
    }
    
    self.ishasBeenSend = YES;
    // 这里开始倒计时
    self.currentSeconds=60;
    [self startTimer];
    [self.sendingVtn setTitle:[NSString stringWithFormat:@"已发送(%ds)",self.currentSeconds] forState:UIControlStateNormal];
    [self.sendingVtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"CDCDCD"])
                               forState:UIControlStateNormal];
    self.sendingVtn.enabled = NO;
    
    /*
     这里请求发送验证码
     */
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"TransType":@"1",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"PhoneNum":self.PhoneNumberTextField.text
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"IdentifyCodeSend") parameters:parameter completion:^(WebAPIResponse *response) {
        
        //        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            
            
        }else if(response.code==WebAPIResponseCodeFailed)
        {
            self.sendingVtn.enabled = YES;
            self.currentSeconds=0;
            [self.sendingVtn setBackgroundImage:createImageWithColor([HXColor colorWithHexString:@"0099e9"])
                                       forState:UIControlStateNormal];
            
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,[NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            
        }
        
    }];
    
}

/**
 *限制只能输入数字
 */
- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9.]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark ---- UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.ishasBeenSend == YES) {
        
        if (IsStringEmptyOrNull(self.PhoneNumberTextField.text)) {
            ShowImportErrorAlertView(@"验证码不能为空");
            return;
        }
    }
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ---- UITextView delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 123) {
        if (range.location>10) {
            return NO;
        }
    }else if (textField.tag == 321){
        if (range.location>6) {
            return NO;
        }
    }
    if (textField.tag == 123 || textField.tag == 321) {
        return [self validateNumberByRegExp:string];
    }else{
        return YES;
    }
    
}

@end
