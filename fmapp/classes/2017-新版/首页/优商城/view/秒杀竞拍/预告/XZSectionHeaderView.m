//
//  XZSectionHeaderView.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZSectionHeaderView.h"
#import "XZEarningGroupModel.h"

@interface XZSectionHeaderView ()
@property (nonatomic, strong) UIImageView *imgIcon;
@end

@implementation XZSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSectionHeaderView];
    }
    return self;
}

- (void)setUpSectionHeaderView {
    UIView *background = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:background];
    background.backgroundColor = [UIColor whiteColor];
    
    // 时间
    UILabel *labelTime = [[UILabel alloc] init];
    [background addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.labelLeft = labelTime;
//    labelTime.text = @"2016年8月";
    
    // 右侧图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [background addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(labelTime.mas_centerY);
        make.width.equalTo(@(11 * 0.8));
        make.height.equalTo(@(17 * 0.8));
    }];
    self.imgIcon = imgIcon;
    imgIcon.image = [UIImage imageNamed:@"向右_03"];
    
    // 金额
    UILabel *labelMoney = [[UILabel alloc] init];
    [background addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgIcon.mas_left).offset(-5);
        make.centerY.equalTo(labelTime.mas_centerY);
    }];
    self.labelRight = labelMoney;
//    labelMoney.text = @"25830.27";
    labelMoney.textColor = XZColor(244, 88, 45);
    
    // 线
    UILabel *line = [[UILabel alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = XZColor(216, 216, 216);
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    [coverBtn addTarget:self action:@selector(didClickSection:) forControlEvents:UIControlEventTouchUpInside];
}

//
- (void)didClickSection:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchAction:)]) {
        [self.delegate touchAction:self];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.delegate) {
//        [self.delegate touchAction:self];
//    }
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgIcon.transform = self.modelEarning.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)setModelEarning:(XZEarningGroupModel *)modelEarning {
    _modelEarning = modelEarning;
    self.labelLeft.text = [NSString stringWithFormat:@"%@",modelEarning.month];
    self.labelRight.text = [NSString stringWithFormat:@"%@",modelEarning.Monthtotal];

}

@end
