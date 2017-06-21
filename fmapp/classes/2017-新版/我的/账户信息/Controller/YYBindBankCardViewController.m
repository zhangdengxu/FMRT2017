//
//  YYBindBankCardViewController.m
//  fmapp
//
//  Created by yushibo on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//  绑定银行卡

#import "YYBindBankCardViewController.h"

@interface YYBindBankCardViewController ()

@end

@implementation YYBindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self settingNavTitle:@"我的银行卡"];
    [self createContentView];
    
}
- (void)createContentView{
    /**
     *  背景backView
     */
    UIImageView *backView = [[UIImageView alloc]init];
    backView.image = [UIImage imageNamed:@"微商_注册:取现_绑定银行卡"];
    backView.userInteractionEnabled = YES;
//    backView.backgroundColor = [UIColor whiteColor];
//    backView.layer.masksToBounds = YES;
//    backView.layer.cornerRadius = 10.0;
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(15);
//        if (KProjectScreenWidth > 320) {
//            make.height.equalTo(@370);
//        }else{
            make.height.equalTo(@150);
//        }
    }];
    
    //绑定银行卡
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#999"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"绑定银行卡";
    [backView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX).offset(15);
    }];
    
    UIImageView *addView = [[UIImageView alloc]init];
    addView.image = [UIImage imageNamed:@"微商_注册:取现_加号"];
    [backView addSubview:addView];
    [addView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-10);
    }];
    
    /**   */
    UIButton *bindCardBtn = [[UIButton alloc]init];
    [bindCardBtn addTarget:self action:@selector(bindBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:bindCardBtn];
    [bindCardBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.height.equalTo(@100);
        make.width.equalTo(@240);
       
    }];

}
- (void)bindBtnAction{

    NSLog(@"%s", __func__);
}
@end
