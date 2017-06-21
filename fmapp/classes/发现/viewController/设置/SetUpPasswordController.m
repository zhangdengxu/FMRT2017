//
//  SetUpPasswordController.m
//  fmapp
//
//  Created by 张利广 on 14-5-19.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "SetUpPasswordController.h"
#import "HTTPClient+MeModulesSetup.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "LocalDataManagement.h"
#import "OpenUDID.h"
#import "GestureViewController.h"
#import "LGTextFieldView.h"

#define KUserFormerPwdTextTag 171001        ///原密码
#define KUserFreshPwdTextTag 171002         ///新密码
#define KUserVerifyPwdTextTag 171003        ///确认密码



@interface SetUpPasswordController ()
///用户原密码
@property (nonatomic , weak)    LGTextFieldView             *userPersonalFormerPassWord;
///用户新密码
@property (nonatomic , weak)    LGTextFieldView             *userPersonalFreshPassWord;
///用户确认密码
@property (nonatomic , weak)    LGTextFieldView             *userPersonalVerifyPassWord;




/** 在该控制器中初始化界面控件框架内容
 
 *@return void
 **/
- (void) initWithControlFrameAtThisViewController;

/** 用户保存个人新的密码并提交到服务器
 
 *@return void
 **/
- (void) userSaveUserPersonalFreshPassWordAndSubmit;


/** 初始化用户自动登录信息内容
 
 *@return void
 **/
- (void) initWithUserAutoLoginWithNewPassword;
@end

@implementation SetUpPasswordController


- (id) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.0f blue:240/255.0f alpha:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self settingNavTitle:@"重置密码"];
    //在该控制器中初始化界面控/Users/zhangliguang/Pictures/iPhoto 图库件框架内容
    [self initWithControlFrameAtThisViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - 在该控制器中初始化界面控件框架内容
- (void) initWithControlFrameAtThisViewController{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];

    ///第一组：原密码背景图设置
    UIView  *formerPassWordBackGrondView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, 20.0f,
                                                                                   KProjectScreenWidth-20, 47*3+1)];
    [formerPassWordBackGrondView setBackgroundColor:KDefaultOrNightBackGroundColor];
    [formerPassWordBackGrondView.layer setBorderWidth:0.5f];
    [formerPassWordBackGrondView.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [mainScrollView addSubview:formerPassWordBackGrondView];

    ///原密码头部Label
//    UILabel *formerPassWordHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 12, 60, 23)];
////    [formerPassWordHeaderLabel setText:@"原密码"];
//    [formerPassWordHeaderLabel setTextColor:KDefaultOrNightTextColor];
//    [formerPassWordHeaderLabel setBackgroundColor:[UIColor clearColor]];
//    [formerPassWordHeaderLabel setFont:KContentLeftTitleFontOfSize];
//    formerPassWordHeaderLabel.textAlignment=NSTextAlignmentLeft;
//    [formerPassWordBackGrondView addSubview:formerPassWordHeaderLabel];
    NSArray *array = [NSArray arrayWithObjects:@"旧密码_03.png",@"新密码_03.png",@"确认密码_03.png", nil];
    for (int i = 0; i<3; i++) {
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, (47-15)/2+47*i, 13, 15)];
        [imageV setImage:[UIImage imageNamed:array[i]]];
        [formerPassWordBackGrondView addSubview:imageV];
 
    }
    
    ///原密码输入框
    LGTextFieldView *formerPasswordTextField = [[LGTextFieldView alloc]initWithFrame:CGRectMake(30.0f, 1, KProjectScreenWidth-30-65, 45.0f)];
    [formerPasswordTextField setDelegate:self];
    [formerPasswordTextField becomeFirstResponder];
    [formerPasswordTextField setTag:KUserFormerPwdTextTag];
    [formerPasswordTextField setSecureTextEntry:YES];
//    [formerPasswordTextField setPlaceholder:@"(6-16位数字或字母)"];
    [formerPasswordTextField setPlaceholder:@"旧密码"];
    [formerPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [formerPasswordTextField setReturnKeyType:UIReturnKeyNext];
    [formerPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [formerPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [formerPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [formerPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalFormerPassWord = formerPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalFormerPassWord];
    
    UIView *seperatorView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, KProjectScreenWidth-20, 0.5f)];
    seperatorView.backgroundColor=KSepLineColorSetup;
    [formerPassWordBackGrondView addSubview:seperatorView];
    
    
    ///新密码头部Label
//    UILabel *freshPassWordHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,59.5,60,23)];
//    [freshPassWordHeaderLabel setText:@"新密码"];
//    [freshPassWordHeaderLabel setTextColor:KDefaultOrNightTextColor];
//    [freshPassWordHeaderLabel setBackgroundColor:[UIColor clearColor]];
//    [freshPassWordHeaderLabel setFont:KContentLeftTitleFontOfSize];
//    [formerPassWordBackGrondView addSubview:freshPassWordHeaderLabel];
    
    ///新密码输入框
    LGTextFieldView *freshPasswordTextField = [[LGTextFieldView alloc]initWithFrame:CGRectMake(30.0f, 48.5, KProjectScreenWidth-30-65, 45.0f)];
    [freshPasswordTextField setDelegate:self];
    [freshPasswordTextField setSecureTextEntry:YES];
    [freshPasswordTextField setPlaceholder:@"新密码（6-16位数字或字母）"];
    [freshPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [freshPasswordTextField setTag:KUserFreshPwdTextTag];
    [freshPasswordTextField setReturnKeyType:UIReturnKeyNext];
    [freshPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [freshPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [freshPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [freshPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalFreshPassWord = freshPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalFreshPassWord];
    
    ///新密码底部横线
    UIImageView *freshPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                       94.5f,
                                                                                       KProjectScreenWidth-20,
                                                                                       0.5f)];
    [freshPasswordImageView setBackgroundColor:KSepLineColorSetup];
    [freshPasswordImageView setUserInteractionEnabled:YES];
    [formerPassWordBackGrondView addSubview:freshPasswordImageView];
    
    
    ///确认码输入框
    LGTextFieldView *verifyPasswordTextField = [[LGTextFieldView alloc]initWithFrame:CGRectMake(30.0f,
                                                                                        95.0f,
                                                                                        KProjectScreenWidth-20-100,
                                                                                        47.5)];
    [verifyPasswordTextField setDelegate:self];
    [verifyPasswordTextField setSecureTextEntry:YES];
    [verifyPasswordTextField setPlaceholder:@"确认密码"];
    [verifyPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [verifyPasswordTextField setTag:KUserVerifyPwdTextTag];
    [verifyPasswordTextField setReturnKeyType:UIReturnKeySend];
    [verifyPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [verifyPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [verifyPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [verifyPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalVerifyPassWord = verifyPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalVerifyPassWord];
    
    

    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                            forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                            forState:UIControlStateHighlighted];
    
    [finishButton setTitle:@"提交"
                  forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(90.0f, 220.0f, KProjectScreenWidth-180, 43.0f)];
    [finishButton.layer setBorderWidth:0.5f];
    [finishButton.layer setCornerRadius:2.0f];
    [finishButton.layer setMasksToBounds:YES];
    [finishButton setBackgroundColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [finishButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [finishButton addTarget:self action:@selector(userSaveUserPersonalFreshPassWordAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:finishButton];
    
    
}


#pragma mark -
#pragma mark - 用户保存个人新的密码并提交到服务器
- (void)userSaveUserPersonalFreshPassWordAndSubmit{
    
    NSString * strPassword1 = [self.userPersonalFormerPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * strPassword2 = [self.userPersonalFreshPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * strPassword3 = [self.userPersonalVerifyPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    ///原密码为空
    if (IsStringEmptyOrNull(strPassword1)) {
        ShowImportErrorAlertView(@"输入你的原密码");
        return;
    }else if (IsStringEmptyOrNull(strPassword2)){
        ShowImportErrorAlertView(@"输入你的新密码");
        return;
    }
    //新密码不可过短或过长
    else if ([strPassword2 length] > 16 ||
             [strPassword2 length] < 6) {
        ShowImportErrorAlertView(@"密码长度为6-16位数字或字母组合");
        [self.userPersonalFreshPassWord becomeFirstResponder];
        return;
    }
    //输入你的密码
    else if(IsStringEmptyOrNull(strPassword3)){
        ShowImportErrorAlertView(@"输入你的确认密码");
        return;
    }
    //新密码和确认密码不一致
    else if (![strPassword3 isEqualToString:strPassword2]){
        ShowImportErrorAlertView(@"两次输入的密码不一致，请重新输入");
        [self.userPersonalVerifyPassWord setText:@""];
        [self.userPersonalFreshPassWord setText:@""];
        return;
    }
    
    [self.view endEditing:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.userPersonalFreshPassWord setEnabled:NO];
    [self.userPersonalVerifyPassWord setEnabled:NO];
    [self.userPersonalFormerPassWord setEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(&*self)weakSelf = self;
     [FMHTTPClient getUserSetupPersonalPasswordWithUserId:[CurrentUserInformation sharedCurrentUserInfo].userId withPassword:strPassword1 withnewPwd:strPassword3 withConfirmPassword:strPassword2 completion:^(WebAPIResponse *response) {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       if (response.code == WebAPIResponseCodeSuccess) {
           
           
           
          //保存登录信息 用户名 密码
           LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
           NSDictionary *userLoginDic = nil;
               userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:[CurrentUserInformation sharedCurrentUserInfo].mobile,@"UserName",strPassword2,@"Password",nil];
           [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
           
           ShowAutoHideMBProgressHUD(self.view,@"密码修改成功");
           [weakSelf performSelector:@selector(initWithUserAutoLoginWithNewPassword) withObject:weakSelf afterDelay:1.0];
           
       }else if (response.code == WebAPIResponseCodeFailed){
            ShowAutoHideMBProgressHUD(self.view,StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
           [weakSelf.navigationItem.rightBarButtonItem setEnabled:YES];
           [weakSelf.userPersonalFreshPassWord setEnabled:YES];
           [weakSelf.userPersonalVerifyPassWord setEnabled:YES];
           [weakSelf.userPersonalFormerPassWord setEnabled:YES];
       }else{
           ShowAutoHideMBProgressHUD(self.view,StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
           [weakSelf.navigationItem.rightBarButtonItem setEnabled:YES];
           [weakSelf.userPersonalFreshPassWord setEnabled:YES];
           [weakSelf.userPersonalVerifyPassWord setEnabled:YES];
           [weakSelf.userPersonalFormerPassWord setEnabled:YES];
           
       }
}];

}

- (void)initWithUserAutoLoginWithNewPassword{
    
    __block NSString * strPassword2 = [self.userPersonalFreshPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
        
        [FMHTTPClient getUserLoginInforWithUser:[CurrentUserInformation sharedCurrentUserInfo].mobile withUserPassword:strPassword2 completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(response.code == WebAPIResponseCodeSuccess){
                    //初始化登录信息
                    [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                    
                [self.navigationController popViewControllerAnimated:YES];
                    
                }
            });
        }];
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    ///原密码
    if (textField.tag == KUserFormerPwdTextTag) {
        [self.userPersonalFreshPassWord becomeFirstResponder];
    }
    ///新密码
    else if (textField.tag == KUserFreshPwdTextTag){
        [self.userPersonalVerifyPassWord becomeFirstResponder];
    }
    ///确认密码
    else if (textField.tag == KUserVerifyPwdTextTag){
        [self userSaveUserPersonalFreshPassWordAndSubmit];
    }
   return YES;
}
/**
 *退出登录
 */
-(void)tuichu{

    //退出登录前请求数据
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&imei=%@",explorerIsLoginURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,openUDIDString];
    [FMHTTPClient getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.responseObject) {
            
            if (response.code == WebAPIResponseCodeSuccess) {
                [[CurrentUserInformation sharedCurrentUserInfo] setUserLoginState:0];//设置用户为未登录状态
                
                //移除本地文件
                LocalDataManagement *dataManagement=[[LocalDataManagement alloc] init];
                ////移除用户登录文件
                [[CurrentUserInformation sharedCurrentUserInfo] cleanAllUserInfo];
                NSString *userLoginInfoPathString=[dataManagement getUserFilePathWithUserFileType:CYHUserLoginInfoFile];;
                [[NSFileManager defaultManager] removeItemAtPath:userLoginInfoPathString error:nil];
                ////移除用户详情文件
                NSString *userDetailInfoPathString = [dataManagement getUserFilePathWithUserFileType:CYHUserDetailInfoFile];
                [[NSFileManager defaultManager] removeItemAtPath:userDetailInfoPathString error:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLogoutNotification object:nil];//触发退出登录通知
                
                [GestureViewController cleanFigureGesture];
                
              
                
                //注册控制器
                FMWeakSelf;
                LoginController *registerController = [[LoginController alloc] init];
                registerController.isComFromLoginOut = NO;
                registerController.successBlock = ^(){
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                };
                
                registerController.homeBack = ^(){
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                };
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                
                [self.tabBarController presentViewController:navController animated:YES completion:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    //weakSelf.tabBarController.selectedIndex = 0;
                    //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }

    }];
}

@end
