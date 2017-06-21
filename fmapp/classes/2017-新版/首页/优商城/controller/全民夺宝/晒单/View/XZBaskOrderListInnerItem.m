//
//  XZBaskOrderListInnerItem.m
//  fmapp
//
//  Created by admin on 16/8/27.
//  Copyright © 2016年 yk. All rights reserved.
//  评价的图片

#import "XZBaskOrderListInnerItem.h"

@interface XZBaskOrderListInnerItem ()
/** 图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
@end

@implementation XZBaskOrderListInnerItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpBaskOrderListInnerItem];
    }
    return self;
}

- (void)setUpBaskOrderListInnerItem {
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.imgPhoto = imgPhoto;
//    imgPhoto.image = [UIImage imageNamed:@"竞拍商品_07"];
}

- (void)setPhotoUrl:(NSString *)photoUrl {
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoUrl]] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
}

@end
