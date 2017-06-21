//
//  FMFavoriteBottomView.m
//  fmapp
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMFavoriteBottomView.h"


@interface FMFavoriteBottomView ()

@property (nonatomic, strong)UIButton *shareButton, *deleteButton;
@property (nonatomic, strong)UILabel *allSelectLabel;

@end

@implementation FMFavoriteBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createBottomView];
    }
    return self;
}

- (void)createBottomView {
    
    [self addSubview:self.deleteButton];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self);
        make.width.equalTo(KProjectScreenWidth / 4);
    }];
    
    [self addSubview:self.shareButton];
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(-1);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.deleteButton.mas_width);
    }];
    
    [self addSubview:self.allSelectButton];
    [self.allSelectButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
//        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.allSelectLabel];
    [self.allSelectLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allSelectButton.mas_right).offset(7);
        make.centerY.equalTo(self.allSelectButton.mas_centerY);
        
    }];
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
        [_deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteButton;
}


- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shareButton.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
        [_shareButton setTitle:@"分享宝贝" forState:(UIControlStateNormal)];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _shareButton;
}

- (UIButton *)allSelectButton {
    if (!_allSelectButton) {
        _allSelectButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"t2-0"] forState:(UIControlStateNormal)];
        [_allSelectButton setImage:[UIImage imageNamed:@"t2"] forState:(UIControlStateSelected)];
        [_allSelectButton addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}

- (UILabel *)allSelectLabel {
    if (!_allSelectLabel) {
        _allSelectLabel = [[UILabel alloc]init];
        _allSelectLabel.text = @"全选";
        _allSelectLabel.font = [UIFont systemFontOfSize:14];
        _allSelectLabel.textColor = kColorTextColorClay;
    }
    return _allSelectLabel;
}

- (void)allSelectAction:(UIButton *)sender {
    if (self.allSelectBlcok) {
        self.allSelectBlcok(sender);
    }
}

- (void)shareAction:(UIButton *)sender {
    if (self.shareBlcok) {
        self.shareBlcok(sender);
    }
}

- (void)deleteAction:(UIButton *)sender{
    if (self.deleteBlcok) {
        self.deleteBlcok(sender);
    }
}

@end
