//
//  XZChooseTicketFooter.m
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//  选择抵价券

#import "XZChooseTicketFooter.h"
#import "XZChooseTicketModel.h" // model

@interface XZChooseTicketFooter ()
// 暂无抵价券
@property (nonatomic, strong) UILabel *labelNoTicket;
// 查看已使用和过期抵价券
@property (nonatomic, strong) UIButton *btnLook;
@end

@implementation XZChooseTicketFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChooseTicketFooter];
    }
    return self;
}

- (void)setUpChooseTicketFooter {
    self.backgroundColor = XZBackGroundColor;
    
    // 暂无抵价券
    UILabel *labelNoTicket = [[UILabel alloc] init];
    [self addSubview:labelNoTicket];
    [labelNoTicket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
    self.labelNoTicket = labelNoTicket;
    labelNoTicket.text = @"暂无抵价券";
    labelNoTicket.textColor = XZColor(51, 51, 51);
    
    // 查看已使用和过期抵价券
    UIButton *btnLook = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnLook];
    [btnLook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(labelNoTicket.mas_bottom).offset(10);
    }];
    self.btnLook = btnLook;
    [btnLook setTitleColor:XZColor(153, 153, 153) forState:UIControlStateNormal];
    [btnLook setTitle:@"查看已使用和过期抵价券>" forState:UIControlStateNormal];
    [btnLook addTarget:self action:@selector(didClickUsedAndOverDueTicket) forControlEvents:UIControlEventTouchUpInside];
}

// 点击了查看已使用和过期抵价券
- (void)didClickUsedAndOverDueTicket {
    if (self.blockUsedAndOverdue) {
        self.blockUsedAndOverdue();
    }
}

- (void)setModelChoose:(XZChooseTicketModel *)modelChoose {
    _modelChoose = modelChoose;
    if (modelChoose.isNoData) { // 没数据
        self.labelNoTicket.hidden = NO;
        [self.btnLook mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.labelNoTicket.mas_bottom).offset(10);
        }];
    }else { // 有数据
        self.labelNoTicket.hidden = YES;
        [self.btnLook mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
}

@end
