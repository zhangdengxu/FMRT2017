//
//  LoginController.m
//  fmapp
//
//  Created by 张利广 on 14-5-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "LoginController.h"
#import "OpenUDID.h"
#import "HUILoadMoreCell.h"
#import "LocalDataManagement.h"
#import "RegisterController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "PhoneNumberController.h"
#import "AppDelegate.h"
#import "FMSettings.h"
#import "JPUSHService.h"
#import "GestureViewController.h"
#import "UIButton+Bootstrap.h" //修改右侧button

#import "FMRTRegisterAppController.h"
#import "LGTextFieldView.h"

#define kLoginButtonTag 1630114                 //登录操作按键
#define KForgetPasswordButtonTag 1630115        //找回密码操作按键
#define KUserGotoRegisterButtonTag 1630119      //注册信息新用户按键
#define KUserPersonalNameTextTag 1630116        //用户名输入框
#define KUserPersonalPWdTextTag 1630117         //用户密码输入框

#import "FMTabBarController.h"

@interface LoginController ()<UIAlertViewDelegate,UIScrollViewDelegate>

/*!
 *@breif 数据通信设置
 */
/*!
 *@breif 用户个人昵称
 */
@property(nonatomic,strong)UITextField                 *userNameTextField;
/*!
 *@breif 用户个人密码
 */
@property(nonatomic,strong)UITextField                 *userPasswordTextField;


@end

@implementation LoginController

- (void)dealloc
{
    NSLog(@"shanchu");
}

- (id)init{
    self = [super init];
    if (self) {
        self.enableCustomNavbarBackButton = FALSE;
        
    }
    
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self settingNavTitle:@"登录"];
    [self initWithLoginControllerFrame];
    
    NSString *string = [OpenUDID value];
    Log(@"string is %@ ",string);
    
    [self setLeftNavButtonFA:FMIconLeftArrow
                   withFrame:kNavButtonRect
                actionTarget:self
                      action:@selector(navigationBarCancelItemClicked:)];
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    if (self.isComFromLoginOut) {
        UIButton *homePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [homePageBtn setTitle:@"首页" forState:UIControlStateNormal];
        [homePageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [homePageBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [homePageBtn sizeToFit];
        [homePageBtn addTarget:self action:@selector(homePageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:homePageBtn];
        self.navigationItem.leftBarButtonItem = nil;
        
//        self.isComFromLoginOut = NO;
    }

    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)homePageBtnClick{

//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        [weakSelf.tabBarController setSelectedIndex:0];
//    }];
    

    
    [ShareAppDelegate setTabBarIndex:0];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.homeBack) {
            self.homeBack();
        }
    }];

}
// 返回按钮
- (void)navigationBarCancelItemClicked:(id)sender{
    [self.userNameTextField setEnabled:NO];
    [self.userPasswordTextField setEnabled:NO];
    self.userPasswordTextField.userInteractionEnabled = NO;
    self.userNameTextField.userInteractionEnabled = NO;
    [self.userNameTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    ShareAppDelegate.isMyAcount = NO;
    if (self.isGoBackLogin) { // 广告页跳入的登录
        if (self.isComFromFirstPage) {
           [self.navigationController popViewControllerAnimated:YES];
        }else{
           [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 初始化登录界面框架内容
- (void)initWithLoginControllerFrame{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +80.0f);
    [self.view addSubview:mainScrollView];
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 94.5f)];
    if (ThemeCategory==5) {
        backGroundView.alpha=0.6;
    }
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 23, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    //文本框
    UITextField *userNameText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userNameText setReturnKeyType:UIReturnKeyNext];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userNameText setFont:[UIFont systemFontOfSize:18.0f]];
    [userNameText setBorderStyle:UITextBorderStyleNone];
    [userNameText setPlaceholder:@"用户名/手机号"];
    userNameText.tag=KUserPersonalNameTextTag;
    [userNameText setDelegate:self];
//    [userNameText becomeFirstResponder];
    
    self.userNameTextField=userNameText;
    [backGroundView addSubview:userNameText];
    
    
    
    ////分割线
    UIView *sectionSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 47.5, self.view.bounds.size.width-20.0f, 0.5f)];
    sectionSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:sectionSeperatorView];
    //密码
    ////指示图片
    UIImageView *passwordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secret.png"]];
    [passwordIndicatorImageView setFrame:CGRectMake(20, 59.5, 18, 23)];
    [backGroundView addSubview:passwordIndicatorImageView];
    ////文本框
    LGTextFieldView *passwordText= [[LGTextFieldView alloc] initWithFrame:CGRectMake(60.0f, 48.5, KProjectScreenWidth-30-60, 45.0f)];
    [passwordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passwordText setReturnKeyType:UIReturnKeyGo];
    [passwordText setPlaceholder:@"密码"];
    passwordText.tag=KUserPersonalPWdTextTag;
    [passwordText setDelegate:self];
    [passwordText setFont:KContentLeftTitleFontOfSize];
    [passwordText setKeyboardType:UIKeyboardTypeAlphabet];
    [passwordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordText setBorderStyle:UITextBorderStyleNone];
    [passwordText setSecureTextEntry:YES];
    self.userPasswordTextField=passwordText;
    [backGroundView addSubview:passwordText];
    
   
    
    ///退出登录
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateHighlighted];
    
    //    if ([[CurrentUserInformation sharedCurrentUserInfo] userLoginState] == 0) {//未登录
    [personalLogoOutButton setTitle:@"登  录"
                           forState:UIControlStateNormal];
    
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [personalLogoOutButton setFrame:CGRectMake(20.0f, 145.0f, KProjectScreenWidth-40, 43.0f)];
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:2.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    personalLogoOutButton.tag=kLoginButtonTag;
    [personalLogoOutButton setBackgroundColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [personalLogoOutButton addTarget:self action:@selector(initWithUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:personalLogoOutButton];
    
    
    
    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.tag = KForgetPasswordButtonTag;
    //    [forgetPasswordButton setFrame:CGRectMake(79.75*widthScale, 150.0f+ (HUIIsIPhone5() ?+80.0f:0.0f), 70, 20.0f)];
    [forgetPasswordButton setFrame:CGRectMake((KProjectScreenWidth-160)/2, 230, 70, 20.0f)];
    
    [forgetPasswordButton setBackgroundColor:[UIColor clearColor]];
    [forgetPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:KSubTitleContentTextColor forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [forgetPasswordButton setBackgroundImage:createImageWithColor([UIColor lightGrayColor]) forState:UIControlStateHighlighted];
    [forgetPasswordButton addTarget:self action:@selector(initWithUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:forgetPasswordButton];
    //忘记密码按钮下划线
    UIView *forgetPasswordButtonUnderLineView = [[UIView alloc] initWithFrame:CGRectMake(22, 188, 66, 1)];
    forgetPasswordButtonUnderLineView.hidden = YES;
    forgetPasswordButtonUnderLineView.backgroundColor = [UIColor blueColor];
    [mainScrollView addSubview:forgetPasswordButtonUnderLineView];
    
    UIView *sectionView =[[UIView alloc]initWithFrame:CGRectMake(forgetPasswordButton.frame.origin.x+80, 225, 0.5, 30.0f)];
    [sectionView setBackgroundColor:[UIColor grayColor]];
    [mainScrollView addSubview:sectionView];
    
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.tag = KUserGotoRegisterButtonTag;
    [loginButton setFrame:CGRectMake(forgetPasswordButton.frame.origin.x+90, 230, 70, 20.0f)];
    [loginButton setBackgroundColor:[UIColor clearColor]];
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f,70.0f, 20.0f)];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    loginLabel.font = [UIFont systemFontOfSize:16.0f];
    [loginLabel setBackgroundColor:[UIColor clearColor]];
    [loginLabel setTextColor:KContentTextCanEditColor];
    [loginLabel setText:@"会员注册"];
    [loginButton addSubview:loginLabel];
    [loginButton setBackgroundImage:createImageWithColor([UIColor clearColor])
                           forState:UIControlStateNormal];
    [loginButton setBackgroundImage:createImageWithColor([UIColor lightGrayColor])
                           forState:UIControlStateHighlighted];
    //    登录方法
    [loginButton addTarget:self action:@selector(initWithUserButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginButton];
    
    
//    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
//    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
//        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
//        NSString *userName = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserName"]];//用户名
        //        NSString *password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
        NSString *userName =  [CurrentUserInformation sharedCurrentUserInfo].personName;

        //        NSString *userId = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserId"]];//userId
        
        if (!IsStringEmptyOrNull(userName)) {
            [self.userNameTextField setText:userName];
        }
        
        //        if (!IsStringEmptyOrNull(password)) {
        //            [self.userPasswordTextField setText:password];
        //        }
        
//    }
}
#pragma mark - 初始化用户按键事件
- (void)initWithUserButtonClicked:(id)sender{
    UIButton    *button = (UIButton *)sender;
    [self.view endEditing:YES];
    if (button.tag == kLoginButtonTag) {
        ///初始化用户登录请求
        [self initWithRequestUserLogoInformation];
    }
    
    ///用户忘记密码处理
    else if (button.tag == KForgetPasswordButtonTag){
        PhoneNumberController *viewController = [[PhoneNumberController alloc]initWithUserOperationStyle:UserFindPasswordStyle];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    ///用户进行新用户注册
    else if (button.tag == KUserGotoRegisterButtonTag){
        
        FMRTRegisterAppController *viewController = [[FMRTRegisterAppController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - 初始化用户登录请求
- (void)initWithRequestUserLogoInformation{
    
    ///判断用户名是否已编辑
    if (IsStringEmptyOrNull(self.userNameTextField.text)) {
        ShowImportErrorAlertView(@"请输入用户名");
        return;
    }
    
    NSString * strPassword = [self.userPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    ///判断密码是否已编辑
    if (IsStringEmptyOrNull(strPassword)) {
        ShowImportErrorAlertView(@"请输入密码");
        return;
    }
    
    NSString  *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    
    WaittingMBProgressHUD(HUIKeyWindow, @"登录中...");
    __weak __typeof(&*self)weakSelf = self;
    
    NSDate * tmpStartData = [NSDate date];
    Log(@"%@",tmpStartData);
    
   
    
    [FMHTTPClient getUserLoginInforWithUser:self.userNameTextField.text withUserPassword:strPassword completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Log(@"%@",response.responseObject);
            // 去除掉广告页
            
//            double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
//            NSLog(@">>>>>>>>>>time = %f ms", deltaTime*1000);
            
            if (response.code==WebAPIResponseCodeSuccess) {
                
                SuccessMBProgressHUD(HUIKeyWindow, @"登录成功");
                
                [JPUSHService setAlias:openUDIDString callbackSelector:nil object:nil];
                
                [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                NSDictionary *userLoginDic = nil;
                userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.userNameTextField.text,@"UserName",strPassword,@"Password",nil];
                LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
                [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
                NSDictionary * diction;
                if (self.goToDuobaoMiaosha == 1) {
                    diction = @{@"status":@1};
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification object:nil userInfo:nil];
                if (self.isComFromFirstPage) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:FMCreateGestureNotificationNew object:self userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.successBlock) {
                        self.successBlock();
                    }
                }else{
                    
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:FMCreateGestureNotificationNew object:self userInfo:nil];
                        
                        if (self.successBlock) {
                            self.successBlock();
                        }
                    }];
                }
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
        });
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    ///若点击的是用户名的下一步，则输入密码
    if (textField.tag == KUserPersonalNameTextTag) {
        [self.userPasswordTextField becomeFirstResponder];
    }
    else if (textField.tag == KUserPersonalPWdTextTag){
        //初始化用户登录请求
        [self initWithRequestUserLogoInformation];
        
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
