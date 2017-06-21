//
//  FMSelectView.m
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectView.h"

@interface FMSelectView ()

@end

@implementation FMSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {
    
    UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [timeButton addTarget:self action:@selector(selectAction) forControlEvents:(UIControlEventTouchUpInside)];
    [timeButton setTitle:@"早餐" forState:(UIControlStateNormal)];
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    timeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [timeButton setTitleColor:KContentTextColor forState:UIControlStateNormal];
    self.timeButton = timeButton;
    [self addSubview:timeButton];
    [timeButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(KProjectScreenWidth/2);
    }];
    
    UITextField *nameTextField = [[UITextField alloc]init];
    nameTextField.font = [UIFont systemFontOfSize:15];
    nameTextField.textColor = KContentTextColor;
    nameTextField.placeholder = @"借贷人";
    nameTextField.textAlignment = NSTextAlignmentLeft;
    self.nameTextField = nameTextField;
    [self addSubview:nameTextField];
    [nameTextField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_centerX);
        make.width.equalTo(KProjectScreenWidth / 2);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void)selectAction{
    if (self.selctBlock) {
        self.selctBlock();
    }
}

- (void)sendTypeWithString:(NSString *)type{
    [self.timeButton setTitle:type forState:(UIControlStateNormal)];
}

@end
