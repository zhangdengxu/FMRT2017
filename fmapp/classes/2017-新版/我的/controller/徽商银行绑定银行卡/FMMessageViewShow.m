//
//  FMMessageViewShow.m
//  fmapp
//
//  Created by runzhiqiu on 2017/6/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMMessageViewShow.h"

@interface FMMessageViewShow ()<UITextViewDelegate>

@property (nonatomic, strong) UIView * backGroundButton;
@property (nonatomic, strong) UIView  * whiteViewContent;
@property (nonatomic,copy) NSMutableAttributedString *muString;

@property (nonatomic, strong) UILabel * titlelabel;
@property (nonatomic, strong) UITextView * contenltabel;
@property (nonatomic, strong) UIButton * bottomlabel;
@property (nonatomic,copy) messageViewShowButtonOnClickBlock block;

@end

@implementation FMMessageViewShow
-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.text = @"温馨提示";
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.textColor = [UIColor blackColor];
        _titlelabel.font = [UIFont systemFontOfSize:19];
        
    }
    return _titlelabel;
}
-(UITextView *)contenltabel
{
    if (!_contenltabel) {
        _contenltabel = [[UITextView alloc]init];
        _contenltabel.textAlignment = NSTextAlignmentLeft;
        _contenltabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _contenltabel.font = [UIFont systemFontOfSize:16];
        _contenltabel.linkTextAttributes = @{NSForegroundColorAttributeName: [HXColor colorWithHexString:@"#2280f6"],NSUnderlineColorAttributeName: [HXColor colorWithHexString:@"#666666"],NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)
                                             };
        
        _contenltabel.delegate = self;
        _contenltabel.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
        _contenltabel.scrollEnabled = NO;
        
    }
    return _contenltabel;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if (self.block) {
        self.block();
    }
    
    return YES;
}
-(UIButton *)bottomlabel
{
    if (!_bottomlabel) {
        _bottomlabel = [[UIButton alloc]init];
        
        [_bottomlabel setTitle:@"我知道了" forState:UIControlStateNormal];
        [_bottomlabel setTitleColor:[HXColor colorWithHexString:@"#2280f6"] forState:UIControlStateNormal];
        [_bottomlabel addTarget:self action:@selector(bottomlabelOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _bottomlabel;
}
-(void)bottomlabelOnClick
{
    [self removeFromSuperview];

}

-(void)removeAllViewFromSuperView
{
    [self removeFromSuperview];
}
-(void)backGroundButtonOnClick:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(UIView *)backGroundButton
{
    if (!_backGroundButton) {
        _backGroundButton = [[UIView alloc]init];
        _backGroundButton.userInteractionEnabled = YES;
        
        _backGroundButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
        [_backGroundButton addGestureRecognizer:tapGesture];
        
        
    }
    return _backGroundButton;
}


- (instancetype)initWithSuccess:(NSMutableAttributedString *)muString WithBlock:(messageViewShowButtonOnClickBlock)block;
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        self.muString = muString;
        self.block = block;
        
        [self addSubview:self.backGroundButton];
        [self.backGroundButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        
        UIView * whiteViewContent = [[UIView alloc]init];
        whiteViewContent.layer.cornerRadius = 7.0;
        whiteViewContent.layer.masksToBounds = YES;
        whiteViewContent.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteViewContent];
        CGFloat radio;
        if (KProjectScreenWidth < 350) {
            radio = 0.35;
        }else if (KProjectScreenWidth < 400)
        {
            radio = 0.30;
        }else
        {
            radio = 0.25;
        }
        [whiteViewContent makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(35);
            make.right.equalTo(self.mas_right).offset(-35);
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY).offset(-30);
            make.height.equalTo(self.height).multipliedBy(radio);
            
            
        }];
        
        [whiteViewContent addSubview:self.titlelabel];
        [self.titlelabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(whiteViewContent.centerX);
            make.top.equalTo(whiteViewContent.mas_top).offset(8);
        }];
        [whiteViewContent addSubview:self.contenltabel];
        [self.contenltabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(whiteViewContent);
            make.left.equalTo(whiteViewContent.mas_left).offset(16);
            make.right.equalTo(whiteViewContent.mas_right).offset(-16);

            
        }];
        [whiteViewContent addSubview:self.bottomlabel];
        
        [self.bottomlabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(whiteViewContent.centerX);
            make.bottom.equalTo(whiteViewContent.mas_bottom).offset(-8);
        }];
        self.contenltabel.attributedText = muString;
        
    }
    return self;
}


+(instancetype)showFMMessageViewShow:(NSMutableAttributedString *)muString WithBolok:(messageViewShowButtonOnClickBlock)block;
{
    FMMessageViewShow * show = [[FMMessageViewShow alloc]initWithSuccess:muString WithBlock:block];
    return show;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
