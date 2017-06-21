//
//  FMGatherCollectionViewCell.m
//  fmapp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMGatherCollectionViewCell.h"

@interface FMGatherCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgGoods;
@property (nonatomic, strong) UILabel *labelTitle, *labelPrice;
@property (nonatomic, strong) UIButton *imgIntegral;

@end

@implementation FMGatherCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUpGoodsCollectionCell];
        
    }
    return self;
}
- (void)setUpGoodsCollectionCell {
    
    CGFloat width = (KProjectScreenWidth - 30) / 2;
    self.imgGoods = [[UIImageView alloc]init];
    self.imgGoods.contentMode = UIViewContentModeScaleAspectFit;
    self.imgGoods.image = [UIImage imageNamed:@"敬请稍后new_03"];
    [self.contentView addSubview:self.imgGoods];
    [self.imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(width);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    self.labelTitle = [[UILabel alloc]init];
    self.labelTitle.numberOfLines = 0;
    self.labelTitle.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.imgGoods.mas_bottom).offset(10);
    }];

    self.labelPrice = [[UILabel alloc]init];
    self.labelPrice.textAlignment = NSTextAlignmentJustified;
    self.labelPrice.textColor = KMoneyColor;
    self.labelPrice.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.labelPrice];
    self.imgIntegral = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.imgIntegral];
    
    self.imgIntegral.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.imgIntegral setImage:[UIImage imageNamed:@"t3"] forState:(UIControlStateNormal)];
    [self.imgIntegral addTarget: self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.imgIntegral.hidden = YES;
    
    [self.labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelTitle.mas_left);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityHigh();
    }];
}

- (void)selectAction:(UIButton *)sender {

    if (self.MoveToShoppingListBlock) {
        self.MoveToShoppingListBlock(sender);
    }
}

+ (CGSize)heightForItemWith:(FMGatherModel *)model{
    
    CGFloat width = (KProjectScreenWidth - 30) / 2;
    CGSize size = CGSizeMake(width - 20, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
    CGRect rect = [model.name boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return CGSizeMake(width , width + rect.size.height +45);
}

- (void)setModel:(FMGatherModel *)model {
    _model = model;
    self.labelTitle.text = model.name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
    [self.imgGoods sd_setImageWithURL:model.image placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGRect frame1 = self.contentView.frame;
    CGRect frame2 = self.bounds;
    frame1.size = frame2.size;
    self.contentView.frame = frame2;
}

@end
