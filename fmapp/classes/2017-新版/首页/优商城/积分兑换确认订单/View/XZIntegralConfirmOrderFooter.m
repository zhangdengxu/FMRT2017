//
//  XZIntegralConfirmOrderFooter.m
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//  确认订单积分footer

#import "XZIntegralConfirmOrderFooter.h"
// model
#import "XZConfirmOrderModel.h"
#import "FMShoppingListModel.h"


@interface XZIntegralConfirmOrderFooter ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *labelCombined;
@property (nonatomic, strong) UIButton *btnCoinPay;
// 可用积分
@property (nonatomic, strong) UILabel *labelUsefulCoins;
/** 支付方式 */
@property (nonatomic, strong) UIButton *currentSelectButton;
// 数量
@property (nonatomic, strong) UILabel *labelNumber;
// 微信支付
@property (nonatomic, strong) UIButton *btnWechat;
/** 支付方式 */
@property (nonatomic, strong) UIButton *btnAlipay;
// 配送方式
@property (nonatomic, strong) UILabel *labelDistribution;
// 买家留言
@property (nonatomic, strong) UITextField *textMessage;
@end

@implementation XZIntegralConfirmOrderFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpIntegralConfirmOrderFooter];
    }
    return self;
}

- (void)setUpIntegralConfirmOrderFooter {
    self.backgroundColor = XZBackGroundColor;
    
    UIView *(^createView)(CGFloat) = ^(CGFloat y) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,KProjectScreenWidth, 50)];
        [self addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    };
#pragma mark ---- 配送方式 50+8+1
    UIView *viewDistribution = createView(8);
    [self createLabelWithSuperView:viewDistribution text:@"配送方式:"];
    // 右箭头
    UIImageView *imageArrow = [[UIImageView alloc] init];
    [viewDistribution addSubview:imageArrow];
    [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewDistribution).offset(-10);
        make.centerY.equalTo(viewDistribution);
        make.width.equalTo(@(8 * 0.8)); // @(8 * 0.8)
        make.height.equalTo(@(15 * 0.8)); // @(15 * 0.8)
    }];
    imageArrow.image = [UIImage imageNamed:@"右键头"];
    
    UILabel *labelDistribution = [self createRightLabelWithSuperView:viewDistribution text:nil rightView:imageArrow addColor:NO isLeft:YES hasSize:NO offSet:-10];
    labelDistribution.textColor = XZColor(255, 102, 51);
    self.labelDistribution = labelDistribution;
    
    // 配送方式按钮
    UIButton *btnDistribution = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewDistribution addSubview:btnDistribution];
    [btnDistribution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewDistribution);
    }];
    btnDistribution.tag = 404;
    [btnDistribution addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark ----  买家留言 59+1+50
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
    self.textMessage = textMessage;
    textMessage.placeholder = @"选填，可填写您和卖家达成的一致要求";
    if (KProjectScreenWidth < 350) {
        textMessage.font = [UIFont systemFontOfSize:13.0f];
    }else {
        textMessage.font = [UIFont systemFontOfSize:15.0f];
    }
    
#pragma mark ---- 合计 110+1+50
    UIView *viewCombined = createView(110);
    UILabel *labelCombined = [self createRightLabelWithSuperView:viewCombined text:nil rightView:viewCombined addColor:NO isLeft:NO hasSize:NO offSet:0];
    self.labelCombined = labelCombined;
#pragma mark ---- 积分支付 161+8+50
    UIView *viewIntegralPay = createView(161);
    [self createLabelWithSuperView:viewIntegralPay text:@"积分支付"];
    
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
    btnCoinPay.selected = YES;
    // 积分支付按钮
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewIntegralPay addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewIntegralPay);
    }];
    cover.tag = 403;
    [cover addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    // 可用积分
    UILabel *labelUsefulCoins = [self createRightLabelWithSuperView:viewIntegralPay text:@"" rightView:btnCoinPay addColor:YES  isLeft:YES hasSize:NO offSet:-10];
    self.labelUsefulCoins = labelUsefulCoins;
#pragma mark ---- 支付方式 219+1+50
    UIView *viewPayWay = createView(219);
    [self createLabelWithSuperView:viewPayWay text:@"支付方式:"];
    /** 支付方式 */
    UIButton *btnAlipay = [self createBtnPaymentMethodWithSuperView:viewPayWay rightView:viewPayWay offSet:-10 title:@"  支付宝支付" tag:401 isLeft:NO action:@selector(didClickWeChatBtn:) width:(KProjectScreenWidth / 3.0) height:50 isPay:YES];
    self.btnAlipay = btnAlipay;
    // 微信支付
    UIButton *btnWechat = [self createBtnPaymentMethodWithSuperView:viewPayWay rightView:btnAlipay offSet:-15 title:@"  微信支付" tag:402 isLeft:YES action:@selector(didClickWeChatBtn:) width:(KProjectScreenWidth / 3.0) height:50 isPay:YES];
    self.btnWechat = btnWechat;
    // 默认选中左边按钮
    [self didClickWeChatBtn:nil];
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

#pragma mark ---- 支付方式单选
- (void)didClickWeChatBtn:(UIButton *)button {
    if (self.blockDidClickButton) {
        self.blockDidClickButton(button);
    }
}

- (void)setConfirmModelCoins:(XZConfirmOrderModel *)confirmModelCoins {
    _confirmModelCoins = confirmModelCoins;
    NSMutableAttributedString *(^makeMoneyRed)(NSString *,NSString *) = ^(NSString *m,NSString *front) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, length)];
        //        NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:@""];
        //        [attryuan addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51)  (0, 1)];
        NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:front];
        NSInteger lengthFore = [front length];
        [attrTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, lengthFore)];
        //        [attrTotal appendAttributedString:attryuan];
        [attrTotal appendAttributedString:attrStr];
        return  attrTotal;
    };
    
    if (confirmModelCoins.isWechatPay) { // 微信支付
        self.btnWechat.selected = YES;
        self.btnAlipay.selected = NO;
        self.btnCoinPay.selected = NO;
    }else if (confirmModelCoins.isAliPay){
        self.btnWechat.selected = NO;
        self.btnAlipay.selected = YES; // 支付宝支付
        self.btnCoinPay.selected = NO;
        
    }else if (confirmModelCoins.isCoinPay) { // 积分支付
        self.btnWechat.selected = NO;
        self.btnAlipay.selected = NO;
        self.btnCoinPay.selected = YES;
    }
    // 可用积分
    self.labelUsefulCoins.text = [NSString stringWithFormat:@"可用积分%@",self.confirmModelCoins.jifenUser];
    // 共一件商品合计￥
    NSString *textTotal = [NSString stringWithFormat:@"共%ld件商品 合计：",(long)confirmModelCoins.shopListModel.selectCount];
    if (confirmModelCoins.isCoinPay) { // 积分支付
        // 用户所需总积分
        NSString *totalMoney = [NSString stringWithFormat:@"%@积分",confirmModelCoins.totalJifen];
        if (totalMoney) {
            self.labelCombined.attributedText = makeMoneyRed(totalMoney,textTotal);
        }
    }else {
        // 用户所需价格
        NSString *totalMoney = [NSString stringWithFormat:@"￥%@",confirmModelCoins.totalMoney];
        if (totalMoney) {
            self.labelCombined.attributedText = makeMoneyRed(totalMoney,textTotal);
        }
    }
    
    self.labelNumber.text =  [NSString stringWithFormat:@"%ld",(long)confirmModelCoins.shopListModel.selectCount];
    self.labelDistribution.text = confirmModelCoins.deliveryWay;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.blockSendUserMsg ) {
        self.blockSendUserMsg (textField.text);
    }
}

// 点击了选择积分支付按钮
- (void)didClickSelectedButton:(UIButton *)button {
    [self.textMessage resignFirstResponder];
    if (self.blockDidClickButton) {
        self.blockDidClickButton(button);
    }
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

// 创建右侧view
- (UILabel *)createRightLabelWithSuperView:(UIView *)superView text:(NSString *)text rightView:(UIView *)rightView addColor:(BOOL)addColor isLeft:(BOOL)isLeft hasSize:(BOOL)hasSize offSet:(CGFloat)offSet{
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isLeft) {
            make.right.equalTo(rightView.mas_left).offset(offSet);
        }else {
            make.right.equalTo(superView).offset(-10);
        }
        make.centerY.equalTo(superView);
        if (hasSize) {
            make.size.equalTo(@40);
        }
    }];
    label.text = text;
    if (addColor) {
       label.textColor = [UIColor lightGrayColor];
    }
    label.font = [UIFont systemFontOfSize:15.0f];
    return label;
}

@end
