//
//  XZOptimalMallSubmitOrderFooter.m
//  fmapp
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//  优商城确认订单

#import "XZOptimalMallSubmitOrderFooter.h"
//#import "XZIntegralConfirmOrderModel.h" // model
#import "XZConfirmOrderModel.h" // 快递
#import "XZChooseTicketModel.h" // 优惠券

@interface XZOptimalMallSubmitOrderFooter ()<UITextFieldDelegate>
// 积分抵扣
@property (nonatomic, strong) UIButton *btnCoinPay;
// 可用积分抵扣
@property (nonatomic, strong) UILabel *labelCoinPay;
// 创建快递和价格
@property (nonatomic, strong) UILabel *labelDistribution;
// 合计
@property (nonatomic, strong) UILabel *labelCombined;
// 使用优惠券
@property (nonatomic, strong) UILabel *labelUseCoupons;
// 订单可得积分
@property (nonatomic, strong) UILabel *labelGetCoins;
// 优惠金额
@property (nonatomic, strong) UILabel *labelGetCoupon;
// 支付宝支付
@property (nonatomic, strong) UIButton *btnAlipay;
// 微信支付
@property (nonatomic, strong) UIButton *btnWechat;
@end

@implementation XZOptimalMallSubmitOrderFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpOptimalMallSubmitOrderFooter];
    }
    return self;
}

- (void)setUpOptimalMallSubmitOrderFooter {
    self.backgroundColor = XZBackGroundColor;
    
    UIView *(^createView)(CGFloat) = ^(CGFloat y) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,KProjectScreenWidth, 50)];
        [self addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    };
#pragma mark ---- 配送方式
    UIView *viewDistribution = createView(8);
    [self createLabelWithSuperView:viewDistribution text:@"配送方式:"];
    // 右箭头
    UIImageView *imageArrow = [[UIImageView alloc] init];
    [viewDistribution addSubview:imageArrow];
    [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewDistribution).offset(-10);
        make.centerY.equalTo(viewDistribution);
        make.width.equalTo(@(8 * 0.8));
        make.height.equalTo(@(15 * 0.8));
    }];
    imageArrow.image = [UIImage imageNamed:@"右键头"];
    
    // 创建快递方式和价格
    UILabel *labelDistribution = [self createRightLabelWithSuperView:viewDistribution text:nil rightView:imageArrow isLeft:YES offSet:-10];
    self.labelDistribution = labelDistribution;
    labelDistribution.textColor = XZColor(255, 102, 51);
    
    // 配送方式按钮
    UIButton *btnDistribution = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewDistribution addSubview:btnDistribution];
    [btnDistribution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewDistribution);
    }];
    btnDistribution.tag = 601;
    [btnDistribution addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark ---- 买家留言
    UIView *viewBuyerMsg = createView(59);
    UILabel *BuyerMessage = [self createLabelWithSuperView:viewBuyerMsg text:@"买家留言:"];
    UITextField *textMessage = [[UITextField alloc] init];
    [viewBuyerMsg addSubview:textMessage];
    [textMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(BuyerMessage.mas_right);
        make.right.equalTo(viewBuyerMsg).offset(-10);
        make.centerY.equalTo(viewBuyerMsg);
    }];
    textMessage.delegate = self;
    textMessage.placeholder = @"选填，可填写您和卖家达成的一致要求";
    if (KProjectScreenWidth < 350) {
        textMessage.font = [UIFont systemFontOfSize:13.0f];
    }else {
        textMessage.font = [UIFont systemFontOfSize:15.0f];
    }
#pragma mark ---- 商品合计
    UIView *viewCombined = createView(110);
    UILabel *labelCombined = [self createRightLabelWithSuperView:viewCombined text:nil rightView:viewCombined isLeft:NO offSet:-10];
    self.labelCombined = labelCombined;
    
#pragma mark ---- 可用积分抵扣
    UIView *viewIntegralPay = createView(169);
    UILabel *labelCoinPay = [self createLabelWithSuperView:viewIntegralPay text:@"可用积分抵扣"];
    self.labelCoinPay = labelCoinPay;
    
    UIButton *btnCoinPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewIntegralPay addSubview:btnCoinPay];
    [btnCoinPay setBackgroundImage:[UIImage imageNamed:@"勾选框_确认支付"] forState:UIControlStateNormal];
    [btnCoinPay setBackgroundImage:[UIImage imageNamed:@"对号_确认支付"] forState:UIControlStateSelected];
    [btnCoinPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewIntegralPay).offset(-10);
        make.centerY.equalTo(viewIntegralPay);
        make.size.equalTo(@18);
    }];
    self.btnCoinPay = btnCoinPay;
//    btnCoinPay.selected = YES;
    
    // 积分支付按钮
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewIntegralPay addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewIntegralPay);
    }];
    cover.tag = 604;
    [cover addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark ---- 使用优惠券
    UIView *viewUseCoupons = createView(220);
    UILabel *labelUseCoupons = [self createLabelWithSuperView:viewUseCoupons text:@"使用优惠券"];
    self.labelUseCoupons = labelUseCoupons;
    labelUseCoupons.textColor = XZColor(255, 102, 51);
    
    // 右箭头
    UIImageView *imageArrowCou = [[UIImageView alloc] init];
    [viewUseCoupons addSubview:imageArrowCou];
    [imageArrowCou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewUseCoupons).offset(-10);
        make.centerY.equalTo(viewUseCoupons);
        make.width.equalTo(@(8 * 0.8));
        make.height.equalTo(@(15 * 0.8));
        make.left.equalTo(labelUseCoupons.mas_right).offset(5);
    }];
    imageArrowCou.image = [UIImage imageNamed:@"右键头"];
    
    // 使用优惠券按钮
    UIButton *btnUseCoupons = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewUseCoupons addSubview:btnUseCoupons];
    [btnUseCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewUseCoupons);
    }];
    btnUseCoupons.tag = 605;
    [btnUseCoupons addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark ---- 订单可得积分
    UIView *viewGetCoins = createView(271);
    // 订单可得积分
    UILabel *labelGetCoins = [self createLabelWithSuperView:viewGetCoins text:@"订单可得积分：0"];
    self.labelGetCoins = labelGetCoins;
    // 优惠金额
    UILabel *labelGetCoupon = [self createRightLabelWithSuperView:viewGetCoins text:@"优惠金额：￥0.00" rightView:viewGetCoins isLeft:NO offSet:-10];
    self.labelGetCoupon = labelGetCoupon;
#pragma mark ---- 支付方式
    UIView *viewPayWay = createView(322);
    [self createLabelWithSuperView:viewPayWay text:@"支付方式:"];
    // 支付宝支付
    UIButton *btnAlipay = [self createBtnPaymentMethodWithSuperView:viewPayWay rightView:viewPayWay offSet:-10 title:@"  支付宝支付" tag:602 isLeft:NO action:@selector(didClickSelectedButton:) width:(KProjectScreenWidth / 3.0) height:50 isPay:YES];
    self.btnAlipay = btnAlipay;
    // 微信支付
    UIButton *btnWechat = [self createBtnPaymentMethodWithSuperView:viewPayWay rightView:btnAlipay offSet:-15 title:@"  微信支付" tag:603 isLeft:YES action:@selector(didClickSelectedButton:) width:(KProjectScreenWidth / 3.0) height:50 isPay:YES];
    self.btnWechat = btnWechat;
    
}

- (void)setConfirmModel:(XZConfirmOrderModel *)confirmModel {
    _confirmModel = confirmModel;
    // 创建快递方式和价格 makeMoneyRed(@"6.00",@"快递")
    if (confirmModel.dt_name) { // 有默认快递
        if (confirmModel.money) {
            self.labelDistribution.textColor = [UIColor blackColor];
            NSString *moneyDistribution = [NSString stringWithFormat:@"￥%.2f",[confirmModel.money floatValue]];
            self.labelDistribution.attributedText = [self makeMoneyRedWithBlackStr:confirmModel.dt_name redStr:moneyDistribution];
        }
    }else {
        self.labelDistribution.textColor = XZColor(255, 102, 51);
        self.labelDistribution.text = @"请选择快递方式";
    }
    // 共一件商品合计￥
    NSString *textTotal = [NSString stringWithFormat:@"共%@件商品 合计：",confirmModel.totalCount];
    NSString *moneyUser = [NSString stringWithFormat:@"￥%.2f",[confirmModel.totalMoney floatValue]];
    if (confirmModel.isCoinPay) {
        if (confirmModel.totalMoney.length != 0) {
            if ([confirmModel.totalMoney floatValue] <= 0) {
                // 全部使用积分支付
                NSString *jifenUser = [NSString stringWithFormat:@"%ld积分",(long)[confirmModel.usedJifen integerValue]];
                self.labelCombined.attributedText = [self makeMoneyRedWithBlackStr:textTotal redStr:jifenUser];
            }else {
                self.labelCombined.attributedText = [self makeMoneyRedWithBlackStr:textTotal redStr:moneyUser];
            }
        }
    }else {
        if (confirmModel.totalMoney.length != 0) {
            self.labelCombined.attributedText = [self makeMoneyRedWithBlackStr:textTotal redStr:moneyUser];
        }
    }
    if (confirmModel.isCoinPay) {
        self.labelCoinPay.text = [NSString stringWithFormat:@"可用%zi积分抵用%@元",(long)[confirmModel.usedJifen integerValue],confirmModel.jifen_discount];
    }else {
        self.labelCoinPay.text = [NSString stringWithFormat:@"您当前有%zi积分可用",(long)[confirmModel.jifenUser integerValue]];
    }
    
    // 订单可得积分
    self.labelGetCoins.text = [NSString stringWithFormat:@"订单可得积分：%ld",(long)[confirmModel.jifen integerValue]];
    // 优惠金额===如果推荐优惠为空
    if ([confirmModel.tuijianyouhui isEqualToString:@""]) {
        self.labelGetCoupon.text = [NSString stringWithFormat:@"优惠金额：%@",confirmModel.youhui];
    }else {
        self.labelGetCoupon.text = [NSString stringWithFormat:@"优惠金额：%@",confirmModel.tuijianyouhui];
    }
    
    // 优惠券
    if (self.confirmModel.chooseTicket.cpns_name.length == 0) {
        self.labelUseCoupons.text = @"使用优惠券";
    }else {
        self.labelUseCoupons.text = self.confirmModel.chooseTicket.cpns_name;
    }
    
    if (confirmModel.isWechatPay) { // 微信支付
        self.btnWechat.selected = YES;
        self.btnAlipay.selected = NO;
    }else if (confirmModel.isAliPay){ // 支付宝支付
        self.btnWechat.selected = NO;
        self.btnAlipay.selected = YES;
    }
    if (confirmModel.isCoinPay) { // 使用积分抵扣
        self.btnCoinPay.selected = YES;
    }else {
        self.btnCoinPay.selected = NO;
    }
}

- (NSMutableAttributedString *)makeMoneyRedWithBlackStr:(NSString *)blackStr redStr:(NSString *)redStr {
//    NSLog(@"blackStr:%@---redStr:%@",blackStr,redStr);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
    NSInteger length = [redStr length];
    [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, length)];
//    NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:@"￥"];
//    [attryuan addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, 1)];
    NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:blackStr];
    NSInteger lengthFore = [blackStr length];
    [attrTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, lengthFore)];
//    [attrTotal appendAttributedString:attryuan];
    [attrTotal appendAttributedString:attrStr];
    return  attrTotal;
}

// 支付方式按钮
- (UIButton *)createBtnPaymentMethodWithSuperView:(UIView *)view rightView:(UIView *)rightView offSet:(CGFloat)offSet title:(NSString *)title tag:(NSInteger)tag isLeft:(BOOL)isLeft action:(SEL)action width:(CGFloat)width height:(CGFloat)height isPay:(BOOL)isPay{
    UIButton *btnWeChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btnWeChat];
    [btnWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isLeft) {
            make.right.equalTo(rightView.mas_left).offset(offSet);
        }else {
            make.right.equalTo(view.mas_right).offset(offSet);
        }
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    btnWeChat.tag = tag;
    if (isPay) {
        [btnWeChat setImage:[UIImage imageNamed:@"确认订单页面（支付方式未勾选）_21"] forState:UIControlStateNormal];
        [btnWeChat setImage:[UIImage imageNamed:@"确认订单页面（支付方式勾选）_21"] forState:UIControlStateSelected];
    }
    [btnWeChat setTitle:title forState:UIControlStateNormal];
    [btnWeChat addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btnWeChat.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnWeChat setTitleColor:XZColor(3, 3, 3) forState:UIControlStateNormal];
    //    btnWeChat.backgroundColor = XZRandomColor;
    return btnWeChat;
}

// 点击了选择积分支付按钮
- (void)didClickSelectedButton:(UIButton *)button {
    if (self.blockDidClickButton) {
        self.blockDidClickButton(button);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.blockSendUserMsg ) {
        self.blockSendUserMsg (textField.text);
    }
}

// 创建右侧view
- (UILabel *)createRightLabelWithSuperView:(UIView *)superView text:(NSString *)text rightView:(UIView *)rightView isLeft:(BOOL)isLeft offSet:(CGFloat)offSet{
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isLeft) {
            make.right.equalTo(rightView.mas_left).offset(offSet);
        }else {
            make.right.equalTo(superView).offset(-10);
        }
        make.centerY.equalTo(superView);
    }];
    label.text = text;
    label.font = [UIFont systemFontOfSize:15.0f];
    return label;
}

- (UILabel *)createLabelWithSuperView:(UIView *)superView text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(10);
        make.centerY.equalTo(superView);
    }];
    label.text = text;
    label.font = [UIFont systemFontOfSize:15.0f];
    return label;
}

//- (void)setModelSubmit:(XZIntegralConfirmOrderModel *)modelSubmit {
//    _modelSubmit = modelSubmit;
//    // 让金额数字变色
//    NSMutableAttributedString *(^makeMoneyRed)(NSString *,NSString *) = ^(NSString *m,NSString *front) {
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
//        NSInteger length = [m length];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, length)];
//        NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:@"￥"];
//        [attryuan addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, 1)];
//        NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:front];
//        NSInteger lengthFore = [front length];
//        [attrTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, lengthFore)];
//        [attrTotal appendAttributedString:attryuan];
//        [attrTotal appendAttributedString:attrStr];
//        return  attrTotal;
//    };
//    if (modelSubmit.isWechatPay) { // 微信支付
//        self.btnWechat.selected = YES;
//        self.btnAlipay.selected = NO;
//    }else if (modelSubmit.isAliPay){ // 支付宝支付
//        self.btnWechat.selected = NO;
//        self.btnAlipay.selected = YES;
//    }
//    if (modelSubmit.isCoinPay) { // 使用积分抵扣
//        self.btnCoinPay.selected = YES;
//    }else {
//        self.btnCoinPay.selected = NO;
//    }
//}
@end
