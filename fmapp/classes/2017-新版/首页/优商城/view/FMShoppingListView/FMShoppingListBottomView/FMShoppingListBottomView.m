//
//  FMShoppingListBottomView.m
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListBottomView.h"


@interface FMShoppingListBottomView ()

@property (nonatomic, strong) UIButton *accountsButton;

@end

@implementation FMShoppingListBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor whiteColor]];

        [self createBottomView];
    }
    return self;
}

- (void)createBottomView {
    
    [self addSubview:self.accountsButton];
    [self.accountsButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self);
        make.width.equalTo(KProjectScreenWidth / 4);
    }];
    
    [self addSubview:self.totalMoneyLabel];

    [self addSubview:self.freightMoneyLabel];
//    self.freightMoneyLabel.text = @"(含运费￥0.00)";
    self.freightMoneyLabel.text = @"(不含运费)";
    [self.totalMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.accountsButton.mas_left).offset(-15);

    }];
    
    [self.freightMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoneyLabel.mas_bottom);
        make.left.equalTo(self.totalMoneyLabel.mas_left);
    }];
}

- (void)acountsSelectAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}

-(UILabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[UILabel alloc]init];
        _totalMoneyLabel.textColor = KDefaultOrNightTextColor;
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _totalMoneyLabel;
}

-(UILabel *)freightMoneyLabel {
    if (!_freightMoneyLabel) {
        _freightMoneyLabel = [[UILabel alloc]init];
        _freightMoneyLabel.textColor = kColorTextColorClay;
        _freightMoneyLabel.font = [UIFont systemFontOfSize:11];
    }
    return _freightMoneyLabel;
}

- (UIButton *)accountsButton {
    if (!_accountsButton) {
        UIButton *accountsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        accountsButton.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
        accountsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [accountsButton addTarget:self action:@selector(acountsSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _accountsButton = accountsButton;
    }
    return _accountsButton;
}

- (void)sendeDataWith:(NSString *)str withNumber:(CGFloat)number{
    
    NSString *money = [NSString stringWithFormat:@"￥%@",str];
    NSString *tot = @"合计:";
    NSString *all =[NSString stringWithFormat:@"%@%@",tot,money];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:all];
    NSRange range = [all rangeOfString:money];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
    
    self.totalMoneyLabel.attributedText = attrStr;
    
    [self.accountsButton setTitle:[NSString stringWithFormat:@"结算 （%.0f）",number] forState:(UIControlStateNormal)];

}


@end
