//
//  FMRTPlatformHeaderView.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTPlatformHeaderView.h"

@implementation FMRTPlatformHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XZColor(249, 249, 249);
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIImageView *verticalView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_竖线_1702"]];
    verticalView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:verticalView];
    [verticalView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(35);
    }];
    
    UIImageView *logolView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_logo_1702"]];
    logolView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logolView];
    [logolView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(verticalView.left).offset(-20);
        make.centerY.equalTo(verticalView.centerY);
    }];
    
    UILabel *rightLogo = [[UILabel alloc]init];
    rightLogo.text = @"融汇天下资本\n托起财富梦想";
    rightLogo.numberOfLines = 2;
    rightLogo.font = [UIFont systemFontOfSize:15];
    rightLogo.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:rightLogo];
    [rightLogo makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(verticalView.right).offset(20);
        make.centerY.equalTo(verticalView.centerY);
    }];
    
}


@end
