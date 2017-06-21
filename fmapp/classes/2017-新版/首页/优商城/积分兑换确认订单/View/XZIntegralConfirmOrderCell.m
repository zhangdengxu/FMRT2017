//
//  XZIntegralConfirmOrderCell.m
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZIntegralConfirmOrderCell.h"
#import "XZConfirmOrderModel.h" // model
#import "FMShoppingListModel.h"

@interface XZIntegralConfirmOrderCell ()
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

@implementation XZIntegralConfirmOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置SalesOrderCell子视图
        [self setUpConfirmOrderCell];
    }
    return self;
}
- (void)setUpConfirmOrderCell {
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

- (void)setConfirmModelCoins:(XZConfirmOrderModel *)confirmModelCoins {
    _confirmModelCoins = confirmModelCoins;
//    NSLog(@"图片地址:%@===================",confirmModelCoins.shopListModel.image);
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:confirmModelCoins.shopListModel.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:confirmModelCoins.shopListModel.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (confirmModelCoins.shopListModel.currentStyle == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",confirmModelCoins.shopListModel.currentStyle];
    }
    if (confirmModelCoins.isCoinPay) {
        self.introduceLabel.text = [NSString stringWithFormat:@"%@",confirmModelCoins.shopListModel.name];
        self.quantityLabel.text = [NSString stringWithFormat:@"x %ld",(long)confirmModelCoins.shopListModel.selectCount];
        self.priceLabel.text = [NSString stringWithFormat:@"%ld积分",(long)[confirmModelCoins.shopListModel.fulljifen_ex integerValue]];
    }else {
        self.introduceLabel.text = [NSString stringWithFormat:@"%@",confirmModelCoins.shopListModel.name];
        self.quantityLabel.text = [NSString stringWithFormat:@"x %zi",confirmModelCoins.shopListModel.selectCount];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[confirmModelCoins.shopListModel.price.price floatValue]];
    }
}

/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"confirmOrderCell";
    XZIntegralConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
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
