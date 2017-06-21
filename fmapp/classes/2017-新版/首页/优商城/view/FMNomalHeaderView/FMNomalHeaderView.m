//
//  FMNomalHeaderView.m
//  fmapp
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMNomalHeaderView.h"

@implementation FMNomalHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame =CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*280/640+30);
        [self loadHeaderView];
    }
    return self;
}

- (void)loadHeaderView {
    
    // 头视图
    UIView *headerView = [[UIView alloc]initWithFrame:self.frame];
    [headerView setBackgroundColor:KDefaultOrBackgroundColor];
    
    [self addSubview:headerView];
    UIImageView *hearderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*280/640)];
    hearderImgV.image = [UIImage imageNamed:@"优商城首页-活动区-加载中-376x142"];

    [headerView addSubview:hearderImgV];
    self.headerImageView = hearderImgV;
    
    UILabel *blueLine = [[UILabel alloc]init];
    [headerView addSubview:blueLine];
    UIImageView *imgPrimeL = [[UIImageView alloc]init];
    [headerView addSubview:imgPrimeL];
    UILabel *labelCoupon = [[UILabel alloc]init];
    [headerView addSubview:labelCoupon];
    UILabel *blueLine2 = [[UILabel alloc]init];
    [headerView addSubview:blueLine2];
    
    UIImageView *imgPrimeR = [[UIImageView alloc]init];
    [headerView addSubview:imgPrimeR];
    
    // 左边线
    [blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.right.equalTo(imgPrimeL.mas_left);
        make.top.equalTo(hearderImgV.mas_bottom).offset(15);
        make.height.equalTo(@1.0);
    }];
    blueLine.backgroundColor = [UIColor colorWithRed:0/255.0 green:23/255.0 blue:120/255.0 alpha:1.0f];
    
    // 左边三撇
    [imgPrimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueLine.mas_right);
        make.top.equalTo(blueLine.mas_top).offset(-5);
        make.width.equalTo(@15);
        make.height.equalTo(@10);
    }];
    imgPrimeL.image = [UIImage imageNamed:@"z6.png"];
    
    // 中间券码区字
    [labelCoupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueLine.mas_right).offset(30);
        make.centerX.equalTo(hearderImgV.mas_centerX);
        make.right.equalTo(blueLine2.mas_left).offset(-30);
        make.top.equalTo(hearderImgV.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    labelCoupon.textColor = [UIColor colorWithRed:7/255.0 green:64/255.0 blue:143/255.0 alpha:1.0f];
    labelCoupon.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel = labelCoupon;
    // 右边线
    
    [blueLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPrimeR.mas_right);
        make.right.equalTo(hearderImgV.mas_right).offset(-15);
        make.top.equalTo(blueLine.mas_top);
        make.height.equalTo(@1.0);
    }];
    blueLine2.backgroundColor = [UIColor colorWithRed:0/255.0 green:23/255.0 blue:120/255.0 alpha:1.0f];
    // 右边三撇
    [imgPrimeR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(blueLine2.mas_left);
        make.top.equalTo(imgPrimeL.mas_top);
        make.width.equalTo(@15);
        make.height.equalTo(@10);
    }];
    imgPrimeR.image = [UIImage imageNamed:@"z7.png"];

}

@end
