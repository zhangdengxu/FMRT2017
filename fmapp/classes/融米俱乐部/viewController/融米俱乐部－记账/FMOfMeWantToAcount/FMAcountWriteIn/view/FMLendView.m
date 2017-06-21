//
//  FMLendView.m
//  fmapp
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMLendView.h"


@interface FMLendView ()

@end

@implementation FMLendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor colorWithHexString:@"1e1e1e" alpha:0.6];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenHeight);
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {
  
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    [centerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(100);
        make.width.equalTo(KProjectScreenWidth * 0.6);
        make.height.equalTo(@130);
    }];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.backgroundColor = XZColor(220, 221, 222);
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"借贷类型";
    [centerView addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(centerView);
        make.height.equalTo(@40);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeButton setImage:[UIImage imageNamed:@"t4"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [centerView addSubview:closeButton];
    [closeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(titleLable.mas_centerY);
        make.right.equalTo(centerView.mas_right).offset(-10);
    }];
    
    UIButton *lendOutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [lendOutButton setTitle:@"借出"forState:(UIControlStateNormal)];
    lendOutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [lendOutButton setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
    lendOutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [lendOutButton addTarget:self action:@selector(lendOutAction) forControlEvents:(UIControlEventTouchUpInside)];
    [centerView addSubview:lendOutButton];
    [lendOutButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLable.mas_bottom);
        make.right.equalTo(centerView.mas_right);
        make.left.equalTo(centerView.mas_left).offset(10);
        make.height.equalTo(@45);
    }];

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [centerView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(lendOutButton.mas_bottom);
        make.right.equalTo(centerView.mas_right);
        make.left.equalTo(centerView.mas_left);
        make.height.equalTo(@1);
    }];
    
    UIButton *lendInButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [lendInButton setTitle:@"借入"forState:(UIControlStateNormal)];
    lendInButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [lendInButton setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
    lendInButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [lendInButton addTarget:self action:@selector(lendInAction) forControlEvents:(UIControlEventTouchUpInside)];
    [centerView addSubview:lendInButton];
    [lendInButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(centerView.mas_right);
        make.left.equalTo(centerView.mas_left).offset(10);
        make.height.equalTo(@45);
    }];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
    
    [self addGestureRecognizer:tapGesture];
}

- (void)lendInAction{
    
    if (self.lendOInBlock) {
        self.lendOInBlock(@"借入");
    }
    
    [self removeFromSuperview];
}

- (void)lendOutAction{
    
    if (self.lendOutBlock) {
        self.lendOutBlock(@"借出");
    }
    
    [self removeFromSuperview];
}

- (void)closeAction{
    [self removeFromSuperview];
}

@end
