//
//  XZBankRechargeFooter.m
//  fmapp
//
//  Created by admin on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//  充值底部视图

#import "XZBankRechargeFooter.h"
#import "XZBankRechargeModel.h"

@interface XZBankRechargeFooter ()
// 确认充值
@property (nonatomic, strong) UIButton *btnSurePay;
// 充值限额
@property (nonatomic, strong) UILabel *labelLimit;

@end

@implementation XZBankRechargeFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpBankRechargeFooter];
    }
    return self;
}

- (void)setUpBankRechargeFooter {
    self.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    //
    UILabel *labelLimit = [[UILabel alloc] init];
    [self addSubview:labelLimit];
    [labelLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
    }];
    labelLimit.font = [UIFont systemFontOfSize:14.0f];
    labelLimit.textColor = [HXColor colorWithHexString:@"#666666"];
    self.labelLimit = labelLimit;
    
    // 确认充值
    UIButton *btnSurePay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnSurePay];
    [btnSurePay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelLimit);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(labelLimit.mas_bottom).offset(15);
        make.height.equalTo(@44);
    }];
    [btnSurePay setBackgroundColor:XZColor(1, 89, 213)];
    [btnSurePay setTitle:@"确认充值" forState:UIControlStateNormal];
    [btnSurePay addTarget:self action:@selector(didClickSurePayButton:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSurePay = btnSurePay;
    
}

- (void)didClickSurePayButton:(UIButton *)button {
    if (self.blockSurePay) {
        self.blockSurePay(button);
    }
}

- (void)setModelBankUser:(XZBankRechargeUserModel *)modelBankUser {
    _modelBankUser = modelBankUser;
    
    if (modelBankUser.isQuickPay) { // 快捷充值
        // @"充值限额：单笔25.00万，单日25.00万"
        if (modelBankUser.limitDesc) {
            self.labelLimit.text = [NSString stringWithFormat:@"充值限额：%@",modelBankUser.limitDesc];
        }else {
            self.labelLimit.text = [NSString stringWithFormat:@"充值限额："];
        }
        self.btnSurePay.hidden = NO;
    }else { // 转账充值
        self.labelLimit.text = @"转账充值，随时随地，方式多样，操作简单。";
        self.btnSurePay.hidden = YES;
    }
}

//- (void)setModelRecharge:(XZBankRechargeModel *)modelRecharge {
//    _modelRecharge = modelRecharge;
//    
//    if (modelRecharge.isQuickPay) { // 快捷充值
//        self.labelLimit.text = @"充值限额：单笔25.00万，单日25.00万";
//        self.btnSurePay.hidden = NO;
//    }else { // 转账充值
//        self.labelLimit.text = @"转账充值，随时随地，方式多样，操作简单。";
//        self.btnSurePay.hidden = YES;
//    }
//}

@end
