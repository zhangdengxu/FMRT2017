//
//  FMAcountFootView.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountFootView.h"

@interface FMAcountFootView ()

@end

@implementation FMAcountFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 60);
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button addTarget:self action:@selector(addAcountAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:button];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
    }];
    
    UIImageView *addView = [[UIImageView alloc]init];
    [addView setImage:[UIImage imageNamed:@"新增子类icon_03"]];
    [button addSubview:addView];
    
    [addView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(button.mas_centerY);
        make.left.equalTo(button.mas_left).offset(30);
        make.height.width.equalTo(@20);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"新增子类";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = KContentTextColor;
    [button addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(button.mas_centerY);
        make.left.equalTo(addView.mas_right).offset(5);
    }];

}

- (void)addAcountAction{
    if (self.addBlock) {
        self.addBlock();
    }
}

@end
