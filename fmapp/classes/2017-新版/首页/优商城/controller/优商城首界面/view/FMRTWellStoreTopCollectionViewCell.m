//
//  FMRTWellStoreTopCollectionViewCell.m
//  fmapp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreTopCollectionViewCell.h"
#import "HexColor.h"

@interface FMRTWellStoreTopCollectionViewCell ()

@property (nonatomic, strong)UIImageView *photoView;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation FMRTWellStoreTopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    [self.contentView addSubview:self.photoView];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY).offset(-10);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.photoView.bottom).offset(5);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth < 375?14:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView  =[[UIImageView alloc]init];
    }
    return _photoView;
}

- (void)setModel:(FMRTWellStoreCollectionModel *)model{
    _model = model;
    self.photoView.image = [UIImage imageNamed:model.pic];
    self.titleLabel.text = model.title;
}

@end
