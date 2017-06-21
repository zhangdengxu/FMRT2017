//
//  XZTabBar.m
//  fmapp
//
//  Created by admin on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
// 聚一聚首页tabBar

#import "XZTabBar.h"
#import "XZLargeButton.h"

@implementation XZTabBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTabBar];
    }
    return self;
}

- (void)setUpTabBar {
    self.backgroundColor = [UIColor whiteColor];
    UIView *tabBar = [[UIView alloc]init];
    [self addSubview:tabBar];
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.equalTo(self.mas_height); // 49
    }];
    tabBar.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgPublish = [[UIImageView alloc]init];
    [tabBar addSubview:imgPublish];
    [imgPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tabBar.mas_centerX);
        make.centerY.mas_equalTo(tabBar.mas_centerY).offset(-15);
        make.height.and.width.equalTo(@40);
    }];
    imgPublish.image = [UIImage imageNamed:@"发布"];
    imgPublish.layer.masksToBounds = YES;
    imgPublish.layer.cornerRadius = 10;
    
    /** 发布 */
    UILabel *labelPublish = [[UILabel alloc]init];
    [tabBar addSubview:labelPublish];
    [labelPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tabBar.mas_bottom).offset(-2);
        make.centerX.equalTo(imgPublish.mas_centerX);
    }];
    labelPublish.text = @"发布";
    labelPublish.font = [UIFont systemFontOfSize:13];
    labelPublish.textColor = [UIColor darkGrayColor];
    
    /** 发布按钮 */
    UIButton *btnPublish = [[UIButton alloc]init];
    [tabBar addSubview:btnPublish];
    [btnPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPublish.mas_left).offset(-10);
        make.right.equalTo(imgPublish.mas_right).offset(10);
        make.top.equalTo(tabBar.mas_top);
        make.bottom.equalTo(tabBar.mas_bottom);
    }];
    btnPublish.tag = 100;
    btnPublish.backgroundColor = [UIColor clearColor];
    [btnPublish addTarget:self action:@selector(didClickMyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 我的参与 */
    XZLargeButton *btnParticipate = [[XZLargeButton alloc]init];
    [tabBar addSubview:btnParticipate];
    [btnParticipate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelPublish.mas_centerX).offset(-(KProjectScreenWidth / 4.0));
        make.top.equalTo(tabBar.mas_top);
        make.bottom.equalTo(labelPublish.mas_bottom);
    }];
    [btnParticipate setTitle:@"我的参与" forState:UIControlStateNormal];
    [btnParticipate setImage:[UIImage imageNamed:@"我的参与"] forState:UIControlStateNormal];
    [btnParticipate.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btnParticipate.buttonTypecu = XZLargeButtonTypeTabBar;
    [btnParticipate setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnParticipate.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnParticipate.tag = 101;
    [btnParticipate addTarget:self action:@selector(didClickMyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 我的发布 */
    XZLargeButton *btnMyPublish = [[XZLargeButton alloc]init];
    [tabBar addSubview:btnMyPublish];
    [btnMyPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelPublish.mas_centerX).offset(KProjectScreenWidth / 4.0);
        make.top.equalTo(tabBar.mas_top);
        make.bottom.equalTo(labelPublish.mas_bottom);
    }];
    btnMyPublish.buttonTypecu = XZLargeButtonTypeTabBar;
    [btnMyPublish.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnMyPublish setTitle:@"我的发布" forState:UIControlStateNormal];
    [btnMyPublish setImage:[UIImage imageNamed:@"我的发布"] forState:UIControlStateNormal];
    [btnMyPublish.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnMyPublish.titleLabel setTextColor:[UIColor darkGrayColor]];
    [btnMyPublish setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnMyPublish.tag = 102;
    [btnMyPublish addTarget:self action:@selector(didClickMyBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 点击按钮
- (void)didClickMyBtn:(UIButton *)button {
    if (self.blockTabBarBtn) {
        self.blockTabBarBtn(button);
    }
}


@end
