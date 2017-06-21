//
//  FMRTAllTakeBuyFailureView.m
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAllTakeBuyFailureView.h"


@interface FMRTAllTakeBuyFailureView ()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIButton *bottomBtn;


@end
@implementation FMRTAllTakeBuyFailureView

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
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(flineView.mas_bottom).offset(15);
    }];
    
    UIView *slineView = [[UIView alloc]init];
    slineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self addSubview:slineView];
    [slineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(slineView.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(35);
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
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
    
    if ([model.failureStatus isEqualToString:@"OldFiriendPriceFailureOfPay"]) {
        self.titleLabel.text = @"尊敬的用户，对不起您的余额不足。";
        [self.bottomBtn setTitle:@"重新支付" forState:(UIControlStateNormal)];
    }else if ([model.failureStatus isEqualToString:@"TimeOutFailureOfPay"]){
        self.titleLabel.text = @"抱歉，您操作超时，请重新支付！";
        [self.bottomBtn setTitle:@"重新支付" forState:(UIControlStateNormal)];
    }else if ([model.failureStatus isEqualToString:@"ActivityEndedFailureOfPay"]){
        self.titleLabel.text = @"抱歉您晚来一步，该商品活动已结束！";
        [self.bottomBtn setTitle:@"查看其它商品" forState:(UIControlStateNormal)];
    }else if ([model.failureStatus isEqualToString:@"SoldedZeroFailureOfPay"]){
        self.titleLabel.text = @"抱歉您晚来一步，本次商品已经售罄！";
        [self.bottomBtn setTitle:@"其他方式获得" forState:(UIControlStateNormal)];
    }
}

@end
