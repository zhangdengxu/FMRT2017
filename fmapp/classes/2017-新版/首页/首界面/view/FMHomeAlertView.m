//
//  FMHomeAlertView.m
//  fmapp
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KAddsActivityShowViewMarGon 13
#import "FMHomeAlertView.h"

@interface FMHomeAlertView ()

@property (nonatomic, strong) NSDictionary *dataSoucre;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation FMHomeAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        [self createMainView];
    }
    return self;
}

- (void)createMainView{
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(40, 40 + 64, KProjectScreenWidth -80, KProjectScreenHeight - 200 )];
    [whiteView.layer setCornerRadius:6.0f];
    [whiteView.layer setMasksToBounds:YES];
    [whiteView setUserInteractionEnabled:YES];
    whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView = whiteView;
    [self addSubview:whiteView];
    
    UIButton  * cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth -40 - 10,30 + 64, 26.5f, 26.5f)];
    cancleButton.layer.cornerRadius = 13;
    [cancleButton setBackgroundColor:[UIColor whiteColor]];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"NearbyShops_Promotion_SubscribeBackImage"] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(hideAlerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
}

- (void)hideAlerView{
    
    [self removeFromSuperview];
}

-(void)showViewWithdict:(NSDictionary *)dataSource{
    
    if ([dataSource objectForKey:@"url"]) {
        NSString *url = dataSource[@"url"];
        UIWebView *alerContent=[[UIWebView alloc]initWithFrame:self.whiteView.bounds];
        [self.whiteView addSubview:alerContent];
        [alerContent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [alerContent sizeToFit];
    }

}


@end
