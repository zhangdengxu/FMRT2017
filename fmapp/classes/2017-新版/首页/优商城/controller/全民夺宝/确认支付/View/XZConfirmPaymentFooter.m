//
//  XZConfirmPaymentFooter.m
//  fmapp
//
//  Created by admin on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZConfirmPaymentFooter.h"
#import "XZButton.h"
//#import "FMShopSpecModel.h"
#import "FMDuobaoClass.h" // model

@interface XZConfirmPaymentFooter ()
// 共几件商品
@property (nonatomic, strong) UILabel *labelGoods;
// 实付
@property (nonatomic, strong) UILabel *labelRealPay;
// 账户余额
@property (nonatomic, strong) UILabel *labelBalance;

// 余额支付
@property (nonatomic, strong) XZButton *btnBalancePay;
/** 支付方式 */
@property (nonatomic, strong) UIView *viewPayment;
/** 获取夺宝币 */
@property (nonatomic, strong) UIView *viewGetCoin;
// 当前按钮
@property (nonatomic, strong) UIButton *currentBtn;
@end

@implementation XZConfirmPaymentFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConfirmPaymentFooter];
    }
    return self;
}

//
- (void)setUpConfirmPaymentFooter {
    self.backgroundColor = XZColor(229, 233, 242);
    
    /** 共一件商品、实付合计 */
    UIView *viewGoods = [[UIView alloc] initWithFrame:CGRectMake(0, 8, KProjectScreenWidth, 50)];
    [self addSubview:viewGoods];
    viewGoods.backgroundColor = [UIColor whiteColor];
    // 共几件商品
    UILabel *labelGoods = [[UILabel alloc] init];
    [viewGoods addSubview:labelGoods];
    [labelGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewGoods).offset(10);
        make.centerY.equalTo(viewGoods);
    }];
    labelGoods.font = [UIFont systemFontOfSize:15];
    self.labelGoods = labelGoods;
    // 实付
    UILabel *labelRealPay = [[UILabel alloc] init];
    [viewGoods addSubview:labelRealPay];
    [labelRealPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewGoods).offset(-10);
        make.centerY.equalTo(viewGoods);
    }];
    self.labelRealPay = labelRealPay;
    labelRealPay.font = [UIFont systemFontOfSize:15];
    
    /** 账户余额、余额支付 */
    UIView *viewBalance = [[UIView alloc] initWithFrame:CGRectMake(0, 58.5, KProjectScreenWidth, 50)];
    [self addSubview:viewBalance];
    viewBalance.backgroundColor = [UIColor whiteColor];
    // 账户余额
    UILabel *labelBalance = [[UILabel alloc] init];
    [viewBalance addSubview:labelBalance];
    [labelBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBalance).offset(10);
        make.centerY.equalTo(viewBalance);
    }];
    labelBalance.font = [UIFont systemFontOfSize:15];
    self.labelBalance = labelBalance; 
//    labelBalance.text = @"账户余额：";
    
    // 余额支付
    XZButton *btnBalancePay = [XZButton buttonWithType:UIButtonTypeCustom];
    [viewBalance addSubview:btnBalancePay];
    [btnBalancePay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewBalance).offset(-10);
        make.centerY.equalTo(viewBalance);
        make.width.equalTo(@90);
    }];
    btnBalancePay.tag = 180;
    self.btnBalancePay = btnBalancePay;
    btnBalancePay.buttonsType = XZButtonTypePicRight;
    [btnBalancePay.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnBalancePay setImage:[UIImage imageNamed:@"勾选框_确认支付"] forState:UIControlStateSelected]; // UIControlStateNormal
    [btnBalancePay setImage:[UIImage imageNamed:@"对号_确认支付"] forState:UIControlStateNormal]; // UIControlStateSelected
    [btnBalancePay setTitle:@"余额支付" forState:UIControlStateNormal];
    [btnBalancePay setTitleColor:XZColor(153, 153, 153) forState:UIControlStateNormal];
    [btnBalancePay addTarget:self action:@selector(didClickBalancePayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 获取夺宝币 */
    UIView *viewGetCoin = [[UIView alloc] initWithFrame:CGRectMake(0, 116.5, KProjectScreenWidth, 80)];
    [self addSubview:viewGetCoin];
    self.viewGetCoin = viewGetCoin;
    viewGetCoin.backgroundColor = [UIColor whiteColor];
    // 获取夺宝币
    UILabel *labelGetCoin = [[UILabel alloc] init];
    [viewGetCoin addSubview:labelGetCoin];
    [labelGetCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewGetCoin).offset(10);
        make.centerY.equalTo(viewGetCoin);
    }];
    labelGetCoin.text = @"获取夺宝币：";
    labelGetCoin.font = [UIFont systemFontOfSize:15];
    
    // 积分兑换
    UIButton *btnIntegralExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewGetCoin addSubview:btnIntegralExchange];
    [btnIntegralExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelGetCoin.mas_right);
        make.centerY.equalTo(viewGetCoin);
        make.width.equalTo(@((120 / 375.0) * KProjectScreenWidth));
    }];
    btnIntegralExchange.tag = 130;
    [btnIntegralExchange setTitle:@"积分兑换" forState:UIControlStateNormal];
    [btnIntegralExchange addTarget:self action:@selector(didClickBalancePayButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnIntegralExchange setTitleColor:XZColor(255, 102, 51) forState:UIControlStateNormal];
    [btnIntegralExchange.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btnIntegralExchange.layer.borderColor = XZColor(229, 233, 242).CGColor;
    btnIntegralExchange.layer.borderWidth = 0.5f;
    
    // 购买夺宝币
    UIButton *btnBuyCoins = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewGetCoin addSubview:btnBuyCoins];
    [btnBuyCoins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewGetCoin).offset(-10);
        make.centerY.equalTo(viewGetCoin);
        make.width.equalTo(btnIntegralExchange);
    }];
    btnBuyCoins.tag = 140;
    [btnBuyCoins setTitle:@"购买夺宝币" forState:UIControlStateNormal];
    [btnBuyCoins addTarget:self action:@selector(didClickBalancePayButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBuyCoins setTitleColor:XZColor(255, 102, 51) forState:UIControlStateNormal];
    [btnBuyCoins.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btnBuyCoins.layer.borderColor = XZColor(229, 233, 242).CGColor;
    btnBuyCoins.layer.borderWidth = 0.5f;
    
    /** 支付方式 */
    UIView *viewPayment = [[UIView alloc] initWithFrame:CGRectMake(0, 116.5, KProjectScreenWidth, 50)];
    [self addSubview:viewPayment];
    self.viewPayment = viewPayment;
    viewPayment.backgroundColor = [UIColor whiteColor];
    // 支付方式：
    UILabel *labelPayment = [[UILabel alloc] init];
    [viewPayment addSubview:labelPayment];
    [labelPayment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPayment).offset(10);
        make.centerY.equalTo(viewPayment);
    }];
    labelPayment.text = @"支付方式：";
    labelPayment.font = [UIFont systemFontOfSize:15];
    
    // 微信支付
    UIButton *btnWechat = [self createButtonWithTag:160 title:@" 微信支付" normaliMG:@"确认订单页面（支付方式未勾选）_21" selectediMG:@"确认订单页面（支付方式勾选）_21" color:[UIColor blackColor] superV:viewPayment font:15 isPay:YES];
    [btnWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPayment.mas_right).offset(10);
        make.centerY.equalTo(viewPayment);
        make.width.equalTo(@((120 / 375.0) * KProjectScreenWidth));
        make.height.equalTo(viewPayment);
    }];
    btnWechat.selected = YES;
    self.currentBtn = btnWechat;
    
    // 支付宝支付
    UIButton *btnAliPay = [self createButtonWithTag:170 title:@" 支付宝支付" normaliMG:@"确认订单页面（支付方式未勾选）_21" selectediMG:@"确认订单页面（支付方式勾选）_21" color:[UIColor blackColor] superV:viewPayment font:15 isPay:YES];
    [btnAliPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnWechat.mas_right).offset(10);
        make.centerY.equalTo(viewPayment);
        make.width.equalTo(@((120 / 375.0) * KProjectScreenWidth));
        make.height.equalTo(viewPayment);
    }];
    
    // 协议 200
    UIButton *btnAgreement = [self createButtonWithTag:200 title:@"我已阅读并同意《全民夺宝服务协议》" normaliMG:@"" selectediMG:@"" color:[UIColor darkGrayColor] superV:self font:13 isPay:NO];
    [btnAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.centerX.equalTo(self);
    }];
    
    // 协议选择框 150
    UIButton *btnSelected = [self createButtonWithTag:150 title:@"" normaliMG:@"对号_确认支付" selectediMG:@"勾选框_确认支付" color:[UIColor darkGrayColor] superV:self font:13 isPay:NO];
    [btnSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnAgreement); // .offset(-30)
        make.right.equalTo(btnAgreement.mas_left).offset(-8);
    }];

}

- (UIButton *)createButtonWithTag:(NSInteger)btnTag title:(NSString *)title normaliMG:(NSString *)normaliMG selectediMG:(NSString *)selectediMG color:(UIColor *)color superV:(UIView *)superV  font:(CGFloat)font isPay:(BOOL)isPay {

    UIButton *btnAgreement = [UIButton buttonWithType:UIButtonTypeCustom];
    [superV addSubview:btnAgreement];
    btnAgreement.tag = btnTag;
    if (isPay) { // 支付按钮
        [btnAgreement addTarget:self action:@selector(didClickAlipyOrWechat:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [btnAgreement addTarget:self action:@selector(didClickBalancePayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btnAgreement setTitle:title forState:UIControlStateNormal];
    [btnAgreement setImage:[UIImage imageNamed:normaliMG]  forState:UIControlStateNormal];
    [btnAgreement setImage:[UIImage imageNamed:selectediMG]  forState:UIControlStateSelected];
    [btnAgreement setTitleColor:color forState:UIControlStateNormal];
    [btnAgreement.titleLabel setFont:[UIFont systemFontOfSize:font]];
    return btnAgreement;
}

// 点击“余额支付”按钮
- (void)didClickBalancePayButton:(UIButton *)button {
    // 150 同意全民夺宝服务协议 180 余额支付
    if (button.tag == 150 || button.tag == 180) {
        button.selected = !button.selected;
    }
    if (self.blockPayWay) {
        self.blockPayWay(button);
    }
}

// 支付宝和微信支付
- (void)didClickAlipyOrWechat:(UIButton *)button {
    if (self.currentBtn != button) { //
        self.currentBtn.selected = !self.currentBtn.selected;
        self.currentBtn = button;
        button.selected = YES;
    }else {
        button.selected = YES;
        self.currentBtn = button;
        self.currentBtn.selected = YES;
    }
    if (self.blockPay) {
        self.blockPay(button);
    }
}

- (void)setDuobaoShop:(FMDuobaoClassSelectStyle *)duobaoShop {
    _duobaoShop = duobaoShop;
    self.labelGoods.text = @"共1件商品";
    NSMutableAttributedString *(^makeMoneyOrange)(NSString *,NSString *,UIColor *) = ^(NSString *profmpt,NSString *m,UIColor *color) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
        NSMutableAttributedString *attrProfmpt = [[NSMutableAttributedString alloc] initWithString:profmpt];
        //            [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, 1)];
        [attrProfmpt appendAttributedString:attrStr];
        return  attrProfmpt;
    };
    if ([duobaoShop.selectModel.type integerValue] == 2) { // 老友价
        self.viewGetCoin.hidden = YES;
        self.viewPayment.hidden = NO;
        // 包邮
        self.labelBalance.attributedText = makeMoneyOrange(@"包邮",@"（港澳台及偏远地区除外）",XZColor(153, 153, 153));
        self.btnBalancePay.hidden = YES;
        // 实付合计
        self.labelRealPay.attributedText = makeMoneyOrange(@"实付合计：",[NSString stringWithFormat:@"￥%@元",duobaoShop.selectModel.won_cost],XZColor(255, 102, 51));
    }else { // 1、5币得
        self.viewPayment.hidden = YES;
        self.viewGetCoin.hidden = NO;
        // 实付合计
        self.labelRealPay.attributedText = makeMoneyOrange(@"实付合计：",[NSString stringWithFormat:@"%@币",duobaoShop.selectModel.unit_cost],XZColor(255, 102, 51));
    }
}

- (void)setAccountBalance:(NSString *)accountBalance {
    _accountBalance = accountBalance;
    NSMutableAttributedString *(^makeMoneyOrange)(NSString *,NSString *,UIColor *) = ^(NSString *profmpt,NSString *m,UIColor *color) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
        NSMutableAttributedString *attrProfmpt = [[NSMutableAttributedString alloc] initWithString:profmpt];
        [attrProfmpt appendAttributedString:attrStr];
        return  attrProfmpt;
    };
    
    // 账户余额
    self.labelBalance.attributedText = makeMoneyOrange(@"账户余额：",[NSString stringWithFormat:@"%@币",accountBalance],XZColor(255, 102, 51));
}

@end
