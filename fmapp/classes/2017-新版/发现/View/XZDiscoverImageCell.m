//
//  XZDiscoverImageCell.m
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//  推荐活动的图片cell

#import "XZDiscoverImageCell.h"
#import "XMRongmiAdsModel.h"

@interface XZDiscoverImageCell ()
@property (nonatomic, strong) UIImageView *imagePhoto;
@end

@implementation XZDiscoverImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpDiscoverImageCell];
    }
    return self;
}

- (void)setUpDiscoverImageCell {
    UIImageView *imagePhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imagePhoto];
    [imagePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    self.imagePhoto = imagePhoto;
}

- (void)setModel:(XMRongmiAdsModel *)model {
    _model = model;
    [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-376x126"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
