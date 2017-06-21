//
//  PhoneNumberRegisterNewViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/1/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "PhoneNumberRegisterNewViewController.h"

#import "HTTPClient+UserLoginOrRegister.h"
#import "FontAwesome.h"
#import "CodeController.h"
#import "ShareViewController.h"
#import "RegisterController.h"
#import "FindPassWordViewController.h"
#import "OpenUDID.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "LocalDataManagement.h"
#import "WLZhuCeViewController.h"
#import "RegexKitLite.h"
#import "LGTextFieldView.h"

@interface PhoneNumberRegisterNewViewController ()<UITextFieldDelegate>
@property (nonatomic,assign) BOOL ishasBeenSend;
@property (nonatomic,weak) UIButton *nextBtn;

@property (nonatomic,weak) UITextField *phoneField;
@property (nonatomic,weak) UITextField *registerPhoneField;



@property (nonatomic,strong) UIButton *sendingVtn;
@property (nonatomic,weak) UITextField *phoneCodeField;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) UITextField *seSecreatLabel;
@property (nonatomic,assign) UserPhoneCodeOperationStyle codeStyle;
@property (nonatomic,assign) int currentSeconds;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation PhoneNumberRegisterNewViewController

-(void)loadView
{
    [super loadView];
    [self createTimer];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];

//    [self.timer invalidate];
//    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"注册"];
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self UserRegisterView];
}

-(void)UserRegisterView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    //    这里添加
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    
    [mainScrollView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:mainScrollView];
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 47.0f)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机号icon@2x_03.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 17, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userPhoneNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneNumberText setReturnKeyType:UIReturnKeyNext];
    [userPhoneNumberText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneNumberText setFont:[UIFont systemFontOfSize:18.0f]];
    [userPhoneNumberText setBorderStyle:UITextBorderStyleNone];
    [userPhoneNumberText setPlaceholder:@"手机号"];
    [userPhoneNumberText setDelegate:self];
    [userPhoneNumberText setKeyboardType:UIKeyboardTypePhonePad];
    self.phoneField=userPhoneNumberText;
    [backGroundView addSubview:userPhoneNumberText];
//    //更改键盘
//    NHKeyboard *customKeyBoard1 = [NHKeyboard keyboardWithType:NHKBTypeASCIICapableONLY];
//    customKeyBoard1.enterprise = @"融托金融安全输入";
//    userPhoneNumberText.inputView = customKeyBoard1;
//    customKeyBoard1.inputSource = userPhoneNumberText;
    
    
    UIView *backGroundView1 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(backGroundView.frame) + 13,(self.view.bounds.size.width-20)/2, 47.0f)];
    backGroundView1.backgroundColor = [UIColor whiteColor];
    backGroundView1.layer.borderWidth = 0.5f;
    backGroundView1.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView1];
    
    //    输入验证码
    UITextField *identifyingCodeText = [[UITextField alloc] initWithFrame:CGRectMake(20, 1.0f, (KProjectScreenWidth-20)/2, 45.0f)];
    [identifyingCodeText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [identifyingCodeText setReturnKeyType:UIReturnKeyNext];
    [identifyingCodeText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [identifyingCodeText setFont:[UIFont systemFontOfSize:18.0f]];
    [identifyingCodeText setBorderStyle:UITextBorderStyleNone];
    [identifyingCodeText setPlaceholder:@"输入验证码"];
    [identifyingCodeText setDelegate:self];
    [identifyingCodeText setKeyboardType:UIKeyboardTypeNumberPad];
    self.phoneCodeField = identifyingCodeText;
    [backGroundView1 addSubview:identifyingCodeText];
    
    UIButton *sendingIdentifyingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateNormal];
    [sendingIdentifyingBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateHighlighted];
    
    [sendingIdentifyingBtn setTitle:@"发送验证码"
                           forState:UIControlStateNormal];
    [sendingIdentifyingBtn setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [sendingIdentifyingBtn setFrame:CGRectMake((KProjectScreenWidth-20)/2+30, 84, (KProjectScreenWidth-20)/2-30, 39)];
    [sendingIdentifyingBtn.layer setBorderWidth:0.5f];
    [sendingIdentifyingBtn.layer setCornerRadius:2.0f];
    [sendingIdentifyingBtn.layer setMasksToBounds:YES];
    sendingIdentifyingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sendingIdentifyingBtn setBackgroundColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [sendingIdentifyingBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [sendingIdentifyingBtn addTarget:self action:@selector(sendingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendingVtn = sendingIdentifyingBtn;
    [mainScrollView addSubview:sendingIdentifyingBtn];
    
    
    
    UIView *backGroundView2  = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(backGroundView1.frame) + 13,self.view.bounds.size.width-20, 47.0f)];
    backGroundView2.backgroundColor = [UIColor whiteColor];
    backGroundView2.layer.borderWidth = 0.5f;
    backGroundView2.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView2];
    
    UIImageView *clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码icon@2x_03.png"]];
    [clockImageView setFrame:CGRectMake(20, 12.0f, 17, 23)];
    [backGroundView2 addSubview:clockImageView];
    
    //    输入码
    UITextField *setSecreat = [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, (KProjectScreenWidth-20), 45.0f)];
    [setSecreat setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [setSecreat setReturnKeyType:UIReturnKeyNext];
    [setSecreat setClearButtonMode:UITextFieldViewModeWhileEditing];
    [setSecreat setFont:[UIFont systemFontOfSize:18.0f]];
    [setSecreat setBorderStyle:UITextBorderStyleNone];
    [setSecreat setPlaceholder:@"请设置密码"];
    [setSecreat setDelegate:self];
    [setSecreat setKeyboardType:UIKeyboardTypeAlphabet];
    setSecreat.secureTextEntry = YES;
    self.seSecreatLabel = setSecreat;
    [backGroundView2 addSubview:self.seSecreatLabel];
    
    //更改键盘
//    NHKeyboard *customKeyBoard2 = [NHKeyboard keyboardWithType:NHKBTypeASCIICapableONLY];
//    customKeyBoard2.enterprise = @"融托金融安全输入";
//    setSecreat.inputView = customKeyBoard2;
//    customKeyBoard2.inputSource = setSecreat;
    
    UIView * currentView;
    
    UIView *backGroundView3  = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(backGroundView2.frame) + 13,self.view.bounds.size.width-20, 47.0f)];
    backGroundView3.backgroundColor = [UIColor whiteColor];
    backGroundView3.layer.borderWidth = 0.5f;
    backGroundView3.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView3];
    
    ////指示图片
    UIImageView *phoneIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    [phoneIndicatorImageView setFrame:CGRectMake(20, 12.0f, 17, 23)];
    [backGroundView3 addSubview:phoneIndicatorImageView];
    ////文本框
    UITextField *registerPhoneField= [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [registerPhoneField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [registerPhoneField setReturnKeyType:UIReturnKeyGo];
    [registerPhoneField setPlaceholder:@"推荐人手机号"];
    [registerPhoneField setDelegate:self];
    [registerPhoneField setFont:KContentLeftTitleFontOfSize];
    [registerPhoneField setKeyboardType:UIKeyboardTypePhonePad];
    [registerPhoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [registerPhoneField setBorderStyle:UITextBorderStyleNone];
    [registerPhoneField setSecureTextEntry:YES];
    self.registerPhoneField=registerPhoneField;
    [backGroundView3 addSubview:registerPhoneField];

    NSString * enterpriseVersion = kRecommendPersonNamePhoneNumber;
    if (enterpriseVersion.length > 1) {
        backGroundView3.hidden = YES;
        currentView = backGroundView2;
    }else
    {
        backGroundView3.hidden = NO;
        currentView = backGroundView3;
    }

    
    UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slectCtn setFrame:CGRectMake(20, CGRectGetMaxY(currentView.frame) + 15, 16, 16)];
    [slectCtn setImage:[UIImage imageNamed:@"未勾选icon"] forState:UIControlStateNormal];
    [slectCtn setImage:[UIImage imageNamed:@"勾选icon"] forState:UIControlStateSelected];
    [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [slectCtn setSelected:NO];
    [mainScrollView addSubview:slectCtn];
    self.selectBtn = slectCtn;
    [self.selectBtn setSelected:YES];
    
    UILabel *delegateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(currentView.frame) + 13, KProjectScreenWidth-40, 20)];
    delegateLabel.text = @"我已阅读并同意《融托金融用户服务协议》";
    delegateLabel.font = [UIFont systemFontOfSize:12];
    [mainScrollView addSubview:delegateLabel];
    
    NSString *vStr = delegateLabel.text;
    NSString *vDStr=@"《融托金融用户服务协议》";
    NSRange range=[vStr rangeOfString:vDStr];
    NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:vStr];
    [mstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1] range:range];
    delegateLabel.attributedText=mstr;
    
    delegateLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
    
    [delegateLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                          forState:UIControlStateNormal];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                          forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"确定"
                forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(70.0f, CGRectGetMaxY(currentView.frame) + 120, KProjectScreenWidth-140, 43.0f)];
    [nextButton.layer setBorderWidth:0.5f];
    [nextButton.layer setCornerRadius:2.0f];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton setBackgroundColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [nextButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [nextButton addTarget:self action:@selector(userNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn=nextButton;
    [mainScrollView addSubview:nextButton];
    
    
}

-(void)bottomSelectAction:(UIButton *)button{
    
    button.selected=!button.selected;
    
}

-(void)labelTouchUpInside{
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"融托金融用户服务协议" AndWithShareUrl:userServiceAgreementURL];
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

-(void)Actiondo:(id)sender{
    
    [self.phoneField resignFirstResponder];
    [self.seSecreatLabel resignFirstResponder];
    [self.phoneCodeField resignFirstResponder];
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
        [self.sendingVtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self stopTimer];
        self.sendingVtn.enabled = YES;
    }
    else
    {
        self.currentSeconds--;
        NSString *secondsStr = [NSString stringWithFormat:@"重新获取验证码(%ds)",self.currentSeconds];
        self.sendingVtn.titleLabel.text = secondsStr;
        
    }
}

-(void)sendingAction:(UIButton *)button{
    

    if (!IsNormalMobileNum(self.phoneField.text)) {
        ShowImportErrorAlertView(@"请输入正确的手机号");
        return;
    }
    if (![self.self.phoneField.text isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"]) {
        ShowImportErrorAlertView(@"请输入正确的手机号");
        return;
    }
    
    self.ishasBeenSend = YES;
    // 这里开始倒计时
    self.currentSeconds=60;
    [self startTimer];
    [self.sendingVtn setTitle:[NSString stringWithFormat:@"重新获取验证码(%ds)",self.currentSeconds] forState:UIControlStateNormal];
    self.sendingVtn.enabled = NO;

    [FMHTTPClient getUserRegisterWithUserPersonalPhoneNumber:self.phoneField.text WithType:1 completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if (response.code==WebAPIResponseCodeSuccess) {

                self.codeStyle=1;
                self.phoneNumber = self.phoneField.text;
                
            }
            else if(response.code==WebAPIResponseCodeFailed)
            {
                ShowAutoHideMBProgressHUD(self.view,response.responseObject[@"msg"]);
                self.sendingVtn.enabled = YES;
                self.currentSeconds=0;
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view,@"网络太差，请稍后重试！");
            }
        });
    }];
    
}



-(void)userNextBtnClick
{
    [self.view endEditing:YES];
    if (!self.selectBtn.selected) {
        ShowImportErrorAlertView(@"您尚未勾选融托金融用户服务协议");
    }else{
        
        if (self.ishasBeenSend == YES) {
            
            if (IsStringEmptyOrNull(self.phoneCodeField.text)) {
                ShowImportErrorAlertView(@"验证码不能为空");
                return;
            }else{
               
                // 输入密码后提交
                NSString * strPassword = [self.seSecreatLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if (strPassword.length<6) {
                    ShowImportErrorAlertView(@"密码长度至少为6位");
                    return;
                }else{
                    
                    if (self.registerPhoneField.text.length > 0) {
                        if (!IsNormalMobileNum(self.registerPhoneField.text)) {
                            ShowImportErrorAlertView(@"推荐人手机号格式不符");
                            return;
                        }
                    }

                    
                    
                    NSString    *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
                    NSString * enterpriseVersion = kRecommendPersonNamePhoneNumber;
                    if (enterpriseVersion.length > 1) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        //调用企业版
                        [FMHTTPClient getUserRegisterNewWithUserWithUserName:self.phoneCodeField.text WithPassword:strPassword WhithLeixing:@"1" PersonalPhoneNumber:self.phoneField.text imei:openUDIDString withRecommendPeople:kRecommendPersonNamePhoneNumber recommendUserID:kRecommendUserID completion:^(WebAPIResponse *response) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                if (response.code==WebAPIResponseCodeSuccess){
                                    //这里调用登录方法

                                    ShowImportErrorAlertView(@"注册成功");
                                    NSDictionary * dict = (NSDictionary *)response.responseObject;
                                    
                                    NSDictionary * dataDict = dict[@"data"];
                     
                                    [self getUserLoginInforWithUser:dataDict[@"user_id"]];
                                    
                                }else{
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    NSDictionary * dict = (NSDictionary *)response.responseObject;
                                    NSString * showString = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                                    ShowImportErrorAlertView(showString);
                                }
                            });
                        }];

                    }else
                    {
                        
                        NSString * registerPhone = self.registerPhoneField.text;
                        if (registerPhone.length > 0) {
                            
                        }else
                        {
                            registerPhone = @"";
                        }
                        //调用上线版
                         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [FMHTTPClient getUserRegisterNewWithUserWithUserName:self.phoneCodeField.text WithPassword:strPassword WhithLeixing:@"1" PersonalPhoneNumber:self.phoneField.text imei:openUDIDString withRecommendPeopleNOUserID:registerPhone completion:^(WebAPIResponse *response) {
                            
                                if (response.code==WebAPIResponseCodeSuccess){
                                    //这里调用登录方法
                                    ShowImportErrorAlertView(@"注册成功");

                                    NSDictionary * dict = (NSDictionary *)response.responseObject;
                                    NSDictionary * dataDict = dict[@"data"];
                                    [self getUserLoginInforWithUser:dataDict[@"user_id"]];
                                }else{
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    NSDictionary * dict = (NSDictionary *)response.responseObject;
                                    
                                    NSString * showString = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                                    ShowImportErrorAlertView(showString);
                                    
                                }
                        }];
                    }
                }
            }
        }else
        {
            ShowImportErrorAlertView(@"请点击发送验证码");
        }
    }
}

//初次注册直接登录方法                          
-(void)getUserLoginInforWithUser:(NSString *)user_id{

     NSString  *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    __weak __typeof(&*self)weakSelf = self;
    __block NSString * strPassword = [self.seSecreatLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [FMHTTPClient getUserLoginInforWithUser:self.phoneField.text withUserPassword:strPassword completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (response.code==WebAPIResponseCodeSuccess) {
                
                [JPUSHService setAlias:openUDIDString callbackSelector:nil object:nil];
                [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                NSDictionary *userLoginDic = nil;
                userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.phoneField.text,@"UserName",strPassword,@"Password",nil];
                LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
                [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
                
              
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    
                    
                    //调用手势解锁
                    [ShareAppDelegate initWithUserAutoLogin:user_id];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:FMCreateGestureNotificationNew object:self userInfo:nil];
                    
                      [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification object:nil];//触发登录通知
                }];
                
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"登录失败");
                NSString * showString = StringForKeyInUnserializedJSONDic(response.responseObject, @"msg");
                if (showString.length) {
                    ShowImportErrorAlertView(showString);
                }else
                {
                    ShowImportErrorAlertView(@"网络错误");
                }
            }
    }];

}


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
