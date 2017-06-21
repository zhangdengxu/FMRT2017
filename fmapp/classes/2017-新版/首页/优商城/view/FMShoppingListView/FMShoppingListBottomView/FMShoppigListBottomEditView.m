//
//  FMShoppigListBottomEditView.m
//  fmapp
//
//  Created by apple on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppigListBottomEditView.h"


@interface FMShoppigListBottomEditView ()

@property (nonatomic, strong)UIButton *shareButton, *deleteButton;

@end

@implementation FMShoppigListBottomEditView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor purpleColor]];
        
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
    
    [self addSubview:self.removeButton];
    [self.removeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(-1);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.deleteButton.mas_width);
        
    }];
    
    [self addSubview:self.shareButton];
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.removeButton.mas_left).offset(-1);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.deleteButton.mas_width);
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

- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _removeButton.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
        [_removeButton setTitle:@"移到收藏夹" forState:(UIControlStateNormal)];
        _removeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_removeButton addTarget:self action:@selector(removeAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _removeButton;
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

- (void)shareAction:(UIButton *)sender {
    if (self.shareBlcok) {
        self.shareBlcok(sender);
    }
}

- (void)deleteAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

- (void)removeAction:(UIButton *)sender {
    if (self.removeBlock) {
        self.removeBlock(sender);
    }
}

@end
