//
//  WLWenJuanView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLWenJuanView.h"
@interface WLWenJuanView()


@end
@implementation WLWenJuanView

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self setFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [self showSignView];
    }
    return self;
}


-(void)showSignView{
    
    CGRect rect = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*574/640);
//    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
//    rect.size.height = rect.size.width * 547/414+60;
    UIImageView *backgroundView = [[UIImageView alloc]init];
    [backgroundView setImage:[UIImage imageNamed:@"首页-红包背景_021_02_02"]];
    backgroundView.userInteractionEnabled = YES;
    self.backgroundView = backgroundView;
    self.backgroundView.frame = rect;
    self.backgroundView.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5-60);;
    [self addSubview:self.backgroundView];

    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(KProjectScreenWidth*3/4, 0, KProjectScreenWidth/4, KProjectScreenWidth*574/3200)];
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:closeBtn];
    
    //立即参与
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:249/255.0f green:219/255.0f blue:91/255.0f alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:249/255.0f green:219/255.0f blue:91/255.0f alpha:1])
                                     forState:UIControlStateHighlighted];
    [personalLogoOutButton addTarget:self
                              action:@selector(userLoginOut:)
                    forControlEvents:UIControlEventTouchUpInside];
    personalLogoOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    
    [personalLogoOutButton setTitle:@"立即参与" forState:UIControlStateNormal];
    
    [personalLogoOutButton setTitleColor:[UIColor redColor]
                                forState:UIControlStateNormal];
    
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:4.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrBackgroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [self.backgroundView addSubview:personalLogoOutButton];
    [personalLogoOutButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-15);
        make.width.equalTo(KProjectScreenWidth/3);
        make.height.equalTo(40);
        make.centerX.equalTo(self.backgroundView.centerX);
    }];

}

-(void)closeAction:(UIButton *)button{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)hiddenSignView{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)btn{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)linkAction:(UIButton *)button{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
    
}

-(void)userLoginOut:(UIButton *)button{
//立即参与
    if (self.blockWenJuanBtn) {
        self.blockWenJuanBtn();
    }
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];

}

@end
