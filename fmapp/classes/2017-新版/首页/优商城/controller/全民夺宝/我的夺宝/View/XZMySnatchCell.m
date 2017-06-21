//
//  XZMySnatchCell.m
//  fmapp
//
//  Created by admin on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//  我的夺宝cell

#import "XZMySnatchCell.h"

@interface XZMySnatchCell ()

@end

@implementation XZMySnatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置
        [self setUpMySnatchCell];
    }
    return self;
}

- (void)setUpMySnatchCell {
    
    // 左方图片
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.and.width.equalTo(@40);
    }];
    self.imgPhoto = imgPhoto;
//    imgPhoto.layer.masksToBounds = YES;
//    imgPhoto.layer.cornerRadius = 20;
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_right).offset(10);
        make.centerY.equalTo(imgPhoto.mas_centerY);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textColor = XZColor(67, 67, 65);
    
    // 线
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = KDefaultOrBackgroundColor;
    
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    // 竞拍记录箭头_26
    imgArrow.image = [UIImage imageNamed:@"首页零钱贯-箭头_07"];
    
    UIImageView *imgUnread = [[UIImageView alloc] init];
    [self.contentView addSubview:imgUnread];
    [imgUnread mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgArrow.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(@7);
    }];
    self.imgUnread = imgUnread;
//    imgUnread.image = [UIImage imageNamed:@"crowdfund_red_icon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
