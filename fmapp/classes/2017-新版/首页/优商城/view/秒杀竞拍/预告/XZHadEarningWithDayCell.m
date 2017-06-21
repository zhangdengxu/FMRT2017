//
//  XZHadEarningWithDayCell.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZHadEarningWithDayCell.h"
#import "XZEarningModel.h"
#import "XZEarningInnerModel.h"

@interface XZHadEarningWithDayCell ()
// 日期:日
@property (nonatomic, strong) UILabel *labelDay;
// 日期:月日
@property (nonatomic, strong) UILabel *labelTime;
// 总钱数
@property (nonatomic, strong) UILabel *labelTotalMoney;
// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 钱数
@property (nonatomic, strong) UILabel *labelMoney;
@end

@implementation XZHadEarningWithDayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpHadEarningWithDayCell];
    }
    return self;
}

- (void)setUpHadEarningWithDayCell {
    // 日期图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top);
        make.width.equalTo(@(34 * 0.8));
        make.height.equalTo(@(41 * 0.8));
    }];
    imgIcon.image = [UIImage imageNamed:@"恒丰银行存管app--我的（已赚收益）01"];
    
    // 日期:日
    UILabel *labelDay = [[UILabel alloc] init];
    [self.contentView addSubview:labelDay];
    [labelDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgIcon.mas_centerX);
        make.centerY.equalTo(imgIcon.mas_centerY);
    }];
    self.labelDay = labelDay;
    labelDay.textColor = [UIColor whiteColor];
    labelDay.font = [UIFont systemFontOfSize:13];
    
    // 日期:月日
    UILabel *labelTime = [[UILabel alloc] init];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelDay.mas_centerX);
        make.top.equalTo(labelDay.mas_bottom).offset(5);
    }];
    self.labelTime = labelTime;
    labelTime.textColor = [UIColor lightGrayColor];
    labelTime.font = [UIFont systemFontOfSize:13];
    
    // 线
    UIImageView *imgLine = [[UIImageView alloc] init];
    [self.contentView addSubview:imgLine];
    [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgIcon.mas_centerX);
        make.top.equalTo(labelTime.mas_bottom);
        make.width.equalTo(@12);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    imgLine.image = [UIImage imageNamed:@"恒丰银行存管app--我的（已赚收益）02"];
    
    // 总钱数
    UIView *view = [[UIView alloc] init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(labelTime.mas_right).offset(10);
        make.height.equalTo(@25);
    }];
    view.backgroundColor = XZColor(245, 246, 247);
    
    UILabel *labelTotalMoney = [[UILabel alloc] init];
    [view addSubview:labelTotalMoney];
    [labelTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    self.labelTotalMoney = labelTotalMoney;
    labelTotalMoney.font = [UIFont systemFontOfSize:13];
    labelTotalMoney.textColor = XZColor(244, 88, 45);
    
    // 钱数
    UILabel *labelMoney = [[UILabel alloc] init];
    [self.contentView addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.labelMoney = labelMoney;
    labelMoney.font = [UIFont systemFontOfSize:15];
    labelMoney.textColor = XZColor(244, 88, 45);
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelMoney.mas_centerY);
        make.right.lessThanOrEqualTo(labelMoney.mas_left).offset(-5);
        make.left.equalTo(view.mas_left);

    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textColor = [UIColor darkGrayColor];
    
    // 线
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = XZColor(216, 216, 216);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setModelInner:(XZEarningInnerModel *)modelInner {
    _modelInner = modelInner;
    self.labelDay.text = [NSString stringWithFormat:@"%@",modelInner.daynum];
    self.labelTime.text = [NSString stringWithFormat:@"%@",modelInner.day];
    
    NSMutableAttributedString *(^makeTextBlack)(NSString *,NSString *) = ^(NSString *redStr,NSString *frontStr) {
        NSMutableAttributedString *blackStr = [[NSMutableAttributedString alloc] initWithString:frontStr];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
        
        NSInteger length = [blackStr length];
        [blackStr addAttribute:NSForegroundColorAttributeName value:XZColor(51, 51, 51) range:NSMakeRange(0, length)];
        [blackStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, length)];
        [blackStr appendAttributedString:attrStr];
        
        return blackStr;
    };
    
    if ([modelInner.controllerName isEqualToString: @"好友贡献佣金"]) { // 好友贡献佣金
        self.labelTotalMoney.attributedText = makeTextBlack([NSString stringWithFormat:@"%@",modelInner.daytotal],@"应发佣金：");
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.lyyongjinshu];
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.xingming];
    }else if ([modelInner.controllerName isEqualToString: @"累计已收佣金"] || [modelInner.controllerName isEqualToString: @"本月累计佣金"])  { //  本月累计佣金
        self.labelTotalMoney.attributedText = makeTextBlack([NSString stringWithFormat:@"%@",modelInner.daytotal],@"当日合计：");
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.lyyongjinshu];
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.miaoshu];
    }else {
        self.labelTotalMoney.text = [NSString stringWithFormat:@"%@",modelInner.daytotal];
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.money];
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.jie_title];
    }
    
}

@end
