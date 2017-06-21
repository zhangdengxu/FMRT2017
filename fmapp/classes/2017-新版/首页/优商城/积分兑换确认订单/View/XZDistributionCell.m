//
//  XZDistributionCell.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/26.
//  Copyright © 2016年 yuyang. All rights reserved.
//  配送方式

#import "XZDistributionCell.h"
#import "XZConfirmOrderModel.h"

@interface XZDistributionCell ()
@property (nonatomic, strong) UILabel *labelDistribution;
@property (nonatomic, strong) UILabel *labelMoney;
@property (nonatomic, strong) UIButton *btnDistribution;
@end

@implementation XZDistributionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置DistributionCell子视图
        [self setUpDistributionCell];
    }
    return self;
}
// 设置DistributionCell子视图
- (void)setUpDistributionCell {
    // 左侧快递名称
    self.labelDistribution = [[UILabel alloc]init];
    [self.contentView addSubview:self.labelDistribution];
    [self.labelDistribution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    // 左侧快递钱数
    self.labelMoney = [[UILabel alloc]init];
    [self.contentView addSubview:self.labelMoney];
    [self.labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelDistribution.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    // 右侧选择框
    self.btnDistribution = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.btnDistribution];
    [self.btnDistribution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.and.width.equalTo(@25);
    }];
    [self.btnDistribution setBackgroundImage:[UIImage imageNamed:@"确认订单（抵用按钮未勾选）_18"] forState:UIControlStateNormal];
    [self.btnDistribution setBackgroundImage:[UIImage imageNamed:@"确认订单（抵用按钮勾选）_18"] forState:UIControlStateSelected];
    
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [cover addTarget:self action:@selector(distributionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)distributionBtnAction:(UIButton *)button {
    if (self.blockDistributionBtn) {
        self.blockDistributionBtn(button);
    }
}

// 给cell赋值
- (void)setModelConfirm:(XZConfirmOrderModel *)modelConfirm {
    _modelConfirm = modelConfirm;
    self.labelDistribution.text = [NSString stringWithFormat:@"%@",modelConfirm.dt_name];
    self.labelMoney.text = [NSString stringWithFormat:@"￥%@",modelConfirm.money];
    self.btnDistribution.selected = modelConfirm.isSelectedCell;
}

/** 创建cell */
+ (instancetype )cellDistributionWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"distribution";
    XZDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

@end
