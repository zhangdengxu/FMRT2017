//
//  XZAboutUsController.m
//  fmapp
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//  关于我们

#import "XZAboutUsController.h"
#import "AboutViewController.h" // 关于我们
#import "ServiceViewController.h" // 客户服务

@interface XZAboutUsController ()

@end

@implementation XZAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavTitle:@"关于我们"];
    
    //
    [self createLineWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50) text:@"关于我们" hasArrow:YES tag:321];
    //
    [self createLineWithFrame:CGRectMake(0, 51, KProjectScreenWidth, 50) text:@"联系客服" hasArrow:YES tag:322];
    //
    [self createLineWithFrame:CGRectMake(0, 102, KProjectScreenWidth, 50) text:@"版本号" hasArrow:NO tag:0];
}

- (void)createLineWithFrame:(CGRect)frame text:(NSString *)text hasArrow:(BOOL)hasArrow tag:(NSInteger)tag {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    //
    UIView *line = [[UIView alloc] init];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom);
        make.left.equalTo(view);
        make.width.equalTo(KProjectScreenWidth);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = XZBackGroundColor;
    
    UILabel *labelLeft = [[UILabel alloc] init];
    [view addSubview:labelLeft];
    [labelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];
    labelLeft.text = text;
    labelLeft.textColor = XZColor(53, 53, 53);
    labelLeft.font = [UIFont systemFontOfSize:15.0f];
    
    if (hasArrow) {
        UIImageView *imgRight = [[UIImageView alloc] init];
        [view addSubview:imgRight];
        [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.centerY.equalTo(view);
            make.width.equalTo(@(15 * 0.5));
            make.height.equalTo(@(24 * 0.5));
        }];
        imgRight.image = [UIImage imageNamed:@"帮助中心_右箭头_1702"];
        
        UIButton *btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCover.frame = view.bounds;
        [view addSubview:btnCover];
        btnCover.tag = tag;
        [btnCover addTarget:self action:@selector(didClickCoverButton:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        UILabel *labelRight = [[UILabel alloc] init];
        [view addSubview:labelRight];
        [labelRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.centerY.equalTo(view);
        }];
        labelRight.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        labelRight.textColor = XZColor(164, 164, 164);
    }
    
}

#pragma mark ---- 点击按钮
- (void)didClickCoverButton:(UIButton *)button {
    if (button.tag == 321) { // 关于我们
        AboutViewController *about = [[AboutViewController alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }else if (button.tag == 322){ // 联系客服
        ServiceViewController *service = [[ServiceViewController alloc] init];
        service.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:service animated:YES];
    }
}

@end
