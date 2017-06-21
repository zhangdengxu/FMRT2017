//
//  YSStaticShareSkipView.m
//  fmapp
//
//  Created by yushibo on 16/8/17.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSStaticShareSkipView.h"

#import "UIImage+GIF.h"

@interface YSStaticShareSkipView ()
@property (nonatomic, strong)UILabel *moneyLabel;

@end
@implementation YSStaticShareSkipView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self  = [super initWithFrame:frame]) {
        
        [self creatContentView];
        self.userInteractionEnabled = YES;
        
    }
    return self;
    
}

- (void)creatContentView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    
    UIImageView *closeView = [[UIImageView alloc]init];
    closeView.image = [UIImage imageNamed:@"关闭_03"];
    closeView.userInteractionEnabled = YES;
    closeView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:closeView];
    [closeView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        if (KProjectScreenHeight > 480) {
            make.top.equalTo(self.mas_top).offset(30);
            
        }else{
            make.top.equalTo(self.mas_top).offset(10);

        }

    }];
    
    /**  覆盖点击button */
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.and.top.equalTo(closeView);
        
    }];
    
    /**  钱包 */
    UIImageView *walletView = [[UIImageView alloc]init];
    walletView.image = [UIImage imageNamed:@"钱包_03"];
    walletView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:walletView];
    [walletView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-(KProjectScreenHeight / 25));
   
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
//    moneyLabel.text = self.money;
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
        make.top.equalTo(moneyLabel.mas_bottom);
    }];
    
    /**  使用说明 */
    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.text = @"仅限优商城限时秒杀、竞拍活动使用";
    explainLabel.font = [UIFont boldSystemFontOfSize:11];
    explainLabel.textColor = [UIColor colorWithHexString:@"#f5ef65"];
    [self addSubview:explainLabel];
    [explainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(walletView.mas_centerX);
        make.centerY.equalTo(walletView.mas_bottom).offset(KProjectScreenHeight / 18);
    }];
    
    /**  左星星 */
    UIImageView *leftStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [self addSubview:leftStar];
    [leftStar makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(explainLabel.mas_left).offset(-(KProjectScreenWidth / 25));
        make.centerY.equalTo(explainLabel.mas_centerY).offset(-1);
    }];
    
    /**  右星星 */
    UIImageView *rightStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星_03"]];
    [self addSubview:rightStar];
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
    [self addSubview:checkBtn];
    [checkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(explainLabel.mas_centerX);
//        make.centerY.equalTo(explainLabel.mas_centerY).offset(KProjectScreenHeight / 12);
        make.width.equalTo(KProjectScreenWidth / 3);
        
        if (KProjectScreenHeight > 568) {
            make.bottom.equalTo(self.mas_bottom).offset(-70);

        }
        if (KProjectScreenHeight > 480) {
            
            make.bottom.equalTo(self.mas_bottom).offset(-35);
            
        }else{
            
            make.bottom.equalTo(self.mas_bottom).offset(-7);
        }
    }];
}

- (void)closeAction:(UIGestureRecognizer *)sender{
    
    Log(@"%s", __func__);
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
