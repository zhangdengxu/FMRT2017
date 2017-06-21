//
//  FMRTAucFootView.m
//  fmapp
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucFootView.h"


@interface FMRTAucFootView ()

@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation FMRTAucFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenWidth/640 *105 +35);
        self.backgroundColor = KDefaultOrBackgroundColor;
        [self createFootView];
    }
    return self;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
        [_moreButton setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreButton addTarget:self action:@selector(moreData) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.moreButton];

    }
    return _moreButton;
}

- (void)moreData{
    
    if (self.moreBlock) {
        self.moreBlock();
    }
}

- (void)createFootView{

    UIImageView *photoView = [[UIImageView alloc]init];
    [self addSubview:photoView];
    photoView.image = [UIImage imageNamed:@"huhklkjl_02"];
    [photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth/640 *105);
    }];
    
    [self.moreButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(photoView.mas_top).offset(-4);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [_moreButton setTitle:title forState:(UIControlStateNormal)];
}

@end
