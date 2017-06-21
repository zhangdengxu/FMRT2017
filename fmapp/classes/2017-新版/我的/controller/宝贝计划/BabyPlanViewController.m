//
//  BabyPlanViewController.m
//  fmapp
//
//  Created by runzhiqiu on 15/12/30.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "BabyPlanViewController.h"
#import "LookAgreementViewController.h"
#import "FMSettings.h"
#import "RegexKitLite.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "ShareViewController.h"

#define KDefaultSurplusMoney  500
@interface BabyPlanViewController ()<UITextFieldDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *surplusMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputNumberMoney;
@property (weak, nonatomic) IBOutlet UIButton *selectAgreeMentButton;
@property (weak, nonatomic) IBOutlet UILabel *yearGetMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *detalModelLabel;
@property (nonatomic,assign)  CGFloat surplusMoney;
@property (nonatomic,copy)  NSString * inputMoney;

@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *putMoneyDayInMonth;

@property (weak, nonatomic) IBOutlet UIButton *activityButton;

@property (nonatomic,copy) NSString *jie_id;

@end

@implementation BabyPlanViewController


- (IBAction)selectAgreeMentButtonOnClick:(UIButton *)button {
    button.selected = !button.selected;
}


- (IBAction)lookUpAgreeMentButtonOnClick:(UIButton *)sender {
    LookAgreementViewController * LookView = [[LookAgreementViewController alloc]init];
    LookView.shareURL = babyPlanInvestmentAgreementURL;
    LookView.navTitle = @"宝贝计划投资协议";
    LookView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:LookView animated:YES];
    
    
}
- (IBAction)saveMoneyButtonOnClick:(UIButton *)sender {
     self.inputMoney = self.inputNumberMoney.text ;
    
//    __weak typeof(self) wself = self;
    
    //还要判断选中状态
    if(self.selectAgreeMentButton.selected)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"操作提示" message:@"您还未勾选宝贝计划投资协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //NSLog(@"%@",self.inputMoney);
    
    if (![self.inputMoney isMatchedByRegex:@"^\\d+(\\.\\d+)?$"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入信息提示" message:@"您输入的金额不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.surplusMoney >= KDefaultSurplusMoney ) {
        
        if ([self.inputMoney floatValue] >= KDefaultSurplusMoney) {
            
            
            if ([self.inputMoney floatValue] >= self.surplusMoney) {
                
//                UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"您输入的金额大于可用余额" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction * quedingAction = [UIAlertAction actionWithTitle:@"我要充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    [wself saveMoney];
//                }];
//                UIAlertAction * cannelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:quedingAction];
//                [alert addAction:cannelAction];
//                [self presentViewController:alert animated:YES completion:nil];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的金额大于可用余额" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我要充值", nil];
                alert.tag = 1000;
                [alert show];

            }else
            {
                [self inPutMoneyToTextFiled:[self.inputMoney floatValue]];
            }
            
            
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"宝贝计划500元起投，请输入正确金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else
    {
        
//            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"宝贝计划500元起投，您当前可用余额不足" preferredStyle:UIAlertControllerStyleAlert];
//        
//            UIAlertAction * quedingAction = [UIAlertAction actionWithTitle:@"我要充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                [wself saveMoney];
//            }];
//            UIAlertAction * cannelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:quedingAction];
//            [alert addAction:cannelAction];
//            [self presentViewController:alert animated:YES completion:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"余额不足" message:@"宝贝计划500元起投，您当前可用余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我要充值", nil];
        alert.tag = 1001;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
         [self saveMoney];
        }
        
    }
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self saveMoney];
        }
    }
}


-(void)saveMoney
{
    //    判断是否已登录 如果没有登录
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
//        [self presentModalViewController:navController animated:YES];

        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=jiekuan&shijian=%d&token=%@",babyPlanPayURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"充值" AndWithShareUrl:url];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)loadView
{
    
    self.view = [[[NSBundle mainBundle]loadNibNamed:@"BabyPlanViewController" owner:self options:nil] firstObject];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    UILabel * yuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
    yuanLabel.text = @"元";
    yuanLabel.font = [UIFont systemFontOfSize:13];
    yuanLabel.textColor = [UIColor grayColor];
    self.inputNumberMoney.rightView = yuanLabel;
    self.inputNumberMoney.rightViewMode = UITextFieldViewModeAlways;
    
}
/** 宝贝计划--进入页面请求数据 */
-(void)getDataFromNetWork
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",babyPlanVCURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient  getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code == WebAPIResponseCodeFailed)
            {

                NSDictionary * dict = response.responseObject;
                if (dict) {
                    [weakSelf setUpAllUseInfo:dict];
//                    NSLog(@"%@",dict);
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
                }
                
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求数据失败");
            }
        });
        
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"宝贝计划"];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataFromNetWork];
    
}
-(void)setUpAllUseInfo:(NSDictionary *)dict
{
    [self setUpUILabel:dict[@"data"]];
    self.surplusMoney = [dict[@"zhhyue"] == nil ? @"0" : dict[@"zhhyue"] floatValue];
    NSString * surPlusMoney = [NSString stringWithFormat:@"%@元",dict[@"zhhyue"]];
    
    self.surplusMoneyLabel.text = surPlusMoney;
    
    
}
-(void)setUpUILabel:(NSDictionary * )dict
{
    if (!dict) {
        return;
    }
    NSString * lilv = [NSString stringWithFormat:@"%@",dict[@"lilv"]];
    NSString * lilvbaifen = @"%";
    
    //第一段
    NSDictionary * attrDict1 = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:60]};
    //    //第二段
    NSDictionary * attrDict2 = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
    
    NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithString:lilv attributes:attrDict1];
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:lilvbaifen  attributes: attrDict2];
    [attrStr1 appendAttributedString: attrStr2];
    self.yearGetMoneyLabel.attributedText = attrStr1;
    
    
    
    NSString * qixian = [NSString stringWithFormat:@"%@",dict[@"qixian"]];
    NSString * geyue = @"个月";
    //第一段
    NSDictionary * attrDict3 = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:31]};
    //第二段
    NSDictionary * attrDict4 = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:qixian attributes: attrDict3];
    
    NSAttributedString *attrStr4 = [[NSAttributedString alloc] initWithString:geyue  attributes: attrDict4];
    //合并
    [attrStr3 appendAttributedString: attrStr4];
    self.detalModelLabel.attributedText = attrStr3;
    self.putMoneyDayInMonth.text = [NSString stringWithFormat:@"%@号",dict[@"mytouziri"] == nil ? @"8" : dict[@"mytouziri"]];
    self.jie_id = dict[@"jie_id"];
    NSString * titleButton = [dict[@"weikaishi"] integerValue] == 0 ? @"立即加入" : @"立即预约" ;
    [self.activityButton setTitle:titleButton forState:UIControlStateNormal];

}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    self.inputMoney = textField.text ;
}

-(void)inPutMoneyToTextFiled:(CGFloat )money
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaobbjhshuzhi
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&jiner=%f&token=%@&jie_id=%@",babyPlanVCURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,money,tokenlow,self.jie_id];
    [self setUpWebView:url];
}

-(void)setUpWebView:(NSString *)shareUrl
{
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.opaque = NO;
    [mainWebView setOpaque:YES];
    mainWebView.scalesPageToFit = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
