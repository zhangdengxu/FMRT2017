//
//  WLDuoBaoView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLDuoBaoView.h"
#import "ShareViewController.h"
@interface WLDuoBaoView()


@end

@implementation WLDuoBaoView

- (instancetype)initWithPic:(NSString *)pic andUrl:(NSString *)lianjie
{
    self = [super init];
    if (self) {
        self.pic = pic;
        self.lianjie = lianjie;
        [self setFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        //[self setFrame:CGRectMake(0, 0, 250, 370)];
        [self showSignView];
    }
    return self;
}


-(void)showSignView{
    
    CGRect rect = CGRectMake(0, 0, 250, 370);
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    rect.size.height = rect.size.width * 547/414+60;
    UIView *backgroundView = [[UIView alloc]init];
    self.backgroundView = backgroundView;
    self.backgroundView.frame = rect;
    self.backgroundView.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5-30);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundView];

    UIImageView *bjImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, rect.size.width, rect.size.height-60)];
    bjImageV.userInteractionEnabled = YES;
    //[bjImageV setImage:[UIImage imageNamed:@"全民夺宝1"]];
    [bjImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.pic]]];
    [self.backgroundView addSubview:bjImageV];
    
    UIButton *linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [linkBtn setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-60)];
    [linkBtn addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [bjImageV addSubview:linkBtn];

    
    UIImageView *closeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width-25.5, 7, 25.5, 53)];
    [closeImageV setImage:[UIImage imageNamed:@"全民夺宝2"]];
    
    closeImageV.userInteractionEnabled = YES;
    [self.backgroundView addSubview:closeImageV];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(0, 0, 25.5, 53)];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeImageV addSubview:closeBtn];
    
    [self.backgroundView.layer setCornerRadius:0];
    [self.backgroundView.layer setMasksToBounds:YES];
    [self.backgroundView setAlpha:1.0f ];
    [self.backgroundView setUserInteractionEnabled:YES];
        
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

    if (self.block) {
        self.block(self.lianjie);
    }
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
 
}

@end
