//
//  FMShowWaitView.m
//  fmapp
//
//  Created by runzhiqiu on 16/7/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShowWaitView.h"
#import "UIImageView+FMGifImageCateGory.h"
#import "YFGIFImageView.h"



@interface FMShowWaitView ()

@property (nonatomic, weak) UIView * fatherView;

@property (nonatomic, strong) UIView * backGroundView;
@property (nonatomic, strong) YFGIFImageView * gitImage;

@property (nonatomic, strong) UIImageView * failImageView;
@property (nonatomic, strong) UIButton * reloadButton;

@end

@implementation FMShowWaitView


-(UIImageView *)failImageView
{
    if (!_failImageView) {
        _failImageView = [[UIImageView alloc]initWithFrame:self.fatherView.bounds];
        [_failImageView setImage:[UIImage imageNamed:@"未标题-1.png"]];
        _failImageView.userInteractionEnabled = NO;
        
    }
    return _failImageView;
}
-(UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 35)];
        _reloadButton.center = CGPointMake(self.fatherView.frame.size.width * 0.5, self.fatherView.frame.size.height * 0.75);
        _reloadButton.layer.borderWidth = 1;
        _reloadButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reloadButton.layer.cornerRadius = 3.0;
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _reloadButton;
}

-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.frame = self.fatherView.bounds;
        _backGroundView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _backGroundView;
}

-(YFGIFImageView *)gitImage
{
    if (!_gitImage) {
        _gitImage = [[YFGIFImageView alloc]init];
        _gitImage.frame = CGRectMake(0, 0, self.fatherView.frame.size.width * 0.8, self.fatherView.frame.size.width * 0.75);
        _gitImage.center = CGPointMake(self.backGroundView.frame.size.width * 0.5, self.backGroundView.frame.size.height * 0.35);
        
        NSString  *gifPath=[[NSBundle mainBundle] pathForResource:@"jiazaizhongGif" ofType:@"gif"];
        _gitImage.backgroundColor=[UIColor clearColor];
        
        _gitImage.gifPath=gifPath;
        _gitImage.userInteractionEnabled = NO;
        
        
    }
    return _gitImage;
}


-(void)showViewWithFatherView:(UIView *)fatherView;
{
    self.isRefresh = NO;
    self.fatherView = fatherView;
    
    if (self.waitType == FMShowWaitViewTpyeFitDeleteNavigation) {
        self.frame = CGRectMake(0, 64, self.fatherView.bounds.size.width, self.fatherView.bounds.size.height - 64);
    }else
    {
        self.frame = fatherView.bounds;
    }
    
    
    [self addSubview:self.backGroundView];
    [self sendSubviewToBack:self.backGroundView];
    
    [self addSubview:self.gitImage];
    [self.gitImage startGIF];
    [self.fatherView addSubview:self];
    [self.fatherView bringSubviewToFront:self];
    self.failImageView.hidden = YES;
    self.reloadButton.hidden = YES;

    
}
-(void)hiddenGifView;
{
    [self.gitImage stopGIF];
//    [self.backGroundView removeFromSuperview];
//    [self.gitImage removeFromSuperview];

    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self removeFromSuperview];
}


-(void)showLoadDataFail:(UIView *)fatherView;
{
    self.fatherView = fatherView;
    if (self.waitType == FMShowWaitViewTpyeFitDeleteNavigation) {
        self.frame = CGRectMake(0, 64, self.fatherView.bounds.size.width, self.fatherView.bounds.size.height - 64);
    }else
    {
        self.frame = fatherView.bounds;
    }
    [self addSubview:self.backGroundView];
    [self sendSubviewToBack:self.backGroundView];
    
    [self addSubview:self.failImageView];
    
    [self addSubview:self.reloadButton];
    [self bringSubviewToFront:self.reloadButton];
    
    [self.fatherView addSubview:self];
    [self.fatherView bringSubviewToFront:self];
    self.failImageView.hidden = NO;
    self.reloadButton.hidden = NO;

    
}
-(void)buttonOnClick
{
    self.isRefresh = YES;
    if (self.loadBtn) {
        self.loadBtn();
    }
    
    [self.backGroundView removeFromSuperview];
    [self.failImageView removeFromSuperview];
    [self.reloadButton removeFromSuperview];
    
    
    [self removeFromSuperview];
    [self showViewWithFatherView:self.fatherView];
    
}


@end
