//
//  XZTestViewController.m
//  fmapp
//
//  Created by admin on 17/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//  图片

#import "XZTestViewController.h"

@interface XZTestViewController ()

@end

@implementation XZTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 200, 60)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"推荐2"];
}


@end
