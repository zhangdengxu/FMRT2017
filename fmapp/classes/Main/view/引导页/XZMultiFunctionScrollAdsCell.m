//
//  XZMultiFunctionScrollAdsCell.m
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//  最后一个广告页或者只有一页的广告页

#import "XZMultiFunctionScrollAdsCell.h"
//#import "XZWeakTimer.h"

@interface XZMultiFunctionScrollAdsCell ()
@property (nonatomic, strong) UIImageView *imgView;

// 秒数
//@property (nonatomic, assign) int seconds;
@end

@implementation XZMultiFunctionScrollAdsCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMultiFunctionScrollAdsCell];
    }
    return self;
}

- (void)setUpMultiFunctionScrollAdsCell {
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    //    imgView.image = [UIImage imageNamed:@"data_empty_iv"];
    self.imgView = imgView;
    imgView.userInteractionEnabled = YES;
    
    // 创建四个button
    CGFloat height = KProjectScreenHeight / 4.0;
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgView addSubview:button];
        button.frame = CGRectMake(0, i * height, KProjectScreenWidth, height);
        button.tag = 500 + i;
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    }
    
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self addGestureRecognizer:recognizer];
    
    // "跳过"按钮
    UIButton *buttonJump = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonJump];
    self.buttonJump = buttonJump;
    [buttonJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    [buttonJump addTarget:self action:@selector(didClickButtonJump:) forControlEvents:UIControlEventTouchUpInside];
    [buttonJump setTitle:@"跳过" forState:UIControlStateNormal];
    buttonJump.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.55];
    buttonJump.layer.cornerRadius = 5.0;
    buttonJump.layer.masksToBounds = YES;
    
}

////
//- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
////    NSLog(@"左滑");
//    if (self.blockSwipeGestureLeft) {
//        self.blockSwipeGestureLeft(recognizer);
//    }
//}

// 点击cell上的每一个button
- (void)didClickButton:(UIButton *)button {
    if (self.blockCellButton) {
        self.blockCellButton(button);
    }
}

// 点击"跳过"按钮
- (void)didClickButtonJump:(UIButton *)button {
    if (self.blockJumpButton) {
        self.blockJumpButton(button);
    }
}

// 给一个网址
- (void)setModelPicUrl:(NSString *)modelPicUrl {
    _modelPicUrl = modelPicUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:modelPicUrl] placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
}

//// 是否跑秒
//- (void)setNoSeconds:(BOOL)noSeconds {
//    _noSeconds = noSeconds;
//    if (!noSeconds) { // No跑秒
//        self.buttonJump.hidden = NO;
////        [self buttonTimeReduce];
//    }else{
//        self.buttonJump.hidden = YES;
//    }
//}

@end
