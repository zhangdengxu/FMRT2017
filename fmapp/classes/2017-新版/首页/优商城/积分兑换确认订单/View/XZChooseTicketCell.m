//
//  XZChooseTicketCell.m
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//  选择抵价券

#import "XZChooseTicketCell.h"
#import "XZChooseTicketModel.h"

@interface XZChooseTicketCell ()
// 购物满300减10
@property (nonatomic, strong) UILabel *labelFullReduction;
// 评价奖励
@property (nonatomic, strong) UILabel *labelReward;
// 有效期
@property (nonatomic, strong) UILabel *labelLine;
// 钱数
@property (nonatomic, strong) UILabel *labelMoney;
// 白色底部
@property (nonatomic, strong) UIImageView *imgWhite;
// 红色图片
@property (nonatomic, strong) UIImageView *imgRed;
// 购物使用
@property (nonatomic, strong) UILabel *labelUse;
@end

@implementation XZChooseTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChooseTicketCell];
    }
    return self;
}

- (void)setupChooseTicketCell {
    self.contentView.backgroundColor = XZBackGroundColor;
    // 红色图片
    UIImageView *imgRed = [[UIImageView alloc] init];
    [self.contentView addSubview:imgRed];
    [imgRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo((KProjectScreenWidth - 20) * 76 / 600.0);
    }];
    self.imgRed = imgRed;
    
    // 购物使用
    UILabel *labelUse = [[UILabel alloc] init];
    [imgRed addSubview:labelUse];
    [labelUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgRed).offset(-10);
        make.centerY.equalTo(imgRed);
    }];
    labelUse.textColor = [UIColor whiteColor];
//    labelUse.text = @"购物使用"; 
    labelUse.textAlignment = NSTextAlignmentRight;
    labelUse.font = [UIFont systemFontOfSize:13.0f];
    self.labelUse = labelUse;
    
    // 购物满300减10
    UILabel *labelFullReduction = [[UILabel alloc] init];
    [imgRed addSubview:labelFullReduction];
    [labelFullReduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgRed).offset(10);
        make.right.equalTo(labelUse.mas_left);
        make.centerY.equalTo(imgRed);
    }];
    self.labelFullReduction = labelFullReduction;
    labelFullReduction.textColor = [UIColor whiteColor];
    labelFullReduction.font = [UIFont systemFontOfSize:20.0f];
    
    // 白色底部
    UIImageView *imgWhite = [[UIImageView alloc] init];
    [self.contentView addSubview:imgWhite];
    [imgWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgRed);
        make.right.equalTo(imgRed);
        make.top.equalTo(imgRed.mas_bottom);
        make.height.equalTo((KProjectScreenWidth - 20) * 164 / 600.0);
    }];
    self.imgWhite = imgWhite;
    
    // 评价奖励
    UILabel *labelReward = [[UILabel alloc] init];
    [imgWhite addSubview:labelReward];
    [labelReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgWhite).offset(10);
        make.left.equalTo(imgWhite).offset(10);
        make.right.equalTo(imgWhite).offset(-10);
    }];
    self.labelReward = labelReward;
    labelReward.numberOfLines = 0;
    labelReward.font = [UIFont systemFontOfSize:15.0f];
    
    // 有效期
    UILabel *labelLine = [[UILabel alloc] init];
    [imgWhite addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgWhite).offset(10);
        make.bottom.equalTo(imgWhite).offset(-10);
    }];
    self.labelLine = labelLine;
    labelLine.font = [UIFont systemFontOfSize:14.0f];
    
    // 钱数
    UILabel *labelMoney = [[UILabel alloc] init];
    [imgWhite addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgWhite).offset(-10);
        make.centerY.equalTo(labelLine);
    }];
    self.labelMoney = labelMoney;
}

- (void)setModelChooseTicket:(XZChooseTicketModel *)modelChooseTicket {
    _modelChooseTicket = modelChooseTicket;
    
    NSMutableAttributedString *(^makeMoneyBig)(NSString *) = ^(NSString *redStr) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
        NSInteger length = [redStr length];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, length)];
        NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:@"元"];
        [attryuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 1)];
        [attrStr appendAttributedString:attryuan];
        return attrStr;
    };
    
    // 购物满300减10
    self.labelFullReduction.text = modelChooseTicket.cpns_name;
    // 评价奖励
    self.labelReward.text = modelChooseTicket.cpns_desc;
    // 有效期
    self.labelLine.text = [NSString stringWithFormat:@"有效期限：%@",modelChooseTicket.endtime];
    // 使用用途
    self.labelUse.text = [NSString stringWithFormat:@"%@",modelChooseTicket.statusText];
    // 钱数
    self.labelMoney.attributedText = makeMoneyBig(modelChooseTicket.jiner);
    
    // 是已过期或已使用
    if (modelChooseTicket.isExpiredOrUnused) {
        self.imgRed.image = [UIImage imageNamed:@"新版_已使用或已过期券_06"];
        self.imgWhite.image = [UIImage imageNamed:@"新版_已使用或已过期券_05"];
        self.labelReward.textColor = [UIColor lightGrayColor];
        self.labelMoney.textColor = [UIColor lightGrayColor];
        self.labelLine.textColor = [UIColor lightGrayColor];
    }else { // 可使用抵价券列表
        self.imgRed.image = [UIImage imageNamed:@"新版_券_03"];
        self.imgWhite.image = [UIImage imageNamed:@"新版_券_04"];
        self.labelReward.textColor = XZColor(51, 51, 51);
        self.labelMoney.textColor = XZColor(250, 85, 89);
        self.labelLine.textColor = XZColor(51, 51, 51);
    }
    
    
    CGFloat height = modelChooseTicket.contentH + 45;
    [self.imgWhite mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
