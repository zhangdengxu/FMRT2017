//
//  FMRTCenterFourView.m
//  fmapp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTCenterFourView.h"


@interface FMRTCenterFourView ()

@property (nonatomic, weak)UIImageView *imageView,*automicImageView,*tradeImageView,*acountImageView;
@property (nonatomic, weak)UILabel *label,*automicLabel,*tradeLabel,*acountLabel;

@end
@implementation FMRTCenterFourView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    UIButton *myPriseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:myPriseButton];
    myPriseButton.tag = 701;
    [myPriseButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [myPriseButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self);
        make.width.height.equalTo(KProjectScreenWidth/4);
    }];
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    [myPriseButton addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(myPriseButton.mas_centerY).offset(-13);
        make.centerX.equalTo(myPriseButton.mas_centerX);
        make.height.width.equalTo(@25);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    self.label = label;
    label.font = [UIFont systemFontOfSize:KProjectScreenWidth < 375?14:15];
    label.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    [myPriseButton addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(13).priorityHigh();
        make.centerY.equalTo(self.mas_centerY).offset(20);
        make.centerX.equalTo(myPriseButton.mas_centerX);
        
    }];
    
    UIButton *automicButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    automicButton.tag = 702;
    [self addSubview:automicButton];
    [automicButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [automicButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(myPriseButton.mas_right);
        make.width.height.equalTo(KProjectScreenWidth/4);
    }];
    UIImageView *automicImageView = [[UIImageView alloc]init];
    self.automicImageView = automicImageView;
    automicImageView.contentMode = UIViewContentModeScaleAspectFill;
    [automicButton addSubview:automicImageView];
    [automicImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(automicButton.mas_centerY).offset(-13);
        make.centerX.equalTo(automicButton.mas_centerX);
        make.height.width.equalTo(@25);
        
    }];
    
    UILabel *automicLabel = [[UILabel alloc]init];
    self.automicLabel = automicLabel;

    automicLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    
    automicLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth < 375?14:15];
    [automicButton addSubview:automicLabel];
    [automicLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(automicImageView.mas_bottom).offset(13).priorityHigh();
        make.centerY.equalTo(self.mas_centerY).offset(20);
        make.centerX.equalTo(automicButton.mas_centerX);
    }];
    
    
    UIButton *tradeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    tradeButton.tag = 703;
    [self addSubview:tradeButton];
    [tradeButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [tradeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(automicButton.mas_right);
        make.width.height.equalTo(KProjectScreenWidth/4);
    }];
    UIImageView *tradeImageView = [[UIImageView alloc]init];
    self.tradeImageView = tradeImageView;
    tradeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [tradeButton addSubview:tradeImageView];
    [tradeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tradeButton.mas_centerY).offset(-13);
        make.centerX.equalTo(tradeButton.mas_centerX);
        make.height.width.equalTo(@25);
        
    }];
    
    UILabel *tradeLabel = [[UILabel alloc]init];
    self.tradeLabel = tradeLabel;
    tradeLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    
    tradeLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth < 375?14:15];
    [tradeButton addSubview:tradeLabel];
    [tradeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tradeImageView.mas_bottom).offset(13).priorityHigh();
        make.centerY.equalTo(self.mas_centerY).offset(20);
        make.centerX.equalTo(tradeButton.mas_centerX);
    }];
    
    UIButton *acountButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    acountButton.tag = 704;
    [self addSubview:acountButton];
    [acountButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [acountButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(tradeButton.mas_right);
        make.width.height.equalTo(KProjectScreenWidth/4);
    }];
    UIImageView *acountImageView = [[UIImageView alloc]init];
    self.acountImageView = acountImageView;
    [acountButton addSubview:acountImageView];
    [acountImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(acountButton.mas_centerY).offset(-15);
        make.centerX.equalTo(acountButton.mas_centerX);
        make.height.width.equalTo(@25);
        
    }];
    
    UILabel *acountLabel = [[UILabel alloc]init];
    self.acountLabel = acountLabel;
    acountLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    
    acountLabel.font = [UIFont systemFontOfSize:KProjectScreenWidth < 375?14:15];
    [acountButton addSubview:acountLabel];
    [acountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acountImageView.mas_bottom).offset(13).priorityHigh();
        make.centerY.equalTo(self.mas_centerY).offset(20);
        make.centerX.equalTo(acountButton.mas_centerX);
    }];
    
    self.imageView.image = [UIImage imageNamed:@"首页_平台数据_1702"];
    self.label.text = @"平台数据";
    self.automicImageView.image = [UIImage imageNamed:@"首页_安全保障_1702"];
    self.automicLabel.text = @"安全保障";
    self.tradeImageView.image = [UIImage imageNamed:@"首页_优商城_1702"];
    self.tradeLabel.text = @"优商城";
    self.acountImageView.image = [UIImage imageNamed:@"首页_邀请好友_1702"];
    self.acountLabel.text = @"邀请好友";
    
    /*
    UIView *firstLine = [[UIView alloc]init];
    firstLine.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:firstLine];
    [firstLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).dividedBy(2);
        make.width.equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
    
    UIView *secondLine = [[UIView alloc]init];
    secondLine.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:secondLine];
    [secondLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
    
    UIView *thirdLine = [[UIView alloc]init];
    thirdLine.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:thirdLine];
    [thirdLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        make.width.equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
     
     */
}

- (void)buttonAction:(UIButton *)sender{
    if (self.fourBlock) {
        self.fourBlock(sender.tag);
    }
}

@end
