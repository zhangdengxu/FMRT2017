//
//  FMRTAllTakeFailureOfDB.m
//  fmapp
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAllTakeFailureOfDB.h"


@interface FMRTAllTakeFailureOfDB ()

@property(nonatomic, strong)UILabel *currentDbLabel,*neededLabel;
@property(nonatomic, strong)UIButton *bottomBtn;


@end

@implementation FMRTAllTakeFailureOfDB

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
    titleLabel.text = @"支付失败";
    titleLabel.textColor = [HXColor colorWithHexString:@"#dc2a3b"];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).offset(10);
        make.top.equalTo(self.mas_top).offset(25);
    }];
    
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = [UIImage imageNamed:@"全新支付失败"];
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
    
    UILabel *alertLabel = [[UILabel alloc]init];
    alertLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    alertLabel.text = @"尊敬的用户，对不起您的夺宝币余额不足。";
    alertLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:alertLabel];
    [alertLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(flineView.mas_bottom).offset(15);
        
    }];

    UIView *slineView = [[UIView alloc]init];
    slineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:slineView];
    [slineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(alertLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.currentDbLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(slineView.mas_bottom).offset(15);
    }];
    
    [self.neededLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(slineView.mas_bottom).offset(15);
    }];
    
    UIView *llineView = [[UIView alloc]init];
    llineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:llineView];
    [llineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.currentDbLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(llineView.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(35);
    }];
    
}

- (UILabel *)currentDbLabel{
    if (!_currentDbLabel) {
        _currentDbLabel = [[UILabel alloc]init];
        _currentDbLabel.font = [UIFont boldSystemFontOfSize:15];
        _currentDbLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        [self addSubview:_currentDbLabel];
    }
    return _currentDbLabel;
}

- (UILabel *)neededLabel{
    if (!_neededLabel) {
        _neededLabel = [[UILabel alloc]init];
        _neededLabel.font = [UIFont boldSystemFontOfSize:15];
        _neededLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        [self addSubview:_neededLabel];
    }
    return _neededLabel;
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_bottomBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_bottomBtn addTarget:self action:@selector(bottomAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

- (void)bottomAction{
    if (self.bottomBlcok) {
        self.bottomBlcok();
    }
}

- (void)setModel:(FMRTAllTakeBuyResultModel *)model{
    _model = model;
    
    
    NSString *price = model.currentDB;
    NSString *titleAll = [NSString stringWithFormat:@"当前余额:%@",price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
    NSRange range = [titleAll rangeOfString:price];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
    self.currentDbLabel.attributedText = attrStr;

    NSString *neededprice = model.neededDB;
    NSString *neededAll = [NSString stringWithFormat:@"需要夺宝币:%@",neededprice];
    
    NSMutableAttributedString *neededStr = [[NSMutableAttributedString alloc]initWithString:neededAll];
    NSRange neededrange = [neededAll rangeOfString:neededprice];
    [neededStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:neededrange];
    self.neededLabel.attributedText = neededStr;
    
    [self.bottomBtn setTitle:@"立即获得" forState:(UIControlStateNormal)];
}

@end
