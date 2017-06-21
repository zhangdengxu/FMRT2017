//
//  XZTransferRechargeView.m
//  fmapp
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//  转账充值弹窗

#import "XZTransferRechargeView.h"
#import "XZTransferRechargeModel.h"

@interface XZTransferRechargeView ()
//
@property (nonatomic, strong) UIView *blackBg;
//
@property (nonatomic, strong) UIView *whiteBg;
@property (nonatomic, strong) UIView *viewBlue;
// 微商_弹窗_柜台办理  64 * 66
@property (nonatomic, strong) UIImageView *imgPigeon;
//
@property (nonatomic, strong) UILabel *labelTitle;
//
@property (nonatomic, strong) UILabel *labelTitleEnglish;
//
@property (nonatomic, strong) UILabel *labelContent;
// 关闭按钮
@property (nonatomic, strong) UIButton *btnClosed;
//
@property (nonatomic, strong) UIWindow *window;
@end

@implementation XZTransferRechargeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTransferRechargeView];
    }
    return self;
}

- (void)setUpTransferRechargeView {
//    self.backgroundColor = KDefaultOrBackgroundColor;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.window = window;
    
    UIView *blackBg = [[UIView alloc] init];
    [window addSubview:blackBg];
    [blackBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    blackBg.backgroundColor = [UIColor blackColor];
    blackBg.alpha = 0.3;
    self.blackBg = blackBg;

    //
    UIView *whiteBg = [[UIView alloc] init];
    [window addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).offset(30);
        make.right.equalTo(window).offset(-30);
        make.centerY.equalTo(window);
        make.height.equalTo(KProjectScreenWidth - 60 - 30);
    }];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.masksToBounds = YES;
    whiteBg.layer.cornerRadius = 5.0f;
    self.whiteBg = whiteBg;
    
    //
    UIView *viewBlue = [[UIView alloc] init];
    [whiteBg addSubview:viewBlue];
    [viewBlue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg);
        make.left.equalTo(whiteBg);
        make.right.equalTo(whiteBg);
        make.height.equalTo(50);
    }];
    viewBlue.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    self.viewBlue = viewBlue;

    // 微商_弹窗_柜台办理  64 * 66
    UIImageView *imgPigeon = [[UIImageView alloc] init];
    [viewBlue addSubview:imgPigeon];
    [imgPigeon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewBlue.mas_centerX).offset(-20);
        make.centerY.equalTo(viewBlue);
        make.width.equalTo(64); //  * 0.9
        make.height.equalTo(66); //  * 0.9
    }];
    self.imgPigeon = imgPigeon;
    
    //
    UILabel *labelTitle = [[UILabel alloc] init];
    [viewBlue addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBlue.mas_centerX).offset(-10);
        make.bottom.equalTo(viewBlue.mas_centerY).offset(3);
    }];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:16.0f];
    self.labelTitle = labelTitle;
    
    //
    UILabel *labelTitleEnglish = [[UILabel alloc] init];
    [viewBlue addSubview:labelTitleEnglish];
    [labelTitleEnglish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.top.equalTo(labelTitle.mas_bottom);
    }];
    labelTitleEnglish.font = [UIFont systemFontOfSize:13.0f];
    labelTitleEnglish.textColor = [UIColor whiteColor];
    self.labelTitleEnglish = labelTitleEnglish;
    
    //
    UILabel *labelContent = [[UILabel alloc] init];
    [whiteBg addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(10);
        make.right.equalTo(whiteBg).offset(-10);
        make.top.equalTo(viewBlue.mas_bottom).offset(20);
    }];
    labelContent.textColor = [HXColor colorWithHexString:@"#333333"];
    labelContent.numberOfLines = 0;
    labelContent.font = [UIFont systemFontOfSize:15.0f];
    self.labelContent = labelContent;
    
    UIButton *btnClosed = [UIButton buttonWithType:UIButtonTypeCustom];
    [window addSubview:btnClosed];
    [btnClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg.mas_bottom).offset(30);
        make.centerX.equalTo(window.mas_centerX);
        make.height.and.width.equalTo(50);
    }];
    [btnClosed setImage:[UIImage imageNamed:@"微商_弹窗_关闭"] forState:UIControlStateNormal];
    [btnClosed addTarget:self action:@selector(didClickClosedButton) forControlEvents:UIControlEventTouchUpInside];
    self.btnClosed = btnClosed;
    
}

// 点击关闭按钮
- (void)didClickClosedButton {
    [self.blackBg removeFromSuperview];
    [self.viewBlue removeFromSuperview];
    [self.whiteBg removeFromSuperview];
    [self.btnClosed removeFromSuperview];
    [self removeFromSuperview];
    if (self.blockClosed) {
        self.blockClosed();
    }
}

- (void)setModelTransfer:(XZTransferRechargeModel *)modelTransfer {
    _modelTransfer = modelTransfer;
    
    self.labelTitle.text = modelTransfer.title;// @"柜台办理"
    self.labelTitleEnglish.text = modelTransfer.EnglishTitle; // @"B-COUNTER"
    // @"银行柜台转账需填写信息\n收款人：杨娟\n收款账号（徽商银行电子交易账号）：\n6236 6400 1000 0155 209\n收款开户行：徽商银行股份有限公司合肥花园街支行"
    self.labelContent.text = modelTransfer.content;
    if ([modelTransfer.content isEqualToString:@"网银转账只能在电脑端操作；"]) {
        self.labelContent.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.whiteBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.window).offset(30);
        make.right.equalTo(self.window).offset(-30);
        make.centerY.equalTo(self.window);
        make.height.equalTo(modelTransfer.contentHeight);
    }];
    
    //
    UIImage *imgIcon = [UIImage imageNamed:modelTransfer.iconName];
    [self.imgPigeon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewBlue.mas_centerX).offset(-20);
        make.centerY.equalTo(self.viewBlue);
        make.width.equalTo(imgIcon.size.width); //  * 0.9
        make.height.equalTo(imgIcon.size.height); //  * 0.9
    }];
    self.imgPigeon.image = imgIcon;
    
}

@end
