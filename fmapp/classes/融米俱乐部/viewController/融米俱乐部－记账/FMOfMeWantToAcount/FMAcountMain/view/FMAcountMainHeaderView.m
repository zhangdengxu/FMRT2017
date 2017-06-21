//
//  FMAcountMainHeaderView.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountMainHeaderView.h"


@interface FMAcountMainHeaderView ()

@property (nonatomic, strong) UILabel *incomeLabel, *expenseLabel, *gapLabel;
@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation FMAcountMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 140 + KProjectScreenWidth * 7 / 16);
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {

    UIImageView *photoView = [[UIImageView alloc]init];
    self.photoView = photoView;
    photoView.image = [UIImage imageNamed:@"shop_loading_wait_04375"];
//    photoView.image = [UIImage imageNamed:@"记账banner_02"];
    [self addSubview:photoView];
    [photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth * 7 / 16);
    }];

    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    [self addSubview:blueView];
    [blueView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(photoView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    UILabel *inLabel = [[UILabel alloc]init];
    inLabel.text = @"本月收入";
    inLabel.font = [UIFont boldSystemFontOfSize:12];
    inLabel.textColor = [UIColor whiteColor];
    [blueView addSubview:inLabel];
    [inLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(blueView.mas_centerX).dividedBy(2).offset(-10);
        make.top.equalTo(blueView.mas_top).offset(8);
    }];
    
    [blueView addSubview:self.incomeLabel];
    [self.incomeLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(inLabel.mas_centerX);
        make.top.equalTo(inLabel.mas_bottom).offset(5);
    }];
    
    UILabel *exLabel = [[UILabel alloc]init];
    exLabel.text = @"本月支出";
    exLabel.font = [UIFont boldSystemFontOfSize:12];
    exLabel.textColor = [UIColor whiteColor];
    [blueView addSubview:exLabel];
    [exLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(blueView.mas_centerX);
        make.top.equalTo(blueView.mas_top).offset(8);
    }];
    
    [blueView addSubview:self.expenseLabel];
    [self.expenseLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(exLabel.mas_bottom).offset(5);
        make.centerX.equalTo(exLabel.mas_centerX);
    }];

    UILabel *pLabel = [[UILabel alloc]init];
    pLabel.text = @"本月差额";
    pLabel.font = [UIFont boldSystemFontOfSize:12];
    pLabel.textColor = [UIColor whiteColor];
    [blueView addSubview:pLabel];
    [pLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5).offset(10);
        make.top.equalTo(blueView.mas_top).offset(8);
    }];
    
    [blueView addSubview:self.gapLabel];
    [self.gapLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(pLabel.mas_bottom).offset(5);
        make.centerX.equalTo(pLabel.mas_centerX);
    }];

    UIButton *writeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    writeButton.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    [writeButton addTarget:self action:@selector(writeAction) forControlEvents:(UIControlEventTouchUpInside)];
    writeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    writeButton.titleLabel.textColor = [UIColor whiteColor];
    [writeButton setTitle:@"记一笔" forState:(UIControlStateNormal)];
    [self addSubview:writeButton];
    [writeButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(blueView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(60);
        make.right.equalTo(self.mas_right).offset(-60);
        make.height.equalTo(@50);
    }];
    

}

- (void)writeAction{
    if (self.writeBlcok) {
        self.writeBlcok();
    }
}

- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.text = @"0.00";
        _incomeLabel.textColor = [UIColor whiteColor];

        _incomeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _incomeLabel;
}

- (UILabel *)expenseLabel{
    if (!_expenseLabel) {
        _expenseLabel = [[UILabel alloc]init];
        _expenseLabel.text = @"0.00";
        _expenseLabel.textColor = [UIColor whiteColor];

        _expenseLabel.font = [UIFont systemFontOfSize:15];
    }
    return _expenseLabel;
}

- (UILabel *)gapLabel{
    if (!_gapLabel) {
        _gapLabel = [[UILabel alloc]init];
        _gapLabel.text = @"0.00";
        _gapLabel.textColor = [UIColor whiteColor];

        _gapLabel.font = [UIFont systemFontOfSize:15];
    }
    return _gapLabel;
}

- (void)sendDataWithModel:(FMAcountMainModel *)model{
    
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",[model.currrentMonthIncome floatValue]];
    self.expenseLabel.text = [NSString stringWithFormat:@"%.2f",[model.currrentMonthExpend floatValue]];
    self.gapLabel.text = [NSString stringWithFormat:@"%.2f",[model.currrentMonthGap floatValue]];
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.rongtuojinrong.com%@",model.acountTopImageios]] placeholderImage:[UIImage imageNamed:@"shop_loading_wait_04375"]];
    
    
}


@end
