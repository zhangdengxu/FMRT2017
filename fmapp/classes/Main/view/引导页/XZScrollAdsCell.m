//
//  XZScrollAdsCell.m
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZScrollAdsCell.h"

@interface XZScrollAdsCell ()
@property (nonatomic, strong) UIImageView *imgView;
// "跳过"按钮
@property (nonatomic, strong) UIButton *buttonJump;
@end

@implementation XZScrollAdsCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpScrollAdsCell];
    }
    return self;
}

- (void)setUpScrollAdsCell {
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    self.imgView = imgView;
    
    // "跳过"按钮
    UIButton *buttonJump = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonJump];
    self.buttonJump = buttonJump;
    [buttonJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    [buttonJump addTarget:self action:@selector(didClickButtonJump:) forControlEvents:UIControlEventTouchUpInside];
    [buttonJump setTitle:@"跳过" forState:UIControlStateNormal];
    buttonJump.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.55];
    buttonJump.layer.cornerRadius = 5.0;
    buttonJump.layer.masksToBounds = YES;
}

// 点击"跳过"按钮
- (void)didClickButtonJump:(UIButton *)button {
    if (self.blockJumpButton) {
        self.blockJumpButton(button);
    }
}

- (void)setModelPicUrl:(NSString *)modelPicUrl {
    _modelPicUrl = modelPicUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:modelPicUrl] placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
}

- (void)setIsHiddenJumpBtn:(BOOL)isHiddenJumpBtn {
    _isHiddenJumpBtn = isHiddenJumpBtn;
    if (isHiddenJumpBtn) { // 隐藏"跳过"按钮
        self.buttonJump.hidden = YES;
    }else { // 不隐藏“跳过”按钮
        self.buttonJump.hidden = NO;
    }
}


@end
