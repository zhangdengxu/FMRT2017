//
//  MoneyTiXianViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultViewHeight 667
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#import "MoneyTiXianViewController.h"
#import "ShowMessageInfoView.h"
#import "RegexKitLite.h"
#import "LookAgreementViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "ShareViewController.h"
#import "WLZhuCeViewController.h"
#import "FMKeyBoardNumberHeader.h"

@interface MoneyTiXianViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) ShowMessageInfoView * showView;
@property (weak, nonatomic) IBOutlet UILabel *anyMoneyInUser;
@property (nonatomic,assign)  CGFloat surplusMoney;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;

@property (nonatomic , weak) UIWebView    * webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) BOOL withDraw;

@end

@implementation MoneyTiXianViewController
/**
 *
 1.普通取现：资金在下一工作日到账，手续费2元/笔。
 2.快速取现：工作日14:30前提交申请，当天到账。14:30之后提交申请，第二个工作日到账。手续费万5+2元/笔。
 3.即时取现：当天到账。手续费万5+2元/笔。目前仅支持取现至工商银行、招商银行卡。
 */
-(void)loadView
{
    [super loadView];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"提现"];
    
    self.withDraw = NO;
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.backgroundColor = KDefaultBackGround;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, KDefaultViewHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewOnClick)];
    
    [scrollView addGestureRecognizer:tapGesture];
    [self.view addSubview:scrollView];
    
    UIView * loadViewXIB  = [[[NSBundle mainBundle] loadNibNamed:@"MoneyTiXianViewController" owner:self options:nil]lastObject];
    loadViewXIB.userInteractionEnabled = YES;
    loadViewXIB.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [scrollView addSubview:loadViewXIB];
    
    __weak __typeof(&*self)weakSelf = self;
    self.inputTextFiled.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    self.navBackButtonRespondBlock = ^(){
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

-(void)keyBoardDown
{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataFromNetWorkYUE];
}

-(void)getDataFromNetWorkYUE
{
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",withDrawalURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient  getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code == WebAPIResponseCodeSuccess)
            {
                NSDictionary * dict = response.responseObject;
                if (dict) {
                    [weakSelf setUpAllUseInfo:dict[@"data"]];
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
                }
                
            }else
            {
                NSDictionary * dict = response.responseObject;
                int huifu = [dict[@"huifu"] intValue];
                if (huifu == 1) {
                    /**
                     *  汇付未注册
                     */
                    [weakSelf notYetToOpenHuiFuTianXia];
                    
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请求数据失败");
                }
            }
        });
    }];
}
-(void)notYetToOpenHuiFuTianXia
{
    //    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"您尚未开通汇付" preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction * quedingAction = [UIAlertAction actionWithTitle:@"开通汇付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //        LookAgreementViewController * lookView = [[LookAgreementViewController alloc]init];
    //        lookView.shareURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/kaihuyuansheng?user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].userId];
    //        lookView.navTitle = @"开通汇付";
    //        lookView.hidesBottomBarWhenPushed=YES;
    //        [self.navigationController pushViewController:lookView animated:YES];
    //
    //    }];
    //
    //    UIAlertAction * cannelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }];
    //    [alert addAction:quedingAction];
    //    [alert addAction:cannelAction];
    //    [self presentViewController:alert animated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未开通汇付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通汇付", nil];
    alert.tag = 1001;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
            
            WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
            viewController.shareURL = url;
            viewController.navTitle = @"开通汇付";
            viewController.comeForm = 5;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//-(void)getDataFromNetWork
//{
//    __weak __typeof(&*self)weakSelf = self;
////    ShowAutoHideMBProgressHUD(weakSelf.view,@"正在加载...");
//    int timestamp = [[NSDate date]timeIntervalSince1970];
//    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//    NSString *tokenlow=[token lowercaseString];
//
//    NSString *url=[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxun?user_id=%@&appid=huiyuan&shijian=%d&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
//
//    [FMHTTPClient  getPath:url parameters:nil completion:^(WebAPIResponse *response) {
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            if (response.code == WebAPIResponseCodeSuccess) {
//                NSDictionary * dict = response.responseObject;
//                [weakSelf setUpAllUseInfo:dict[@"data"]];
//            }else
//            {
//                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
//            }
//        });
//    }];
//}
-(void)setUpAllUseInfo:(NSDictionary *)dict
{
    if (dict) {
        self.anyMoneyInUser.text = dict[@"keyong"] == nil ? @"0.00" : dict[@"keyong"];
        NSString * strSurplus = dict[@"keyongzheng"] == nil ? @"0.00" : dict[@"keyongzheng"];
        self.surplusMoney = [strSurplus floatValue];
    }
}
-(void)scrollViewOnClick
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.showView showMessageInfoViewWilldealloc];
    self.inputTextFiled.font = [UIFont systemFontOfSize:16];
    self.showView = nil;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (!self.showView) {
        ShowMessageInfoView * showView = [ShowMessageInfoView showMessageinfoViewOnThisViewLocation:ShowMessageInfoViewLocationUp];
        showView.font = 14;
        self.showView = showView;
    }
    NSString * contentString;
    if (string.length == 0 ) {
        if (textField.text.length > 0) {
            contentString = [textField.text substringToIndex:textField.text.length - 1];
        }else
        {
            contentString = nil;
        }
    }else{
        contentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    if (contentString.length > 11) {
        return NO;
    }
    
    if (![contentString isMatchedByRegex:@"^\\d+(\\.\\d+)?$"]) {
        return YES;
    }
    
    CGFloat  money = [contentString floatValue];
    NSString * showString = [NSString stringWithFormat:@"预计您每天将损失%@元的收益",[self countMoney:money]];
    [self.showView showMessageInfoViewWithString:showString showString:contentString showView:textField];
    
    return YES;
}
-(NSString *)countMoney:(CGFloat)money
{
    if (!money) {
        return [NSString stringWithFormat:@"0"];
    }
    CGFloat retFloat = money * 0.15 / 365;
    
    return [NSString stringWithFormat:@"%.2lf",retFloat];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.view endEditing:YES];
}
- (IBAction)getMoreMoneyButtonOnClick:(id)sender {
    if ([self.inputTextFiled.text floatValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入信息提示" message:@"输入的金额不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.inputTextFiled.text isMatchedByRegex:@"^\\d+(\\.\\d+)?$"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入信息提示" message:@"您输入的金额不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.inputTextFiled.text floatValue] <= self.surplusMoney) {
        [self inPutMoneyToTextFiled:[self.inputTextFiled.text floatValue]];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入信息提示" message:@"您输入的金额大于可提现金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)inPutMoneyToTextFiled:(CGFloat )money
{
    
    self.withDraw = YES;
    //    int timestamp = [[NSDate date]timeIntervalSince1970];
    //    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    //    NSString *tokenlow=[token lowercaseString];
    //
    //    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&jiner=%f&token=%@",didClickWithDrawalBtnURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,money,tokenlow];
    
    
    
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        //        [self presentModalViewController:navController animated:YES];
        
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    
    NSString * urlString = kXZUniversalTestUrl(@"Cash");
    
    NSString *url=[NSString stringWithFormat:@"%@&UserId=%@&AppId=huiyuan&AppTime=%d&TransAmt=%.2f&Token=%@",urlString,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,money,tokenlow];
    
    
    
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"提现" AndWithShareUrl:url];
    self.inputTextFiled.text = @"";
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

-(void)setUpWebView:(NSString *)shareUrl
{
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.opaque = NO;
    [mainWebView setOpaque:YES];
    [mainWebView setUserInteractionEnabled:YES];
    mainWebView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    for (UIView *subView in [mainWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [mainWebView setBackgroundColor:[UIColor clearColor]];
    self.webShareWebView = mainWebView ;
    [self.view addSubview:self.webShareWebView];
    [self.view bringSubviewToFront:mainWebView];
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webShareWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:shareUrl]];
    [self.webShareWebView loadRequest:urlRequest];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}
/*
 
 金额 ＊ 0.15 ／365
 您每日将会损失
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
