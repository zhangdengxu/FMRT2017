//
//  FMRTWellStoreProductCollectionViewCell.m
//  fmapp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreProductCollectionViewCell.h"

@interface FMRTWellStoreProductCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgGoods,*imgIntegral,*quanView;
@property (nonatomic, strong) UILabel *labelTitle,*labelPrice;

@end

@implementation FMRTWellStoreProductCollectionViewCell

- (UIImageView *)quanView{
    if (!_quanView) {
        _quanView = [[UIImageView alloc]init];
        [self.contentView addSubview:_quanView];
    }
    return _quanView;
}

-(UIImageView *)imgGoods
{
    if (!_imgGoods) {
        _imgGoods = [[UIImageView alloc]init];
        [self.contentView addSubview:_imgGoods];
    }
    return _imgGoods;
}

-(UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc]init];
        [self.contentView addSubview:_labelTitle];
    }
    return _labelTitle;
    
}
-(UILabel *)labelPrice
{
    if (!_labelPrice) {
        _labelPrice = [[UILabel alloc]init];
        [self.contentView addSubview:_labelPrice];
    }
    return _labelPrice;
    
}
-(UIImageView *)imgIntegral
{
    if (!_imgIntegral) {
        _imgIntegral = [[UIImageView alloc]init];
        [self.contentView addSubview:_imgIntegral];
    }
    return _imgIntegral;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpGoodsCollectionCell];
    }
    return self;
}
- (void)setUpGoodsCollectionCell {
    
    [self.imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(self.imgGoods.mas_width);
        make.top.equalTo(self.contentView.mas_top);
    }];

    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.imgGoods.mas_bottom).offset(5);
    }];
    self.labelTitle.font = [UIFont systemFontOfSize:14];
    
    [self.labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelTitle.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(5);
    }];
    self.labelPrice.textColor = [UIColor orangeColor];
    self.labelPrice.font = [UIFont systemFontOfSize:16];
    
    self.imgIntegral.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.top.equalTo(self.labelPrice.bottom).offset(5);
        make.width.height.equalTo(@18);
    }];
    self.imgIntegral.image = [UIImage imageNamed:@"优商城首页_积分_36"];
    
    self.quanView.contentMode = UIViewContentModeScaleAspectFit;
    [self.quanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgIntegral.right).offset(5);
        make.top.equalTo(self.labelPrice.bottom).offset(5);
        make.width.height.equalTo(@18);
    }];
    self.quanView.image = [UIImage imageNamed:@"优商城_劵_36"];
    
}

- (void)setModel:(FMRTWellCollectionModel *)model{
    _model = model;
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.labelTitle.text = model.title;

    if ([model.fulljifen_ex integerValue]>0) {
        self.labelPrice.text = [NSString stringWithFormat:@"%zi积分",[model.fulljifen_ex integerValue]];
    }else{
        self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",[model.price floatValue]];
    }
    
    if ([model.icon_jifen integerValue] == 1 && [model.icon_quan integerValue] == 0) {
        [self.imgIntegral setHidden:NO];
        [self.quanView setHidden:YES];
        self.imgIntegral.image = [UIImage imageNamed:@"优商城首页_积分_36"];
        
    }else if([model.icon_jifen integerValue]==0 && [model.icon_quan integerValue] == 1){
        [self.imgIntegral setHidden:NO];
        [self.quanView setHidden:YES];
        self.imgIntegral.image = [UIImage imageNamed:@"优商城_劵_36"];

    }else if([model.icon_jifen integerValue]==0 && [model.icon_quan integerValue] == 0){
        [self.imgIntegral setHidden:YES];
        [self.quanView setHidden:YES];

    }else if([model.icon_jifen integerValue]==1 && [model.icon_quan integerValue] == 1){
        [self.imgIntegral setHidden:NO];
        [self.quanView setHidden:NO];
        self.imgIntegral.image = [UIImage imageNamed:@"优商城首页_积分_36"];
    }
}

@end
