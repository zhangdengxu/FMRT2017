//
//  XZConfirmPaymentCell.m
//  fmapp
//
//  Created by admin on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZConfirmPaymentCell.h"
#import "FMShoppingListModel.h"
//#import "FMPriceModel.h"
//#import "FMShopSpecModel.h"
#import "FMDuobaoClass.h" // model

@interface XZConfirmPaymentCell ()
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色尺码 */
@property (nonatomic, strong) UILabel *colorLabel;
/** 5币得、1币得、老友价 */
@property (nonatomic, strong) UIImageView *imgGetWay;
@end

@implementation XZConfirmPaymentCell
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
        make.top.equalTo(self.contentView).offset(10);
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
    
    /** 5币得、1币得、老友价 */
    self.imgGetWay = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imgGetWay];
    [self.imgGetWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduceLabel.mas_left);
        make.top.equalTo(self.introduceLabel.mas_bottom).offset(KProjectScreenWidth * 0.026);
    }];
    
    
    /** 颜色 */
    self.colorLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.colorLabel];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduceLabel.mas_left);
        make.top.equalTo(self.imgGetWay.mas_bottom).offset(KProjectScreenWidth * 0.026);
    }];
    self.colorLabel.font = [UIFont systemFontOfSize:15];
    self.colorLabel.textColor = [UIColor lightGrayColor];
    
//    [self setModel];
}

//- (void)setModel {
//    /** 商品图片 */
//    self.imgPhoto.image = [UIImage imageNamed:@"竞拍商品_07"];
//    /** 5币得、1币得、老友价 */
//    self.imgGetWay.image = [UIImage imageNamed:@"全新5币得"];
//    /** 产品介绍 */
//    self.introduceLabel.text = @"Apple 苹果iPad Pro 平板电脑 超长续航";
//    /** 颜色尺码 */
//    self.colorLabel.text = @"颜色分类：蓝色 尺码：M";
//}

- (void)setDuobaoClass:(FMDuobaoClassSelectStyle *)duobaoClass {
    _duobaoClass = duobaoClass;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:duobaoClass.goods_img] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
    // 如果没有颜色、尺码属性，给一个空字符串
    if (duobaoClass.selectString == nil) {
        self.colorLabel.text = @" ";
    }else {
        self.colorLabel.text = [NSString stringWithFormat:@"%@",duobaoClass.selectString];
    }
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",duobaoClass.goods_name];
    if ([duobaoClass.selectModel.type integerValue] == 2) { // 老友价
        self.imgGetWay.image = [UIImage imageNamed:@"全新老友价"];
    }else { //  5币得、1币得
        if ([duobaoClass.selectModel.unit_cost integerValue] == 1) {
            // 1币得
            self.imgGetWay.image = [UIImage imageNamed:@"全新1币得"];
        }else { // == 5是5币得
            self.imgGetWay.image = [UIImage imageNamed:@"全新5币得"];
        }
    }
}

//- (void)setModel:(FMShoppingListModel *)model {
//    _model = model;
//    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
//    // 如果没有颜色、尺码属性，给一个空字符串
//    if (model.currentStyle == nil) {
//        self.colorLabel.text = @" ";
//    }else {
//        self.colorLabel.text = [NSString stringWithFormat:@"%@",model.currentStyle];
//    }
//    self.introduceLabel.text = [NSString stringWithFormat:@"%@",model.name];
//}

//- (void)setPriceModel:(FMPriceModel *)priceModel {
//    _priceModel = priceModel;
//    // 让金额数字变红
//    NSMutableAttributedString *(^makeMoneyRed)(NSString *) = ^(NSString *m) {
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:m];
//        NSInteger length = [m length];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
//        return  attrStr;
//    };
//    
//    self.priceLabel.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[priceModel.price floatValue]]);
//}

//- (void)setModelShopInfo:(FMSelectShopInfoModel *)modelShopInfo {
//    _modelShopInfo = modelShopInfo;
//    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:modelShopInfo.image] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
//    // 如果没有颜色、尺码属性，给一个空字符串
//    if (modelShopInfo.currentStyle == nil) {
//        self.colorLabel.text = @" ";
//    }else {
//        self.colorLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.currentStyle];
//    }
//    self.introduceLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.title];
////    self.quantityLabel.text = [NSString stringWithFormat:@"%@",modelShopInfo.store];
////    // 让金额数字变红
////    NSMutableAttributedString *(^makeMoneyRed)(NSString *) = ^(NSString *m) {
////        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:m];
////        NSInteger length = [m length];
////        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
////        return  attrStr;
////    };
////    self.priceLabel.attributedText = makeMoneyRed([NSString stringWithFormat:@"￥%.2f",[modelShopInfo.price floatValue]]);
//}

/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"confirmOrderCell";
    XZConfirmPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
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
