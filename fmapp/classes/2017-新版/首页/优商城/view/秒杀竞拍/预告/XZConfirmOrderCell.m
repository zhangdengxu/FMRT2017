//
//  XZConfirmOrderCell.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/23.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZConfirmOrderCell.h"
#import "FMShoppingListModel.h"
#import "FMPriceModel.h"
#import "FMShopSpecModel.h"

@implementation XZConfirmOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置SalesOrderCell子视图
        [self setUpConfirmOrderCell];
    }
    return self;
}
- (void)setUpConfirmOrderCell {
    /** 商品图片 */
    self.imgPhoto = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgPhoto];
    [self.imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.and.height.equalTo(@(KProjectScreenWidth * 0.26));
    }];
    /** 产品介绍 */
    self.introduceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgPhoto.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.imgPhoto.mas_top);
    }];
    self.introduceLabel.numberOfLines = 2;
        self.introduceLabel.font = [UIFont systemFontOfSize:15];
    
    /** 颜色 */
    self.colorLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.colorLabel];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduceLabel.mas_left);
        make.top.equalTo(self.introduceLabel.mas_bottom).offset(KProjectScreenWidth * 0.026);
    }];
    self.colorLabel.font = [UIFont systemFontOfSize:15];
    self.colorLabel.textColor = [UIColor lightGrayColor];
    /** 价格 */
    self.priceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorLabel.mas_left);
        make.bottom.equalTo(self.imgPhoto.mas_bottom);
//        make.width.equalTo(@(KProjectScreenWidth * 0.2));
    }];
    self.priceLabel.textColor = [UIColor lightGrayColor];
    self.priceLabel.font = [UIFont systemFontOfSize:15];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    /** 数量 */
    self.quantityLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.quantityLabel];
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.quantityLabel.textColor = [UIColor lightGrayColor];
    self.quantityLabel.font = [UIFont systemFontOfSize:15];
    self.quantityLabel.textAlignment = NSTextAlignmentRight;
}
/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"confirmOrderCell";
    XZConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}
- (void)setModel:(FMShoppingListModel *)model {
    _model = model;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (model.currentStyle == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",model.currentStyle];
    }
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.quantityLabel.text = [NSString stringWithFormat:@"%zi",model.selectCount];
}
- (void)setPriceModel:(FMPriceModel *)priceModel {
    _priceModel = priceModel;
    // 让金额数字变红
    NSMutableAttributedString *(^makeMoneyRed)(NSString *) = ^(NSString *m) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
        return  attrStr;
    };
    
    self.priceLabel.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[priceModel.price floatValue]]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModelShopInfo:(FMSelectShopInfoModel *)modelShopInfo {
    _modelShopInfo = modelShopInfo;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:modelShopInfo.image] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (modelShopInfo.currentStyle == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.currentStyle];
    }
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.title];
    self.quantityLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.store];
    // 让金额数字变红
    NSMutableAttributedString *(^makeMoneyRed)(NSString *) = ^(NSString *m) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:m];
        NSInteger length = [m length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
        return  attrStr;
    };
    self.priceLabel.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[modelShopInfo.price floatValue]]);
}
@end
