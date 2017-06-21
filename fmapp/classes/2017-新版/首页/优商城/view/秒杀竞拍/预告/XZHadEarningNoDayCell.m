//
//  XZHadEarningNoDayCell.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZHadEarningNoDayCell.h"
#import "XZEarningInnerModel.h"

@interface XZHadEarningNoDayCell ()
//// 日期:日
//@property (nonatomic, strong) UILabel *labelDay;
//// 日期:月日
//@property (nonatomic, strong) UILabel *labelTime;
//// 总钱数
//@property (nonatomic, strong) UILabel *labelTotalMoney;
// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 钱数
@property (nonatomic, strong) UILabel *labelMoney;
@end


@implementation XZHadEarningNoDayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpHadEarningNoDayCell];
    }
    return self;
}

- (void)setUpHadEarningNoDayCell {
    // 线
    UIImageView *imgLine = [[UIImageView alloc] init];
    [self.contentView addSubview:imgLine];
    [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17.5);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@12);
    }];
    imgLine.image = [UIImage imageNamed:@"恒丰银行存管app--我的（已赚收益）02"];
    

    // 钱数
    UILabel *labelMoney = [[UILabel alloc] init];
    self.labelMoney = labelMoney;
    [self.contentView addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
//    labelMoney.text = @"6.9";
    labelMoney.font = [UIFont systemFontOfSize:15];
    labelMoney.textColor = XZColor(244, 88, 45);
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    self.labelTitle = labelTitle;
    [self.contentView addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelMoney.mas_centerY);
        make.left.equalTo(imgLine.mas_right).offset(20);
        make.right.lessThanOrEqualTo(labelMoney.mas_left).offset(-5);
    }];
    //    labelTitle.text = @"融益盈YY2016101期";
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
//    CGFloat money = [modelInner.money floatValue];
    if ([modelInner.controllerName isEqualToString: @"累计已收佣金"] || [modelInner.controllerName isEqualToString: @"本月累计佣金"])  {
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.lyyongjinshu];
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.miaoshu];
    }else if ([modelInner.controllerName isEqualToString: @"好友贡献佣金"]){
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.lyyongjinshu];
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.xingming];
    }else {
        self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInner.jie_title];
        self.labelMoney.text = [NSString stringWithFormat:@"%@",modelInner.money];
    }
}

@end
