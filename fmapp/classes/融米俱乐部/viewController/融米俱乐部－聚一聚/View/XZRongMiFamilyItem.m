//
//  XZRongMiFamilyItem.m
//  fmapp
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZRongMiFamilyItem.h"

@implementation XZRongMiFamilyItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRongMiFamilyItem];
    }
    return self;
}

- (void)setUpRongMiFamilyItem {
    /** 图片 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
//    imgPhoto.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.and.height.equalTo(@20);
        make.top.equalTo(self.contentView.mas_centerY).offset(-20);
    }];
    imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _imgPhoto = imgPhoto;
    
    /** 文字 */
    UILabel *labelTitle = [[UILabel alloc]init];
//    labelTitle.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto);
        make.top.equalTo(self.contentView.mas_centerY).offset(20);
    }];
    [labelTitle setFont:[UIFont systemFontOfSize:15]];
//    labelTitle.font =[UIFont preferredFontForTextStyle: UIFontTextStyleHeadline];
    _labelTitle = labelTitle;
    [_labelTitle setFont:[UIFont systemFontOfSize:15]];
}

@end
