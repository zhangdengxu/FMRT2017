//
//  FMPurifyWrbViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/3/16.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMPurifyWrbViewController.h"

@interface FMPurifyWrbViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation FMPurifyWrbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(241/255.0) green:(73/255.0) blue:(71/255.0) alpha:1];
    UIWebView * webView = [[UIWebView alloc]init];
    webView.delegate = self;
    self.webView = webView;
    self.webView.backgroundColor = [UIColor colorWithRed:(241/255.0) green:(73/255.0) blue:(71/255.0) alpha:1];
    self.webView.frame = self.view.bounds;
    
    
    [FMHTTPClient getPath:@"http://weibo.com/rongtuojinrong" parameters:nil completion:^(WebAPIResponse *response) {
       
        NSLog(@"html:      %@",response.responseObject);
        
        
    }];
    
   
 //   NSURL *url = [NSURL URLWithString:@"http://weibo.com/rongtuojinrong"];
//    http://m.weibo.cn/u/3924727859
//    NSURL *url = [NSURL URLWithString:@"http://m.weibo.cn/u/3924727859"];
    NSURL * url = [NSURL URLWithString:@"http://m.weibo.cn/p/index?containerid=1008088a825b51c65f3e7b8d71415180fe9758&extparam=%E6%96%B0%E6%A0%87%E9%A2%84%E5%91%8A"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView setScalesPageToFit:YES];
    
    
    // Do any additional setup after loading the view.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString * url = request.URL.absoluteString;
    NSLog(@"url:%@",url);
    
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSLog(@"error:%@",error);

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
