//
//  XZRechargeSuccessView.m
//  fmapp
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//  充值成功

#import "XZRechargeSuccessView.h"
#import "XZBankRechargeModel.h"

@interface XZRechargeSuccessView ()
//
@property (nonatomic, strong) UIView *blackBg;
//
@property (nonatomic, strong) UIView *whiteBg;
// 微商_弹窗_对号
@property (nonatomic, strong) UIImageView *imgPigeon;
//
@property (nonatomic, strong) UILabel *labelMoneyCount;
//
@property (nonatomic, strong) UILabel *labelBankName;
@end

@implementation XZRechargeSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRechargeSuccessView];
    }
    return self;
}

- (void)setUpRechargeSuccessView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackBg = [[UIView alloc] init];
    [window addSubview:blackBg];
    [blackBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    blackBg.backgroundColor = [UIColor blackColor];
    blackBg.alpha = 0.3;
    self.blackBg = blackBg;
    
    //
    CGFloat height = 128 * 0.4 + 15 + 20 + 101 + 15 + 40; //  + 15
    UIView *whiteBg = [[UIView alloc] init];
    [window addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).offset(20);
        make.right.equalTo(window).offset(-20);
        make.centerY.equalTo(window);
        make.height.equalTo(height);
    }];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.masksToBounds = YES;
    whiteBg.layer.cornerRadius = 5.0f;
    self.whiteBg = whiteBg;
    
    // 128 * 128 微商_弹窗_对号
    UIImageView *imgPigeon = [[UIImageView alloc] init];
    [window addSubview:imgPigeon];
    [imgPigeon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteBg);
        make.centerY.equalTo(whiteBg.mas_top);
        make.width.and.height.equalTo(128 * 0.4);
    }];
    imgPigeon.image = [UIImage imageNamed:@"微商_弹窗_对号"];
    self.imgPigeon = imgPigeon;
    
    //
    UILabel *labelSuccess = [[UILabel alloc] init];
    [whiteBg addSubview:labelSuccess];
    [labelSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteBg);
        make.top.equalTo(imgPigeon.mas_bottom).offset(15);
    }];
    labelSuccess.text = @"充值成功";
    labelSuccess.textColor = [HXColor colorWithHexString:@"#333333"];
    
    // 灰色view
    UIView *viewGray = [[UIView alloc] init];
    [whiteBg addSubview:viewGray];
    [viewGray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(20);
        make.right.equalTo(whiteBg).offset(-20);
        make.height.equalTo(@101);
        make.top.equalTo(labelSuccess.mas_bottom).offset(15);
    }];
    viewGray.backgroundColor = [HXColor colorWithHexString:@"#f0f0f0"];
    viewGray.layer.masksToBounds = YES;
    viewGray.layer.cornerRadius = 5.0f;
    
    //
    UILabel *labelBank = [[UILabel alloc] init];
    [viewGray addSubview:labelBank];
    [labelBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewGray).offset(10);
        make.top.equalTo(viewGray);
        make.height.equalTo(@50);
    }];
    labelBank.textColor = [HXColor colorWithHexString:@"#333333"];
    labelBank.font = [UIFont systemFontOfSize:15.0f];
    labelBank.text = @"储蓄卡";
    labelBank.textAlignment = NSTextAlignmentCenter;
    
    //
    UILabel *labelBankName = [[UILabel alloc] init];
    [viewGray addSubview:labelBankName];
    [labelBankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewGray).offset(-10);
        make.top.and.height.equalTo(labelBank);
    }];
    labelBankName.textColor = [HXColor colorWithHexString:@"#333333"];
    labelBankName.font = [UIFont systemFontOfSize:15.0f];
    self.labelBankName = labelBankName;
    // line
    UILabel *line = [[UILabel alloc] init];
    [viewGray addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewGray);
        make.right.equalTo(viewGray);
        make.top.equalTo(labelBank.mas_bottom);
        make.height.equalTo(@1);
    }];
    // [UIColor blackColor]
    line.backgroundColor = [HXColor colorWithHexString:@"#cccccc"];

    //
    UILabel *labelMoney = [[UILabel alloc] init];
    [viewGray addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.equalTo(labelBank);
        make.top.equalTo(line.mas_bottom);
    }];
    labelMoney.text = @"充值金额(元)";
    labelMoney.textColor = [HXColor colorWithHexString:@"#333333"];
    labelMoney.font = [UIFont systemFontOfSize:15.0f];
    
    //
    UILabel *labelMoneyCount = [[UILabel alloc] init];
    [viewGray addSubview:labelMoneyCount];
    [labelMoneyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelBankName);
        make.top.height.equalTo(labelMoney);
    }];
    labelMoneyCount.textColor = [HXColor colorWithHexString:@"#333333"];
    labelMoneyCount.font = [UIFont systemFontOfSize:15.0f];
    self.labelMoneyCount = labelMoneyCount;
    
    // 确认
    UIButton *btnSureRecharge = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBg addSubview:btnSureRecharge];
    [btnSureRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewGray);
        make.right.equalTo(viewGray);
        make.top.equalTo(viewGray.mas_bottom).offset(15);
        make.height.equalTo(@40);
    }];
    [btnSureRecharge addTarget:self action:@selector(didClickSureRechargeButton) forControlEvents:UIControlEventTouchUpInside];
    [btnSureRecharge setTitle:@"确认" forState:UIControlStateNormal];
    [btnSureRecharge setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
    [btnSureRecharge.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    btnSureRecharge.layer.masksToBounds = YES;
    btnSureRecharge.layer.cornerRadius = 5.0f;
    
//    //
//    [self setModel];
}

- (void)setModelBankUser:(XZBankRechargeUserModel *)modelBankUser {
    _modelBankUser = modelBankUser;
    
//    self.labelBankName.text = @"民生银行 尾号0440";
    NSString *wayName;
    if (modelBankUser.signBankCard) {
        NSString *lastNumber = [modelBankUser.signBankCard substringWithRange:NSMakeRange(self.modelBankUser.signBankCard.length - 4, 4)];
        wayName = [NSString stringWithFormat:@"%@ 尾号%@",self.modelBankUser.signBankName,lastNumber];
    }
    
    self.labelBankName.text = wayName;
    // 让某些文字变橙色
    NSMutableAttributedString *(^makeStirngSmall)(NSString *) = ^(NSString *allString) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:allString];
        NSInteger length = [allString length];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(length - 2, 2)];
        return  attrStr;
    };

    NSLog(@"充值成功页面 =========== %@",modelBankUser.moneyRecharge);
    
    self.labelMoneyCount.attributedText = makeStirngSmall([NSString stringWithFormat:@"￥%.2f",[modelBankUser.moneyRecharge floatValue]]);
    
}

- (void)didClickSureRechargeButton {
    [self.blackBg removeFromSuperview];
    [self.whiteBg removeFromSuperview];
    [self.imgPigeon removeFromSuperview];
    [self removeFromSuperview];
    
    if (self.blockSureRecharge) {
        self.blockSureRecharge();
    }
}

@end
