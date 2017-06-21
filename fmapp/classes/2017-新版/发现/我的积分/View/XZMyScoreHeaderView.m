//
//  XZMyScoreHeaderView.m
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZMyScoreHeaderView.h"

@interface XZMyScoreHeaderView ()
// 总积分
@property (nonatomic, strong) UILabel *labelCoins;
//
@end

@implementation XZMyScoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMyScoreHeaderView];
    }
    return self;
}

- (void)setUpMyScoreHeaderView {
    self.backgroundColor = [UIColor whiteColor];
    
    // 总积分
    UILabel *labelCoins = [[UILabel alloc] init];
    [self addSubview:labelCoins];
    [labelCoins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
    labelCoins.textColor = [HXColor colorWithHexString:@"#0059D5"];
    labelCoins.font = [UIFont systemFontOfSize:30.0f];
    self.labelCoins = labelCoins;
    
    CGFloat width = [@"积分明细" getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 44) WithFont:[UIFont systemFontOfSize:17.0f]].width + 30;
    
    // 积分明细
    UIButton *btnCoinDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCoinDetail];
    [btnCoinDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX).offset(-KProjectScreenWidth / 4.0);
        make.top.equalTo(labelCoins.mas_bottom).offset(10);
        make.width.equalTo(width);
        make.height.equalTo(@44);
    }];
    [btnCoinDetail setTitle:@"积分明细" forState:UIControlStateNormal];
    [btnCoinDetail setTitleColor:[HXColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    btnCoinDetail.tag = 520;
    [btnCoinDetail addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line = [[UILabel alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(btnCoinDetail);
        make.width.equalTo(@0.5);
        make.height.equalTo(@30);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
    // 兑换记录
    UIButton *btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX).offset(KProjectScreenWidth / 4.0);
        make.top.equalTo(btnCoinDetail);
        make.width.equalTo(btnCoinDetail);
        make.height.equalTo(btnCoinDetail);
    }];
    [btnRecord setTitle:@"兑换记录" forState:UIControlStateNormal];
    [btnRecord setTitleColor:[HXColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    btnRecord.tag = 521;
    [btnRecord addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 热门商品
    UIButton *btnHotGoods = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnHotGoods];
    [btnHotGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(line.mas_bottom).offset(20);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
    }];
    btnHotGoods.tag = 522;
    [btnHotGoods setTitle:@"热门商品" forState:UIControlStateNormal];
    btnHotGoods.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    [btnHotGoods setTitleColor:[HXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [btnHotGoods addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 我的积分_三角箭头_1702 12 * 18
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [btnHotGoods addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnHotGoods).offset(-10);
        make.centerY.equalTo(btnHotGoods);
        make.width.equalTo(@(12 * 0.7));
        make.height.equalTo(@(18 * 0.7));
    }];
    imgArrow.image = [UIImage imageNamed:@"我的积分_三角箭头_1702"];
       
}

- (void)setUserJifen:(NSString *)userJifen {
    _userJifen = userJifen;
    
    NSMutableAttributedString *(^makeUnitSmall)(NSString *) = ^(NSString *redStr) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
        NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:@"分"];
        [attryuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 1)];
        [attrStr appendAttributedString:attryuan];
        return attrStr;
    };
    if ([userJifen integerValue] > 0) {
        self.labelCoins.attributedText = makeUnitSmall([NSString stringWithFormat:@"%.2f",[userJifen floatValue]]);
    }else {
        self.labelCoins.attributedText = makeUnitSmall(@"0.00");
    }
    
}

- (void)didClickButton:(UIButton *)button {
    if (self.blockDidClickButton) {
        self.blockDidClickButton(button);
    }
}

@end
