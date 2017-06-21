//
//  WeiViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 15/12/28.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "WeiViewController.h"

@interface WeiViewController ()<UIScrollViewDelegate>
{
    
    UIScrollView *mainScrollView;
}
@end

@implementation WeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self settingNavTitle:@"微信客服"];
    [self settingNavTitle:self.navTitle];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];

    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 700);
    
    [self.view addSubview:mainScrollView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
    // @"微信客服内容页_02.png"
    [imageView setImage:[UIImage imageNamed:self.imgName]];
    [mainScrollView addSubview:imageView];
}

@end
