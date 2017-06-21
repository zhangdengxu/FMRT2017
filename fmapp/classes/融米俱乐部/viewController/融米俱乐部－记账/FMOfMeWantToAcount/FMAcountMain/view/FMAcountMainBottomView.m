//
//  FMAcountMainBottomView.m
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountMainBottomView.h"


@implementation FMAcountMainBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [HXColor colorWithHexString:@"#333333"];
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {
    
    UIButton *detailButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [detailButton setImage:[UIImage imageNamed:@"明细icon_03"] forState:(UIControlStateNormal)];
    [detailButton addTarget:self action:@selector(detailAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:detailButton];
    
    [detailButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX).dividedBy(2);
        make.top.equalTo(self.mas_top).offset(8);
    }];
    
    UIButton *detailBtLabel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [detailBtLabel setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [detailBtLabel setTitle:@"明细" forState:(UIControlStateNormal)];
    [detailBtLabel addTarget:self action:@selector(detailAction) forControlEvents:(UIControlEventTouchUpInside)];
    detailBtLabel.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:detailBtLabel];
    [detailBtLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(detailButton.mas_centerX);
        make.top.equalTo(detailButton.mas_bottom);
    }];
    
    UIButton *formButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [formButton setImage:[UIImage imageNamed:@"报表_03"] forState:(UIControlStateNormal)];
    [formButton addTarget:self action:@selector(formAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:formButton];
    [formButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        make.top.equalTo(self.mas_top).offset(8);
    }];
    
    UIButton *formBtLabel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [formBtLabel setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [formBtLabel setTitle:@"报表" forState:(UIControlStateNormal)];
    [formBtLabel addTarget:self action:@selector(formAction) forControlEvents:(UIControlEventTouchUpInside)];
    formBtLabel.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:formBtLabel];
    [formBtLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(formButton.mas_centerX);
        make.top.equalTo(formButton.mas_bottom);
    }];
}

- (void)detailAction{
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)formAction{
    if (self.formBlock) {
        self.formBlock();
    }
}

@end
