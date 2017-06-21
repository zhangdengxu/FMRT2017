//
//  XZRedEnvelopeCell.m
//  fmapp
//
//  Created by admin on 17/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//  使用红包券

#import "XZRedEnvelopeCell.h"
#import "XZRedEnvelopeModel.h" // model
#import "Fm_Tools.h"

@interface XZRedEnvelopeCell ()
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
@property (nonatomic, strong) UIImageView *imgHeader;
// 购物使用
@property (nonatomic, strong) UILabel *labelUse;
// 选中当前行的图片
@property (nonatomic, strong) UIImageView *imgSelected;

@end

@implementation XZRedEnvelopeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpRedEnvelopeCell];
    }
    return self;
}

- (void)setUpRedEnvelopeCell {
    self.contentView.backgroundColor = XZBackGroundColor;
//     项目详情_红包券（上半部分）_1702 项目详情_红包券（上半灰色部分）_1702
//     项目详情_红包券（下半部分）_1702 新版_已使用或已过期券_05
    
    // 红色头部
    UIImageView *imgHeader = [[UIImageView alloc] init];
    [self.contentView addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@((KProjectScreenWidth - 20) * 76 / 600.0));
    }];
    self.imgHeader = imgHeader;
    
    // 投资使用
    UILabel *labelUse = [[UILabel alloc] init];
    [imgHeader addSubview:labelUse];
    [labelUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgHeader).offset(-10);
        make.centerY.equalTo(imgHeader);
    }];
    labelUse.textColor = [UIColor whiteColor];
    labelUse.font = [UIFont systemFontOfSize:13.0f];
    self.labelUse = labelUse;
    labelUse.textAlignment = NSTextAlignmentRight;
    
    // 满30000减300元
    UILabel *labelFullReduction = [[UILabel alloc] init];
    [imgHeader addSubview:labelFullReduction];
    [labelFullReduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgHeader).offset(10);
        make.right.equalTo(labelUse.mas_left);
        make.centerY.equalTo(imgHeader);
    }];
    self.labelFullReduction = labelFullReduction;
    self.labelFullReduction.textColor = [UIColor whiteColor];
    self.labelFullReduction.font = [UIFont systemFontOfSize:20.0f];

    // 白色底部
    UIImageView *imgWhite = [[UIImageView alloc] init];
    [self.contentView addSubview:imgWhite];
    [imgWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgHeader);
        make.right.equalTo(imgHeader);
        make.top.equalTo(imgHeader.mas_bottom);
        make.height.equalTo((KProjectScreenWidth - 20) * 164 / 600.0);
    }];
    self.imgWhite = imgWhite;
    
    // 评价奖励
    UILabel *labelReward = [[UILabel alloc] init];
    [imgWhite addSubview:labelReward];
    [labelReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgWhite).offset(10);
        make.left.equalTo(imgWhite).offset(10);
        make.right.equalTo(labelUse.mas_left).offset(-20);
    }];
    self.labelReward = labelReward;
    labelReward.numberOfLines = 0;
    labelReward.font = [UIFont systemFontOfSize:15.0f];
    
    // 选中当前行
    UIImageView *imgSelected = [[UIImageView alloc] init];
    [imgWhite addSubview:imgSelected];
    [imgSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelUse);
        make.top.equalTo(labelReward);
        make.size.equalTo(@(32 * 0.5));
    }];
    self.imgSelected = imgSelected;
    
    // 钱数
    UILabel *labelMoney = [[UILabel alloc] init];
    [imgWhite addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgWhite).offset(-10);
        make.bottom.equalTo(imgWhite).offset(-10);
    }];
    self.labelMoney = labelMoney;
    labelMoney.font = [UIFont systemFontOfSize:24.0f];
    
    // 有效期
    UILabel *labelLine = [[UILabel alloc] init];
    [imgWhite addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgWhite).offset(10);
        make.bottom.equalTo(labelMoney);
        make.right.lessThanOrEqualTo(labelMoney.mas_left);
    }];
    self.labelLine = labelLine;
    labelLine.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setModelRedEnvelope:(XZRedEnvelopeModel *)modelRedEnvelope {
    _modelRedEnvelope = modelRedEnvelope;
    
    NSMutableAttributedString *(^makeMoneyBig)(NSString *,NSString *) = ^(NSString *redStr,NSString *unit) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
        NSInteger length = [redStr length];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:NSMakeRange(0, length)];
        NSMutableAttributedString *attryuan = [[NSMutableAttributedString alloc] initWithString:unit];
        [attryuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 1)];
        [attrStr appendAttributedString:attryuan];
        return attrStr;
    };
    
    // 满30000减300
    self.labelFullReduction.text = modelRedEnvelope.Title;
    
    // 奖励来源
    self.labelReward.text = modelRedEnvelope.Desc;
    
    // 有效期：发放时间-过期时间
    NSString *AwardTime = [Fm_Tools getTotalTimeWithString:modelRedEnvelope.AwardTime andFormatter:@"yyyy.MM.dd"];
    NSString *PastTime = [Fm_Tools getTotalTimeWithString:modelRedEnvelope.PastTime andFormatter:@"yyyy.MM.dd"];
    self.labelLine.text = [NSString stringWithFormat:@"有效期限：%@-%@",AwardTime,PastTime];
    
    if (modelRedEnvelope.isRedEnvelope) { // 是红包券
        // 钱数
        NSString *amt = [NSString stringWithFormat:@"%@",modelRedEnvelope.Amt];
        if (amt.length != 0) {
            self.labelMoney.attributedText = makeMoneyBig(amt,@"元");
        }
    }else { // 是加息券
        // 加息
        NSString *rate = [NSString stringWithFormat:@"%.1f",[modelRedEnvelope.Rate floatValue] * 100];
        if (rate.length != 0) {
            self.labelMoney.attributedText = makeMoneyBig(rate,@"%");
        }
    }
    
    if (modelRedEnvelope.isUseful) { // 可用红包券
        self.imgHeader.image = [UIImage imageNamed:@"新版_券_03"];
        self.imgWhite.image = [UIImage imageNamed:@"新版_券_04"];
        self.labelReward.textColor = XZColor(51, 51, 51);
        self.labelMoney.textColor = XZColor(250, 85, 89);
        self.labelLine.textColor = XZColor(51, 51, 51);
        self.imgSelected.hidden = NO;
        if (modelRedEnvelope.isSelected) { // 被选中
            self.imgSelected.image = [UIImage imageNamed:@"项目详情_红包选择-勾选_1702"];
        }else { // 未勾选
            self.imgSelected.image = [UIImage imageNamed:@"项目详情_红包选择-未勾选_1702"];
        }
        // 投资使用/已过期
        self.labelUse.text = @"投资使用";
    }else { // 不可使用抵价券
        self.imgSelected.hidden = YES;
        NSString *status = [NSString stringWithFormat:@"%@",modelRedEnvelope.Status];
        
        if ([status isEqualToString:@"0"]) { // 未使用，红色
            self.labelUse.text = @"投资使用";
            self.imgHeader.image = [UIImage imageNamed:@"新版_券_03"];
            self.imgWhite.image = [UIImage imageNamed:@"新版_券_04"];
            self.labelReward.textColor = XZColor(51, 51, 51);
            self.labelMoney.textColor = XZColor(250, 85, 89);
            self.labelLine.textColor = XZColor(51, 51, 51);
        }else { // 已使用或已过期，灰色
            if ([status isEqualToString:@"1"]) { // 已使用
                self.labelUse.text = @"已使用";
                self.imgHeader.image = [UIImage imageNamed:@"新版_已使用或已过期券_06"];
                self.imgWhite.image = [UIImage imageNamed:@"新版_已使用或已过期券_05"];
                self.labelReward.textColor = [UIColor lightGrayColor];
                self.labelMoney.textColor = [UIColor lightGrayColor];
                self.labelLine.textColor = [UIColor lightGrayColor];
            }else if ([status isEqualToString:@"2"]) { // 已过期
                self.labelUse.text = @"已过期";
                self.imgHeader.image = [UIImage imageNamed:@"新版_已使用或已过期券_06"];
                self.imgWhite.image = [UIImage imageNamed:@"新版_已使用或已过期券_05"];
                self.labelReward.textColor = [UIColor lightGrayColor];
                self.labelMoney.textColor = [UIColor lightGrayColor];
                self.labelLine.textColor = [UIColor lightGrayColor];
            }else { // 未使用
                self.labelUse.text = @"投资使用";
                self.imgHeader.image = [UIImage imageNamed:@"新版_券_03"];
                self.imgWhite.image = [UIImage imageNamed:@"新版_券_04"];
                self.labelReward.textColor = XZColor(51, 51, 51);
                self.labelMoney.textColor = XZColor(250, 85, 89);
                self.labelLine.textColor = XZColor(51, 51, 51);
            }
        }
    }
    
    CGFloat height = modelRedEnvelope.contentH;
    [self.imgWhite mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
