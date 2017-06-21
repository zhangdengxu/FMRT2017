//
//  XZPaymentDetailsView.m
//  fmapp
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 yk. All rights reserved.
//  付款详情

#import "XZPaymentDetailsView.h"
#import "XZConfirmOrderModel.h"
#import "FMShoppingListModel.h"

@interface XZPaymentDetailsView ()
// 白色视图
@property (nonatomic, strong) UIView *whiteBack;
// 订单信息
@property (nonatomic, strong) UILabel *labelOrderInfo;
// 需支付积分
@property (nonatomic, strong) UILabel *labelNeedCoins;
// 支付方式
@property (nonatomic, strong) UILabel *labelPayWay;
@end

@implementation XZPaymentDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpPaymentDetailsView];
    }
    return self;
}

- (void)setUpPaymentDetailsView {
//    self.backgroundColor = KDefaultOrBackgroundColor;
    // 黑色透明背景
    UIView *cover = [[UIView alloc] init];
    [self addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    
    //
    UIView *whiteBack = [[UIView alloc] init];
    [self addSubview:whiteBack];
    [whiteBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@350);
    }];
    self.whiteBack = whiteBack;
    whiteBack.backgroundColor = [UIColor whiteColor];
    
    //
    UIImageView *imgClosed = [[UIImageView alloc] init];
    [whiteBack addSubview:imgClosed];
    [imgClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(whiteBack).offset(15);
        make.width.equalTo(@(24 * 0.7));
        make.height.equalTo(@(25 * 0.8));
    }];
    imgClosed.image = [UIImage imageNamed:@"优商城_支付关闭_36"];
    
    // 关闭按钮
    UIButton *btnClosed = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBack addSubview:btnClosed];
    [btnClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(whiteBack);
        make.size.equalTo(@50);
    }];
//    [btnClosed setBackgroundColor:[UIColor greenColor]];
    [btnClosed addTarget:self action:@selector(didClickClosedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 付款详情
    UILabel *labelDetails = [[UILabel alloc] init];
    [whiteBack addSubview:labelDetails];
    [labelDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteBack);
        make.centerY.equalTo(btnClosed);
    }];
    labelDetails.text = @"付款详情";
    labelDetails.font = [UIFont systemFontOfSize:21.0f];
    
    // 线
    UILabel *line1 = [self createLineWithLeftView:whiteBack rightView:whiteBack topView:btnClosed];
    
    // 订单信息
    UIView *viewOrderInfo = [self createViewWithTopView:line1];
    UILabel *labelOrderLeft = [self createLeftLabelWithSuperView:viewOrderInfo text:@"订单信息" lightGray:YES];
    
    UILabel *labelOrderInfo = [self createRightLabelWithSuperView:viewOrderInfo text:nil lightGray:YES];
    self.labelOrderInfo = labelOrderInfo;
    
    // 线
    UILabel *line2 = [self createLineWithLeftView:labelOrderLeft rightView:labelOrderInfo topView:viewOrderInfo];
    
    // 支付方式
    UIView *viewPayWay = [self createViewWithTopView:line2];
    [self createLeftLabelWithSuperView:viewPayWay text:@"支付方式" lightGray:YES];
    // 积分支付
    UILabel *labelPayWay = [self createRightLabelWithSuperView:viewPayWay text:nil lightGray:YES];
    self.labelPayWay = labelPayWay;
    
    // 线
    UILabel *line3 = [self createLineWithLeftView:labelOrderLeft rightView:labelOrderInfo topView:viewPayWay];
    
    // 需支付积分
    UIView *viewNeedCoins = [self createViewWithTopView:line3];
    [self createLeftLabelWithSuperView:viewNeedCoins text:@"需支付积分" lightGray:NO];
    // UILabel *labelPayWay =
    UILabel *labelNeedCoins = [self createRightLabelWithSuperView:viewNeedCoins text:nil lightGray:NO];
    self.labelNeedCoins = labelNeedCoins;
    
    // 线
    UILabel *line4 = [self createLineWithLeftView:labelOrderLeft rightView:labelOrderInfo topView:viewNeedCoins];
    
    // 确认支付
    UIButton *btnSurePay = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBack addSubview:btnSurePay];
    [btnSurePay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBack).offset(10);
        make.right.equalTo(whiteBack).offset(-10);
        make.top.equalTo(line4.mas_bottom).offset(50);
        make.height.equalTo(@45);
    }];
    [btnSurePay setTitle:@"确认支付" forState:UIControlStateNormal];
    [btnSurePay setBackgroundColor:XZColor(14, 93, 211)];
    btnSurePay.layer.masksToBounds = YES;
    btnSurePay.layer.cornerRadius = 5.0f;
    [btnSurePay addTarget:self action:@selector(didClickSurePayButton) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)setConfirmModelCoins:(XZConfirmOrderModel *)confirmModelCoins {
    _confirmModelCoins = confirmModelCoins;
    self.labelOrderInfo.text = confirmModelCoins.shopListModel.name;
    if (confirmModelCoins.isCoinPay) { // 积分支付
        self.labelPayWay.text = @"积分支付";
        self.labelNeedCoins.text = confirmModelCoins.totalJifen;
    }else if (confirmModelCoins.isWechatPay) { // 微信支付
        self.labelPayWay.text = @"微信支付";
        self.labelNeedCoins.text = confirmModelCoins.totalMoney;
    }else {
        self.labelPayWay.text = @"支付宝支付";
        self.labelNeedCoins.text = confirmModelCoins.totalMoney;
    }
}

//
- (UIView *)createViewWithTopView:(UIView *)topView {
    UIView *view = [[UIView alloc] init];
    [self.whiteBack addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBack);
        make.right.equalTo(self.whiteBack);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@50);
    }];
    return view;
}

- (UILabel *)createLeftLabelWithSuperView:(UIView *)superView  text:(NSString *)text lightGray:(BOOL)lightGray {
    UILabel *labelLeft = [[UILabel alloc] init];
    [superView addSubview:labelLeft];
    [labelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(10);
        make.centerY.equalTo(superView);
    }];
    labelLeft.font = [UIFont systemFontOfSize:15.0f];
    labelLeft.text = text;
    if (lightGray) {
        labelLeft.textColor = XZColor(153, 153, 153);
    }else {
        labelLeft.textColor = [UIColor blackColor];
    }
    return labelLeft;
}

- (UILabel *)createRightLabelWithSuperView:(UIView *)superView  text:(NSString *)text lightGray:(BOOL)lightGray {
    UILabel *labelRight = [[UILabel alloc] init];
    [superView addSubview:labelRight];
    [labelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView).offset(-10);
        make.centerY.equalTo(superView);
    }];
    labelRight.font = [UIFont systemFontOfSize:15.0f];
    labelRight.text = text;
    if (lightGray) {
        labelRight.textColor = XZColor(102, 102, 102);
    }else {
        labelRight.textColor = [UIColor blackColor];
    }
    return labelRight;
}

- (UILabel *)createLineWithLeftView:(UIView *)leftView rightView:(UIView *)rightView topView:(UIView *)topView {
    UILabel *line = [[UILabel alloc] init];
    [self.whiteBack addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(rightView);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = XZBackGroundColor;
    return line;
}

// 点击确认订单
- (void)didClickSurePayButton {
    if (self.blockDidClickClosed) {
        self.blockDidClickClosed();
    }
     [self removeFromSuperview];
}

// 点击关闭按钮
- (void)didClickClosedButton:(UIButton *)button {
    [self removeFromSuperview];
}

@end
