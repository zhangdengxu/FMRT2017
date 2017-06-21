//
//  FMRTAddCardToView.m
//  fmapp
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTAddCardToView.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation FMRTAddCardToView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UIButton *blackView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    blackView.backgroundColor = [UIColor colorWithHexString:@"1e1e1e" alpha:0.7];
    [blackView addTarget:self action:@selector(viewForHide) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:blackView];
    [blackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *bottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微商_注册:取现_盾牌2"]];
    bottomView.userInteractionEnabled = YES;
    bottomView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:bottomView];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).offset(-20);
        make.width.equalTo(KProjectScreenWidth/672*594);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?13:15];
    titleLabel.textColor = [HXColor colorWithHexString:@"333333"];
    titleLabel.text = @"为了保障您的资金安全，须绑定银行卡\n确保资金同卡进出";
    titleLabel.numberOfLines = 0;
    [UILabel changeLineSpaceForLabel:titleLabel WithSpace:5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX);
        make.bottom.equalTo(bottomView.centerY).offset(-10);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"微商_注册:取现_绑定蓝色图标"] forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?13:15];
    [rightBtn setTitle:@"立即绑卡" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:rightBtn];
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(bottomView.centerY).offset(10);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?11:13];
    bottomLabel.textColor = [HXColor colorWithHexString:@"999999"];
    bottomLabel.text = @"融托金融智能加密，确保您的用卡安全";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:bottomLabel];
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(rightBtn.bottom).offset(20);
    }];
    
    UIImageView *keyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微商_注册:取现_钥匙"]];
    keyView.userInteractionEnabled = YES;
    keyView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:keyView];
    
    [keyView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomLabel.left);
        make.centerY.equalTo(bottomLabel.centerY);
    }];
    
    UIImageView *closeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微商_弹窗_关闭"]];
    closeView.userInteractionEnabled = NO;
    closeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:closeView];
    
    [closeView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.centerX);
        make.top.equalTo(bottomView.bottom);
    }];
}

- (void)rightAction{
    if (self.addCardBlock) {
        self.addCardBlock();
    }
    [self removeFromSuperview];
}

- (void)viewForHide{
    if (self.closeCardBlock) {
        self.closeCardBlock();
    }
    [self removeFromSuperview];
}

+(void)showWithAddBtn:(void (^)())clickBlcok{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    FMRTAddCardToView *cardView = [FMRTAddCardToView sharedCardView];
    cardView.frame = window.bounds;
    cardView.addCardBlock = ^(){
        if (clickBlcok) {
            clickBlcok();
        }
    };
    [window addSubview:cardView];
}

+(void)showWithAddBtn:(void (^)())clickBlcok hidView:(void (^)())closeBlcok;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    FMRTAddCardToView *cardView = [FMRTAddCardToView sharedCardView];
    cardView.frame = window.bounds;
    cardView.addCardBlock = ^(){
        if (clickBlcok) {
            clickBlcok();
        }
    };
    cardView.closeCardBlock = ^(){
        if (closeBlcok) {
            closeBlcok();
        }
    };
    [window addSubview:cardView];
}

+(instancetype)sharedCardView{
    return [[FMRTAddCardToView alloc]init];
}

@end
