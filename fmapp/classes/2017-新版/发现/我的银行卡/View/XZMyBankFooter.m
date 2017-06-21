//
//  XZMyBankFooter.m
//  fmapp
//
//  Created by admin on 2017/6/1.
//  Copyright © 2017年 yk. All rights reserved.
//  更换银行卡

#import "XZMyBankFooter.h"

@implementation XZMyBankFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMyMyBankFooter];
    }
    return self;
}

- (void)setUpMyMyBankFooter {
    self.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    UIButton *btnChangeBank = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnChangeBank];
    [btnChangeBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@180);
        make.height.equalTo(@35);
    }];
    [btnChangeBank setTitle:@"更换银行卡" forState:UIControlStateNormal];
    [btnChangeBank setBackgroundColor:[HXColor colorWithHexString:@"#0099e9"]];
    [btnChangeBank addTarget:self action:@selector(didClickChangeBankButton) forControlEvents:UIControlEventTouchUpInside];
    [btnChangeBank.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    btnChangeBank.layer.masksToBounds = YES;
    btnChangeBank.layer.cornerRadius = 18.0f;
}

- (void)didClickChangeBankButton {
    if (self.blockChangeBank) {
        self.blockChangeBank();
    }
}

@end
