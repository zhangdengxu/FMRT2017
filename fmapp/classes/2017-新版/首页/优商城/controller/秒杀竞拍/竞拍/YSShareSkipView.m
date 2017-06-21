//
//  YSShareSkipView.m
//  fmapp
//
//  Created by yushibo on 16/8/15.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSShareSkipView.h"

#import "UIImage+GIF.h"

@interface YSShareSkipView ()
@property (nonatomic, strong)UILabel *moneyLabel;
@end
@implementation YSShareSkipView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self  = [super initWithFrame:frame]) {
        
        [self creatContentView];
        self.userInteractionEnabled = YES;

    }
    return self;

}

- (void)creatContentView{

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];

    /** 钱包  */
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"1.gif" ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImageView *walletView = [[UIImageView alloc]init];
    walletView.image = [UIImage sd_animatedGIFWithData:imageData];
    [self addSubview:walletView];
    [self bringSubviewToFront:walletView];
    walletView.contentMode = UIViewContentModeScaleAspectFit;
    [walletView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);//-(KProjectScreenHeight / 25)
        make.centerY.equalTo(self.mas_centerY).offset(-55);
        make.height.equalTo(KProjectScreenHeight - 80);
        if (KProjectScreenWidth > 400) {
            make.width.equalTo(KProjectScreenWidth-20);
        }

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
    self.moneyLabel = moneyLabel;
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
        make.top.equalTo(upLabel.mas_bottom).offset(30);
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
    [walletView addSubview:checkBtn];
    [checkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.width.equalTo(KProjectScreenWidth / 3);

//        make.bottom.equalTo(self.mas_bottom).offset(-60);
        if (KProjectScreenHeight > 480) {

            make.bottom.equalTo(self.mas_bottom).offset(-100);
        
        }else{
        
            make.bottom.equalTo(self.mas_bottom).offset(-60);
        }
    
    }];
    
    /** 关闭按钮  */
    UIImageView *closeView = [[UIImageView alloc]init];
    closeView.image = [UIImage imageNamed:@"关闭_03"];
    closeView.contentMode = UIViewContentModeScaleAspectFit;
    closeView.userInteractionEnabled = YES;
    [walletView addSubview:closeView];
    [closeView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(30);
    }];
    
    walletView.userInteractionEnabled = YES;
    
    /**  覆盖点击button */
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [walletView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.and.top.equalTo(closeView);
        
    }];
    
    /**  使用说明 */
    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.text = @"仅限优商城限时秒杀、竞拍活动使用";
    explainLabel.font = [UIFont boldSystemFontOfSize:11];
    explainLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    [walletView addSubview:explainLabel];
    [explainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.centerY.equalTo(walletView.mas_centerY).offset(KProjectScreenHeight / 4);
    }];
    
    /**  左星星 */
    UIImageView *leftStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [walletView addSubview:leftStar];
    [leftStar makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(explainLabel.mas_left).offset(-(KProjectScreenWidth / 25));
        make.centerY.equalTo(explainLabel.mas_centerY).offset(-1);
    }];
    
    /**  右星星 */
    UIImageView *rightStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [walletView addSubview:rightStar];
    [rightStar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(explainLabel.mas_right).offset(KProjectScreenWidth / 25);
        make.centerY.equalTo(explainLabel.mas_centerY).offset(-1);
    }];

    
}

- (void)closeAction:(UIGestureRecognizer *)sender{

    [self removeFromSuperview];

}

- (void)checkAction:(UIButton *)button{
    
    if (self.blockBtn) {
        self.blockBtn(button);
    }
    [self removeFromSuperview];
    
}

- (void)setMoney:(NSString *)money{
    
    _money = money;
    self.moneyLabel.text = money;
}

@end
