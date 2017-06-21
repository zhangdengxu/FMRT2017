//
//  YSInterestRateCoupon.m
//  fmapp
//
//  Created by yushibo on 2016/9/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSInterestRateCoupon.h"

@interface YSInterestRateCoupon ()
@end
@implementation YSInterestRateCoupon
-(instancetype)initWithFrame:(CGRect)frame andWithJiaxiText:(NSString *)jiaxiText{
    
    if (self = [super initWithFrame:frame]) {
        self.jiaxiText = jiaxiText;
        

    }
    return self;
    
}
- (void)createContentView{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    /**
     *  背景backView
     */
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
        make.height.equalTo(KProjectScreenHeight/4);
    }];
    /**
     * 恭喜您!
     */
    UILabel *gongxiLabel = [[UILabel alloc]init];
    gongxiLabel.text = @"恭喜您!";
    gongxiLabel.font = [UIFont boldSystemFontOfSize:21];
    gongxiLabel.textColor = [UIColor colorWithHexString:@"#fc683d"];
    [backView addSubview:gongxiLabel];
    [gongxiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY).offset(-(KProjectScreenHeight / 16));
    }];
    /**
     *  加息券
     */
    UILabel *jiaxiLabel = [[UILabel alloc]init];
    jiaxiLabel.font = [UIFont boldSystemFontOfSize:16];
    jiaxiLabel.text = [NSString stringWithFormat:@"%@",self.jiaxiText];
    [jiaxiLabel setTextAlignment:NSTextAlignmentCenter];
    jiaxiLabel.textColor = [UIColor colorWithHexString:@"#fc683d"];
    [backView addSubview:jiaxiLabel];
    [jiaxiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(gongxiLabel.mas_bottom).offset(KProjectScreenHeight/32);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
    }];
    /**
     *  确定按钮
     */
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0f5ed2"];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(backView.mas_bottom);
        make.height.equalTo(KProjectScreenHeight / 16);
    }];
    
    [backView.layer setCornerRadius:4.0f];
    [backView.layer setMasksToBounds:YES];
    [backView setAlpha:1.0f ];
    [backView setUserInteractionEnabled:YES];
}
- (void)sureAction:(UIButton *)button{
    
    [self removeFromSuperview];
}

@end
