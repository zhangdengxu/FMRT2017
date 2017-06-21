//
//  XZContactServicesFooter.m
//  fmapp
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 yk. All rights reserved.
//  联系客服的footerView

#import "XZContactServicesFooter.h"

@interface XZContactServicesFooter ()
@property (nonatomic, strong) UIView *viewWechat;
@end

@implementation XZContactServicesFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpContactServicesFooter];
    }
    return self;
}
    
- (void)setUpContactServicesFooter {
    UIView *background = [[UIView alloc] init];
    [self addSubview:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    background.backgroundColor = [UIColor whiteColor];
    
    UIView *viewQQ = [[UIView alloc] init];
    [background addSubview:viewQQ];
    [viewQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background.mas_left).offset(5);
//        make.right.equalTo(background.mas_centerX).offset(-2);
        make.bottom.equalTo(background.mas_bottom).offset(-5);
        make.centerY.equalTo(background.mas_centerY);
        make.width.equalTo(((KProjectScreenWidth - 44) / 2.0 - 5));
    }];
    viewQQ.backgroundColor = XZColor(6, 63, 142);
    CGFloat offSet = 10 * KProjectScreenWidth / 320.0;
    
    /** QQ */
    UIImageView *imgQQ = [[UIImageView alloc] init];
    [viewQQ addSubview:imgQQ];
    [imgQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewQQ.mas_left).offset(offSet);
        make.centerY.equalTo(viewQQ.mas_centerY);
        make.height.equalTo(@(46 * 0.7));
        make.width.equalTo(@(41 * 0.7));
    }];
    imgQQ.image = [UIImage imageNamed:@"QQ"];
    
    UILabel *labelQQ = [[UILabel alloc] init];
    [viewQQ addSubview:labelQQ];
    [labelQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgQQ.mas_right).offset(offSet);
        make.top.equalTo(imgQQ.mas_top);
    }];
    labelQQ.font = [UIFont systemFontOfSize:13];
    labelQQ.textColor = [UIColor whiteColor];
    labelQQ.text = @"QQ客服";
    
    UILabel *labelQQPhone = [[UILabel alloc] init];
    [viewQQ addSubview:labelQQPhone];
    [labelQQPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelQQ.mas_left);
        make.bottom.equalTo(imgQQ.mas_bottom).offset(3);
    }];
    labelQQPhone.font = [UIFont systemFontOfSize:13];
    labelQQPhone.textColor = [UIColor whiteColor];
    labelQQPhone.text = @"2718534215";
    
    UIView *viewWechat = [[UIView alloc] init];
    [background addSubview:viewWechat];
    [viewWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewQQ.mas_right).offset(4); // 4
        make.width.equalTo(viewQQ.mas_width);
        make.height.equalTo(viewQQ.mas_height);
        make.centerY.equalTo(background.mas_centerY);
    }];
    self.viewWechat = viewWechat;
    viewWechat.backgroundColor = XZColor(217, 45, 64);
    
    /** Phone */
    UIImageView *imgWechat = [[UIImageView alloc] init];
    [viewWechat addSubview:imgWechat];
    [imgWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWechat.mas_left).offset(offSet);
        make.centerY.equalTo(viewWechat.mas_centerY);
        make.height.equalTo(@(46 * 0.6));
        make.width.equalTo(@(41 * 0.6));
    }];
    imgWechat.image = [UIImage imageNamed:@"电话"];
    
    UILabel *labelWechat = [[UILabel alloc] init];
    [viewWechat addSubview:labelWechat];
    [labelWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgWechat.mas_right).offset(10);
        //        make.right.equalTo(imgQQ.mas_left).offset(20);
        make.top.equalTo(imgWechat.mas_top);
    }];
    labelWechat.font = [UIFont systemFontOfSize:13];
    labelWechat.textColor = [UIColor whiteColor];
    labelWechat.text = @"拨打电话";
    
    UILabel *labelPhone = [[UILabel alloc] init];
    [viewWechat addSubview:labelPhone];
    [labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelWechat.mas_left);
        make.bottom.equalTo(imgWechat.mas_bottom).offset(3);
    }];
    labelPhone.font = [UIFont systemFontOfSize:13];
    labelPhone.textColor = [UIColor whiteColor];
    labelPhone.text = @"400-8788686";
 
    UIButton *coverQQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewQQ addSubview:coverQQ];
    [coverQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewQQ.mas_left);
        make.right.equalTo(viewQQ.mas_right);
        make.top.equalTo(viewQQ.mas_top);
        make.bottom.equalTo(viewQQ.mas_bottom);
    }];
    [coverQQ addTarget:self action:@selector(didClickContactSerBtn:) forControlEvents:UIControlEventTouchUpInside];
    coverQQ.tag = 300;
    
    UIButton *coverPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWechat addSubview:coverPhone];
    [coverPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWechat.mas_left);
        make.right.equalTo(viewWechat.mas_right);
        make.top.equalTo(viewWechat.mas_top);
        make.bottom.equalTo(viewWechat.mas_bottom);
    }];
    [coverPhone addTarget:self action:@selector(didClickContactSerBtn:) forControlEvents:UIControlEventTouchUpInside];
    coverPhone.tag = 302;
    
}

- (void)setIsCommonProblem:(BOOL)isCommonProblem {
    _isCommonProblem = isCommonProblem;
    self.viewWechat.backgroundColor = XZColor(0, 102, 204) ;
}

- (void)didClickContactSerBtn:(UIButton *)button {
    if (self.blockContactServices) {
        self.blockContactServices(button);
    }
}

@end
