//
//  XZOptimalMallSubmitOrderCell.m
//  fmapp
//
//  Created by admin on 16/12/12.
//  Copyright © 2016年 yk. All rights reserved.
//  优商城确认订单

#import "XZOptimalMallSubmitOrderCell.h"
#import "XZConfirmOrderModel.h"
#import "FMShoppingListModel.h"
//
@interface XZOptimalMallSubmitOrderCell ()
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色尺码 */
@property (nonatomic, strong) UILabel *colorLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *quantityLabel;
@end

@implementation XZOptimalMallSubmitOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupOptimalMallSubmitOrderCell];
    }
    return self;
}

- (void)setupOptimalMallSubmitOrderCell {
    /** 商品图片 */
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.and.height.equalTo(@(KProjectScreenWidth * 0.26));
    }];
    self.imgPhoto = imgPhoto;
//    imgPhoto.backgroundColor = [UIColor redColor];
    
    /** 产品介绍 */
    UILabel *introduceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(imgPhoto).offset(5);
    }];
    introduceLabel.numberOfLines = 2;
    introduceLabel.font = [UIFont systemFontOfSize:15];
    self.introduceLabel = introduceLabel;
    
    /** 颜色 */
    UILabel *colorLabel = [[UILabel alloc] init];
    [self.contentView addSubview:colorLabel];
    [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introduceLabel);
        make.centerY.equalTo(imgPhoto).offset(10);
    }];
    colorLabel.font = [UIFont systemFontOfSize:15];
    colorLabel.textColor = [UIColor grayColor];
    self.colorLabel = colorLabel;
    
    /** 价格 */
    UILabel *priceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorLabel);
        make.bottom.equalTo(imgPhoto).offset(-5);
    }];
    priceLabel.textColor = XZColor(255, 102, 51);
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel = priceLabel;
    
    /** 数量 */
    UILabel *quantityLabel = [[UILabel alloc] init];
    [self.contentView addSubview:quantityLabel];
    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    quantityLabel.font = [UIFont systemFontOfSize:15];
    quantityLabel.textAlignment = NSTextAlignmentRight;
    self.quantityLabel = quantityLabel;

}

// 从商品详情跳入
- (void)setConfirmModel:(XZConfirmOrderModel *)confirmModel {
    _confirmModel = confirmModel;
//    NSLog(@"商品数量：%@--商品价格：--%@",confirmModel.totalCount,confirmModel.shopListModel.price.price);
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:confirmModel.shopListModel.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (confirmModel.shopListModel.currentStyle == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",confirmModel.shopListModel.currentStyle];
    }
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",confirmModel.shopListModel.name];
    self.quantityLabel.text = [NSString stringWithFormat:@"x %@",confirmModel.totalCount];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[confirmModel.shopListModel.price.price floatValue]];
}

// 从购物车跳入
- (void)setShopListModel:(FMShoppingListModel *)shopListModel {
    _shopListModel = shopListModel;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:shopListModel.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (shopListModel.currentStyle == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",shopListModel.currentStyle];
    }
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",shopListModel.name];
    self.quantityLabel.text = [NSString stringWithFormat:@"x %zi",shopListModel.selectCount];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[shopListModel.price.price floatValue]];
}

/** 创建cell */
+ (instancetype )CellMallSubmitOrderWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"OptimalMallSubmitOrderCell";
    XZOptimalMallSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
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
