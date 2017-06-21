//
//  XZOptimalMallSubmitOrderTabBar.m
//  fmapp
//
//  Created by admin on 16/12/13.
//  Copyright © 2016年 yk. All rights reserved.
//  优商城"提交订单"栏

#import "XZOptimalMallSubmitOrderTabBar.h"
#import "XZConfirmOrderModel.h" // model

@interface XZOptimalMallSubmitOrderTabBar ()
// 运费
@property (nonatomic, strong) UILabel *labelFreight;
// 合计
@property (nonatomic, strong) UILabel *labelCombine;
// 提交订单
@property (nonatomic, strong) UIButton *btnConfirmOrder;
@end

@implementation XZOptimalMallSubmitOrderTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpOptimalMallSubmitOrderTabBar];
    }
    return self;
}

- (void)setUpOptimalMallSubmitOrderTabBar {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *labelLine = [[UILabel alloc] init];
    [self addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@1);
    }];
    labelLine.backgroundColor = XZColor(200, 200, 200);
    
    // 提交订单
    UIButton *btnConfirmOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnConfirmOrder];
    CGFloat width = [self calculateStringWidth:@"提交订单"];
    [btnConfirmOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(1);
        make.bottom.equalTo(self);
        make.width.equalTo((width + 20));
    }];
    self.btnConfirmOrder = btnConfirmOrder;
    [btnConfirmOrder setTitle:@"提交订单" forState:UIControlStateNormal];
    [btnConfirmOrder addTarget:self action:@selector(didClickConfirmOrder:) forControlEvents:UIControlEventTouchUpInside];
    btnConfirmOrder.backgroundColor = XZColor(6, 62, 141);
    [btnConfirmOrder.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnConfirmOrder.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    // 合计
    UILabel *labelCombine = [[UILabel alloc] init];
    [self addSubview:labelCombine];
    [labelCombine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnConfirmOrder.mas_left).offset(-10);
        make.bottom.equalTo(self.mas_centerY);
    }];
    self.labelCombine = labelCombine;
    labelCombine.font = [UIFont systemFontOfSize:15.0f];
    
    // 运费
    UILabel *labelFreight = [[UILabel alloc] init];
    [self addSubview:labelFreight];
    [labelFreight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelCombine);
        make.top.equalTo(labelCombine.mas_bottom);
    }];
    self.labelFreight = labelFreight;
    labelFreight.font = [UIFont systemFontOfSize:13.0f];
    labelFreight.textColor = [UIColor grayColor];
    self.labelFreight.text = @"（含运费￥0.00）";
}
//
//- (void)sendModelToTabBar:(XZConfirmOrderModel *)model {
//    // 让金额数字变色
//    NSMutableAttributedString *(^makeMoneyRed)(NSString *,NSString *) = ^(NSString *m,NSString *front) {
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
//        NSInteger length = [m length];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(245, 75, 22) range:NSMakeRange(0, length)];
//        NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:front];
//        NSInteger lengthFore = [front length];
//        [attrTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, lengthFore)];
//        [attrTotal appendAttributedString:attrStr];
//        return  attrTotal;
//    };
//    
//    if (model.isCoinPay) { // 使用积分支付
//        if ([model.jifenMoney floatValue] > 0) { // 半积分半钱
//            self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"%@",model.jifenMoney],@"合计：");
//        }else {
//            // 全部使用积分支付
//            NSString *jifenUser = [NSString stringWithFormat:@"%ld积分",(long)[model.usedJifen integerValue]];
//            self.labelCombine.attributedText = makeMoneyRed(jifenUser,@"合计：");
//        }
//    }else { // 全部使用钱,不使用积分
//        self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"%@",model.totalMoney],@"合计：");
//    }
//    self.labelFreight.text = [NSString stringWithFormat:@"（含运费￥%.2f）",[model.money floatValue]];
//}

- (void)setConfirmModel:(XZConfirmOrderModel *)confirmModel {
    _confirmModel = confirmModel;
    // 让金额数字变色
    NSMutableAttributedString *(^makeMoneyRed)(NSString *,NSString *) = ^(NSString *m,NSString *front) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(245, 75, 22) range:NSMakeRange(0, length)];
        NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:front];
        NSInteger lengthFore = [front length];
        [attrTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, lengthFore)];
        [attrTotal appendAttributedString:attrStr];
        return  attrTotal;
    };
    if (confirmModel.isCoinPay) {
        if ([confirmModel.totalMoney floatValue] <= 0) {
            // 全部使用积分支付
            NSString *jifenUser = [NSString stringWithFormat:@"%ld积分",(long)[confirmModel.usedJifen integerValue]];
            self.labelCombine.attributedText = makeMoneyRed(jifenUser,@"合计：");
        }else {
            self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[confirmModel.totalMoney floatValue]],@"合计：");
        }
    }else {
        self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[confirmModel.totalMoney floatValue]],@"合计：");
    }
    
    self.labelFreight.text = [NSString stringWithFormat:@"（含运费￥%.2f）",[confirmModel.money floatValue]];
}

- (CGFloat)calculateStringWidth:(NSString *)title {
    CGFloat width = [title getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 50) WithFont:[UIFont systemFontOfSize:15.0f]].width;
    return width;
}

- (void)didClickConfirmOrder:(UIButton *)button {
    if(self.blockClickConfirmOrder) {
        self.blockClickConfirmOrder(button);
    }
}

@end
