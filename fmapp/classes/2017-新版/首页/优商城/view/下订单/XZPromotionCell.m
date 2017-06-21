//
//  XZPromotionCell.m
//  fmapp
//
//  Created by admin on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//  优惠促销

#import "XZPromotionCell.h"
#import "FMShopOtherModel.h"

@interface XZPromotionCell()

@property (nonatomic, strong) UILabel *labelPromotionStyle;
@property (nonatomic, strong)  UILabel *labelPromotion;

@end

@implementation XZPromotionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置PromotionCell子视图
        [self setUpPromotionCell];
    }
    return self;
}
// 设置PromotionCell子视图
- (void)setUpPromotionCell {
    // 优惠的方式
    UILabel *labelPromotionStyle = [[UILabel alloc]init];
    self.labelPromotionStyle = labelPromotionStyle;
    [self.contentView addSubview:labelPromotionStyle];
    
    [labelPromotionStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    labelPromotionStyle.textColor = XZColor(252, 105, 47);
    
    labelPromotionStyle.layoutMargins = UIEdgeInsetsMake(-10, -8, -10, -8);
    labelPromotionStyle.font = [UIFont systemFontOfSize:13];
    labelPromotionStyle.layer.borderColor = [XZColor(252, 105, 47) CGColor];
    labelPromotionStyle.layer.borderWidth = 1.0f;
    labelPromotionStyle.layer.cornerRadius = 2.0;
    labelPromotionStyle.text = @"";
    // 优惠
    UILabel *labelPromotion = [[UILabel alloc]init];
    self.labelPromotion = labelPromotion;
    [self.contentView addSubview:labelPromotion];
    [labelPromotion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPromotionStyle.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    labelPromotion.text = @"";
}
-(void)setActivityModel:(FMShopOtherModel *)activityModel
{
    _activityModel = activityModel;
    self.labelPromotionStyle.text = [NSString stringWithFormat:@" %@ ",activityModel.imageTitle];
    self.labelPromotion.text =  activityModel.contentString;
    
}
/** 创建cell */
+ (instancetype )cellPromotionWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"promotion";
    XZPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
    
}
@end
