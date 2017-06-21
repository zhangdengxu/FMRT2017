//
//  XZProjectRepaymentCell.m
//  fmapp
//
//  Created by admin on 17/4/10.
//  Copyright © 2017年 yk. All rights reserved.
//  还款模型

#import "XZProjectRepaymentCell.h"

@interface XZProjectRepaymentCell ()
// 期数
@property (nonatomic, strong) UILabel *labelNumber;
// 本金
@property (nonatomic, strong) UILabel *labelMoney;
// 利息
@property (nonatomic, strong) UILabel *labelRate;
// 时间
@property (nonatomic, strong) UILabel *labelTime;
@end

@implementation XZProjectRepaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpProjectRepaymentCell];
    }
    return self;
}

- (void)setUpProjectRepaymentCell {
    // 线
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)setCurrnetIndex:(NSInteger)currnetIndex {
    _currnetIndex = currnetIndex;
    
    CGFloat totalPart = 4.0f;
    if (currnetIndex == 2) { // 投标记录
        totalPart = 3.0f;
    }
    
    CGFloat width = KProjectScreenWidth / totalPart;
    
    // 期数
    UILabel *labelNumber = [self createLabelLeftView:self.contentView width:width isFirst:YES];
    self.labelNumber = labelNumber;
    
    // 本金
    UILabel *labelMoney = [self createLabelLeftView:labelNumber width:width isFirst:NO];
    self.labelMoney = labelMoney;
    
    // 利息
    UILabel *labelRate = [self createLabelLeftView:labelMoney width:width isFirst:NO];
    self.labelRate = labelRate;
    
    if (currnetIndex == 1) { // 还款模型
        // 时间
        UILabel *labelTime = [self createLabelLeftView:labelRate width:width isFirst:NO];
        self.labelTime = labelTime;
    }
    
    [self setModel];
}

- (UILabel *)createLabelLeftView:(UIView *)leftView  width:(CGFloat)width isFirst:(BOOL)isFirst {
    UILabel *labelMoney = [[UILabel alloc] init];
    [self.contentView addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isFirst) { // 第一列
            make.left.equalTo(leftView);
        }else {
            make.left.equalTo(leftView.mas_right);
        }
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(width);
    }];
    labelMoney.textAlignment = NSTextAlignmentCenter;
    labelMoney.backgroundColor = XZRandomColor;
    labelMoney.font = [UIFont systemFontOfSize:13.0f];
    return labelMoney;
}

- (void)setModel {
    // 期数
    self.labelNumber.text = @"1";
    // 本金
    self.labelMoney.text = @"1000000.00";
    // 利息
    self.labelRate.text = @"9863.01";
    if (self.currnetIndex == 1) { // 还款模型
        // 时间
        self.labelTime.text = @"2017-05-10";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//    for (int i = 0; i < totalPart; i++) {
//        UILabel *labelNumber = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, 40)];
//        [self.contentView addSubview:labelNumber];
//        self.labelNumber = labelNumber;
//        labelNumber.backgroundColor = [UIColor redColor];
//        labelNumber.textAlignment = NSTextAlignmentCenter;
//        labelNumber.font = [UIFont systemFontOfSize:13.0f];
//    }

@end
