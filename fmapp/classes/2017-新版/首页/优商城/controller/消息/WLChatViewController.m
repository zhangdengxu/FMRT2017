//
//  WLChatViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/5/16.
//  Copyright © 2016年 yk. All rights reserved.
//
//跳转QQ临时聊天界面

#import "WLChatViewController.h"

@interface WLChatViewController ()<UIWebViewDelegate>

@end

@implementation WLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"客服聊天"];
    
    [self createChatWebView];
}

-(void)createChatWebView{

    
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        

}
@end
