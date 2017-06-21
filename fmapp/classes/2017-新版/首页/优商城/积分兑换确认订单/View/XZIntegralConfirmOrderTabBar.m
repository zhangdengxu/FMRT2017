//
//  XZIntegralConfirmOrderTabBar.m
//  fmapp
//
//  Created by admin on 16/12/6.
//  Copyright © 2016年 yk. All rights reserved.
//  提交订单一栏

#import "XZIntegralConfirmOrderTabBar.h"
#import "XZConfirmOrderModel.h" // model
#import "FMShoppingListModel.h"

@interface XZIntegralConfirmOrderTabBar ()
// 运费
@property (nonatomic, strong) UILabel *labelFreight;
// 合计
@property (nonatomic, strong) UILabel *labelCombine;
// 提交订单
@property (nonatomic, strong) UIButton *btnConfirmOrder;
@end

@implementation XZIntegralConfirmOrderTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMySnatchHeaderView];
    }
    return self;
}

- (void)setUpMySnatchHeaderView {
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
}

- (void)setConfirmModelCoins:(XZConfirmOrderModel *)confirmModelCoins {
    _confirmModelCoins = confirmModelCoins;
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
    
    if (confirmModelCoins.isCoinPay) { // 积分支付
//        // 用户所需总积分
//        NSString *totalJifen = [NSString stringWithFormat:@"%ld",(long)[confirmModelCoins.shopListModel.fulljifen_ex integerValue] * confirmModelCoins.shopListModel.selectCount];
        // 如果是积分支付，用户积分不足的时候，提交订单是灰色
        self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"%@积分",confirmModelCoins.totalJifen],@"合计：");
        if ([confirmModelCoins.jifenUser integerValue] < [confirmModelCoins.totalJifen integerValue]) {
            // 灰色
            [self.btnConfirmOrder setBackgroundColor:[UIColor lightGrayColor]];
            self.btnConfirmOrder.userInteractionEnabled = NO;
        }else { // 蓝色
            [self.btnConfirmOrder setBackgroundColor:XZColor(6, 62, 141)];
            self.btnConfirmOrder.userInteractionEnabled = YES;
        }
    }else {
//        // 用户所需价格
//        NSString *calCountAndPrice = [NSString stringWithFormat:@"%.2f",[confirmModelCoins.shopListModel.price.price floatValue] * confirmModelCoins.shopListModel.selectCount];
        NSString *totalMoney = [NSString stringWithFormat:@"￥%@",confirmModelCoins.totalMoney];
        if (totalMoney) {
            self.labelCombine.attributedText = makeMoneyRed([NSString stringWithFormat:@"%@",totalMoney],@"合计：");
        }
        [self.btnConfirmOrder setBackgroundColor:XZColor(6, 62, 141)];
        self.btnConfirmOrder.userInteractionEnabled = YES;
    }
    
    self.labelFreight.text = @"（含运费）";
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
