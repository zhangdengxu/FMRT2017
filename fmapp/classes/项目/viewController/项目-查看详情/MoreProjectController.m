//
//  MoreProjectController.m
//  fmapp
//
//  Created by apple on 15/3/15.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "MoreProjectController.h"
#import "ShareViewController.h"
#import "MakeABidWebViewController.h"
#import "WLZhuCeViewController.h"
#import "WLNewBesureViewController.h"

#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"
#import "FMRTChangeTradeKeyViewController.h"

@interface MoreProjectController ()<UIAlertViewDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,weak)UISegmentedControl   *segmentedControl;
@property (nonatomic,strong)ProjectModel       *model;
@property (nonatomic , strong)UIScrollView                        *tableScorllView;
@property (nonatomic,weak)  UIWebView         *webShareWebView;
@property(nonatomic,weak)UIButton *bottomBtn;
@property(nonatomic,strong)NSString *currentUrl;

///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@property (nonatomic,weak)  UIWebView         *webShareWebView1;
@property (nonatomic,weak)  UIWebView         *webShareWebView2;


@end

@implementation MoreProjectController
- (id)initWithProjectModel:(ProjectModel *)model
{
    self=[super init];
    if (self) {
        self.enableCustomNavbarBackButton=FALSE;
        self.model=model;
    }
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.segmentedControl setHidden:NO];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    _progressProxy.progressDelegate = nil;
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy = nil;
    self.webShareWebView.delegate = nil;
    self.webShareWebView1.delegate = nil;
    self.webShareWebView2.delegate = nil;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavView];
    [self createMainView];
    [self createBottomBtn];
}

-(void)createBottomBtn{
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setTitle:@"立即投资" forState:UIControlStateNormal];
    bottomButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [bottomButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [bottomButton setFrame:CGRectMake(0, KProjectScreenHeight-55-64, KProjectScreenWidth, 55)];
    if (self.projectStyle==3) {
        [bottomButton setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
    }
    if (self.projectStyle==2) {
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            if (self.fengxiandengji.length>0) {
                //这里只判断风险评估是否符合
                //不符合 立即投资灰色不可点击
                [bottomButton setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
            }else{
                //不符合 蓝色可点击
                [bottomButton setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
                [bottomButton addTarget:self action:@selector(theBottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            
            [bottomButton setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
        }
    }
    if (self.projectStyle==1) {
        [bottomButton setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
        [self dealBottomBtn];
    }
    [self.view addSubview:bottomButton];
    bottomButton.tag = 852;
    self.bottomBtn = bottomButton;
    
}

- (void)dealBottomBtn
{
    if (self.projectStyle==1) {
        NSDate *startDate=[self convertDateFromString:self.model.start_time];
        NSTimeInterval cha=[startDate timeIntervalSinceNow];
        [self intervalSinceNow:cha];
    }
    
}

//返回设定时间与当前时间的差
- (void )intervalSinceNow: (NSInteger) theDate

{
    if (theDate<0) {
        
        [self DetailDateWithDays:@"0" AndWithHours:@"0" AndWithMinutes:@"0" AndWithSeconds:@"0"];
    }
    else
    {
        NSTimeInterval  cha=theDate;
        
        NSString *days=@"";
        NSString *house=@"";
        NSString *mins=@"";
        NSString *sens=@"";
        //秒
        sens = [NSString stringWithFormat:@"%d",(int)cha%60];
        
        if(cha>60)
        {
            //分
            mins = [NSString stringWithFormat:@"%d", (int)cha/60%60];
            
        }
        if (cha>3600)
        {
            //时
            house = [NSString stringWithFormat:@"%d", (int)cha/3600%24];
        }
        if (cha>86400) {
            //天
            days = [NSString stringWithFormat:@"%d", (int)cha/86400];
        }
        
        //底部button显示剩余时间，到时间后创建视图
        [self DetailDateWithDays:days AndWithHours:house AndWithMinutes:mins AndWithSeconds:sens];
    }
}
-(void)DetailDateWithDays:(NSString *)dayStr AndWithHours:(NSString *)hourStr AndWithMinutes:(NSString *)minuteStr AndWithSeconds:(NSString *)secondStr
{
    __block int timedays=dayStr?[dayStr intValue]:0; //倒计时天数
    __block int timehours=hourStr?[hourStr intValue]:0; //倒计时小时
    __block int timeminutes=minuteStr?[minuteStr intValue]:0; //倒计时分钟
    __block int timeseconds=[secondStr intValue]; //倒计时秒数
    
    //    timedays=0;
    //    timehours=0;
    //    timeminutes=5;
    //    timeseconds=5;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeminutes==5&&timeseconds==0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //设置提醒
                //                if ([self.ShakeBtn.titleLabel.text isEqualToString:@"取消提醒"]) {
                //                    ShowImportErrorAlertView(@"摇奖时间到了");
                //
                //                }
                
            });
        }
        if(timedays<=0&&timeseconds<=0&&timeminutes<=0&&timehours<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                self.projectStyle = ProjectInprogressOperationStyle;
                //                if (self.projectStyle==ProjectInprogressOperationStyle) {
                //                    [self deleteAllSubViewsAndGetNewData];
                //                }
                /**
                 *倒计时结束后 按钮变字 有可点击方法
                 */
                self.projectStyle = 2;
                [self.bottomBtn setTitle:@"立即投资" forState:UIControlStateNormal];
                [self.bottomBtn addTarget:self action:@selector(theBottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
            });
        }else{
            if (timeseconds<0) {
                
                if (timeminutes==0) {
                    if (timehours==0) {
                        timehours=23;
                        timedays--;
                    }else
                    {
                        timehours--;
                        
                    }
                    timeminutes=59;
                }
                else
                {
                    timeminutes--;
                }
                timeseconds=59;
                
            }
            
            int seconds = timeseconds % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //                设置界面的按钮显示 根据自己需求设置
                NSString *chaStr=[NSString stringWithFormat:@"投标倒计时 %d天%d时%d分%d秒",timedays,timehours,timeminutes,seconds];
                [self.bottomBtn setTitle:chaStr forState:UIControlStateNormal];
                //                NSString *timeStr = [NSString stringWithFormat:@"%@",self.model.start_time];
                //                if (timeStr.length>=16) {
                //                    NSString *timeSring = [timeStr substringWithRange:NSMakeRange(5, 11)];
                //                    timeSring = [timeSring stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                //                    [self.bottomBtn setTitle:[NSString stringWithFormat:@"即将开始:%@开投",timeSring] forState:UIControlStateNormal];
                //                }
            });
            timeseconds--;
        }
    });
    dispatch_resume(_timer);
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    Log(@"%@",uiDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

/**
 *立即投资
 */
-(void)theBottomBtnClick{
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    if (!([[CurrentUserInformation sharedCurrentUserInfo].weishangbang integerValue]==1)) {
        [self notYetToOpenHuiFuTianXia];
        return;
    }

    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi integerValue]==1)) {
        [self notYetToSetJiaoyiSecret];
        return;
    }
    
    WLNewBesureViewController *vc = [[WLNewBesureViewController alloc]init];
    vc.fengxiandengji = self.fengxiandengji;
    vc.projectId = self.projectId;
    vc.dizenge = self.dizenge;
    vc.lilvyou = self.model.lilvyou;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)notYetToOpenHuiFuTianXia
{
    __weak __typeof(&*self)weakSelf = self;
    [FMRTAddCardToView showWithAddBtn:^{
        FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
        tieBank.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:tieBank animated:YES];
        
        //!!!!!---!!!!
    }];

}
-(void)notYetToSetJiaoyiSecret
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为了保障资金安全，请设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alert show];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        FMRTChangeTradeKeyViewController *tradeKeyVC = [[FMRTChangeTradeKeyViewController alloc]init];
        tradeKeyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tradeKeyVC animated:YES];
    }
}
/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
        WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
        viewController.shareURL = url;
        viewController.navTitle = @"开通汇付";
        viewController.comeForm = 7;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
 */


- (void)createMainView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3,self.view.bounds.size.height +20.0f);
    mainScrollView.pagingEnabled=YES;
    mainScrollView.bounces=NO;
    mainScrollView.scrollEnabled=NO;
    
    self.tableScorllView=mainScrollView;
    [self.view addSubview:mainScrollView];
    
//    NSArray *urlarr=[NSArray arrayWithObjects:
//                     kXZUniversalTestUrl(@"GetProjectDetail"),
//                     kXZUniversalTestUrl(@"GetProjectRepaymentPlan"),
//                     kXZUniversalTestUrl(@"GetProjectBidRecord"),nil
//                     ];
    NSArray *urlarr=[NSArray arrayWithObjects:
                     kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Lend/xiangmuinfoliuer?"),
                     kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Lend/hkmoxingwebliuer?"),
                     kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Lend/toulistwebliuer?"),nil
                     ];
    NSString *userId = [CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NJKWebViewProgress *progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy = progressProxy;
    CGFloat progressBarHeight = 2.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    NJKWebViewProgressView * progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView = progressView;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    
    for(int i=0;i<3;i++)
    {
        NSString *url=nil;
        url=[NSString stringWithFormat:@"%@UserId=%@&AppId=huiyuan&AppTime=%@&Token=%@&jie_id=%@",urlarr[i],userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
        
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(KProjectScreenWidth*i, 0, KProjectScreenWidth, KProjectScreenHeight-64-55)];
        webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            [webView.scrollView.mj_header endRefreshing];
            
        }];
        if (self.projectStyle==ProjectInprogressOperationStyle) {
            webView.frame=CGRectMake(KProjectScreenWidth*i, 0, KProjectScreenWidth, KProjectScreenHeight-64-47);
        }
        [self.tableScorllView addSubview:webView];
        if (i==0) {
            self.webShareWebView=webView;
            
            self.webShareWebView.delegate = _progressProxy;
            
            
            
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [self.webShareWebView loadRequest:urlRequest];
            
        }else if(i == 1){
            webView.delegate = _progressProxy;
            self.webShareWebView1 = webView;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }else if(i == 2)
        {
            webView.delegate = _progressProxy;
            self.webShareWebView2 = webView;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

        }else
        {
            webView.delegate = _progressProxy;
            
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

        }
        
    }
    
    
    if (self.projectStyle!=ProjectInprogressOperationStyle) {
        
        return;
    }
    
}


- (void)createNavView
{
    [self setLeftNavButtonFA:FMIconLeftArrow withFrame:CGRectMake(0, 0, 30, 44) actionTarget:self action:@selector(backPreviousView)];
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"描述",@"还款模型",@"投标记录", nil]];
    segmentedControl.tintColor = XZColor(14, 93, 210);
    [segmentedControl setFrame:CGRectMake((KProjectScreenWidth-240)/2, 7, 240, 30)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    
    self.segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;
}
- (void)backPreviousView
{

    NSString *currentURL = [self.webShareWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if ([currentURL isEqualToString:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/xiangmuinfo"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.webShareWebView canGoBack]&&(self.segmentedControl.selectedSegmentIndex==0)) {
        [self.webShareWebView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)segmentedControlChange:(id)sender
{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    Log(@"%ld",(long)seg.selectedSegmentIndex);
    self.tableScorllView.contentOffset=CGPointMake(seg.selectedSegmentIndex*KProjectScreenWidth, 0);
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}



@end
