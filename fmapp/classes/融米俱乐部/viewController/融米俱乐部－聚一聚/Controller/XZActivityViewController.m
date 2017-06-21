//
//  XZCommentViewController.m
//  XZLearning
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 admin. All rights reserved.
// 活动

#import "XZActivityViewController.h"
#import "XZTextCommentView.h" // 评论界面
#import "XZSignUpView.h" // 报名界面
#import "XZSignUpSuccessView.h" // 报名成功界面
#import "XZRegistrationCertificateViewController.h" // 报名凭证
#import "XZActivityTabBar.h" // 底部的tabBar
// 数据请求
#import "XZActivityModel.h" // model
#import "WLJYJViewController.h" // 评论列表
#import "XZWebTopView.h"
#import "WLPublishSuccessViewController.h" // 分享

/** 活动详细 */
#define kActivityDetailURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partyfindpartyapp"
/** 活动报名 */
#define kActivitySignUpURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partyjoinpartyapp"
/** 活动赞 */
#define kActivityPraiseURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partypraiseapp"

#import "ShareViewController.h"

@interface XZActivityViewController ()<UIWebViewDelegate>
/** 报名界面 */
@property (nonatomic, strong) XZSignUpView *signUpView;
/** 背景图 */
@property (nonatomic, strong) UIView *viewBackGround;
/** 底部的tabBar */
@property (nonatomic, strong) XZActivityTabBar *tabBar;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIWindow *keyWindow;
/** webView的头部 */
@property (nonatomic, strong) XZWebTopView *topWeb;
/** 报名成功 */
@property (nonatomic, strong) XZSignUpSuccessView *signUpSuccessView;
/** model */
@property (nonatomic, strong) XZActivityModel *modelGetTogether;
@property (nonatomic, strong) UIButton *share;
@end

@implementation XZActivityViewController

- (XZActivityModel *)modelGetTogether {
    if (!_modelGetTogether) {
        _modelGetTogether = [[XZActivityModel alloc]init];
    }
    return _modelGetTogether;
}

- (XZSignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [[XZSignUpView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        __weak __typeof(&*self)weakSelf = self;
        _signUpView.btnTitle = @"提交";
        _signUpView.blockCloseBtn = ^(UIButton *button) {
            [weakSelf.viewBackGround removeFromSuperview];
        };
        _signUpView.blockSubmitBtn = ^(NSString *name,NSString *phone){
            weakSelf.modelGetTogether.phone = phone;
            // 请求报名数据
            [weakSelf getSignUpDataWithName:name andPhone:phone];
        };
    }
    return _signUpView;
}

- (XZSignUpSuccessView *)signUpSuccessView {
    if (!_signUpSuccessView) {
        _signUpSuccessView = [[XZSignUpSuccessView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        __weak __typeof(&*self)weakSelf = self;
        _signUpSuccessView.blockJumpBtn = ^(UIButton *button) {
            if (button.tag == 102){ // 跳转到报名凭证按钮
                XZRegistrationCertificateViewController *registerCer = [[XZRegistrationCertificateViewController alloc]init];
                //       @"27"; //   @"17862066537";
                registerCer.pid = weakSelf.modelGetTogether.pid;
                registerCer.phone = weakSelf.modelGetTogether.phone;
                [weakSelf.navigationController pushViewController:registerCer animated:YES];
            }
            [weakSelf.viewBackGround removeFromSuperview];
        };
    }
    return _signUpSuccessView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, KProjectScreenWidth, KProjectScreenHeight - 113)]; // 290
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(290, 0, 0, 0);
        _webView.scrollView.contentOffset= CGPointMake(0, -290);
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
    }
    return _webView;
}

- (UIView *)viewBackGround {
    if (!_viewBackGround) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _viewBackGround = [[UIView alloc]initWithFrame:keyWindow.frame];
        _viewBackGround.backgroundColor = [UIColor blackColor];
        _viewBackGround.alpha = 0.6;
    }
    return _viewBackGround;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self settingNavTitle:@"活动"];
    [self createTabBar]; 
    // keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.keyWindow = keyWindow;
    // 创建webView
    [self.view addSubview:self.webView];
    [self webViewTopView]; // webView的头视图
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:nil];
    [self setRightNavButton:@"分享" withFrame:CGRectMake(0, 0, 60, 44) actionTarget:self action:nil color:XZColor(51, 51, 51)];
        // 请求数据
    [self requestActivityData];
}

#pragma mark ----- 请求数据
- (void)requestActivityData {
   
    NSString *urlPath = [self getUrlPath];
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlPath parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(response.responseObject){
            if (response.code == WebAPIResponseCodeFailed) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSDictionary *dataDict = response.responseObject[@"data"];
                    [self.modelGetTogether setValuesForKeysWithDictionary:dataDict];
                    self.tabBar.activityModel = self.modelGetTogether;
                    self.topWeb.modelActivity = self.modelGetTogether;
                    [self.webView loadHTMLString:self.modelGetTogether.party_info baseURL:[NSURL URLWithString:urlPath]];
                    [self setRightNavButton:@"分享" withFrame:CGRectMake(0, 0, 60, 44) actionTarget:self action:@selector(didClickShareBtn:) color:XZColor(51, 51, 51)];
                    
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                }
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
        }
    }];
    
}

- (NSString *)getUrlPath {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlPath = [NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%@&token=%@&pid=%@",kActivityDetailURL,[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,self.pid];
    return urlPath;
}

#pragma mark --- 报名数据请求
- (void)getSignUpDataWithName:(NSString *)name andPhone:(NSString *)phone {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"pid":[NSString stringWithFormat:@"%@",self.pid],
                                @"name":[NSString stringWithFormat:@"%@",name],
                               @"phone":[NSString stringWithFormat:@"%@",phone]
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kActivitySignUpURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"response.responseObject ===== %@",response.responseObject);
        if(response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                    if ([status isEqualToString:@"0"]) {
                        [weakSelf.signUpView removeFromSuperview];
                        [self.keyWindow addSubview:self.signUpSuccessView]; // 报名成功
                    }
                }else { // data为null
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                }
            }else {
                [weakSelf.signUpView removeFromSuperview];
                [weakSelf.viewBackGround removeFromSuperview];
                ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            }
        }else {
            [weakSelf.signUpView removeFromSuperview];
            [weakSelf.viewBackGround removeFromSuperview];
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
        }
    }];
}

#pragma mark --- 赞数据请求
- (void)getPraiseData {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"pid":[NSString stringWithFormat:@"%@",self.pid]
                                 };
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kActivityPraiseURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                    NSDictionary *dict = response.responseObject[@"data"];
                    if ([status isEqualToString:@"0"]) {// 点赞成功
                        self.tabBar.praiseNumber = [NSString stringWithFormat:@"%@",dict[@"praisenum"]];
                    }
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                }
            }else { // 已赞过
                ShowAutoHideMBProgressHUD(weakSelf.view,@"您已赞过");
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
        }
    }];
}

#pragma mark ----- 点击分享按钮
- (void)didClickShareBtn:(UIBarButtonItem *)item {
    // 判断是否登录
    [self DetermineWhetherTheLogin:^{
        if ([self.modelGetTogether.state isEqualToString:@"0"]) { // 不能分享
            ShowAutoHideMBProgressHUD(self.view,@"未通过审核不能分享！");
        }else if (self.modelGetTogether.sharetitle.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"未请求到分享数据！");
        }else {
            WLPublishSuccessViewController *share = [[WLPublishSuccessViewController alloc]init];
            share.modelActivity = self.modelGetTogether;
            [self.navigationController pushViewController:share animated:YES];
        }
    }];
}

#pragma mark ----- 判断是否登录
- (void)DetermineWhetherTheLogin:(void(^)()) block {
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        block();
    }else {// 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
    }
}

#pragma mark --- 底部的tabBar
- (void)createTabBar {
    XZActivityTabBar *tabBar = [[XZActivityTabBar alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 113, KProjectScreenWidth, 49)];
    self.tabBar = tabBar;
    tabBar.blockTabBarBtn = ^(UIButton *button) {
        // 判断是否已经登录
        [self DetermineWhetherTheLogin:^{
            if ([self.modelGetTogether.state isEqualToString:@"0"]) { // 不能操作
                ShowAutoHideMBProgressHUD(self.view,@"未通过审核不能操作！");
            }else {
                if (button.tag == 130) { // 评论
                    WLJYJViewController *comment = [[WLJYJViewController alloc] init];
                    comment.pid = self.pid;
                    [self.navigationController pushViewController:comment animated:YES];
                }else if (button.tag == 131) { // 赞
                    [self getPraiseData];
                }else { // 报名已结束
                    [self.keyWindow addSubview:self.viewBackGround];
                    [self.keyWindow addSubview:self.signUpView]; // 报名
                }
            }
        }];
    };
    [self.view addSubview:tabBar];
}

/** 详情页最上面部分 */
- (void)webViewTopView {
    XZWebTopView *topWeb = [[XZWebTopView alloc]initWithFrame:CGRectMake(0,-290, KProjectScreenWidth, 290)];
    self.topWeb = topWeb;
    [self.webView.scrollView addSubview:topWeb];
}

#pragma mark --- webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.webView.scrollView.scrollEnabled = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webView.scrollView.scrollEnabled = YES;
}

@end
