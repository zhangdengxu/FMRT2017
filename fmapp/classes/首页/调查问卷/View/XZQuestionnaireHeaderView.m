//
//  XZQuestionnaireHeaderView.m
//  XZProject
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//  调查问卷/风险评估问卷头视图

#import "XZQuestionnaireHeaderView.h"

@interface XZQuestionnaireHeaderView ()

@property (nonatomic, strong) UIImageView *headerImg;

@end

@implementation XZQuestionnaireHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建子视图
        [self setUpQuestionnaireHeaderView];
    }
    return self;
}

// 创建子视图
- (void)setUpQuestionnaireHeaderView {
    UIImageView *headerImg = [[UIImageView alloc] init];
    [self addSubview:headerImg];
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
    self.headerImg = headerImg;
    
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.headerImg.image = [UIImage imageNamed:imageName];
}

@end
