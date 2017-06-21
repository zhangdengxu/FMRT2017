//
//  FMConfirmBottom.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMConfirmBottom.h"
#import "XZConfirmOrderModel.h"
@interface FMConfirmBottom ()<UITextFieldDelegate>

//first
/** 价格合计提示 */
@property (nonatomic, strong) UILabel *labelMoneyCombined;

/** 快递 */
@property (nonatomic, strong) UILabel *labelCourierName;
@property (nonatomic, strong) UILabel *labelCourierMoney;
/** 买家留言 */
@property (nonatomic, strong) UITextField *textFiledMsg;

//second
/** 价格合计提示 */
@property (nonatomic, strong) UILabel *labelMoneyPrompt;
/** 支付方式 */
@property (nonatomic, strong) UIButton *currentSelectButton;
/** 优惠金额 */
@property (nonatomic, strong) UILabel *labelCouponsMoney;
/** 可得积分 */
@property (nonatomic, strong) UILabel *labelIntegral;
@end
@implementation FMConfirmBottom

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //高度为280
        [self setUpConfirmBottom];
    }
    return self;
}

- (void)changeStatusWithModel:(XZConfirmOrderModel *)model withModel2:(XZConfirmOrderModel *)confirmModel Count:(NSInteger)count {
    // 给合计赋值
    self.labelTotalMoney.text = [NSString stringWithFormat:@"￥%@",confirmModel.totalMoney];
    // ([totalMoney floatValue] + [self.money floatValue])
    self.labelMoneyPrompt.text = [NSString stringWithFormat:@"共%ld件商品 合计：",(long)count];
    self.labelIntegral.text = [NSString stringWithFormat:@"订单可得积分:%@",confirmModel.jifen];
    // 如果推荐优惠为空
    if ([confirmModel.tuijianyouhui isEqualToString:@""]) {
         self.labelCouponsMoney.text = [NSString stringWithFormat:@"%@",confirmModel.youhui];
    }else {
         self.labelCouponsMoney.text = [NSString stringWithFormat:@"%@",confirmModel.tuijianyouhui];
    }
   
    //
//    if (model.isPointShow) {
//        
//        self.viewIntegral.hidden = YES;
//        [self.viewIntegral remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(_viewTotalMoney.mas_bottom).offset(8);
//            make.width.equalTo(@KProjectScreenWidth);
//            make.height.equalTo(@0);
//            
//        }];
//    }else{
//        
//        [self.viewIntegral remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(_viewTotalMoney.mas_bottom).offset(8);
//            make.width.equalTo(@KProjectScreenWidth);
//            make.height.equalTo(@44.5);
//        }];
//    }
//    
//    if (model.isFavorShow) {
//        
//        self.viewCoupons.hidden = YES;
//        [self.viewCoupons remakeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(_viewTotalMoney.mas_bottom).offset(8);
//            make.width.equalTo(@KProjectScreenWidth);
//            make.height.equalTo(@0);
//        }];
//    }else{
//        
//        [self.viewCoupons remakeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(_viewIntegral.mas_bottom).offset(0.5);
//            make.width.equalTo(@KProjectScreenWidth);
//            make.height.equalTo(@44.5);
//        }];
//    }
}

- (void)setUpConfirmBottom {
    self.backgroundColor = KDefaultOrBackgroundColor;
#pragma mark --- 配送方式
    UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 0.5)];
    [self addSubview:topLine];
    UIView *viewDistribution = [[UIView alloc]init];
    [self addSubview:viewDistribution];
    [viewDistribution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(@44.5);
    }];
    viewDistribution.backgroundColor = [UIColor whiteColor];
    /** 购买方式 */
    [self setUpLabelWithSuperView:viewDistribution labelText:@"配送方式："];
    // 快递信息
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewDistribution addSubview:btnDetail];
    [btnDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewDistribution.mas_right).offset(-10);
        make.centerY.equalTo(viewDistribution.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@8);
    }];
    [btnDetail setBackgroundImage:[UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"] forState:UIControlStateNormal];
    // 覆盖的button
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewDistribution addSubview:coverBtn];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewDistribution.mas_left);
        make.top.equalTo(viewDistribution.mas_top);
        make.right.equalTo(viewDistribution.mas_right);
        make.bottom.equalTo(viewDistribution.mas_bottom);
    }];
    
    /** 钱数 */
    UILabel *labelCourierMoney = [[UILabel alloc]init];
    [viewDistribution addSubview:labelCourierMoney];
    [labelCourierMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnDetail.mas_left).offset(-5);
        make.centerY.equalTo(viewDistribution.mas_centerY);
    }];
    self.labelCourierMoney = labelCourierMoney;
    labelCourierMoney.font = [UIFont systemFontOfSize:14];
    labelCourierMoney.textAlignment = NSTextAlignmentRight;
    labelCourierMoney.textColor = [UIColor redColor];
    labelCourierMoney.text = @"请先选择配送方式";
    
    /** 快递名 */
    UILabel *labelCourierName = [[UILabel alloc]init];
    [viewDistribution addSubview:labelCourierName];
    [labelCourierName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelCourierMoney.mas_left).offset(-5);
        make.centerY.equalTo(viewDistribution.mas_centerY);
    }];
    self.labelCourierName = labelCourierName;
    labelCourierName.font = [UIFont systemFontOfSize:14];
    labelCourierName.textAlignment = NSTextAlignmentRight;
#pragma mark --- 买家留言
    UIView *viewBuyerMsg = [[UIView alloc]init];
    [self addSubview:viewBuyerMsg];
    [viewBuyerMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewDistribution.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    viewBuyerMsg.backgroundColor = [UIColor whiteColor];
    /** 买家留言 */
    [self setUpLabelWithSuperView:viewBuyerMsg labelText:@"买家留言："];
    UITextField *textFiledMsg = [[UITextField alloc]init];
    [viewBuyerMsg addSubview:textFiledMsg];
    [textFiledMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewBuyerMsg.mas_right).offset(-10);
        make.left.equalTo(@85);
        make.centerY.equalTo(viewBuyerMsg.mas_centerY);
    }];
    _textFiledMsg = textFiledMsg;
    _textFiledMsg.delegate = self;
    textFiledMsg.placeholder = @"选填，可填写您和卖家达成的一致要求";
    textFiledMsg.font = [UIFont systemFontOfSize:14];
    //    textFiledMsg.textColor = [UIColor darkGrayColor];
#pragma mark --- 商品合计
    UIView *viewTotalMoney = [[UIView alloc]init];
    [self addSubview:viewTotalMoney];
    self.viewTotalMoney = viewTotalMoney;
    [viewTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewBuyerMsg.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    viewTotalMoney.backgroundColor = [UIColor whiteColor];
    
    /** 商品价格合计 */
    UILabel *labelMoneyCombined = [[UILabel alloc]init];
    [viewTotalMoney addSubview:labelMoneyCombined];
    [labelMoneyCombined mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTotalMoney.mas_right).offset(-10);
        make.centerY.equalTo(viewTotalMoney.mas_centerY);
    }];
    labelMoneyCombined.font = [UIFont systemFontOfSize:15];
    labelMoneyCombined.textAlignment = NSTextAlignmentRight;
    labelMoneyCombined.textColor = [UIColor redColor];
    //    labelMoneyCombined.text = [NSString stringWithFormat:@"￥146.00"];
    self.labelMoneyCombined = labelMoneyCombined;
    /** 总价格 */
    _labelTotalMoney = [[UILabel alloc]init];
    [viewTotalMoney addSubview:_labelTotalMoney];
    [_labelTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelMoneyCombined.mas_left);
        make.centerY.equalTo(viewTotalMoney.mas_centerY);
    }];
    _labelTotalMoney.font = [UIFont systemFontOfSize:15];
    _labelTotalMoney.textAlignment = NSTextAlignmentRight;
    _labelTotalMoney.textColor = [UIColor redColor];
    /** 价格合计提示 */
    UILabel *labelMoneyPrompt = [[UILabel alloc]init];
    [viewTotalMoney addSubview:labelMoneyPrompt];
    [labelMoneyPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_labelTotalMoney.mas_left);
        make.centerY.equalTo(viewTotalMoney.mas_centerY);
    }];
    labelMoneyPrompt.font = [UIFont systemFontOfSize:15];
    labelMoneyPrompt.textAlignment = NSTextAlignmentRight;
//    labelMoneyPrompt.text = [NSString stringWithFormat:@"共1件商品 合计："];
    //    labelMoneyPrompt.textColor = [UIColor darkGrayColor];
    self.labelMoneyPrompt = labelMoneyPrompt;
    
#pragma mark --- 可用积分

    UIView *viewIntegral = [[UIView alloc]init];
    [self addSubview:viewIntegral];
    [viewIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewTotalMoney.mas_bottom).offset(8);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    _viewIntegral = viewIntegral;
    viewIntegral.backgroundColor = [UIColor whiteColor];
    /** 可用积分 */
    [self setUpLeftLabelWithSuperView:viewIntegral labelText:@"可用积分"];
    /** 右侧按钮 */
    [self setUpRightBtnWithSuperView:viewIntegral tag:103];
    
    
#pragma mark --- 优惠券
    UIView *viewCoupons = [[UIView alloc]init];
    [self addSubview:viewCoupons];
    _viewCoupons = viewCoupons;
    [viewCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewIntegral.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    _viewCoupons = viewCoupons;
    viewCoupons.backgroundColor = [UIColor whiteColor];
    /** 左边优惠券 */
    [self setUpLeftLabelWithSuperView:viewCoupons labelText:@"优惠券："];
    /** 优惠券信息 */
    UILabel *labelCoupons = [[UILabel alloc]init];
    [viewCoupons addSubview:labelCoupons];
    [labelCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@70);
        make.right.equalTo(viewCoupons.mas_right).offset(-45);
        make.centerY.equalTo(viewCoupons.mas_centerY);
    }];
    labelCoupons.text = [NSString stringWithFormat:@"有10元优惠券可用"];
    labelCoupons.textColor = [UIColor redColor];
    labelCoupons.font = [UIFont systemFontOfSize:15];
    /** 右侧按钮 */
    [self setUpRightBtnWithSuperView:viewCoupons tag:104];
#pragma mark --- 可得积分
    UIView *viewAvailableIntegral = [[UIView alloc]init];
    [self addSubview:viewAvailableIntegral];
    [viewAvailableIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewCoupons.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    viewAvailableIntegral.backgroundColor = [UIColor whiteColor];
    /** 可得积分 */
    UILabel *labelIntegral = [[UILabel alloc]init];
    [viewAvailableIntegral addSubview:labelIntegral];
    [labelIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewAvailableIntegral.mas_centerY);
        make.left.equalTo(viewAvailableIntegral).offset(10);
    }];
    self.labelIntegral = labelIntegral;
    labelIntegral.font = [UIFont systemFontOfSize:15];
    //    labelIntegral.textColor = [UIColor darkGrayColor];
    /** 优惠金额 */
    UILabel *labelCouponsMoney = [[UILabel alloc]init];
    [viewAvailableIntegral addSubview:labelCouponsMoney];
    [labelCouponsMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewAvailableIntegral.mas_centerY);
        make.right.equalTo(viewAvailableIntegral.mas_right).offset(-10);
    }];
    self.labelCouponsMoney = labelCouponsMoney;
    labelCouponsMoney.font = [UIFont systemFontOfSize:15];
    //    labelCouponsMoney.textColor = [UIColor darkGrayColor];
    /** 优惠金额提示 */
    UILabel *labelCouponsMoneyPrompt = [[UILabel alloc]init];
    [viewAvailableIntegral addSubview:labelCouponsMoneyPrompt];
    [labelCouponsMoneyPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewAvailableIntegral.mas_centerY);
        make.right.equalTo(labelCouponsMoney.mas_left);
    }];
    labelCouponsMoneyPrompt.text = @"优惠金额:";
    labelCouponsMoneyPrompt.font = [UIFont systemFontOfSize:15];
    //    labelCouponsMoneyPrompt.textColor = [UIColor darkGrayColor];
#pragma mark --- 支付方式
    UIView *viewPayment = [[UIView alloc]init];
    [self addSubview:viewPayment];
    [viewPayment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewAvailableIntegral.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    viewPayment.backgroundColor = [UIColor whiteColor];
    [self setUpLeftLabelWithSuperView:viewPayment labelText:@"支付方式："];
    /** 支付方式 */
    UIButton *btnLeft = [self createBtnPaymentMethodWithSuperView:viewPayment rightView:viewPayment offSet:-120 title:@"  支付宝支付" tag:101];
    // 微信支付
    [self createBtnPaymentMethodWithSuperView:viewPayment rightView:viewPayment offSet:-30 title:@"  微信支付" tag:100];
    // 默认选中左边按钮
    [self didClickWeChatBtn:btnLeft];
    // 隐藏积分和优惠券行
    self.viewIntegral.hidden = YES;
    [self.viewIntegral remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(_viewTotalMoney.mas_bottom).offset(8);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(@0);
    }];
    self.viewCoupons.hidden = YES;
    [self.viewCoupons remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.top.equalTo(_viewTotalMoney.mas_bottom).offset(8);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(@0);
    }];

}
// 设置左侧label
- (void)setUpLabelWithSuperView:(UIView *)view labelText:(NSString *)text {
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    label.text = [NSString stringWithFormat:@"%@",text];
    label.font = [UIFont systemFontOfSize:15];
}
// 点击地址信息按钮
- (void)didClickDetailBtn:(UIButton *)button {
    [self.textFiledMsg resignFirstResponder];
    if (self.blockDetailBtn) {
        self.blockDetailBtn(button);
    }
}
//// 回收键盘
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    [self.textFiledMsg resignFirstResponder];
//    return YES;
//}
- (void)setConfirmModel:(XZConfirmOrderModel *)confirmModel {
    _confirmModel = confirmModel;
    self.labelCourierName.text = [NSString stringWithFormat:@"%@",confirmModel.dt_name];
    self.labelCourierMoney.text = [NSString stringWithFormat:@"￥%@",confirmModel.money];
//    self.money = confirmModel.money;
}

// 设置左侧label
- (void)setUpLeftLabelWithSuperView:(UIView *)view labelText:(NSString *)text {
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    label.text = [NSString stringWithFormat:@"%@",text];
    //    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
}
// 点击右侧选择按钮
- (void)didClickSelectedBtn:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        if (self.blockPrivilegeBtn) {
            self.blockPrivilegeBtn(button);
        }
    }else{
        button.selected = NO;
        if (self.blockPrivilegeBtn) {
            self.blockPrivilegeBtn(button);
        }
    }
}
/** 右侧按钮 */
- (void)setUpRightBtnWithSuperView:(UIView *)view tag:(NSInteger)tag {
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:selectedBtn];
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.centerY.equalTo(view.mas_centerY);
        make.width.and.height.equalTo(@17);
    }];
    selectedBtn.tag = tag;
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"确认订单（抵用按钮未勾选）_18"] forState:UIControlStateNormal];
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"确认订单（抵用按钮勾选）_18"] forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(didClickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
}
// 支付方式按钮
- (UIButton *)createBtnPaymentMethodWithSuperView:(UIView *)view rightView:(UIView *)rightView offSet:(CGFloat)offSet title:(NSString *)title tag:(NSInteger)tag{
    UIButton *btnWeChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btnWeChat];
    [btnWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightView.mas_right).offset(offSet);
        make.centerY.equalTo(view.mas_centerY);
        //        make.width.and.height.equalTo(@30);
    }];
    btnWeChat.tag = tag;
    [btnWeChat setImage:[UIImage imageNamed:@"确认订单页面（支付方式未勾选）_21"] forState:UIControlStateNormal];
    [btnWeChat setImage:[UIImage imageNamed:@"确认订单页面（支付方式勾选）_21"] forState:UIControlStateSelected];
    [btnWeChat setTitle:title forState:UIControlStateNormal];
    [btnWeChat addTarget:self action:@selector(didClickWeChatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnWeChat.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnWeChat setTitleColor:XZColor(3, 3, 3) forState:UIControlStateNormal];
    //    btnWeChat.backgroundColor = [UIColor darkGrayColor];
    return btnWeChat;
}
/** 支付方式 */
- (void)didClickWeChatBtn:(UIButton *)button {
    
    if (self.currentSelectButton != button) {
        self.currentSelectButton.selected = !self.currentSelectButton.selected;
        self.currentSelectButton = button;
        button.selected = YES;
        if (self.blockPrivilegeBtn) {
            self.blockPrivilegeBtn(button);
        }
    }
}


@end
