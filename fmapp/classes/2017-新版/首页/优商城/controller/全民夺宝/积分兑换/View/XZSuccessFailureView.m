//
//  XZSuccessFailureView.m
//  fmapp
//
//  Created by admin on 16/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//  积分兑换成功/失败

#import "XZSuccessFailureView.h"
#import "XZSuccessFailureModel.h"

@interface XZSuccessFailureView ()
/** 白色视图 */
@property (nonatomic, strong) UIView *viewWhite;
/** 成功/失败提醒 */
@property (nonatomic, strong) UILabel *labelSuccessFail;
/** 成功/失败图片 */
@property (nonatomic, strong) UIImageView *imgSuccessFail;
/** '点此查看'按钮 */
@property (nonatomic, strong) UIButton *btnLookUp;
/** '继续兑换'按钮 */
@property (nonatomic, strong) UIButton *btnContinueChange;
/** '其他方式获得'按钮 */
@property (nonatomic, strong) UIButton *btnAnotherGet;
/** '确定'按钮 */
@property (nonatomic, strong) UIButton *btnSure;
@end

@implementation XZSuccessFailureView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSuccessFailureView];
    }
    return self;
}

- (void)setUpSuccessFailureView {
//    self.backgroundColor = KDefaultOrBackgroundColor;
    // 遮盖
    UIView *cover = [[UIView alloc] init];
    [self addSubview:cover];
    cover.frame = self.frame;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    
    /** 白色视图 */
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 200 - 64, KProjectScreenWidth, 200)];
    [self addSubview:viewWhite];
    viewWhite.backgroundColor = [UIColor whiteColor];
    self.viewWhite = viewWhite;
    
    /** 成功/失败提醒 */
    UILabel *labelSuccessFail = [[UILabel alloc] init];
    [self addSubview:labelSuccessFail];
    [labelSuccessFail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite);
        make.top.equalTo(viewWhite).offset(30);
    }];
    self.labelSuccessFail = labelSuccessFail;
//    labelSuccessFail.text = @"恭喜您成功兑换50枚夺宝币";
    
    /** 成功/失败图片 */
    UIImageView *imgSuccessFail = [[UIImageView alloc] init];
    [viewWhite addSubview:imgSuccessFail];
    [imgSuccessFail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelSuccessFail.mas_left).offset(-10);
        make.centerY.equalTo(labelSuccessFail);
        make.size.equalTo(@25);
    }];
    self.imgSuccessFail = imgSuccessFail;
    
    /** '点此查看'按钮 */
    UIButton *btnLookUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWhite addSubview:btnLookUp];
    [btnLookUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite);
        make.top.equalTo(labelSuccessFail.mas_bottom).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    [btnLookUp setTitle:@"点此查看" forState:UIControlStateNormal];
    [btnLookUp addTarget:self action:@selector(didClickHereToLookUp:) forControlEvents:UIControlEventTouchUpInside];
    btnLookUp.tag = 130;
    [btnLookUp setTitleColor:XZColor(255, 102, 51) forState:UIControlStateNormal];
    [btnLookUp.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.btnLookUp = btnLookUp;
    
    /** '确定'按钮 */
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWhite addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite);
        make.top.equalTo(btnLookUp.mas_bottom).offset(20);
        make.width.equalTo(btnLookUp);
        make.height.equalTo(@40);
    }];
    self.btnSure = btnSure;
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure setBackgroundColor:XZColor(1, 89, 213)];
    [btnSure addTarget:self action:@selector(didClickHereToLookUp:) forControlEvents:UIControlEventTouchUpInside];
    btnSure.tag = 140;
    
    /** '继续兑换'按钮 */
    UIButton *btnContinueChange = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWhite addSubview:btnContinueChange];
    [btnContinueChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewWhite.centerX).offset(-5);
        make.top.equalTo(btnLookUp.mas_bottom).offset(20);
        make.width.equalTo(@135);
        make.height.equalTo(@40);
    }];
    self.btnContinueChange = btnContinueChange;
    [btnContinueChange setTitle:@"继续兑换" forState:UIControlStateNormal];
    [btnContinueChange setBackgroundColor:XZColor(0, 51, 153)];
    [btnContinueChange addTarget:self action:@selector(didClickHereToLookUp:) forControlEvents:UIControlEventTouchUpInside];
    btnContinueChange.tag = 150;
    
    /** '其他方式获得'按钮 */
    UIButton *btnAnotherGet = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWhite addSubview:btnAnotherGet];
    [btnAnotherGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWhite.centerX).offset(5);
        make.top.equalTo(btnLookUp.mas_bottom).offset(20);
        make.width.equalTo(btnContinueChange);
        make.height.equalTo(@40);
    }];
    self.btnAnotherGet = btnAnotherGet;
    [btnAnotherGet setTitle:@"其他方式获得" forState:UIControlStateNormal];
    [btnAnotherGet setBackgroundColor:XZColor(0, 102, 204)];
    [btnAnotherGet addTarget:self action:@selector(didClickHereToLookUp:) forControlEvents:UIControlEventTouchUpInside];
    btnAnotherGet.tag = 160;
}

// 点击了"点此查看/确定"
- (void)didClickHereToLookUp:(UIButton *)button {
    if (button.tag == 150) { // 继续兑换
        [self removeFromSuperview];
    }else if (button.tag == 140 || button.tag == 160 || button.tag == 130) { // 确定 130 点击查看 140 确定 160 其他方式获得
        [self removeFromSuperview];
        if (self.blockLookUp) {
            self.blockLookUp(button);
        }
    }else {
        if (self.blockLookUp) {
            self.blockLookUp(button);
        }
    }
}

//- (void)setTextProfmpt:(NSString *)textProfmpt {
//    _textProfmpt = textProfmpt;
//    
//}

- (void)setModelSF:(XZSuccessFailureModel *)modelSF {
    _modelSF = modelSF;
    if (modelSF.isSuccess) { // 兑换成功
        NSMutableAttributedString *(^makeMoneyOrange)(NSString *) = ^(NSString *m) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:m];
            NSInteger length = [m length];
            [attrStr addAttribute:NSForegroundColorAttributeName value:XZColor(255, 102, 51) range:NSMakeRange(0, length)];
            NSMutableAttributedString *attrProfmpt = [[NSMutableAttributedString alloc]initWithString:@"恭喜您成功兑换"];
            NSAttributedString *attryuan = [[NSAttributedString alloc]initWithString:@"枚夺宝币"];
            [attrProfmpt appendAttributedString:attrStr];
            [attrProfmpt appendAttributedString:attryuan];
            return  attrProfmpt;
        };
        // 提示语
        self.labelSuccessFail.attributedText = makeMoneyOrange(modelSF.coinNumber);
        self.imgSuccessFail.image = [UIImage imageNamed:@"全新支付成功"];
        self.btnContinueChange.hidden = YES;
        self.btnAnotherGet.hidden = YES;
    }else { // 兑换失败
        self.imgSuccessFail.image = [UIImage imageNamed:@"全新支付失败"];
        self.labelSuccessFail.text = @"很抱歉，您的积分不足！";
        self.btnLookUp.userInteractionEnabled = NO;
        [self.btnLookUp setTitle:[NSString stringWithFormat:@"当前：%@积分",modelSF.currentInter] forState:UIControlStateNormal];
        self.btnSure.hidden = YES;
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self removeFromSuperview];
//}

@end
