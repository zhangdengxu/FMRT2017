//
//  XZMonthTotalCommissionSection.m
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZMonthTotalCommissionSection.h"
#import "XZEarningGroupModel.h"

@interface XZMonthTotalCommissionSection ()

@property (nonatomic, strong) UIImageView *imgIcon;

@property (nonatomic, strong) UILabel *labelLeft;
@property (nonatomic, strong) UILabel *labelRight;

@property (nonatomic, strong) UIButton *coverBtn;
@end

@implementation XZMonthTotalCommissionSection

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMonthTotalCommissionSection];
    }
    return self;
}

- (void)setUpMonthTotalCommissionSection {
    self.backgroundColor = [UIColor whiteColor];
    
    // 时间
    UILabel *labelTime = [[UILabel alloc] init];
    [self addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.labelLeft = labelTime;
    
    // 右侧图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [self addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(labelTime.mas_centerY);
        make.width.equalTo(@(15 * 0.55));
        make.height.equalTo(@(24 * 0.55));
    }];
    self.imgIcon = imgIcon;
    
    // 金额
    UILabel *labelMoney = [[UILabel alloc] init];
    [self addSubview:labelMoney];
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
    self.coverBtn = coverBtn;
    [coverBtn addTarget:self action:@selector(didClickSection:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickSection:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchAction:)]) {
        [self.delegate touchAction:self];
    }
}

- (void)setModelEarning:(XZEarningGroupModel *)modelEarning {
    _modelEarning = modelEarning;
    self.labelLeft.text = [NSString stringWithFormat:@"%@",modelEarning.month];
    
    self.labelRight.text = [NSString stringWithFormat:@"%@",modelEarning.Monthtotal];
    
    if (modelEarning.isCanClick) { // 可以被点击
        self.imgIcon.image = [UIImage imageNamed:@"我的推荐_向右小箭头_1702"];
        self.imgIcon.transform = self.modelEarning.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
    }else { // 不可以被点击
        self.coverBtn.userInteractionEnabled = NO;
        self.imgIcon.hidden = YES;
        [self.labelRight mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self.labelLeft.mas_centerY);
        }];
    }
}



@end
