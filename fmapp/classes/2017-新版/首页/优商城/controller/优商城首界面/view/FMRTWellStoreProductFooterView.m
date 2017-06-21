//
//  FMRTWellStoreProductFooterView.m
//  fmapp
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreProductFooterView.h"

@interface FMRTWellStoreProductFooterView ()

@property (nonatomic, strong) UIButton *button;

@end
@implementation FMRTWellStoreProductFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    [self addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
        make.edges.equalTo(self);
    }];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_button setTitle:@"查看更多优选商品" forState:(UIControlStateNormal)];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitleColor:[UIColor colorWithHexString:@"#0159d5"] forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(moreAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (void)moreAction{
    if (self.block) {
        self.block();
    }
}

- (void)setHasmore:(NSInteger)hasmore{
    _hasmore = hasmore;
    if (hasmore == 1) {
        [_button setTitle:@"查看更多优选商品" forState:(UIControlStateNormal)];
    }else{
        [_button setTitle:@"已加载全部商品" forState:(UIControlStateNormal)];
    }
}

@end
