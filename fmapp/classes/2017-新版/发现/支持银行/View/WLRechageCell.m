//
//  WLRechageCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLRechageCell.h"
#import "WLRechageBankModel.h"
@interface WLRechageCell ()
// 银行logo
@property (nonatomic, strong) UIImageView *imgPhoto;
// 银行名称
@property (nonatomic, strong) UILabel *labelTitle;
// 每天最多
@property (nonatomic, strong) UILabel *labelMaxDay;
// 每笔最多
@property (nonatomic, strong) UILabel *labelEveryTime;

@end

@implementation WLRechageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpRechargeCell];
    }
    return self;
}

- (void)setUpRechargeCell {
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(@30);
    }];
    self.imgPhoto = imgPhoto;
    
    // 银行名称
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_right).offset(10);
        make.centerY.equalTo(imgPhoto);
    }];
    labelTitle.font = [UIFont systemFontOfSize:15.0f];
    labelTitle.textColor = XZColor(53, 53, 53);
    self.labelTitle = labelTitle;
    
    // 每天最多
    UILabel *labelMaxDay = [[UILabel alloc] init];
    [self.contentView addSubview:labelMaxDay];
    [labelMaxDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(imgPhoto);
        make.width.equalTo(@70);
    }];
    labelMaxDay.textColor = XZColor(153, 153, 153);
    labelMaxDay.font = [UIFont systemFontOfSize:14.0f];
    labelMaxDay.textAlignment = NSTextAlignmentRight;
    self.labelMaxDay = labelMaxDay;
    
    // 每笔最多
    UILabel *labelEveryTime = [[UILabel alloc] init];
    [self.contentView addSubview:labelEveryTime];
    [labelEveryTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelMaxDay.mas_left).offset(-15);
        make.centerY.equalTo(imgPhoto);
    }];
    labelEveryTime.textColor = XZColor(153, 153, 153);
    labelEveryTime.font = [UIFont systemFontOfSize:14.0f];
    self.labelEveryTime = labelEveryTime;
}

- (void)setModelBank:(WLRechageBankModel *)modelBank {
    _modelBank = modelBank;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:modelBank.logo] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-100x100"]];
    self.labelTitle.text = [NSString stringWithFormat:@"%@",modelBank.BankName];
    // @"5万/日"
    self.labelMaxDay.text = [NSString stringWithFormat:@"%@/日",modelBank.CashAmtDay];
    // @"5万/笔"
    self.labelEveryTime.text = [NSString stringWithFormat:@"%@/笔",modelBank.CashAmt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
