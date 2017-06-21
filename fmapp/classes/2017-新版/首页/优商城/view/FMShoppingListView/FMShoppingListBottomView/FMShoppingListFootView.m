//
//  FMShoppingListFootView.m
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListFootView.h"



@interface FMShoppingListFootView ()

@property (nonatomic, strong) UIButton *clearPastButton;

@end

@implementation FMShoppingListFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 40);
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
    
    [self addSubview:self.clearPastButton];
    [self.clearPastButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
}

- (UIButton *)clearPastButton {
    if (!_clearPastButton) {
        _clearPastButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_clearPastButton setTitle:@"清空失效宝贝" forState:(UIControlStateNormal)];
        _clearPastButton.layer.masksToBounds = YES;
        _clearPastButton.layer.borderColor = [HXColor colorWithHexString:@"#ff6633"].CGColor;
        _clearPastButton.layer.borderWidth = 1;
        [_clearPastButton addTarget:self action:@selector(clearPastAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_clearPastButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        _clearPastButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _clearPastButton;
}

- (void)clearPastAction:(UIButton *)sender {
//    sender.hidden = YES;
    if (self.block) {
        self.block(sender);
    }
}


@end
