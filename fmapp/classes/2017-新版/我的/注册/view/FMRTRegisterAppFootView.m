//
//  FMRTRegisterAppFootView.m
//  fmapp
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRegisterAppFootView.h"

@interface FMRTRegisterAppFootView ()

@property (nonatomic, weak) UIButton *slectCtn,*sureBtn;

@end

@implementation FMRTRegisterAppFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    self.userInteractionEnabled = YES;
    UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slectCtn setImage:[UIImage imageNamed:@"未勾选icon"] forState:UIControlStateNormal];
    [slectCtn setImage:[UIImage imageNamed:@"勾选icon"] forState:UIControlStateSelected];
    [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [slectCtn setSelected:YES];
    self.slectCtn = slectCtn;
    [self addSubview:slectCtn];
    [slectCtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.top).offset(10);
        make.height.width.equalTo(12);
        make.left.equalTo(self.left).offset(15);
    }];
    
    UIButton *labelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [labelBtn setTitle:@"我已阅读并同意" forState:(UIControlStateNormal)];
    labelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [labelBtn addTarget:self action:@selector(labelSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [labelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self addSubview:labelBtn];
    [labelBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(slectCtn.centerY);
        make.left.equalTo(slectCtn.right).offset(5);
    }];
    
    UIButton *protocolBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [protocolBtn setTitle:@"《融托金融用户服务协议》" forState:(UIControlStateNormal)];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [protocolBtn setTitleColor:[UIColor colorWithHexString:@"#0159d5"] forState:(UIControlStateNormal)];
    [self addSubview:protocolBtn];
    [protocolBtn addTarget:self action:@selector(protocolAction) forControlEvents:UIControlEventTouchUpInside];

    [protocolBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(slectCtn.centerY);
        make.left.equalTo(labelBtn.right).offset(2);
    }];

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sureBtn setBackgroundImage:[UIImage imageNamed:@"微商_充值_确认充值"] forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5;
    [sureBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.sureBtn = sureBtn;
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.userInteractionEnabled = YES;
    sureBtn.enabled = NO;
    [self addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(protocolBtn.bottom).offset(50);
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.height.equalTo(45);
    }];
    
}

- (void)labelSelectAction:(UIButton *)sender{
    if (sender.selected) {
        self.slectCtn.selected = YES;
    }else{
        self.slectCtn.selected = NO;
    }
    sender.selected = !sender.selected;
    
    NSInteger semo = 0;
    
    
    if (self.slectCtn.selected) {
        semo = 1;
    }else{
        semo = 2;
    }
    
    if (self.labelBlcok) {
        self.labelBlcok(semo);
    }
}

- (void)bottomSelectAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    NSInteger semo = 0;

    if (self.slectCtn.selected) {
        semo = 1;
    }else{
        semo = 2;
    }
    
    if (self.labelBlcok) {
        self.labelBlcok(semo);
    }
}

- (void)protocolAction{
    if (self.protocolBlcok) {
        self.protocolBlcok();
    }
}

- (void)sureAction{
    
    if (self.sureBlcok) {
        self.sureBlcok();
    }
}

- (void)setSureType:(NSInteger)sureType{
    _sureType = sureType;
    
    if (sureType == 0) {
        [self.sureBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.sureBtn.enabled = NO;

    }else{
        [self.sureBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
        self.sureBtn.enabled = YES;

    }
    
}

@end
