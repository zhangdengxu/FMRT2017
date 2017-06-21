//
//  XZChangeBankCell.m
//  fmapp
//
//  Created by admin on 2017/5/31.
//  Copyright © 2017年 yk. All rights reserved.
//  更换银行卡

#import "XZChangeBankCell.h"
#import "XZMyBankModel.h"

@interface XZChangeBankCell ()
// 银行卡名
@property (nonatomic, strong) UILabel *labelBank;
// 银行卡号
@property (nonatomic, strong) UILabel *labelBankNumber;
// 银行图标
@property (nonatomic, strong) UIImageView *imgBank;
@end

@implementation XZChangeBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChangeBankCell];
    }
    return self;
}

- (void)setUpChangeBankCell {
    self.contentView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    UIView *viewBackground = [[UIView alloc] init];
    [self.contentView addSubview:viewBackground];
    [viewBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(20);
        make.height.equalTo(120);
    }];
    viewBackground.backgroundColor = [UIColor whiteColor];
    viewBackground.layer.masksToBounds = YES;
    viewBackground.layer.cornerRadius = 5.0f;
    
    //
    UILabel *labelBank = [[UILabel alloc] init];
    [viewBackground addSubview:labelBank];
    [labelBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBackground).offset(10);
        make.top.equalTo(viewBackground).offset(15);
    }];
    labelBank.font = [UIFont systemFontOfSize:15.0f];
    self.labelBank = labelBank;
    
    //
    UIImageView *imgBank = [[UIImageView alloc] init];
    [viewBackground addSubview:imgBank];
    [imgBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelBank);
        make.top.equalTo(labelBank.mas_bottom).offset(20);
        make.width.height.equalTo(@45);
    }];
    self.imgBank = imgBank;
    imgBank.layer.masksToBounds = YES;
    imgBank.layer.cornerRadius = 22.5f;
    
    //
    UILabel *labelBankNumber = [[UILabel alloc] init];
    [viewBackground addSubview:labelBankNumber];
    [labelBankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgBank.mas_right).offset(10);
        make.centerY.equalTo(imgBank);
    }];
    labelBankNumber.font = [UIFont systemFontOfSize:15.0f];
    self.labelBankNumber = labelBankNumber;
    
    //
    UILabel *labelCash = [[UILabel alloc] init];
    [viewBackground addSubview:labelCash];
    [labelCash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewBackground).offset(-10);
        make.centerY.equalTo(labelBank);
    }];
    labelCash.text = @"默认取现卡";
    labelCash.font = [UIFont systemFontOfSize:15.0f];
    labelCash.textColor = [HXColor colorWithHexString:@"#666666"];
   
}

- (void)setModelMyBank:(XZMyBankModel *)modelMyBank {
    _modelMyBank = modelMyBank;
    // @"622************4577"
    self.labelBankNumber.text = [NSString retNSStringWithSecret:modelMyBank.No withBegin:3 withEnding:4 WithStarCount:0];
    // @"中国工商银行" ;
    self.labelBank.text = modelMyBank.BankName;
    // image =
    [self.imgBank sd_setImageWithURL:[NSURL URLWithString:modelMyBank.BankLogo] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-100x100"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
