//
//  FMRTAllTakeBuySuccessView.m
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAllTakeBuySuccessView.h"


@interface FMRTAllTakeBuySuccessView ()

@property (nonatomic, strong)UILabel *nameLabel,*moneyLabel,*numberLabel;
@property (nonatomic, strong)UIButton *orderBtn,*mainBtn,*shareBtn;
@property (nonatomic, strong)UIImageView *statusView;
@property (nonatomic, strong)UIView *tlineView,*llineView;

@end
@implementation FMRTAllTakeBuySuccessView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"支付成功";
    titleLabel.textColor = [HXColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX).offset(10);
        make.top.equalTo(self.mas_top).offset(25);
    }];
    
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = [UIImage imageNamed:@"全新支付成功"];
    [self addSubview:photoView];
    [photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-8);
    }];
    
    UIView *flineView = [[UIView alloc]init];
    flineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:flineView];
    [flineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
        make.height.equalTo(@1);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(flineView.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    UIView *slineView = [[UIView alloc]init];
    slineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:slineView];
    [slineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    
    self.statusView.image = [UIImage imageNamed:@"全新1币得"];
    [self.statusView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(slineView.mas_bottom).offset(15);
        make.width.equalTo(@70);
        make.height.equalTo(@18);
    }];

    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.statusView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    UIView *tlineView = [[UIView alloc]init];
    self.tlineView = tlineView;
    tlineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:tlineView];
    [tlineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(self.statusView.mas_bottom).offset(15);
    }];
    

    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(tlineView.mas_bottom).offset(15);
    }];
    
    UIView *llineView = [[UIView alloc]init];
    self.llineView = llineView;
    llineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:llineView];
    [llineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(15);
    }];
    
    [self.mainBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(llineView.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@80);
        make.height.equalTo(@26);
    }];
    
    [self.orderBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(llineView.mas_bottom).offset(20);
        make.right.equalTo(self.mainBtn.mas_left).offset(-20);
        make.width.equalTo(@80);
        make.height.equalTo(@26);
    }];
    
    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(llineView.mas_bottom).offset(20);
        make.left.equalTo(self.mainBtn.mas_right).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@26);
    }];
    
}

- (void)orderAction{
    if (self.orderBlock) {
        self.orderBlock();
    }
}

- (void)mainAction{
    if (self.mainBlock) {
        self.mainBlock();
    }
}

- (void)shareAction{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (UIButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_orderBtn setBackgroundImage:[UIImage imageNamed:@"全新查看订单"] forState:(UIControlStateNormal)];
        [_orderBtn addTarget:self action:@selector(orderAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_orderBtn];

    }
    return _orderBtn;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"全新返回首页"] forState:(UIControlStateNormal)];
        [_mainBtn addTarget:self action:@selector(mainAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_mainBtn];

    }
    return _mainBtn;
}


- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"全新分享"] forState:(UIControlStateNormal)];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];

        [self addSubview:_shareBtn];
    }
    return _shareBtn;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_numberLabel];

    }
    return _numberLabel;
}

- (UIImageView *)statusView{
    if (!_statusView) {
        _statusView = [[UIImageView alloc]init];
        [self addSubview:_statusView];
    }
    return _statusView;
}

- (void)setModel:(FMRTAllTakeBuyResultModel *)model{
    _model = model;
    
    self.nameLabel.text = model.productName;

    if ([model.successStatus isEqualToString:@"DuobaobiSuccessOfPay"]) {
        
        NSString *price = model.money;
        NSString *titleAll = [NSString stringWithFormat:@"支付币数:%@",price];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
        NSRange range = [titleAll rangeOfString:price];
        [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
        self.moneyLabel.attributedText = attrStr;
        
        if (model.number) {
            NSString *number = model.number;
            NSString *numberAll = [NSString stringWithFormat:@"夺宝号码:%@",number];
            
            NSMutableAttributedString *numberaAttrStr = [[NSMutableAttributedString alloc]initWithString:numberAll];
            NSRange numberRange = [numberAll rangeOfString:number];
            [numberaAttrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:numberRange];
            self.numberLabel.attributedText = numberaAttrStr;
        }
        
        if ([model.duobaoStatus integerValue] == 5) {
            self.statusView.image = [UIImage imageNamed:@"全新5币得"];
        }else if([model.duobaoStatus integerValue] == 1){
            self.statusView.image = [UIImage imageNamed:@"全新1币得"];
        }
        
    }else if ([model.successStatus isEqualToString:@"OldFiriendPriceSuccessOfPay"]){
        
        NSString *price = model.money;
        NSString *titleAll = [NSString stringWithFormat:@"支付金额:%@",price];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
        NSRange range = [titleAll rangeOfString:price];
        [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
        self.moneyLabel.attributedText = attrStr;
        
        self.statusView.image = [UIImage imageNamed:@"全新老友价"];
        self.numberLabel.hidden = YES;
        [self.llineView remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@0.1);
            make.top.equalTo(self.tlineView.mas_bottom).offset(-1);
        }];
    }
}


@end
