//
//  XZChooseTicketHeader.m
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//  选择抵价券

#import "XZChooseTicketHeader.h"

@implementation XZChooseTicketHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChooseTicketHeader];
    }
    return self;
}

- (void)setUpChooseTicketHeader {
    self.backgroundColor = XZBackGroundColor;
    
    // 每单购物仅可使用一张
    UILabel *labelTop = [[UILabel alloc] init];
    [self addSubview:labelTop];
    [labelTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(1);
        make.height.equalTo(@29);
    }];
    labelTop.backgroundColor = [UIColor whiteColor];
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.text = @"每单购物仅可使用一张";
    labelTop.textColor = XZColor(153, 153, 153);
    labelTop.font = [UIFont systemFontOfSize:15.0f];
    
    // 使用说明
    UIButton *btnDirections = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnDirections];
    [btnDirections mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(labelTop.mas_bottom);
//        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    [btnDirections setTitle:@"  使用说明" forState:UIControlStateNormal];
//    [btnDirections setBackgroundColor:[UIColor greenColor]];
    [btnDirections.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDirections setImage:[UIImage imageNamed:@"新版_我的卡卷包_使用说明_36"] forState:UIControlStateNormal];
    [btnDirections setTitleColor:XZColor(51, 51, 51) forState:UIControlStateNormal];
    [btnDirections.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnDirections addTarget:self action:@selector(didiClickDirectionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel *labelDirections = [[UILabel alloc] init];
//    [self addSubview:labelDirections];
//    [labelDirections mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.right.equalTo(self).offset(-10);
//        make.top.equalTo(self).offset(1);
//        //        make.height.equalTo(@30);
//    }];
//    labelDirections.text = @"使用说明";
//    labelDirections.textColor = XZColor(51, 51, 51);
//    
//    //
//    UIImageView *imgSigh = [[UIImageView alloc] init];
//    [self addSubview:imgSigh];
//    [imgSigh mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(labelDirections.mas_left).offset(5);
//        make
//    }];
//    imgSigh.image = [UIImage imageNamed:@"新版_我的卡卷包_使用说明_36"];
}

- (void)didiClickDirectionBtn {
    if (self.blockDirection) {
        self.blockDirection();
    }
}

@end
