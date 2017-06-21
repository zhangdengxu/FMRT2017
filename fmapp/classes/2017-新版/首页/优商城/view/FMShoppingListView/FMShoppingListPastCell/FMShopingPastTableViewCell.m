//
//  FMShopingPastTableViewCell.m
//  fmapp
//
//  Created by apple on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShopingPastTableViewCell.h"

@interface FMShopingPastTableViewCell ()

@property (nonatomic, strong) UILabel *pastLabel, *titleLabel, *detailLabel, *numberLabel;
@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation FMShopingPastTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = KUIImageViewDefaultColor;
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
    
    [self.contentView addSubview:self.pastLabel];
    [self.pastLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    
    [self.contentView addSubview:self.photoView];
    self.photoView.image =[UIImage imageNamed:@"t6"];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.self.pastLabel.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-55);
        make.left.equalTo(self.photoView.mas_right).offset(10);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).equalTo(-10);
        
    }];
    
    UIView *bottomGrayView = [[UIView alloc]init];
    bottomGrayView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomGrayView];
    [bottomGrayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(@5);
    }];
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.text = @"x1";
        _numberLabel.textColor = kColorTextColorClay;
        _numberLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numberLabel;
}


- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = KDisableTextColor;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.text = @"宝贝已经不能购买,请联系卖家";
    }
    return _detailLabel;
}

- (UILabel *)pastLabel {
    if (!_pastLabel) {
        _pastLabel = [[UILabel alloc]init];
        _pastLabel.backgroundColor = KDisableTextColor;
        _pastLabel.textColor = [UIColor whiteColor];
        _pastLabel.text = @"失效";
        _pastLabel.font = [UIFont systemFontOfSize:11];
        _pastLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pastLabel;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
    }
    return _photoView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.text = @"泉都优蜜丝锐秋玻尿酸密集补水蚕丝面膜";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)sendDataToCellWith:(FMShoppingListModel *)model {
    
    self.titleLabel.text = model.name;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
}

@end
