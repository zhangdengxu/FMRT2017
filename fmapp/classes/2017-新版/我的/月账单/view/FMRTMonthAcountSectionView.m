//
//  FMRTMonthAcountSectionView.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTMonthAcountSectionView.h"
#import "FMRTMonthAcountModel.h"

@interface FMRTMonthAcountSectionView ()

@property (nonatomic, strong) UILabel *titleLabel,*numberLabel;

@end

@implementation FMRTMonthAcountSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.centerY);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = @"总收入";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _numberLabel.font = [UIFont boldSystemFontOfSize:15];
        _numberLabel.text = @"+1000.00";
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (void)setSection:(NSInteger)section{
    _section = section;
    
    switch (section) {
        case 0:
        {
            self.titleLabel.text = @"总收入";
            [self.numberLabel setHidden:NO];
            break;
        }
        case 1:
        {
            self.titleLabel.text = @"总支出";
            [self.numberLabel setHidden:NO];
            break;
        }
        case 2:
        {
            self.titleLabel.text = @"会员积分";
            [self.numberLabel setHidden:YES];
            break;
        }
        default:
            break;
    }
    
}

- (void)setModel:(FMRTMonthDataModel *)model{
    _model = model;
    
    switch (self.section) {
        case 0:
        {
            double total = 0.00;
            total = model.RechargeAmt +model.BackPrincipalAmt+model.IncomeAmt+model.CommissionAmt+model.OtherIncomeAmt;
            _numberLabel.text = [NSString stringWithFormat:@"+%.2f",total];

            break;
        }
        case 1:
        {
            double total = 0.00;
            total = model.WithdrawAmt +model.BidAmt;
            _numberLabel.text = [NSString stringWithFormat:@"-%.2f",total];
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
    
}

@end
