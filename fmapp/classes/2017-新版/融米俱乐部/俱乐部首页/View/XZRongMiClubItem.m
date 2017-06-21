//
//  XZRongMiClubItem.m
//  fmapp
//
//  Created by admin on 16/11/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZRongMiClubItem.h"
#import "FMBeautifulModel.h"

@interface XZRongMiClubItem ()
@property (nonatomic, strong) UIImageView *imgBackGroud;
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation XZRongMiClubItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRongMiClubItem];
    }
    return self;
}

- (void)setUpRongMiClubItem {
    self.backgroundColor = XZBackGroundColor;
    
    __weak __typeof(&*self)weakSelf = self;
    UIImageView *imgBackGroud = [[UIImageView alloc] init];
    [self.contentView addSubview:imgBackGroud];
    [imgBackGroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    self.imgBackGroud = imgBackGroud;
    imgBackGroud.image = [UIImage imageNamed:@"融米学堂首页视频图片_07"];
    
    // 黑色背景
    UIView *cover = [[UIView alloc] init];
    [imgBackGroud addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgBackGroud);
        make.right.equalTo(imgBackGroud);
        make.bottom.equalTo(imgBackGroud);
        make.height.equalTo(@30);
    }];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    
    //
    UILabel *labelTitle = [[UILabel alloc] init];
    [imgBackGroud addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgBackGroud).offset(10);
        make.right.equalTo(imgBackGroud);
        make.centerY.equalTo(cover);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15.0f];
    labelTitle.textColor = [UIColor whiteColor];
//    labelTitle.backgroundColor = [UIColor redColor];
}

- (void)setMomdelRongmi:(FMBeautifulModel *)momdelRongmi {
    _momdelRongmi = momdelRongmi;
    self.labelTitle.text = momdelRongmi.title;
    [self.imgBackGroud sd_setImageWithURL:[NSURL URLWithString:momdelRongmi.thumb] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
}
@end
