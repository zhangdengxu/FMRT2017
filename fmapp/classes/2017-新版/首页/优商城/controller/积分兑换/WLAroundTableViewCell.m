//
//  WLAroundTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLAroundTableViewCell.h"
#import "HexColor.h"
#define WLAroundButtonTag 100000
@interface WLAroundTableViewCell()

/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgGoods;
/** 商品题目 */
@property (nonatomic, strong) UILabel *labelTitle;
/** 商品价格 */
@property (nonatomic, strong) UILabel *labelPrice;

@property (nonatomic, strong) UIView * backGroundView;
@end


@implementation WLAroundTableViewCell

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
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpGoodsCollectionCell];
    }
    return self;
}
- (void)setUpGoodsCollectionCell {
    self.contentView.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(235.0/255.0) blue:(243.0/255.0) alpha:1];;
    /** 商品图片 */
    
    [self.imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(self.imgGoods.mas_width).multipliedBy(0.8);
        make.top.equalTo(self.contentView.mas_top);
    }];
    [self.imgGoods setImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 背景
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.imgGoods.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    /** 商品题目 */
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.imgGoods.mas_bottom).offset(5);
    }];
    self.labelTitle.numberOfLines = 2;
    self.labelTitle.font = [UIFont systemFontOfSize:13];
    self.labelTitle.text = @"加载中...";
    
   
    /** 商品价格 */
    //    self.labelPrice.backgroundColor = [UIColor greenColor];
    [self.labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelTitle.mas_left);
        make.right.equalTo(self.contentView.mas_right);

        make.top.equalTo(self.labelTitle.mas_bottom).offset(10);
    }];
    self.labelPrice.text = @"加载中...";
    self.labelPrice.textAlignment = NSTextAlignmentJustified;
    self.labelPrice.textColor = [UIColor orangeColor];
    self.labelPrice.font = [UIFont systemFontOfSize:16];
}

-(void)setDetailModel:(WLRongModel *)detailModel
{
    _detailModel = detailModel;
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:detailModel.img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.labelTitle.text = detailModel.title;
    self.labelPrice.text = [NSString stringWithFormat:@"%@积分", detailModel.jifen];
}


@end
