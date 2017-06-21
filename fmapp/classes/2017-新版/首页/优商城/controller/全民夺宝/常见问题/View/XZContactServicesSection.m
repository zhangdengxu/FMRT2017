//
//  XZContactServicesSection.m
//  fmapp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 yk. All rights reserved.
//  联系客服的header

#import "XZContactServicesSection.h"
#import "XZContactServicesModel.h"

@interface XZContactServicesSection ()
@property (nonatomic, strong) UIImageView *imgIcon;
/** label */
@property (nonatomic, strong) UILabel *labelLeft;
@end

@implementation XZContactServicesSection
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpContactServicesSection];
    }
    return self;
}

- (void)setUpContactServicesSection {
    UIView *background = [[UIView alloc] init];
    [self addSubview:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    background.backgroundColor = [UIColor whiteColor];
    
    // 右侧图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [background addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(background.mas_right).offset(-10);
        make.centerY.equalTo(background.mas_centerY);
        make.width.equalTo(@(15 * 0.8));
        make.height.equalTo(@(16 * 0.8));
    }];
    self.imgIcon = imgIcon;
//    imgIcon.image = [UIImage imageNamed:@"箭头-默认"];
    
    // 问题
    UILabel *labelQuestion= [[UILabel alloc] init];
    [background addSubview:labelQuestion];
    [labelQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background.mas_left).offset(10);
        make.centerY.equalTo(imgIcon.mas_centerY);
        make.right.equalTo(imgIcon.mas_left);
    }];
    self.labelLeft = labelQuestion;
    labelQuestion.textColor = XZColor(67, 67, 65);
    labelQuestion.font = [UIFont systemFontOfSize:13];
    labelQuestion.numberOfLines = 0;
    
    /** 线 */
    UILabel *line = [[UILabel alloc] init];
    [background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelQuestion.mas_left);
        make.right.equalTo(imgIcon.mas_right);
        make.bottom.equalTo(background.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [background addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background.mas_left);
        make.bottom.equalTo(background.mas_bottom);
        make.right.equalTo(background.mas_right);
        make.top.equalTo(background.mas_top);
    }];
    [coverBtn addTarget:self action:@selector(didClickSection:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickSection:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchAction:)]) {
        [self.delegate touchAction:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgIcon.transform = self.modelContactSer.isOpened ? CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
}

- (void)setModelContactSer:(XZContactServicesModel *)modelContactSer {
    _modelContactSer = modelContactSer;
    self.labelLeft.text = [NSString stringWithFormat:@"%@",modelContactSer.title];
    if (modelContactSer.isCommonProblems) { // 新的"常见问题"界面
        [self.imgIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(8 * 0.8));
            make.height.equalTo(@(15 * 0.8));
        }];
        self.imgIcon.image = [UIImage imageNamed:@"右键头"];
    }else {// 旧的"常见问题"界面
        self.imgIcon.image = [UIImage imageNamed:@"箭头-默认"];
    }
}
@end
