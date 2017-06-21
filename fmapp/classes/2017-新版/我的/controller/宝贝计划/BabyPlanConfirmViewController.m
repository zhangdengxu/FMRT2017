//
//  BabyPlanConfirmViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/6.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultViewHeight 667
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#import "BabyPlanConfirmViewController.h"

#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "BabyPlanModel.h"
#import "WLFirstPageHeaderViewController.h"
@interface BabyPlanConfirmViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UILabel *babyPlanCount;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyInMonth;
@property (weak, nonatomic) IBOutlet UILabel *alreadySaveMonth;
@property (weak, nonatomic) IBOutlet UILabel *saveMonry;
@property (weak, nonatomic) IBOutlet UILabel *saveDay;

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;
@property (nonatomic , weak) UIWebView    * webShareWebView;
@end

@implementation BabyPlanConfirmViewController

-(void)loadView
{
    [super loadView];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"确认申购"];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = KDefaultBackGround;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, KDefaultViewHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    
    
    UIView * loadView  = [[[NSBundle mainBundle] loadNibNamed:@"BabyPlanConfirmViewController" owner:self options:nil]lastObject];
    loadView.userInteractionEnabled = YES;
    loadView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [scrollView addSubview:loadView];

    [self createDataToUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)createDataToUI
{
    self.babyPlanCount.text = self.babyPlan.title;
    self.saveMoneyInMonth.text = [NSString stringWithFormat:@"%@元",self.babyPlan.jiner];
//    NSLog(@"%@",_babyPlan.yitoucishu);
    self.alreadySaveMonth.text = [NSString stringWithFormat:@"%@/%@",self.babyPlan.yitoucishu, self.babyPlan.zongshu];
    self.saveMonry.text = [NSString stringWithFormat:@"%@元",self.babyPlan.jiner];//
    self.saveDay.text = [NSString stringWithFormat:@"本次存款日  %@",self.babyPlan.bencishijian];
}
-(int)turnToAlreadySaveMoney
{
    CGFloat a = [self.babyPlan.yicun floatValue] / [self.babyPlan.jiner floatValue];
    return (int)a;
}
-(NSString *)turnToThisDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (IBAction)payButtonOnClick:(id)sender {

    [self inPutMoneyToTextFiled:[self.babyPlan.jiner floatValue]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 宝贝计划--确认申购 */
-(void)inPutMoneyToTextFiled:(CGFloat )money
{
    [self.scrollView removeFromSuperview];
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"AppId=baobeijihua&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    //NSString * urlString = kXZUniversalTestUrl(@"BuyBabyPlan");
    
    NSString * urlString = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Lend/toubiaobbjhappliuer?");
    NSString *url=[NSString stringWithFormat:@"%@UserId=%@&AppId=baobeijihua&AppTime=%d&TransAmt=%.2f&Token=%@&ProjId=%@",urlString,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,money,tokenlow,self.babyPlan.jie_id];
    [self setUpWebView:url];
}

-(void)setUpWebView:(NSString *)shareUrl
{
    
    
    WLFirstPageHeaderViewController *shareVC = [[WLFirstPageHeaderViewController alloc]init];
    shareVC.navTitle = @"宝贝计划";
    shareVC.shareURL = shareUrl;
    
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
    
    /*
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
     */
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
