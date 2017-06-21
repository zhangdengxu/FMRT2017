//
//  XZRedEnvelopeHeader.m
//  fmapp
//
//  Created by admin on 17/2/18.
//  Copyright © 2017年 yk. All rights reserved.
//  红包券的头视图

#import "XZRedEnvelopeHeader.h"
#import "XZRedEnvelopeModel.h"

@interface XZRedEnvelopeHeader ()

@property (nonatomic, strong) UIButton *btnUseful;

@property (nonatomic, strong) UIButton *btnNotUseful;

@property (nonatomic, strong) UILabel *labelLine;
@end

@implementation XZRedEnvelopeHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRedEnvelopeHeader];
    }
    return self;
}

- (void)setUpRedEnvelopeHeader {
    self.backgroundColor = [UIColor whiteColor];
//
    UIButton *btnUseful = [self createButtonWithX:0 title:@"" hasLine:YES tag:220];// （0）
    self.btnUseful = btnUseful;
    btnUseful.selected = YES;
    
    UILabel *labelLine = [self createLineAtButtonBottomWithButton:btnUseful];
    self.labelLine = labelLine;
    
    UIButton *btnNotUseful = [self createButtonWithX:KProjectScreenWidth / 2.0 title:@"" hasLine:NO  tag:221];
    self.btnNotUseful = btnNotUseful;
}

- (void)setModelRedEnv:(XZRedEnvelopeModel *)modelRedEnv {
    _modelRedEnv = modelRedEnv;
    
    __weak __typeof(&*self)weakSelf = self;
    
    if (modelRedEnv.isUseful) { // 可用
        if (modelRedEnv.isRedEnvelope) { // 红包券
            [self.btnUseful setTitle:[NSString stringWithFormat:@"%@（%zi）",@"可用红包券",modelRedEnv.countRedEnveUse] forState:UIControlStateNormal];
        }else {
            [self.btnUseful setTitle:[NSString stringWithFormat:@"%@（%zi）",@"可用加息券",modelRedEnv.countRedEnveUse] forState:UIControlStateNormal];
        }
        
        CGFloat width = [self widthWithButton:self.btnUseful];
        
        [UIView animateWithDuration:2.0 animations:^{
            [weakSelf.labelLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.btnUseful.mas_bottom).offset(-1);
                make.centerX.equalTo(weakSelf.btnUseful);
                make.width.equalTo(@(width));
                make.height.equalTo(@1);
            }];
        }];
        
        self.btnUseful.selected = YES;
        self.btnNotUseful.selected = NO;
        
    }else { // 不可用
        if (modelRedEnv.isRedEnvelope) { // 红包券
            [self.btnNotUseful setTitle:[NSString stringWithFormat:@"%@（%zi）",@"不可用红包券",modelRedEnv.countRedEnveNotUse] forState:UIControlStateNormal];
//            NSLog(@"%zi",modelRedEnv.countRedEnveNotUse);
        }else { // 加息券
            [self.btnNotUseful setTitle:[NSString stringWithFormat:@"%@（%zi）",@"不可用加息券",modelRedEnv.countRedEnveNotUse] forState:UIControlStateNormal];
        }
        
        CGFloat width = [self widthWithButton:self.btnNotUseful];
        
        [UIView animateWithDuration:2.0 animations:^{
            [weakSelf.labelLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.btnNotUseful.mas_bottom).offset(-1);
                make.centerX.equalTo(weakSelf.btnNotUseful);
                make.width.equalTo(@(width));
                make.height.equalTo(@1);
            }];
        }];
        self.btnNotUseful.selected = YES;
        self.btnUseful.selected = NO;
    }
}

// 用户没点击的时候不显示数量
- (void)setTitleWithModel:(XZRedEnvelopeModel *)modelRedTitle {
    if (modelRedTitle.isRedEnvelope) { // 红包券
        [self.btnUseful setTitle:@"可用红包券" forState:UIControlStateNormal];
        [self.btnNotUseful setTitle:@"不可用红包券" forState:UIControlStateNormal];

    }else { // 加息券
        [self.btnUseful setTitle:@"可用加息券" forState:UIControlStateNormal];
        [self.btnNotUseful setTitle:@"不可用加息券" forState:UIControlStateNormal];
    }
    
    CGFloat width = [self widthWithButton:self.btnUseful];
    
    [self.labelLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnUseful.mas_bottom).offset(-1);
        make.centerX.equalTo(self.btnUseful);
        make.width.equalTo(@(width));
        make.height.equalTo(@1);
    }];
}

- (UIButton *)createButtonWithX:(CGFloat)x title:(NSString *)title hasLine:(BOOL)hasLine tag:(NSInteger)tag {
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    button.frame = CGRectMake(x, 0, KProjectScreenWidth / 2.0, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[HXColor colorWithHexString:@"#ff5254"] forState:UIControlStateSelected];
    [button setTitleColor:[HXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[HXColor colorWithHexString:@"#ff5254"] forState:UIControlStateHighlighted];
//    button.backgroundColor = XZRandomColor;
    button.tag = tag;
    [button addTarget:self action:@selector(didClickButtonAtThisView:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGFloat)widthWithButton:(UIButton *)button {
    CGFloat width = [[button currentTitle] getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 40) WithFont:[UIFont systemFontOfSize:15.0f]].width + 5;
    return width;
}

- (UILabel *)createLineAtButtonBottomWithButton:(UIButton *)button {
    
    CGFloat width = [self widthWithButton:self.btnUseful];
    
    UILabel *label = [[UILabel alloc] init];
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(-1);
        make.centerX.equalTo(button);
        make.width.equalTo(@(width));
        make.height.equalTo(@1);
    }];
    label.backgroundColor = [HXColor colorWithHexString:@"#ff5254"];
    return label;
}

- (void)didClickButtonAtThisView:(UIButton *)button {
    if (self.blockRedEnvelope) {
        self.blockRedEnvelope(button);
    }
}

@end
