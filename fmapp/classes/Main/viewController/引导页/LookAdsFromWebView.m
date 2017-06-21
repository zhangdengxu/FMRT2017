//
//  LookAdsFromWebView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)

#import "LookAdsFromWebView.h"
#import "UIButton+Bootstrap.h" //修改右侧button

@interface LookAdsFromWebView ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView * webView;
@end

@implementation LookAdsFromWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:20];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"热门活动";
    self.navigationItem.titleView = labelTitle;

    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navButton.frame = kNavButtonRect;
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    [navButton addAwesomeIcon:FMIconLeftArrow beforeTitle:YES];
    
    [navButton addTarget:self action:@selector(backToPrevController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    self.navigationItem.leftBarButtonItem = navItem;
    
    
}
- (void)backToPrevController
{

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setShareURL:(NSString *)shareURL
{
    _shareURL = shareURL;
    UIWebView * webView = [[UIWebView alloc]init];
    webView.delegate = self;
    [self.view addSubview:webView];
    webView.frame = CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenHeight) ;
    self.webView  = webView;
    NSURL *url = [NSURL URLWithString:shareURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void) setLeftNavButtonFA:(NSInteger)buttonType withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action
{
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    [navButton addAwesomeIcon:buttonType beforeTitle:YES];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    }else{
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    self.navigationItem.leftBarButtonItem = navItem;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
