//
//  XZCommentAgainTabBar.m
//  fmapp
//
//  Created by admin on 16/12/27.
//  Copyright © 2016年 yk. All rights reserved.
//  追评

#import "XZCommentAgainTabBar.h"

@implementation XZCommentAgainTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMySnatchHeaderView];
    }
    return self;
}

- (void)setUpMySnatchHeaderView {
    self.backgroundColor = [UIColor whiteColor];
    // 线
    UILabel *line = [[UILabel alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = XZColor(235, 236, 236);
    
    /** 发表评价按钮 */
    UIButton *btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnComment];
    [btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(line.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(48);
    }];
    [btnComment setTitle:@"发表评价" forState:UIControlStateNormal];
    btnComment.backgroundColor = [UIColor colorWithRed:6/255.0 green:41/255.0 blue:125/255.0 alpha:1.0f];
    [btnComment addTarget:self action:@selector(didClickCommentAgainBtn:) forControlEvents:UIControlEventTouchUpInside];
}

// 点击发表评论按钮
- (void)didClickCommentAgainBtn:(UIButton *)button {
    if (self.blockCommentBtn) {
        self.blockCommentBtn(button);
    }
}

@end
