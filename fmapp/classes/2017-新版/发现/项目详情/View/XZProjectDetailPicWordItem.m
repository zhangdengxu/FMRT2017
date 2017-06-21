//
//  XZProjectDetailPicWordItem.m
//  fmapp
//
//  Created by admin on 17/4/12.
//  Copyright © 2017年 yk. All rights reserved.
//  描述中带文字和图片的item

#import "XZProjectDetailPicWordItem.h"

@interface XZProjectDetailPicWordItem ()
/** 图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 图片的题目 */
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation XZProjectDetailPicWordItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpProjectDetailPicWordItem];
    }
    return self;
}

- (void)setUpProjectDetailPicWordItem {
    self.backgroundColor = XZRandomColor;
    
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.imgPhoto = imgPhoto;
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto);
        make.top.equalTo(imgPhoto.mas_bottom).offset(5);
    }];
    labelTitle.font = [UIFont systemFontOfSize:13.0f];
    self.labelTitle = labelTitle;
    
    [self setModel];
}

- (void)setModel {
    self.imgPhoto.image = [UIImage imageNamed:@"竞拍商品_07"];
    self.labelTitle.text = @"证件原件3";
}
@end
