//
//  XZTradeSuccessGoodsCell.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/28.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZTradeSuccessGoodsCell.h"
#import "YSCustomerSerViewController.h"
#import "XZMyOrderGoodsModel.h"
#define kDarkGrayTextColor XZColor(48, 48, 48)
#define kLightGrayTextColor XZColor(143, 143, 143)

@interface XZTradeSuccessGoodsCell ()
/** 价格划线 */
@property (nonatomic, strong) UILabel *priceLineLabel;
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色 */
@property (nonatomic, strong) UILabel *colorLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *quantityLabel;


@property (nonatomic, assign) NSInteger viewFontStandard;

@property (nonatomic, weak) UIButton *btnAfterSales;

@end

@implementation XZTradeSuccessGoodsCell

-(NSInteger)viewFontStandard
{
    if (_viewFontStandard == 0) {
        if (KProjectScreenWidth == 320) {
            _viewFontStandard = 13;
        }else if (KProjectScreenWidth == 375)
        {
            _viewFontStandard = 14;
        }else
        {
            _viewFontStandard = 15;
        }
    }
    return _viewFontStandard;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置TradeSuccessGoodsCell子视图
        [self setUpTradeSuccessGoodsCell];
    }
    return self;
}
// 设置TradeSuccessGoodsCell子视图
- (void)setUpTradeSuccessGoodsCell {
    self.backgroundColor = XZColor(225, 230, 234);
    self.contentView.backgroundColor = XZColor(255, 255, 255);
    /** 商品图片 */
    self.imgPhoto = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgPhoto];
    [self.imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.and.height.equalTo(@(KProjectScreenWidth * 0.2));
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    /** 价格 */
    self.priceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.imgPhoto.mas_top);
        make.width.equalTo(@80);
        make.height.equalTo(@18);
    }];
    self.priceLabel.textColor = kDarkGrayTextColor;
    self.priceLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    /** 价格划线 */
    UILabel *priceLineLabel = [[UILabel alloc]init];
    self.priceLineLabel = priceLineLabel;
    [self.contentView addSubview:priceLineLabel];
    [priceLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(4);
        make.width.equalTo(@80);
    }];
    priceLineLabel.textColor = kDarkGrayTextColor;
    priceLineLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    priceLineLabel.textAlignment = NSTextAlignmentRight;
    /** 产品介绍 */
    self.introduceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgPhoto.mas_right).offset(8);
        make.right.equalTo(self.priceLabel.mas_left).offset(-2);
        make.top.equalTo(self.imgPhoto.mas_top);
    }];
    
    self.introduceLabel.numberOfLines = 0;
    
    self.introduceLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    
    self.introduceLabel.textColor = [UIColor darkGrayColor];
    /** 颜色 */
    self.colorLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.colorLabel];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduceLabel.mas_left);
        make.top.equalTo(self.introduceLabel.mas_bottom).offset(8);
        make.height.equalTo(@18);
    }];
    
    self.colorLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    self.colorLabel.textColor = kLightGrayTextColor;
    /** 数量 */
    self.quantityLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.quantityLabel];
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLineLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@18);
    }];
    self.quantityLabel.textColor = kDarkGrayTextColor;
    self.quantityLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    self.quantityLabel.textAlignment = NSTextAlignmentRight;
    
    
    
    /** 申请售后button */
    CGFloat radio = KProjectScreenWidth / 414;
    UIButton *btnAfterSales = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAfterSales = btnAfterSales;
    
    
    [self.contentView addSubview:btnAfterSales];
    [btnAfterSales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(30 * radio);
        make.width.equalTo(80 * radio);
        make.top.equalTo(self.quantityLabel.mas_bottom).offset(8);
    }];
    
    [btnAfterSales setTitle:@"商品评价" forState:UIControlStateNormal];
    btnAfterSales.titleLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    
    
    btnAfterSales.layer.masksToBounds = YES;
    btnAfterSales.layer.borderWidth = 0.5f;
    btnAfterSales.layer.cornerRadius = 4;
    
    [self.btnAfterSales setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnAfterSales setTintColor:[UIColor whiteColor]];
    self.btnAfterSales.backgroundColor = XZColor(6, 41, 125);
    self.btnAfterSales.layer.borderColor = XZColor(6, 41, 125).CGColor;
    
    
    
    [btnAfterSales addTarget:self action:@selector(didClickAfterSalesBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XZColor(225, 230, 234);
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@0.5);
    }];

}
// 点击申请售后按钮
- (void)didClickAfterSalesBtn:(UIButton *)button {
    if (self.blockAfterSalesBtn) {
        self.blockAfterSalesBtn(button);
        
    }
}
/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView{
    static NSString *reuseID = @"XZTradeSuccessGoodsCell";
    XZTradeSuccessGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setGoodsModel:(XZMyOrderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.introduceLabel.text = goodsModel.name;
    self.colorLabel.text = goodsModel.spec_info;
    CGFloat price = [goodsModel.price floatValue];
    self.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",price];
    self.quantityLabel.text = goodsModel.quantity;
    CGFloat mktprice = [goodsModel.mktprice floatValue];
    if (goodsModel.mktprice != nil) {
        // 给数字划线
        NSString *oldPrice = [NSString stringWithFormat:@"￥%.2f",mktprice];
        NSUInteger length = [oldPrice length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:kLightGrayTextColor range:NSMakeRange(0, length)];
        [self.priceLineLabel setAttributedText:attri];
    }
    
    if (goodsModel.orderStatusFM == 31) {
        self.btnAfterSales.hidden = NO;
    }else
    {
        self.btnAfterSales.hidden = YES;

    }
}
@end
