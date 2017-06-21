//
//  XZProjectDetailSection.m
//  fmapp
//
//  Created by admin on 17/4/10.
//  Copyright © 2017年 yk. All rights reserved.
//  描述

#import "XZProjectDetailSection.h"

@interface XZProjectDetailSection ()
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation XZProjectDetailSection

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUpMySnatchHeaderView];
    }
    return self;
}

- (void)setUpMySnatchHeaderView {
    self.contentView.backgroundColor = XZBackGroundColor;
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    self.labelTitle = labelTitle;
    labelTitle.textColor = XZColor(51, 51, 51);
    labelTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    
    [self setModel];
}

- (void)setModel {
    self.labelTitle.text = @"借款方简介";
}

@end
