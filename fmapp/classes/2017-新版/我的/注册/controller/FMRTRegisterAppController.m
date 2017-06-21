//
//  FMRTRegisterAppController.m
//  fmapp
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRegisterAppController.h"
#import "FMRTRegisterAppCell.h"
#import "FMRTRegisterAppFootView.h"
#import "ShareViewController.h"
#import "RegexKitLite.h"
#import "MZTimerLabel.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "OpenUDID.h"
#import "JPUSHService.h"
#import "LocalDataManagement.h"
#import "AppDelegate.h"
#import "FMRTAddCardToView.h"
#import "FMRTChangeTradeKeyViewController.h"
#import "IQKeyboardManager.h"


static NSString *FMRTRegisterAppCellID = @"FMRTRegisterAppCellID";

@interface FMRTRegisterAppController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MZTimerLabelDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger sendeNum;
@property (nonatomic, strong)MZTimerLabel *timer;
@property (nonatomic, weak)  FMRTRegisterAppFootView *footView;

@end

@implementation FMRTRegisterAppController

-(MZTimerLabel *)timer{
    if (!_timer) {
        _timer = ({
            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
            timer.timeFormat = @"ss";
            timer.timeLabel.font = [UIFont systemFontOfSize:13.0];
            timer.timeLabel.textAlignment = NSTextAlignmentRight;
            timer.delegate = self;
            timer;
        });
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"注册"];
    [self createTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHideall)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (void)keyboardHideall{
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.timer pause];
    [self.timer reset];
    self.timer.delegate = nil;
}

- (void)dealloc{
    [self.timer pause];
    [self.timer reset];
    self.timer.delegate = nil;
}

- (void)keyboardHide{
    [self.view endEditing:YES];
}

- (void)createTableView{
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight) style:(UITableViewStylePlain)];
        tableview.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview;
    });

    [_tableView registerClass:[FMRTRegisterAppCell class] forCellReuseIdentifier:FMRTRegisterAppCellID];
    [self.view addSubview:_tableView];
    
    FMRTRegisterAppFootView *footView = [[FMRTRegisterAppFootView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 150)];
    self.footView = footView;
    self.tableView.tableFooterView = footView;
    FMWeakSelf;
    footView.protocolBlcok = ^(){
        [weakSelf protocolBtnActionCilck];
    };
    footView.sureBlcok = ^{
        [weakSelf sureSecBlick];
    };
    footView.labelBlcok = ^(NSInteger sender) {
        weakSelf.sendeNum = sender;
    };
}

- (void)sureSecBlick{
//    FMWeakSelf;
//    [FMRTAddCardToView showWithAddBtn:^{
//        [weakSelf addCardJumpToVC];
//    }];
    
    [self sureBtnClick];
}

- (void)addCardJumpToVC{


    
    FMRTChangeTradeKeyViewController *vc = [[FMRTChangeTradeKeyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sureBtnClick{
    
    FMRTRegisterAppCell * cell0  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    FMRTRegisterAppCell * cell1  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
    FMRTRegisterAppCell * cell3  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    FMRTRegisterAppCell * cell4  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    
    if ([self isCheckWithIndexPath]) {
        
        NSString *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
        NSString * enterpriseVersion = kRecommendPersonNamePhoneNumber;
        if (enterpriseVersion.length > 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //调用企业版
            [FMHTTPClient getUserRegisterNewWithUserWithUserName:cell0.leftTextfield.text WithPassword:cell3.leftTextfield.text WhithLeixing:@"1" PersonalPhoneNumber:cell0.leftTextfield.text imei:openUDIDString withRecommendPeople:kRecommendPersonNamePhoneNumber recommendUserID:kRecommendUserID completion:^(WebAPIResponse *response) {
                
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
            
        }else{
            
            NSString * registerPhone = cell0.leftTextfield.text;
            if (registerPhone.length > 0) {
                
            }else
            {
                registerPhone = @"";
            }
            //调用上线版
            
            
            int timestamp = [[NSDate date]timeIntervalSince1970];
            
            NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            
            NSString *tokenlow=[token lowercaseString];
            
            NSString *string = [NSString stringWithFormat:@"%@?AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@",kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/User/do_registerxinde"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
            NSString *cell0Text = [cell0.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *cell1Text = [cell1.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            NSString *cell3Text = [cell3.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *cell4Text = [cell4.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            NSDictionary *parameter =  @{@"sjcode":cell1Text,
                                           @"password1":cell3Text,
                                           @"leixing":@"1",
                                           @"tel": cell0Text,
                                           @"imei":openUDIDString,
                                           @"tuijianren":cell4Text};
            
            FMWeakSelf;
            [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
                
                if (response.responseObject) {
                    if (response.code==WebAPIResponseCodeSuccess){
                        
                        NSDictionary * dict = (NSDictionary *)response.responseObject;
                        
                        if ([dict objectForKey:@"data"]) {
                            NSDictionary * dataDict = dict[@"data"];
                            
                            if ([dataDict objectForKey:@"user_id"]) {
                                
                                NSString *user_id = [dataDict objectForKey:@"user_id"];
                                if ([user_id intValue] ==0 ) {
                                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                    ShowAutoHideMBProgressHUD(weakSelf.view, @"注册失败！");
                                    
                                }else{
                                    ShowAutoHideMBProgressHUD(weakSelf.view, @"注册成功！");
                                    [weakSelf getUserLoginInforWithUser:dataDict[@"user_id"]];
                                }
                            }else{
                                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                ShowAutoHideMBProgressHUD(weakSelf.view, @"注册失败！");
                            }
                        }else{
                            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                            ShowAutoHideMBProgressHUD(weakSelf.view, @"注册失败！");
                        }
                    }else{
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        NSDictionary * dict = (NSDictionary *)response.responseObject;
                        
                        if ([dict objectForKey:@"msg"]) {
                            
                            NSString * showString = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                            ShowAutoHideMBProgressHUD(weakSelf.view, showString);
                        }else{
                            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                        }

                    }
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                }
            }];
        }
    }
}

//初次注册直接登录方法
-(void)getUserLoginInforWithUser:(NSString *)user_id{
    
    FMRTRegisterAppCell * cell0  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    FMRTRegisterAppCell * cell3  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];

    NSString  *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    FMWeakSelf;
    __block NSString * strPassword = [cell3.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [FMHTTPClient getUserLoginInforWithUser:cell0.leftTextfield.text withUserPassword:strPassword completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            if (response.code==WebAPIResponseCodeSuccess) {
                
                [JPUSHService setAlias:openUDIDString callbackSelector:nil object:nil];
                [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                NSDictionary *userLoginDic = nil;
                userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:cell0.leftTextfield.text,@"UserName",strPassword,@"Password",nil];
                LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
                [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
                
                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                    
                    //调用手势解锁
                    [ShareAppDelegate initWithUserAutoLogin:user_id];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:FMCreateGestureNotificationNew object:self userInfo:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification object:nil];//触发登录通知
                }];
                
            }else{
                //            FailedMBProgressHUD(HUIKeyWindow, @"登录失败");
                NSString * showString = StringForKeyInUnserializedJSONDic(response.responseObject, @"msg");
                if (showString.length) {
                    ShowAutoHideMBProgressHUD(weakSelf.view, showString);
                }
            }
        }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
                

        }
        

    }];
    
}


-(BOOL)isCheckWithIndexPath{
    
    FMRTRegisterAppCell * cell0  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    FMRTRegisterAppCell * cell1  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    FMRTRegisterAppCell * cell2  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    FMRTRegisterAppCell * cell3  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    FMRTRegisterAppCell * cell4  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    
    if (IsStringEmptyOrNull(cell0.leftTextfield.text)) {
        ShowAutoHideMBProgressHUD(self.view, @"手机号码不能为空！");
        return NO;
    }else{
        
        NSString *cell0Text = [cell0.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (![cell0Text isMatchedByRegex:@"^1\\d{10}$"]) {
            ShowAutoHideMBProgressHUD(self.view, @"请输入正确的手机号码！");
            return NO;
        }
    }
    
    if (IsStringEmptyOrNull(cell1.leftTextfield.text)) {
        ShowAutoHideMBProgressHUD(self.view, @"验证码码不能为空！");
        return NO;
    }
    
    NSString *cell1Text = [cell1.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (cell1Text.length<4) {
        ShowAutoHideMBProgressHUD(self.view, @"验证码码格式不正确！");
        return NO;
    }
    
    if (IsStringEmptyOrNull(cell2.leftTextfield.text)) {
        ShowAutoHideMBProgressHUD(self.view, @"请设置登录密码！");
        return NO;
    }
    
    NSString *cell2Text = [cell2.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (cell2Text.length < 6) {
        ShowAutoHideMBProgressHUD(self.view, @"密码长度至少为6位！");
        return NO;
    }
    if (cell2Text.length > 16) {
        ShowAutoHideMBProgressHUD(self.view, @"密码长度不能超过16位！");
        return NO;
    }
    
    if (IsStringEmptyOrNull(cell3.leftTextfield.text)) {
        ShowAutoHideMBProgressHUD(self.view, @"请再次确认登录密码！");
        return NO;
    }
    NSString *cell3Text = [cell3.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![cell2Text isEqualToString:cell3Text]) {
        ShowAutoHideMBProgressHUD(self.view, @"两次输入的密码不一致,请重新输入!");
        return NO;
    }
    
    if (!IsStringEmptyOrNull(cell4.leftTextfield.text)) {
        
        NSString *cell4Text = [cell4.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (![cell4Text isMatchedByRegex:@"^1\\d{10}$"]) {
            
            ShowAutoHideMBProgressHUD(self.view, @"请输入正确的推荐人手机号码！");
            return NO;
        }
    }
    
    if (self.sendeNum == 2) {
        ShowAutoHideMBProgressHUD(self.view, @"您尚未勾选融托金融用户服务协议!");
        return NO;
    }
    
    return YES;
}

-(void)protocolBtnActionCilck{
    ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"融托金融用户服务协议" AndWithShareUrl:userServiceAgreementURL];
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMRTRegisterAppCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTRegisterAppCellID];
    if (cell == nil) {
        cell = [[FMRTRegisterAppCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTRegisterAppCellID];
    }
    cell.leftTextfield.tag = indexPath.row + 10;
    cell.leftTextfield.delegate = self;
    cell.row = indexPath.row;
    FMWeakSelf;
    cell.getCodeBlcok = ^{
        [weakSelf getCodeWithPhone];
    };
    return cell;
}

-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType{
    
    FMRTRegisterAppCell * cell1  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.getCodeBtn.enabled = NO;
    
    if ([timerLabel.timeLabel.text doubleValue]) {
            [cell1.getCodeBtn setTitle:[NSString stringWithFormat:@"已发送(%@)",timerLabel.timeLabel.text] forState:(UIControlStateDisabled)];
    }
}

-(void)getCodeWithPhone{
    
    FMWeakSelf;
    FMRTRegisterAppCell * cell0  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *string = [cell0.leftTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![string isMatchedByRegex:@"^1\\d{10}$"]) {
        ShowAutoHideMBProgressHUD(self.view, @"请输入正确手机号码！");
        return;
    }
    
    FMRTRegisterAppCell * cell1  =(FMRTRegisterAppCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    self.footView.sureType = 1;
    [self.timer setCountDownTime:60];
    [self.timer startWithEndingBlock:^(NSTimeInterval countTime) {
        
        [weakSelf.timer pause];
        [weakSelf.timer reset];
        cell1.getCodeBtn.enabled = YES;
        [cell1.getCodeBtn setTitle:@"重新获取验证码" forState:(UIControlStateNormal)];
    }];
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@?AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@",kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/User/fatelcode"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];
    
    NSDictionary *parameters = @{@"tel": cell0.leftTextfield.text,
                                 @"leixing":@1};
//    
//    [FMHTTPClient getUserRegisterWithUserPersonalPhoneNumber:cell0.leftTextfield.text WithType:1 completion:^(WebAPIResponse *response) {
    [FMHTTPClient postPath:postUrl parameters:parameters completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if (response.responseObject) {
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                }else{
                    if ([response.responseObject objectForKey:@"msg"]) {
                        
                        NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                        
                        ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                    }else{
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                    }
                    
                    cell1.getCodeBtn.enabled = YES;
                    [weakSelf.timer pause];
                    [weakSelf.timer reset];
                    weakSelf.timer = nil;
                    [weakSelf.timer setCountDownTime:60];

                    [cell1.getCodeBtn setTitle:@"重新获取验证码" forState:(UIControlStateNormal)];

                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"网络错误，请稍后重试！");
                cell1.getCodeBtn.enabled = YES;
                [weakSelf.timer pause];
                [weakSelf.timer reset];
                [weakSelf.timer setCountDownTime:60];
                weakSelf.timer = nil;
                [cell1.getCodeBtn setTitle:@"重新获取验证码" forState:(UIControlStateNormal)];
            }
        });
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 10:
            textField.keyboardType= UIKeyboardTypePhonePad;
            textField.returnKeyType = UIReturnKeyDefault;
            break;
        case 11:
            textField.keyboardType= UIKeyboardTypePhonePad;
            textField.returnKeyType = UIReturnKeyDefault;
            break;
        case 12:
            textField.keyboardType= UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDefault;
            break;
        case 13:
            textField.keyboardType= UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDefault;
            break;
        case 14:
            textField.keyboardType= UIKeyboardTypePhonePad;
            textField.returnKeyType = UIReturnKeyDefault;
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
