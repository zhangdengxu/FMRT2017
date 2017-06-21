//
//  FMRTBackEarnHeaderView.m
//  fmapp
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTBackEarnHeaderView.h"
#import "FMRTBackEariningModel.h"

@interface FMRTBackEarnHeaderView ()

@property (nonatomic, strong) UILabel *earnLabel,*totalLabel;

@end

@implementation FMRTBackEarnHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UILabel *earnLabel = [[UILabel alloc]init];
    earnLabel.text = @"应发佣金(元)";
    earnLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:earnLabel];
    
    [earnLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.top).offset(10);
        make.left.equalTo(self.left).offset(10);
    }];
    
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.text = @"到期资产(万)";
    totalLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:totalLabel];
    
    [totalLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(earnLabel.bottom).offset(30);
        make.left.equalTo(earnLabel.left);
    }];
    
    [self.earnLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(earnLabel.centerY);
        make.right.equalTo(self.right).offset(-10);
    }];
    
    [self.totalLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(totalLabel.centerY);
        make.right.equalTo(self.right).offset(-10);
    }];
}

- (UILabel *)earnLabel{
    if (!_earnLabel) {
        _earnLabel = [[UILabel alloc]init];
        _earnLabel.text = @"0.00";
        _earnLabel.textColor = [UIColor colorWithHexString:@"#666"];
        _earnLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_earnLabel];
    }
    return _earnLabel;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.text = @"0.00";
        _totalLabel.textColor = [UIColor colorWithHexString:@"#666"];        _totalLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_totalLabel];
    }
    return _totalLabel;
}

- (void)setModel:(FMRTBackEariningModel *)model{
    _model = model;
    
    if (!model.Commispabl) {
        model.Commispabl = @"0.00";
    }
    if (!model.Maturas) {
        model.Maturas = @"0.00";
    }
    self.totalLabel.text = model.Maturas;
    self.earnLabel.text = model.Commispabl;
}


@end
