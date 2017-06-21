//
//  XZPersonalCenterCell.m
//  XZProject
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZPersonalCenterCell.h"

@implementation XZPersonalCenterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置
        [self setUpPersonalCenterCell];
    }
    return self;
}

- (void)setUpPersonalCenterCell {
    // 左方图片
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.and.width.equalTo(@40);
    }];
    self.imgPhoto = imgPhoto;
    imgPhoto.layer.masksToBounds = YES;
    imgPhoto.layer.cornerRadius = 20;
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_right).offset(10);
       make.centerY.equalTo(imgPhoto.mas_centerY);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
