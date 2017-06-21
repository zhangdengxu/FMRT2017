//
//  XZGoodsCollectionCell.m
//  OptimalMall
//
//  Created by rongtuo on 16/4/18.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZGoodsCollectionCell.h"
#import "FMGoodShopHeaderModel.h"
#import "UIImageView+WebCache.h"
@interface XZGoodsCollectionCell ()

/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgGoods;
/** 商品题目 */
@property (nonatomic, strong) UILabel *labelTitle;
/** 商品价格 */
@property (nonatomic, strong) UILabel *labelPrice;
/** 积分图片 */
@property (nonatomic, strong) UIImageView *imgIntegral;

@property (nonatomic, strong) UIView * backGroundView;
@end


@implementation XZGoodsCollectionCell

-(UIImageView *)imgGoods
{
    if (!_imgGoods) {
        _imgGoods = [[UIImageView alloc]init];
        [self.contentView addSubview:_imgGoods];
    }
    return _imgGoods;
}

-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        [self.contentView addSubview:_backGroundView];
    }
    return _backGroundView;
}

-(UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc]init];
        [self.backGroundView addSubview:_labelTitle];
    }
    return _labelTitle;

}
-(UILabel *)labelPrice
{
    if (!_labelPrice) {
        _labelPrice = [[UILabel alloc]init];
        [self.backGroundView addSubview:_labelPrice];
    }
    return _labelPrice;
    
}
-(UIImageView *)imgIntegral
{
    if (!_imgIntegral) {
        _imgIntegral = [[UIImageView alloc]init];
        [self.backGroundView addSubview:_imgIntegral];
    }
    return _imgIntegral;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpGoodsCollectionCell];
    }
    return self;
}
- (void)setUpGoodsCollectionCell {
    self.contentView.backgroundColor = [UIColor clearColor];
    /** 商品图片 */
    
    [self.imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(self.imgGoods.mas_width);
        make.top.equalTo(self.contentView.mas_top);
    }];
    [self.imgGoods setImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 背景
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.imgGoods.mas_bottom);
        make.height.equalTo(@80);
    }];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    /** 商品题目 */
//    self.labelTitle.backgroundColor = [UIColor yellowColor];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
//        make.height.equalTo(@60);
        make.top.equalTo(self.imgGoods.mas_bottom).offset(5);
    }];
    self.labelTitle.numberOfLines = 2;
    self.labelTitle.font = [UIFont systemFontOfSize:13];
    self.labelTitle.text = @"加载中...";
  
    /** 积分图片 */
//    self.imgIntegral.backgroundColor = [UIColor redColor];
    self.imgIntegral.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(40);
        make.right.equalTo(self.contentView.mas_right).offset(-3);
//        make.top.equalTo(self.labelTitle.mas_bottom).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    self.imgIntegral.image = [UIImage imageNamed:@"优商城首页-积分-72x92px"];
    /** 商品价格 */
//    self.labelPrice.backgroundColor = [UIColor greenColor];
    [self.labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelTitle.mas_left);
        make.right.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.imgIntegral.mas_centerY);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(10);
    }];
    self.labelPrice.text = @"加载中...";
    self.labelPrice.textAlignment = NSTextAlignmentJustified;
    self.labelPrice.textColor = [UIColor orangeColor];
    self.labelPrice.font = [UIFont systemFontOfSize:16];
}
-(void)setShopModel:(FMGoodShopModel *)shopModel
{
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:shopModel.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.labelTitle.text = shopModel.title;
    if ([shopModel.fulljifen_ex integerValue] != 0 && ![shopModel.fulljifen_ex isMemberOfClass:[NSNull class]]) {
        self.labelPrice.text = [NSString stringWithFormat:@"%@积分", shopModel.fulljifen_ex];
    }else
    {
        self.labelPrice.text = [NSString stringWithFormat:@"￥%@", shopModel.price];
    }
    
    
}
@end
