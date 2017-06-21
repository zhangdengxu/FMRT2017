//
//  XZPhoneBankSupportCell.m
//  fmapp
//
//  Created by admin on 2017/5/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZPhoneBankSupportCell.h"
#import "XZPhoneBankSupportModel.h"

@interface XZPhoneBankSupportCell ()
@property (nonatomic, strong) UIButton *buttonRight;
@property (nonatomic, strong) UIButton *buttonLeft;
@end

@implementation XZPhoneBankSupportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpPhoneBankSupportCell];
    }
    return self;
}

- (void)setUpPhoneBankSupportCell {
    CGFloat font = 13.0f;
    if (KProjectScreenWidth > 350) {
        font = 15.0f;
    }
    
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonLeft];
    [buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [buttonLeft setTitleColor:[HXColor colorWithHexString:@"0099e9"] forState:UIControlStateNormal];
    [buttonLeft.titleLabel setFont:[UIFont systemFontOfSize:font]];
    buttonLeft.tag = 510;
    [buttonLeft addTarget:self action:@selector(didClickBankButton:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonLeft = buttonLeft;
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonRight];
    [buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(buttonLeft);
        make.height.equalTo(buttonLeft);
        make.right.equalTo(self.contentView);
    }];
    [buttonRight setTitleColor:[HXColor colorWithHexString:@"0099e9"] forState:UIControlStateNormal];
    [buttonRight.titleLabel setFont:[UIFont systemFontOfSize:font]];
    buttonRight.tag = 511;
    [buttonRight addTarget:self action:@selector(didClickBankButton:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonRight = buttonRight;
}
 - (void)setModelBank:(XZPhoneBankSupportModel *)modelBank {
    _modelBank = modelBank;
    
    if (modelBank.name1.length > 0) {
        [self.buttonLeft setTitle:[NSString stringWithFormat:@"%@  >>",modelBank.name1] forState:UIControlStateNormal];
    }else {
        [self.buttonLeft setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (modelBank.name2.length > 0) {
        [self.buttonRight setTitle:[NSString stringWithFormat:@"%@  >>",modelBank.name2] forState:UIControlStateNormal];
    }else {
        [self.buttonRight setTitle:@"" forState:UIControlStateNormal];
    }
    
}

// 点击银行按钮
- (void)didClickBankButton:(UIButton *)button {
    if (self.blockBankButton) {
        self.blockBankButton(button);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
