//
//  BabyPlanAccountViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/12.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultViewHeight 667
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#import "BabyPlanAccountViewController.h"
#import "CalculatorBabyPlanView.h"
#import "ShareViewController.h"
#import "FMRTChangeTradeKeyViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "LookAgreementViewController.h"
//#import "FMBabyPlanWebView.h"
#import "FMJSAndOCWebController.h"
#import "WLZhuCeViewController.h"
//#import "XZRechargeController.h"
#import "XZBankRechargeController.h" // 徽商充值

#import "FMKeyBoardNumberHeader.h"
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"
#import "WLFirstPageHeaderViewController.h"
#define KDefaultSurplusMoney  500
@interface BabyPlanAccountViewController ()<UIScrollViewDelegate,UITextFieldDelegate,NJKWebViewProgressDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showFirstTitle;
@property (weak, nonatomic) IBOutlet UITextField *inputTextMoney;
@property (weak, nonatomic) IBOutlet UILabel *yearAddMoney;
@property (weak, nonatomic) IBOutlet UILabel *exceptAddMoney;

@property (weak, nonatomic) IBOutlet UILabel *timeRunoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearExceptGetLabel;
@property (weak, nonatomic) IBOutlet UILabel *LockUpLabel;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSDictionary * dataSourceList;

@property (nonatomic, assign) int currentMoneyLabel;

@property (nonatomic, assign) int zidongtoubiao;

@property (nonatomic, assign) CGFloat surplusMoney;

@property (nonatomic, assign) BOOL haveAlreadyGetSurplusMoney;

@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@property (nonatomic,copy) NSString *jie_id;
@property (nonatomic,copy) NSString *initialvalue;
@property (nonatomic,copy) NSString *jiner;
@property (nonatomic,copy) NSString *tishi;
@property (nonatomic,copy) NSString *tishineirong;


@property (nonatomic, assign) int notYetRegisterHUIFU;

@property (weak, nonatomic) IBOutlet UIButton *addButtonTitle;

@end

@implementation BabyPlanAccountViewController

- (IBAction)littleNumberButtonOnClick:(id)sender {
    if(self.currentMoneyLabel <= 500)
    {
        return;
    }
    
    self.currentMoneyLabel = self.currentMoneyLabel - 100;
    self.inputTextMoney.text = [NSString stringWithFormat:@"%d",self.currentMoneyLabel];

    [self calculateCurrentData];
}

- (IBAction)addNumberButtonOnClick:(id)sender {
    
    self.currentMoneyLabel = self.currentMoneyLabel + 100;
    self.inputTextMoney.text = [NSString stringWithFormat:@"%d",self.currentMoneyLabel];
    [self calculateCurrentData];
}

-(void)calculateCurrentData
{
    self.yearAddMoney.text = [NSString stringWithFormat:@"%d",self.currentMoneyLabel * 12];
    self.exceptAddMoney.text = [NSString stringWithFormat:@"%.2lf",self.currentMoneyLabel * [self.dataSourceList[@"1"] floatValue] - self.currentMoneyLabel * 12];
    
}

- (IBAction)calculatorButtonOnClick:(id)sender {
    CalculatorBabyPlanView * calculate = [[CalculatorBabyPlanView alloc]init];
    [calculate showCalculateBabyPlayView];
}
-(void)readDataSource
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoneyCoefficient" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataSourceList = dictionary[@"data"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"宝贝计划"];
    
    [self readDataSource];
    self.currentMoneyLabel = 1000;
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
    
    
    
    UIView * loadViewXIB  = [[[NSBundle mainBundle] loadNibNamed:@"BabyPlanAccountViewController" owner:self options:nil]lastObject];
    loadViewXIB.userInteractionEnabled = YES;
    loadViewXIB.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KDefaultViewHeight);
    [scrollView addSubview:loadViewXIB];
    
    [self.addButtonTitle setTitle:self.buttonTitle forState:UIControlStateNormal];
     __weak __typeof(&*self)weakSelf = self;
    self.inputTextMoney.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];

     [self loadBabyPlanDataWithHTTPClient];
    
    [self calculateCurrentData];
    
   
    // Do any additional setup after loading the view from its nib.
}
-(void)keyBoardDown
{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

     [self getDataFromNetWork];
}

-(void)loadBabyPlanDataWithHTTPClient
{

//    NSString *string = @"";
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow};
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/baobeijihuajiuyiba" parameters:parameter completion:^(WebAPIResponse *response) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSDictionary * dic1 = [response.responseObject objectForKey:kDataKeyData];
                [self setUpThisBabyPlanUIContent:dic1];
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
        });
    }];
}

-(void)setUpThisBabyPlanUIContent:(NSDictionary *)dic1
{
    NSString * exceptMonth = [dic1 objectForKey:@"qixian"] == nil ? @"0" : [dic1 objectForKey:@"qixian"];
    NSString * saveMoneyDay = [dic1 objectForKey:@"mytouziri"] == nil ? @"1":[dic1 objectForKey:@"mytouziri"];
    self.showFirstTitle.text = [NSString stringWithFormat:@"%@,每月%@日加入",exceptMonth,saveMoneyDay];
    
    self.timeRunoutLabel.text = [self timemarkToNSStringTime:dic1[@"ended_time"]];
    
    NSString * yearExceptLILU = [NSString stringWithFormat:@"%@",dic1[@"lilv"] == nil ? @"0" : dic1[@"lilv"]];
    self.yearExceptGetLabel.text = yearExceptLILU;
    
    self.LockUpLabel.text = [NSString stringWithFormat:@"%@",exceptMonth];
    self.jie_id = dic1[@"jie_id"];
    
    
    NSString * titleButton = [dic1[@"weikaishi"] intValue] == 0 ? @"立即加入" : @"立即预约" ;
    [self.addButtonTitle setTitle:titleButton forState:UIControlStateNormal];
    
    self.initialvalue = [dic1 objectForKey:@"initialvalue"];
    if ([self.initialvalue integerValue] == 2) {
        
        self.tishi = [dic1 objectForKey:@"tishi"];
        self.tishineirong = [dic1 objectForKey:@"tishineirong"];
        self.jiner = [dic1 objectForKey:@"jiner"];
        
        self.currentMoneyLabel = [self.jiner intValue];
        self.inputTextMoney.text = [NSString stringWithFormat:@"%d",self.currentMoneyLabel];
        [self calculateCurrentData];
        
    }else if ([self.initialvalue integerValue] == 1){
        self.inputTextMoney.text = @"1000";
    }
    
    
}
-(NSString *)timemarkToNSStringTime:(NSString *)str{
    
    NSTimeInterval time = [str doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate: detaildate];
}
/** 宝贝计划--判断是否注册汇付 */
-(void)getDataFromNetWork
{
    if ([[CurrentUserInformation sharedCurrentUserInfo].weishangbang integerValue]== 0) {
        
        __weak __typeof(&*self)weakSelf = self;
        [FMRTAddCardToView showWithAddBtn:^{
            FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
            tieBank.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:tieBank animated:YES];
            
            //!!!!!---!!!!
        } hidView:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        return;
    }
    
    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi integerValue]==1)) {
        [self notYetToSetJiaoyiSecret];
        
        return;
    }

    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",babyPlanRegisterHuiFuURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient  getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (response.code == WebAPIResponseCodeSuccess)
            {
                NSDictionary * dict = response.responseObject;
                if (dict) {
                    [weakSelf setUpAllUseInfo:dict[@"data"]];
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
                }
                
            }
        });
    }];
}


-(void)notYetToSetJiaoyiSecret
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为了保障资金安全，请设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    alert.tag = 13456;
    [alert show];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
       if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self saveMoney];
        }
        
    }
    if (alertView.tag == 1005) {
        
        if (buttonIndex == 1) {
            ///自动投标
            ///交易记录
            int timestamp = [[NSDate date]timeIntervalSince1970];
            NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            
            NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",babyPlanAutoTenderURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
            
            WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];//WithTitle:@"自动投标" AndWithShareUrl:url
            viewController.navTitle = @"自动投标" ;
            viewController.shareURL = url;
            
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    if (alertView.tag == 13456) {
        if (buttonIndex == 1) {
            FMRTChangeTradeKeyViewController *tradeKeyVC = [[FMRTChangeTradeKeyViewController alloc]init];
            tradeKeyVC.typeTitle = titleSetting;
            tradeKeyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tradeKeyVC animated:YES];
        }else{
         
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
}

-(void)setUpAllUseInfo:(NSDictionary *)dict
{
    self.surplusMoney = [dict[@"keyongzheng"] == nil ? @"0" : dict[@"keyongzheng"] floatValue];
    self.haveAlreadyGetSurplusMoney = YES;
    self.zidongtoubiao = [dict[@"zidongtoubiao"] intValue];

}
- (IBAction)saveMoneyButtonOnClick:(id)sender {
    
    if ([self.initialvalue integerValue] == 2){
        
        if (self.tabBarController.selectedIndex == 0) {
            
            if ([self.tishi integerValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:self.tishineirong delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            if ([self.inputTextMoney.text floatValue] != [self.jiner floatValue]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"宝贝计划修改金额，请去【我的】—【宝贝计划】页面修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    }
    
    if (self.currentMoneyLabel > self.surplusMoney) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我要充值", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    if (self.zidongtoubiao != 1){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"预约宝贝计划需要开通自动投标，是否开通？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
        alert.tag = 1005;
        [alert show];
        return;
    }

     if (self.currentMoneyLabel < KDefaultSurplusMoney) {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"宝贝计划500元起投，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
         return;
     }
    
    if (self.currentMoneyLabel > 20000) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"宝贝计划单次加入金额小于等于20000元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    
    if ((self.currentMoneyLabel % 100) != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"投标金额必须是100的整数倍，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self inPutMoneyToTextFiled:self.currentMoneyLabel];

}
    
-(void)saveMoney
{
    //    判断是否已登录 如果没有登录
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    
//    FMJSAndOCWebController *viewController=[[FMJSAndOCWebController alloc]initWithTitle:@"充值" AndWithShareUrl:url];
//    viewController.hidesBottomBarWhenPushed=YES;
//    viewController.isShowRightButton = 1;
//    [self.navigationController pushViewController:viewController animated:YES];
    
//    XZRechargeController *viewController=[[XZRechargeController alloc]init];
    XZBankRechargeController *viewController=[[XZBankRechargeController alloc]init];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewOnClick
{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.text.length > 6) {
        if (string.length == 0) {
            
        }else
        {
            return NO;
        }
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
    
    int currentValue = [contentString intValue];
    if (currentValue > 20000)
    {
        textField.text = @"20000";
        self.currentMoneyLabel = 20000;
        [self calculateCurrentData];
        return NO;
    }else
    {
        self.currentMoneyLabel = [contentString intValue];
        [self calculateCurrentData];
        return YES;
    }
}
-(void)inPutMoneyToTextFiled:(CGFloat )money
{
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
    
    
    //NSString * urlString = kXZUniversalTestUrl(@"HomePageBuyBabyPlan");
    NSString * urlString = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Lend/toubiaobbjhappyuanshengliuer?");

    
    NSString *url=[NSString stringWithFormat:@"%@UserId=%@&AppId=huiyuan&AppTime=%d&TransAmt=%.2f&Token=%@&ProjId=%@",urlString,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,money,tokenlow,self.jie_id];

    
    WLFirstPageHeaderViewController *shareVC = [[WLFirstPageHeaderViewController alloc]init];
    shareVC.navTitle = @"宝贝计划";
    shareVC.shareURL = url;

    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
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
//    NSString * url = request.URL.absoluteString;
//    NSLog(@"URL:%@",url);
    return YES;
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}

@end


/*
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
 alert.tag = 1000;
 [alert show];
 }
 */
/** 宝贝计划--开通汇付 */
/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if (alertView.tag == 1000) {
 if (buttonIndex == 1) {
 NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
 WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
 viewController.shareURL = url;
 viewController.navTitle = @"开通汇付";
 viewController.comeForm = 1;
 viewController.hidesBottomBarWhenPushed=YES;
 [self.navigationController pushViewController:viewController animated:YES];
 
 }else
 {
 [self.navigationController popViewControllerAnimated:YES];
 }
 
 
 }
 if (alertView.tag == 1001) {
 if (buttonIndex == 1) {
 [self saveMoney];
 }
 
 }
 if (alertView.tag == 1005) {
 
 if (buttonIndex == 1) {
 ///自动投标
 ///交易记录
 int timestamp = [[NSDate date]timeIntervalSince1970];
 NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
 NSString *tokenlow=[token lowercaseString];
 
 NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",babyPlanAutoTenderURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
 
 ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"自动投标" AndWithShareUrl:url];
 viewController.hidesBottomBarWhenPushed=YES;
 [self.navigationController pushViewController:viewController animated:YES];
 }
 }
 
 }
 */

