//
//  XZConFirmOrderKillBottomView.m
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#define WhiteViewHeighRadio 0.55
#import "XZConFirmOrderKillBottomView.h"
//#import "XZConfirmOrderModel.h"
#import "FMShopSpecModel.h"

@interface XZConFirmOrderKillBottomView ()<UITextFieldDelegate>
// 包邮
@property (nonatomic, strong) UILabel *labelCourierMoney;
/** 支付方式 */
@property (nonatomic, strong) UIButton *currentSelectButton;
@property (nonatomic, strong) UIButton *coverBtn;
/** 右侧箭头 */
@property (nonatomic, strong) UIImageView *imageDetail;
/** 请选择优惠券 */
@property (nonatomic, strong) UILabel *labelChooseCoupons;
@end

@implementation XZConFirmOrderKillBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //高度为280
        [self setUpConfirmBottom];
    }
    return self;
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
    
    /** 包邮 */
    UILabel *labelCourierMoney = [[UILabel alloc]init];
    [viewDistribution addSubview:labelCourierMoney];
    [labelCourierMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewDistribution.mas_right).offset(-10);
        make.centerY.equalTo(viewDistribution.mas_centerY);
    }];
    self.labelCourierMoney = labelCourierMoney;
    labelCourierMoney.font = [UIFont systemFontOfSize:14];
    labelCourierMoney.textAlignment = NSTextAlignmentRight;
    labelCourierMoney.textColor = [UIColor redColor];
    labelCourierMoney.text = @"包邮";
    
#pragma mark --- 可用积分
    UIView *viewAvailableIntegral = [[UIView alloc]init];
    [self addSubview:viewAvailableIntegral];
    [viewAvailableIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(viewDistribution.mas_bottom).offset(0.5);
        make.width.equalTo(@KProjectScreenWidth);
        make.height.equalTo(viewDistribution.mas_height);
    }];
    viewAvailableIntegral.backgroundColor = [UIColor whiteColor];
    /** 可用积分 */
    [self setUpLeftLabelWithSuperView:viewAvailableIntegral labelText:@"抵价券："];
    /** 右侧箭头 */
    UIImageView *imageDetail = [[UIImageView alloc] init];
    [viewAvailableIntegral addSubview:imageDetail];
    [imageDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewAvailableIntegral.mas_right).offset(-10);
        make.centerY.equalTo(viewAvailableIntegral.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@8);
    }];
    self.imageDetail = imageDetail;
    imageDetail.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
    
    /** 请选择优惠券 */
    UILabel *labelChooseCoupons = [[UILabel alloc]init];
    [viewAvailableIntegral addSubview:labelChooseCoupons];
    [labelChooseCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageDetail.mas_right).offset(-10);
        make.centerY.equalTo(viewAvailableIntegral.mas_centerY);
    }];
    self.labelChooseCoupons = labelChooseCoupons;
    labelChooseCoupons.font = [UIFont systemFontOfSize:14];
    labelChooseCoupons.textAlignment = NSTextAlignmentRight;
    labelChooseCoupons.textColor = [UIColor orangeColor];
    labelChooseCoupons.text = @"请选择抵价券";
    
    // 覆盖的button
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewAvailableIntegral addSubview:coverBtn];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn = coverBtn;
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewAvailableIntegral.mas_left);
        make.top.equalTo(viewAvailableIntegral.mas_top);
        make.right.equalTo(viewAvailableIntegral.mas_right);
        make.bottom.equalTo(viewAvailableIntegral.mas_bottom);
    }];
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

// 选择优惠券
- (void)didClickDetailBtn:(UIButton *)button {
    if (self.blockDetailBtn) {
        self.blockDetailBtn(button);
    }
}

- (void)setShopDetailModel:(FMSelectShopInfoModel *)shopDetailModel {
    _shopDetailModel = shopDetailModel;
    if (shopDetailModel.ticket_state) { // 1 可以使用
        if ([shopDetailModel.ticket_amount integerValue] > 0) { // 前一个页面传过来优惠券
            self.coverBtn.userInteractionEnabled = NO;
            self.imageDetail.hidden = YES;
            self.labelChooseCoupons.text = [NSString stringWithFormat:@"￥%@",shopDetailModel.ticket_amount];
        }else { // 未传优惠值
            
        }
    }
    
}

- (void)setValueWithModel:(FMSelectShopInfoModel *)shopDetailModel {
//    self.coverBtn.userInteractionEnabled = NO;
    if (shopDetailModel.unUseCoupon) { // 选择不使用优惠券
        self.imageDetail.hidden = NO;
        self.coverBtn.userInteractionEnabled = YES;
        self.labelChooseCoupons.text = @"请选择抵价券";
    }else { // 使用优惠券
        self.imageDetail.hidden = YES;
        self.labelChooseCoupons.text = [NSString stringWithFormat:@"￥%@",shopDetailModel.amount];
    }
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
