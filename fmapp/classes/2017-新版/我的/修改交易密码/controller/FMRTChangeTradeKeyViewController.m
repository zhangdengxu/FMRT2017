//
//  FMRTChangeTradeKeyViewController.m
//  fmapp
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTChangeTradeKeyViewController.h"
#import "RegexKitLite.h"
#import "MZTimerLabel.h"
#import "IQKeyboardManager.h"
#import "WLFirstPageHeaderViewController.h"

@interface FMRTChangeTradeKeyViewController ()<MZTimerLabelDelegate>

@property (nonatomic, weak) UITextField *phoneTextField,*keyTextField;
@property (nonatomic, strong)MZTimerLabel *keytimer;
@property (nonatomic, weak)UIButton *getBtn;

@end

@implementation FMRTChangeTradeKeyViewController


-(MZTimerLabel *)keytimer{
    if (!_keytimer) {
        _keytimer = ({
            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
            timer.timeFormat = @"ss";
            timer.timeLabel.font = [UIFont systemFontOfSize:13.0];
            timer.timeLabel.textAlignment = NSTextAlignmentRight;
            timer.delegate = self;
            timer;
        });
    }
    return _keytimer;
}

-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType{

    self.getBtn.enabled = NO;
    if ([timerLabel.timeLabel.text doubleValue]) {
        [self.getBtn setTitle:[NSString stringWithFormat:@"已发送(%@)",timerLabel.timeLabel.text] forState:(UIControlStateDisabled)];//
//        [self.getBtn setBackgroundImage:[UIImage imageNamed:@"徽商点击获取_灰色2"] forState:(UIControlStateDisabled)];
//        NSLog(@"%@",timerLabel.timeLabel.text);
    }
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
    
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    
    if (self.typeTitle == titleSetting) {
        [self settingNavTitle:@"交易密码设置"];
    }else{
        [self settingNavTitle:@"交易密码重置"];
    }
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(110);
        make.top.equalTo(self.view.top);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"预留手机号";
    nameLabel.textColor  =[HXColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nameLabel];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(self.view.top).offset(20);
    }];
    
    UIView *bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.view addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(1);
        make.top.equalTo(nameLabel.bottom).offset(20);
    }];
    
    
    UILabel *keyLabel = [[UILabel alloc]init];
    keyLabel.text = @"验证码";
    keyLabel.textColor  =[HXColor colorWithHexString:@"333333"];
    keyLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:keyLabel];
    
    [keyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(bottomline.bottom).offset(20);
    }];
    
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.text = [CurrentUserInformation sharedCurrentUserInfo].mobile;
//    phoneTextField.placeholder = @"请输入预留手机号";
    phoneTextField.keyboardType= UIKeyboardTypePhonePad;
    phoneTextField.enabled = NO;
//    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?14:15];
    self.phoneTextField = phoneTextField;
    [self.view addSubview:phoneTextField];
    [phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(100);
        make.top.equalTo(self.view.top).offset(20);
        make.right.equalTo(self.view.right).offset(-10);

    }];
    
    UITextField *keyTextField = [[UITextField alloc]init];
    keyTextField.keyboardType= UIKeyboardTypePhonePad;
    keyTextField.placeholder = @"请输入收到的验证码";
    keyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    keyTextField.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?12:14];
    self.keyTextField = keyTextField;
    [self.view addSubview:keyTextField];
    [keyTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(100);
        make.centerY.equalTo(keyLabel.centerY);
        make.right.equalTo(self.view.right).offset(-100);
    }];
    
    UIButton *getBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"微商_点击获取"] forState:(UIControlStateNormal)];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"徽商点击获取_灰色2"] forState:(UIControlStateDisabled)];

    self.getBtn = getBtn;
    getBtn.layer.cornerRadius = 20;
    getBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [getBtn setTitle:@"点击获取" forState:(UIControlStateNormal)];
    [getBtn addTarget:self action:@selector(getAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:getBtn];
    [getBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(keyLabel.centerY);
        make.right.equalTo(self.view.right).offset(-10);
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"微商_充值_确认充值"] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view.bottom).offset(-40);
        make.height.equalTo(45);
    }];
    
}


- (void)sureAction{
    
    NSString *keyString = [self.keyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (IsStringEmptyOrNull(keyString)) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入收到的验证码！");
        return ;
    }
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@&TransType=%@&PhoneNum=%@&Code=%@",kXZUniversalTestUrl(@"IdentifyCodeCheck"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1",@"2",[CurrentUserInformation sharedCurrentUserInfo].mobile,keyString];
    NSLog(@"获取验证码接口%@",string);
    
    FMWeakSelf;
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        NSLog(@"验证验证码%@",response.responseObject);
        
        if (response.responseObject) {
            
            if (response.code==WebAPIResponseCodeSuccess){
                [weakSelf sureLastSure];
            }else{
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
        }
    }];
}

- (void)sureLastSure{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@",kXZUniversalTestUrl(@"LLPassWordSet"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];
    
    WLFirstPageHeaderViewController *webVC  = [[WLFirstPageHeaderViewController alloc]init];

    if (self.typeTitle == titleSetting) {
        webVC.navTitle = @"交易密码设置";
    }else{
        webVC.navTitle = @"交易密码重置";
    }
    webVC.shareURL = string;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)requestForcoreInformation{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@&TransType=%@&PhoneNum=%@",kXZUniversalTestUrl(@"IdentifyCodeSend"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1",@"2",[CurrentUserInformation sharedCurrentUserInfo].mobile];
    NSLog(@"获取验证码接口%@",string);

    FMWeakSelf;
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        NSLog(@"获取验证码%@",response.responseObject);
        
        if (response.responseObject) {
            
            if (response.code==WebAPIResponseCodeSuccess){
                
            }else{
                
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
                
                [weakSelf.keytimer pause];
                [weakSelf.keytimer reset];
                weakSelf.getBtn.enabled = YES;
                [weakSelf.keytimer setCountDownTime:60];
                [weakSelf.getBtn setTitle:@"重新获取" forState:(UIControlStateNormal)];
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
            [weakSelf.keytimer pause];
            [weakSelf.keytimer reset];
            weakSelf.getBtn.enabled = YES;
            [weakSelf.keytimer setCountDownTime:60];
            [weakSelf.getBtn setTitle:@"重新获取" forState:(UIControlStateNormal)];
        }
    }];
}

- (void)getAction{
    
//    NSString *string = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if (IsStringEmptyOrNull(string)) {
//        ShowAutoHideMBProgressHUD(self.view, @"请输入预留手机号码！");
//        return ;
//    }else{
//        if (![string isMatchedByRegex:@"^1\\d{10}$"]) {
//            ShowAutoHideMBProgressHUD(self.view, @"请输入正确的手机号码！");
//            return ;
//        }
//    }
//
    
    [self requestForcoreInformation];
    [self.keytimer setCountDownTime:60];
    FMWeakSelf;
    [self.keytimer startWithEndingBlock:^(NSTimeInterval countTime) {
        
        [weakSelf.keytimer pause];
        [weakSelf.keytimer reset];
        weakSelf.getBtn.enabled = YES;
        [weakSelf.getBtn setTitle:@"重新获取" forState:(UIControlStateNormal)];

    }];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.keytimer pause];
    [self.keytimer reset];
    self.getBtn.enabled = YES;
    [self.getBtn setTitle:@"重新获取" forState:(UIControlStateNormal)];

}

- (void)dealloc{
    [self.keytimer pause];
    [self.keytimer reset];
    self.keytimer.delegate = nil;
}


@end
