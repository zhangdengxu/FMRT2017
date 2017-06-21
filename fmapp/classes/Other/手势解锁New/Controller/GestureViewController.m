#define KGestureViewControllerRetryTimes 5 // 最多重试几次

#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FMSettings.h"

#import "GesturerViewController.h"
#import "FMTabBarController.h"
#import "AppDelegate.h"

#import "FMTieBankCardViewController.h"

@interface GestureViewController ()<CircleViewDelegate,UIAlertViewDelegate>

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

/**
 *  可以输入密码的次数
 */
@property (nonatomic, assign) NSInteger nRetryTimesRemain;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhuceUserId"];
    if ([[NSString stringWithFormat:@"%@",str] isEqualToString:[NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].userId]]) {
    
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    
    [ShareAppDelegate checkAppVsrsion];
    
}

#pragma mark - 创建UIBarButtonItem
- (UIButton *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {160, 20}};
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (kScreenW == 320) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }else if (kScreenW == 375)
    {
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }else
    {
        [button.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }

    button.tag = tag;
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setHidden:YES];
    
    return button;
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{

    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 15);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    CGFloat imageViewWidth;
    if (kScreenW == 320) {
        imageViewWidth = 65;
    }else if (kScreenW == 375)
    {
        imageViewWidth = 75;
    }else
    {
        imageViewWidth = 85;
    }
    imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
    if (KProjectScreenWidth == 320) {
        
        if (self.type == GestureViewControllerTypeSetting) {
             imageView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 40  - 45);
        }else
        {
             imageView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 25  - 45);
        }
        
    }else
    {
         imageView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 30 - 20 - 20 - 45);
    }
   
    
    imageView.layer.cornerRadius = imageView.frame.size.height * 0.5;
    imageView.layer.masksToBounds = YES;
    
    NSString * imageUrl = [NSString stringWithFormat:@"https://%@",[CurrentUserInformation sharedCurrentUserInfo].touxiangsde];
//    NSLog(@"====>%@",imageUrl);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
    

        [self.view addSubview:imageView];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    [self settingNavTitle:@"设置手势密码"];
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * CircleRadiusRadio * 2 * 0.6, CircleRadius * CircleRadiusRadio * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    
    self.resetBtn = [self itemWithTitle:@"重绘密码" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    [self.view addSubview:self.resetBtn];
    self.resetBtn.center = CGPointMake(kScreenW * 0.5, kScreenH - 60 + 10);
    
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    self.nRetryTimesRemain = KGestureViewControllerRetryTimes;
    
    
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(0, 0, kScreenW, 25);
    
    if (KProjectScreenWidth == 320) {
         nameLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 10- 10 );
    }else
    {
        nameLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 20 - 10 );
    }
   
    nameLabel.textColor = [UIColor whiteColor];
    if (kScreenW == 320) {
        nameLabel.font = [UIFont systemFontOfSize:14.0];
    }else if (kScreenW == 375)
    {
        nameLabel.font = [UIFont systemFontOfSize:16.0];
    }else
    {
        nameLabel.font = [UIFont systemFontOfSize:17.0];
    }
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userName.length) {
        nameLabel.text = [NSString stringWithFormat:@"欢迎%@",[CurrentUserInformation sharedCurrentUserInfo].userName];
    }else
    {
        nameLabel.text = @"融托金融欢迎您！";
    }
    
    [self.view addSubview:nameLabel];
    
    [self.msgLabel showNormalMsg:@"请输入解锁密码"];
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"管理手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"登陆其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
    
    
    
    [self setUpFigureFunction];
    
    
    
}
-(void)setUpFigureFunction
{
    LAContext *lac = [[LAContext alloc]init];
    BOOL isSupport = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    if(!isSupport)
    {
        //[self showLockView];
    }else{
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if (userDef) {
            NSNumber *user = [userDef objectForKey:@"userSetShowSheJieSuo"];
            
            if (!user) {
                [self alertInfoWithSetShoushi];
            }
        }
        
        if (userDef) {
            NSNumber *user = [userDef objectForKey:@"userSetShowSheJieSuo"];
            if (user) {
                if ([user intValue] == 1) {
                    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键来验证已有手机指纹" reply:^(BOOL success, NSError *error) {
                        if(success)
                        {
                            
//                            NSLog(@"通过Home键来验证已有手机指纹");
                          
                            if (![ShareAppDelegate.window isKeyWindow]) {
                            
                                [[CurrentUserInformation sharedCurrentUserInfo]checkUserInfoWithNetWork];

                                [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSuccessInGestureViewController object:nil userInfo:nil];

                            }else{
                                
                                
                                //指纹识别成功
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [[CurrentUserInformation sharedCurrentUserInfo]checkUserInfoWithNetWork];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSuccessInGestureViewController object:nil userInfo:nil];
                                }];
                            }
                            
                            
                            
                        }else{
                            NSString *errorStr = [error localizedDescription];
                           
                            if ([errorStr isEqualToString: @"Canceled by user."]) {

                                
                            }
                            if ([errorStr isEqualToString:@"Application retry limit exceeded."]) {
                            }
                            if ([errorStr isEqualToString:@"Fallback authentication mechanism selected."]) {
                            }
                            
                        }
                    }];
                }else
                {
                }
            }else
            {
            }
        }
    }

}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    if (kScreenW == 320) {
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }else if (kScreenW == 375)
    {
         [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }else
    {
         [btn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    Log(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            Log(@"点击了重设按钮");
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        }
            break;
        case buttonTagManager:
        {
            Log(@"点击了管理手势密码按钮");
            GesturerViewController * gesture = [[GesturerViewController alloc]init];
            gesture.enterStyleForPush = NO;
            
            FMNavigationController * nav = [[FMNavigationController alloc]initWithRootViewController:gesture];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
        case buttonTagForget:
        {
            Log(@"点击了登录其他账户按钮");
            [self retuRootViewController];
//            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        Log(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    Log(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
    self.resetBtn.hidden = NO;
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    Log(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        Log(@"两次手势匹配！可以进行本地化保存了");
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        
        GesturerViewController * viewController;

            for (UIViewController * viewC in self.navigationController.viewControllers) {
                if ([viewC isKindOfClass:[GesturerViewController class]]) {
                    viewController = (GesturerViewController *)viewC;
                    break;
                }
            }
            if (viewController) {
                [self.navigationController popToViewController:viewController animated:YES];
            }else
            {
                
                FMShareSetting.agreeGestures = YES;
                //做从注册跳转过来的标记 ， zhuceUserId这个字段在用完之后就会删除。
                //需要添加判断是否是是从注册跳转过来的
                NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhuceUserId"];
                if ([[NSString stringWithFormat:@"%@",str] isEqualToString:[NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].userId]]) {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhuceUserId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSetGestureViewController object:nil userInfo:nil];
                    
                    ////跳转到注册汇付页面(已被注掉)详情代买参考最下边注释
    
                    // 跳转绑定银行卡界面
                    FMTieBankCardViewController * tieBank = [[FMTieBankCardViewController alloc]init];
                    tieBank.viewType = 1;
                    [self.navigationController pushViewController:tieBank animated:YES];
                    
                    
                   
                    
                    
                }else
                {
                    
                    [ShareAppDelegate createTabBarController];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSuccessInGestureViewController object:nil userInfo:nil];
                    //从注册跳转过来
                    [self dismissViewControllerAnimated:YES completion:^{
 
                    }];
                }
            }
        
    } else {
        Log(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

+(void)cleanFigureGesture;
{
    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {

            
            if (![ShareAppDelegate.window isKeyWindow]) {
                [[CurrentUserInformation sharedCurrentUserInfo] checkUserInfoWithNetWork];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSuccessInGestureViewController object:nil userInfo:nil];

                
            }
            Log(@"登陆成功！");
            [self dismissViewControllerAnimated:YES completion:^{
                [[CurrentUserInformation sharedCurrentUserInfo] checkUserInfoWithNetWork];
                
//                NSDictionary * dict ;
                [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultSuccessInGestureViewController object:nil userInfo:nil];
            }];
        } else {
            Log(@"密码错误！");
            
            self.nRetryTimesRemain--;
            
            if (self.nRetryTimesRemain > 0) {
                
                if (1 == self.nRetryTimesRemain) {
                    [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"最后的机会咯-_-!"]];
//
                    //出发退出登陆的通知，让用户重新登录
//                    [[CurrentUserInformation sharedCurrentUserInfo] userQuiteWithApp];
                } else {
                    [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误，还可以再输入%zi次", self.nRetryTimesRemain]];
                   
                }
                
            } else {
                
                [self showAlert:@"您已连续输错5次,请重新登录！"];
                //出发退出登陆的通知，让用户重新登录
                [[CurrentUserInformation sharedCurrentUserInfo] userQuiteWithApp];
            }
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            Log(@"验证成功，跳转到设置手势界面");
            
        } else {
            Log(@"原手势密码输入错误！");
        }
    }
}



#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 30099;
    [alert show];
    
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    ShowAutoHideMBProgressHUD(window,string);
//    
//    [self performSelector:@selector(retuRootViewController) withObject:nil afterDelay:2.0f];
    
}


-(void)hhhhhhRootViewController
{
    
    //    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    //    FMTabBarController * tabbar = (FMTabBarController *)window.rootViewController;
    //        [tabbar setSelectedIndex:0];
//    [[CurrentUserInformation sharedCurrentUserInfo] cleanAllUserInfo];
    
    [ShareAppDelegate createTabBarController];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:KdefaultSuccessInGestureViewController object:nil];

}




-(void)retuRootViewController
{
    
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;

//    FMTabBarController * tabbar = (FMTabBarController *)window.rootViewController;
    //        [tabbar setSelectedIndex:0];
    [[CurrentUserInformation sharedCurrentUserInfo] cleanAllUserInfo];

    [ShareAppDelegate createTabBarController];

    [[NSNotificationCenter defaultCenter]postNotificationName:KdefaultShowLoginControler object:nil];

//    [self dismissViewControllerAnimated:YES completion:^{
    
//        UIWindow * window = [UIApplication sharedApplication].keyWindow;
//        FMTabBarController * tabbar = (FMTabBarController *)window.rootViewController;
////        [tabbar setSelectedIndex:0];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:KdefaultShowLoginControler object:nil];
        

//    }];
}


#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

-(void)alertInfoWithSetShoushi{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否使用指纹解锁" delegate:self cancelButtonTitle:@"不使用" otherButtonTitles:@"使用", nil];
    alert.tag = 30086;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag==30086) {
        if (buttonIndex==1) {
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            if (userDef) {
                [userDef setObject:[NSNumber numberWithInt:1] forKey:@"userSetShowSheJieSuo"];
                
            }
        }else
        {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            if (userDef) {
                [userDef setObject:[NSNumber numberWithInt:0] forKey:@"userSetShowSheJieSuo"];
            }
        }
    }
    if(alertView.tag == 30099)
    {
        [self retuRootViewController];
    }
}


@end


