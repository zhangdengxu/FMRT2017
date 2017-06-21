//
//  XZMySnatchHeaderView.m
//  fmapp
//
//  Created by admin on 16/10/13.
//  Copyright © 2016年 yk. All rights reserved.
//  我的夺宝头视图

#import "XZMySnatchHeaderView.h"
#import "XZIndianaCurrencyModel.h" // model

@interface XZMySnatchHeaderView ()
/** 头像View */
@property (nonatomic, strong) UIImageView *imgIcon;
/** 昵称 */
@property (nonatomic, strong) UILabel *labelNickname;
/** 夺宝币数量 */
@property (nonatomic, strong) UILabel *labelCoin;
@end

@implementation XZMySnatchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMySnatchHeaderView];
    }
    return self;
}

- (void)setUpMySnatchHeaderView {
    self.backgroundColor = KDefaultOrBackgroundColor;
    
    /** 头像View */
    UIView *viewTop = [[UIView alloc] init];
    [self addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    viewTop.backgroundColor = [UIColor whiteColor];
    
    /** 头像 */
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [viewTop addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTop.mas_left).offset(10);
        make.top.equalTo(viewTop.mas_top).offset(10);
        make.width.and.height.equalTo(@50);
    }];
    imgIcon.layer.masksToBounds = YES;
    imgIcon.layer.cornerRadius = 25;
    self.imgIcon = imgIcon;
    imgIcon.backgroundColor = [UIColor darkGrayColor];
    
    /** 购买按钮 */
    UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewTop addSubview:btnBuy];
    [btnBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTop.mas_right).offset(-10);
        make.top.equalTo(imgIcon.mas_top).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
    }];
    [btnBuy setTitle:@"获取夺宝币" forState:UIControlStateNormal];
    [btnBuy setBackgroundColor:XZColor(252, 103, 61)];
    [btnBuy addTarget:self action:@selector(didClickGetIndianaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBuy.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
    /** 昵称 */
    UILabel *labelNickname = [[UILabel alloc] init];
    [viewTop addSubview:labelNickname];
    [labelNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_right).offset(10);
        make.top.equalTo(imgIcon.mas_top).offset(3);
        make.right.equalTo(btnBuy.mas_left);
    }];
    self.labelNickname = labelNickname;
    //    labelNickname.text = @"昵称：";
    labelNickname.textColor = XZColor(67, 67, 65);
    labelNickname.font = [UIFont systemFontOfSize:14];
    
    /** 金额 */
    UIImageView *imgMoney = [[UIImageView alloc] init];
    [viewTop addSubview:imgMoney];
    [imgMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelNickname.mas_left);
        make.top.equalTo(imgIcon.mas_centerY);
        make.width.equalTo(@(20 * 0.6));
        make.height.equalTo(@(22 * 0.6));
    }];
    imgMoney.image = [UIImage imageNamed:@"全新夺宝币-改版"];
    
    /** 夺宝币数量 */
    UILabel *labelCoin = [[UILabel alloc] init];
    [viewTop addSubview:labelCoin];
    [labelCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgMoney.mas_right).offset(10);
        make.centerY.equalTo(imgMoney.mas_centerY);
        make.right.equalTo(btnBuy.mas_left);
    }];
    self.labelCoin = labelCoin;
    labelCoin.text = @"0";
    // [UIColor orangeColor]
    labelCoin.textColor = XZColor(252, 103, 61);
    labelCoin.font = [UIFont systemFontOfSize:16];
    
}

- (void)didClickGetIndianaBtn:(UIButton *)button {
    if (self.blockMySnatchHeader) {
        self.blockMySnatchHeader(button);
    }
}

- (void)setModelMySnatch:(XZIndianaCurrencyModel *)modelMySnatch {
    _modelMySnatch = modelMySnatch;
    /** 头像View */
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:modelMySnatch.head_img] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
    if (modelMySnatch.nickname.length == 0) {
        /** 昵称 */
        self.labelNickname.text = [NSString stringWithFormat:@"ID:%@",modelMySnatch.phone];
    }else {
        /** 昵称 */
        self.labelNickname.text = [NSString stringWithFormat:@"ID:%@",modelMySnatch.nickname];
    }
    /** 夺宝币数量 */
    self.labelCoin.text = [NSString stringWithFormat:@"%@",modelMySnatch.coin];
}

@end
