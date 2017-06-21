//
//  XZSignUpSuccessView.m
//  fmapp
//
//  Created by admin on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
// 报名成功

#import "XZSignUpSuccessView.h"

@interface XZSignUpSuccessView ()
/** 报名成功图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;

@end

@implementation XZSignUpSuccessView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSignUpSuccessView];
    }
    return self;
}

- (void)setUpSignUpSuccessView {
    /** 报名成功图片 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
    [self addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(45);
        make.right.equalTo(self.mas_right).offset(-45);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.imgPhoto = imgPhoto;
    imgPhoto.image = [UIImage imageNamed:@"融米活动_报名成功"];
    imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    imgPhoto.userInteractionEnabled = YES;
    
    /** 关闭按钮 */
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [imgPhoto addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgPhoto.mas_top);
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
        make.height.and.width.equalTo(@18);
    }];
    [btnClose addTarget:self action:@selector(didClickJumpButton:) forControlEvents:UIControlEventTouchUpInside];
    btnClose.tag = 100;
    [btnClose setBackgroundImage:[UIImage imageNamed:@"报名成功_关闭"] forState:UIControlStateNormal];
    
    /** 跳转按钮 */
    UIButton *btnJump = [UIButton buttonWithType:UIButtonTypeSystem];
    [imgPhoto addSubview:btnJump];
    [btnJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_left);
        make.right.equalTo(imgPhoto.mas_right);
        make.top.equalTo(imgPhoto.mas_top).offset(35);
        make.bottom.equalTo(imgPhoto.mas_bottom).offset(15);
    }];
    btnJump.tag = 102;
    [btnJump addTarget:self action:@selector(didClickJumpButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 点击按钮
- (void)didClickJumpButton:(UIButton *)button {
    Log(@"点击了跳转按钮");
    
    if (self.blockJumpBtn) {
        self.blockJumpBtn(button);
    }
    [self removeFromSuperview];
}

@end
