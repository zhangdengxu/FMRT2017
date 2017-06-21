//
//  YSShareSkipViewController.m
//  fmapp
//
//  Created by yushibo on 16/8/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSShareSkipViewController.h"


@interface YSShareSkipViewController ()

@end

@implementation YSShareSkipViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpContent];
    
}

- (void)setUpContent{

//    self.definesPresentationContext = YES; //self is presenting view controller
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    UIImageView *closeView = [[UIImageView alloc]init];
    closeView.image = [UIImage imageNamed:@"关闭_03"];
    closeView.userInteractionEnabled = YES;
    [self.view addSubview:closeView];
    [closeView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    /**  覆盖点击button */
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.and.top.equalTo(closeView);
        
    }];
    
    /**  钱包 */
    UIImageView *walletView = [[UIImageView alloc]init];
    walletView.image = [UIImage imageNamed:@"钱包_03"];
    [self.view addSubview:walletView];
    [walletView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-(KProjectScreenHeight / 25));
    }];
    
    /**  恭喜您获得 */
    UILabel *upLabel = [[UILabel alloc]init];
    upLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    upLabel.text = @"恭喜您获得";
    upLabel.font = [UIFont systemFontOfSize:14];
    [walletView addSubview:upLabel];
    [upLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.centerY.equalTo(walletView.mas_centerY);
    }];
    
    /**  现金额 */
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    moneyLabel.text = @"5元";
    moneyLabel.text = self.moneyLabel;
    moneyLabel.font = [UIFont boldSystemFontOfSize:28];
    [walletView addSubview:moneyLabel];
    [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.top.equalTo(upLabel.mas_bottom);
    }];

    /**  抵价券 */
    UILabel *downLabel = [[UILabel alloc]init];
    downLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    downLabel.text = @"抵价券";
    downLabel.font = [UIFont systemFontOfSize:17];
    [walletView addSubview:downLabel];
    [downLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.top.equalTo(moneyLabel.mas_bottom);
    }];

    /**  使用说明 */
    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.text = @"仅限优商城限时秒杀、竞拍活动使用";
    explainLabel.font = [UIFont boldSystemFontOfSize:11];
    explainLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    [self.view addSubview:explainLabel];
    [explainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.centerY.equalTo(walletView.mas_bottom).offset(KProjectScreenHeight / 18);
    }];
    
    /**  左星星 */
    UIImageView *leftStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [self.view addSubview:leftStar];
    [leftStar makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(explainLabel.mas_left).offset(-(KProjectScreenWidth / 25));
        make.centerY.equalTo(explainLabel.mas_centerY).offset(-1);
    }];
    
    /**  右星星 */
    UIImageView *rightStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [self.view addSubview:rightStar];
    [rightStar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(explainLabel.mas_right).offset(KProjectScreenWidth / 25);
        make.centerY.equalTo(explainLabel.mas_centerY).offset(-1);
    }];
    
    /**  查看button */
    UIButton *checkBtn = [[UIButton alloc]init];
    [checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    checkBtn.layer.cornerRadius = 5;
    checkBtn.titleLabel.textColor = [UIColor whiteColor];
    checkBtn.backgroundColor = [UIColor colorWithHexString:@"#eb1540"];
    checkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    checkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    [checkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(explainLabel.mas_centerX);
        make.centerY.equalTo(explainLabel.mas_centerY).offset(KProjectScreenHeight / 12);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    
    
}
- (void)closeAction:(UIGestureRecognizer *)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkAction:(UIButton *)button{

    Log(@"你好哇!");
}
@end
