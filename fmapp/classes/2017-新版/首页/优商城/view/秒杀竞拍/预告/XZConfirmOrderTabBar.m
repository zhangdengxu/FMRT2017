//
//  XZConfirmOrderTabBar.m
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZConfirmOrderTabBar.h"
#import "FMShopSpecModel.h"

@interface XZConfirmOrderTabBar ()
///** 金额 */
//@property (nonatomic, strong) UILabel *labelTotalMoney;
/** 运费 */
@property (nonatomic, strong) UILabel *labelCarriage;
@end

@implementation XZConfirmOrderTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConfirmOrderTabBar];
    }
    return self;
}

- (void)setUpConfirmOrderTabBar {
    // 下方佣金总计
    UIView *payView = [[UIView alloc]init];
    [self addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    payView.backgroundColor = [UIColor whiteColor];
    
    /** 提交订单按钮 */
    UIButton *btnSubmitOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    [payView addSubview:btnSubmitOrder];
    [btnSubmitOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payView.mas_right);
        make.top.equalTo(payView.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(payView.mas_height);
    }];
    [btnSubmitOrder setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmitOrder.backgroundColor = [UIColor colorWithRed:6/255.0 green:41/255.0 blue:125/255.0 alpha:1.0f];
    [btnSubmitOrder.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnSubmitOrder addTarget:self action:@selector(didClickSubmitOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    
    /** 运费 */
    UILabel *labelCarriage = [[UILabel alloc]init];
    [payView addSubview:labelCarriage];
    [labelCarriage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(payView.mas_bottom).offset(-10);
        make.right.equalTo(btnSubmitOrder.mas_left).offset(-10);
    }];
    self.labelCarriage = labelCarriage;
//    labelCarriage.backgroundColor = [UIColor greenColor];
    labelCarriage.textColor = [UIColor lightGrayColor];
    labelCarriage.font = [UIFont systemFontOfSize:13];
    
    /** 金额 */
    UILabel *labelTotalMoney = [[UILabel alloc]init];
    [payView addSubview:labelTotalMoney];
    [labelTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payView.mas_top).offset(5);
        make.right.equalTo(labelCarriage.mas_right);
    }];
//    labelTotalMoney.backgroundColor = [UIColor redColor];
    self.labelTotalMoney = labelTotalMoney;
    labelTotalMoney.textColor = [UIColor redColor];
    labelTotalMoney.font = [UIFont systemFontOfSize:15];
    
    /** 金额合计提示 */
    UILabel *labelTotalMoneyPrompt = [[UILabel alloc]init];
    [payView addSubview:labelTotalMoneyPrompt];
    [labelTotalMoneyPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTotalMoney.mas_top);
        make.right.equalTo(labelTotalMoney.mas_left);
    }];
    labelTotalMoneyPrompt.font = [UIFont systemFontOfSize:15];
    labelTotalMoneyPrompt.text = @"合计：";
}

- (void)didClickSubmitOrderBtn {
    if (self.blockSubmitOrderBtn) {
        self.blockSubmitOrderBtn();
    }
}

- (void)setModelProductTab:(FMSelectShopInfoModel *)modelProductTab {
    _modelProductTab = modelProductTab;
    CGFloat money = [modelProductTab.price floatValue];
    self.labelTotalMoney.text = [NSString stringWithFormat:@"￥%.2f",money];
    self.labelCarriage.text = @"含运费";
}

- (void)setTabBarWithValue:(NSString *)valueStr {
    self.labelTotalMoney.text = [NSString stringWithFormat:@"￥%@",valueStr];
    self.labelCarriage.text = @"免运费";
}

@end
