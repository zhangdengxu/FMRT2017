//
//  FMShoppingListShareView.m
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListShareView.h"

#import "Fm_Tools.h"

@interface FMShoppingListShareView ()

@property (nonatomic, strong) UILabel  *titleLabel, *cpLabel, *scanLabel, *wbLabel, *wxLabel, *qqLabel, *frLabel;
@property (nonatomic, strong) UIButton *cpButton, *scanButton, *wbButton, *wxButton, *qqButton, *frButton, *btButton;

@end

@implementation FMShoppingListShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor =[UIColor colorWithHexString:@"1e1e1e" alpha:0.6];
        [self createShareView];
    }
    return self;
}

- (void)createShareView {

    UIView *view = [[UIView alloc]init];
    view.backgroundColor =[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0.8];
    [self addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@350);
    }];

    [view addSubview:self.btButton];
    self.btButton.tag = 2110;
    [self.btButton makeConstraints:^(MASConstraintMaker *make) {

        make.right.left.bottom.equalTo(view);
        make.height.equalTo(@50);
    }];
    
    [view addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(20);
    }];
    
    [view addSubview:self.cpButton];
    self.cpButton.tag = 2111;
    self.cpButton.imageView.contentMode =  UIViewContentModeScaleToFill;
    [self.cpButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.width.equalTo(@60);
    }];
    
    [view addSubview:self.cpLabel];
    [self.cpLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpButton.mas_left);
        make.top.equalTo(self.cpButton.mas_bottom).offset(5);
        make.right.equalTo(self.cpButton.mas_right);
        make.height.equalTo(@20);
    }];
    
    [view addSubview:self.scanButton];
    self.scanButton.tag = 2112;
    [self.scanButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpButton.mas_right).offset(8);
        make.top.equalTo(self.cpButton.mas_top);
        make.height.width.equalTo(self.cpButton);
    }];
    
    [view addSubview:self.scanLabel];
    [self.scanLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scanButton.mas_centerX);
        make.centerY.equalTo(self.cpLabel.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KDisableTextColor;
    [view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cpLabel.mas_bottom).offset(15);
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [view addSubview:self.wbButton];
    self.wbButton.tag = 2113;
    [self.wbButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpButton.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.width.height.equalTo(self.cpButton);
    }];
    
    [view addSubview:self.wbLabel];
    [self.wbLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wbButton.mas_centerX);
        make.top.equalTo(self.wbButton.mas_bottom).offset(5);
    }];
    
    [view addSubview:self.qqButton];
    self.qqButton.tag = 2114;
    [self.qqButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wbButton.mas_top);
        make.left.equalTo(self.wbButton.mas_right).offset(8);
        make.width.height.equalTo(self.cpButton);
    }];
    
    [view addSubview:self.qqLabel];
    [self.qqLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqButton.mas_centerX);
        make.centerY.equalTo(self.wbLabel.mas_centerY);
    }];
    
    [view addSubview:self.wxButton];
    self.wxButton.tag = 2115;
    [self.wxButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qqButton.mas_top);
        make.left.equalTo(self.qqButton.mas_right).offset(8);
        make.width.height.equalTo(self.qqButton);
    }];
    
    [view addSubview:self.wxLabel];
    [self.wxLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wxButton.mas_centerX);
        make.centerY.equalTo(self.qqLabel.mas_centerY);
    }];
    
    [view addSubview:self.frButton];
    self.frButton.tag = 2116;
    [self.frButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wxButton.mas_top);
        make.left.equalTo(self.wxButton.mas_right).offset(8);
        make.width.height.equalTo(self.wxButton);
    }];
    
    [view addSubview:self.frLabel];
    [self.frLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.frButton.mas_centerX);
        make.centerY.equalTo(self.wxLabel.mas_centerY);
    }];
    
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"分享";
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIButton *)cpButton {
    if (!_cpButton) {
        _cpButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cpButton setImage:[UIImage imageNamed:@"t8"] forState:(UIControlStateNormal)];
        [_cpButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cpButton;
}

- (UILabel *)cpLabel {
    if (!_cpLabel) {
        _cpLabel = [[UILabel alloc]init];
        _cpLabel.textAlignment = NSTextAlignmentCenter;
        _cpLabel.text = @"复制链接";
        _cpLabel.font = [UIFont systemFontOfSize:14];

    }
    return _cpLabel;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_scanButton setImage:[UIImage imageNamed:@"t9"] forState:(UIControlStateNormal)];
        [_scanButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _scanButton;
}

- (UILabel *)scanLabel {
    if (!_scanLabel) {
        _scanLabel = [[UILabel alloc]init];
        _scanLabel.text = @"二维码";
        _scanLabel.font = [UIFont systemFontOfSize:14];

    }
    return _scanLabel;
}

- (UIButton *)wbButton {
    if (!_wbButton) {
        _wbButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_wbButton setImage:[UIImage imageNamed:@"inviteIcon04"] forState:(UIControlStateNormal)];
        [_wbButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _wbButton;
}

- (UILabel *)wbLabel {
    if (!_wbLabel) {
        _wbLabel = [[UILabel alloc]init];
        _wbLabel.text = @"微博";
        _wbLabel.font = [UIFont systemFontOfSize:14];

    }
    return _wbLabel;
}

- (UIButton *)qqButton {
    if (!_qqButton) {
        _qqButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_qqButton setImage:[UIImage imageNamed:@"inviteIcon03"] forState:(UIControlStateNormal)];
        [_qqButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _qqButton;
}

- (UILabel *)qqLabel {
    if (!_qqLabel) {
        _qqLabel = [[UILabel alloc]init];
        _qqLabel.text = @"QQ";
        _qqLabel.font = [UIFont systemFontOfSize:14];
    }
    return _qqLabel;
}

- (UIButton *)wxButton {
    if (!_wxButton) {
        _wxButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_wxButton setImage:[UIImage imageNamed:@"inviteIcon02"] forState:(UIControlStateNormal)];
        [_wxButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _wxButton;
}

- (UILabel *)wxLabel {
    if (!_wxLabel) {
        _wxLabel = [[UILabel alloc]init];
        _wxLabel.text = @"微信";
        _wxLabel.font = [UIFont systemFontOfSize:14];

    }
    return _wxLabel;
}

- (UIButton *)frButton {
    if (!_frButton) {
        _frButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_frButton setImage:[UIImage imageNamed:@"inviteIcon01"] forState:(UIControlStateNormal)];
        [_frButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _frButton;
}

- (UILabel *)frLabel {
    if (!_frLabel) {
        _frLabel = [[UILabel alloc]init];
        _frLabel.text = @"朋友圈";
        _frLabel.font = [UIFont systemFontOfSize:14];
    }
    return _frLabel;
}

- (UIButton *)btButton {
    if (!_btButton) {
        
        _btButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [_btButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_btButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_btButton setBackgroundColor:[UIColor lightGrayColor]];

    }
    return _btButton;
}

- (void)buttonAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(sender);
    }
}

@end
