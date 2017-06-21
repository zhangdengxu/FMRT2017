//
//  FMRTRebackHeaderView.m
//  fmapp
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRebackHeaderView.h"
#import "FMRTRebackMoneyModel.h"

@interface FMRTRebackHeaderView ()

@property (nonatomic, strong)UIButton *timeBtn,*bigMoneyBtn,*sureBtn;
@property (nonatomic, weak)UIView *secView;
@property (nonatomic, weak)UITextField *TXText;
@property (nonatomic, assign)NSInteger txType;
@property (nonatomic, weak)UILabel *titleLabel,*bankLabel,*bankDetail;


@end

@implementation FMRTRebackHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
//        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 290);
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    titleLabel.text = @"徽商银行电子交易账户余额：0.00元";
    [self addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@50);
    }];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(@110);
        make.top.equalTo(titleLabel.bottom);
    }];
    
    UILabel *kaLabel = [[UILabel alloc]init];
    kaLabel.backgroundColor = [UIColor whiteColor];
    kaLabel.textAlignment = NSTextAlignmentLeft;
    kaLabel.textColor = [UIColor colorWithHexString:@"#333"];
    kaLabel.font = [UIFont systemFontOfSize:16];
    kaLabel.text = @"储蓄卡";
    [self addSubview:kaLabel];
    [kaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@90);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@45);
    }];
    
    UILabel *bankLabel = [[UILabel alloc]init];
    self.bankLabel = bankLabel;
    bankLabel.textAlignment = NSTextAlignmentLeft;
    bankLabel.backgroundColor = [UIColor whiteColor];
    bankLabel.textColor = [UIColor colorWithHexString:@"#333"];
    bankLabel.font = [UIFont systemFontOfSize:16];
    bankLabel.text = @"";
    [self addSubview:bankLabel];
    [bankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaLabel.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@45);
    }];
    
    UIView *bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(1);
        make.top.equalTo(bankLabel.bottom).offset(5);
    }];
    
    
    UILabel *jinerLabel = [[UILabel alloc]init];
    jinerLabel.backgroundColor = [UIColor whiteColor];
    jinerLabel.textAlignment = NSTextAlignmentLeft;
    jinerLabel.textColor = [UIColor colorWithHexString:@"#333"];
    jinerLabel.font = [UIFont systemFontOfSize:16];
    jinerLabel.text = @"金额(元)";
    [self addSubview:jinerLabel];
    [jinerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@90);
        make.top.equalTo(bottomline.mas_bottom).offset(15);
    }];
    
    UITextField *TXText = [[UITextField alloc]init];
    self.TXText = TXText;
    TXText.textColor = [HXColor colorWithHexString:@"#333333"];
    [TXText setBackgroundColor:[UIColor whiteColor]];
    [TXText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [TXText setReturnKeyType:UIReturnKeyNext];
    [TXText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [TXText setFont:[UIFont systemFontOfSize:16.0f]];
    [TXText setBorderStyle:UITextBorderStyleNone];
    [TXText setPlaceholder:@"请输入提现金额"];
    [TXText setKeyboardType:UIKeyboardTypeDecimalPad];
    
    [self addSubview:TXText];
    [TXText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jinerLabel.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(bottomline.mas_bottom).offset(15);
    }];
    
    self.timeBtn.selected = YES;
    [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.top.equalTo(whiteView.bottom).offset(10);
    }];
    
    [self.bigMoneyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.top.equalTo(self.timeBtn.bottom).offset(10);
    }];
    
    
    UIView *secwhiteView = [[UIView alloc]init];
    self.secView = secwhiteView;
    secwhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:secwhiteView];
    [secwhiteView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(@50);
        make.top.equalTo(self.bigMoneyBtn.bottom).offset(10);
    }];
    
    self.secView.hidden = YES;
    self.txType = 0;
    UILabel *bankLeftLabel = [[UILabel alloc]init];
    bankLeftLabel.textColor = [UIColor colorWithHexString:@"#333"];
    bankLeftLabel.font = [UIFont systemFontOfSize:16];
    bankLeftLabel.text = @"开户行";
    [secwhiteView addSubview:bankLeftLabel];
    [bankLeftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(secwhiteView.centerY);
    }];
    
    UILabel *bankDetail = [[UILabel alloc]init];
    self.bankDetail = bankDetail;
    
    bankDetail.textColor = [UIColor lightGrayColor];
    bankDetail.font = [UIFont systemFontOfSize:13];
    bankDetail.text = @"";
    [secwhiteView addSubview:bankDetail];
    [bankDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(105);
        make.right.equalTo(self.right).offset(-15);
        make.centerY.equalTo(secwhiteView.centerY);
    }];
    
    UIImageView *indexView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微商_充值_右箭头"]];
    [secwhiteView addSubview:indexView];
    [indexView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15);
        make.centerY.equalTo(secwhiteView.centerY);
    }];
    
    UIButton *yesBtn = [[UIButton alloc]init];
    [yesBtn addTarget:self action:@selector(yesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [secwhiteView addSubview:yesBtn];
    [yesBtn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(secwhiteView);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:XZColor(16, 133, 228)];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 15;
    self.sureBtn = sureBtn;
    [self addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.bottom.equalTo(self.bottom).offset(-15);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    
}

- (void)sureAction{
    if (!IsStringEmptyOrNull(self.TXText.text)) {
        
        NSString *string = [self.TXText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if (self.sureBlcok) {
            self.sureBlcok(self.txType, string);
        }
    }else{

        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入提现金额！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alter show];
    }
}

- (UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_timeBtn setImage:[UIImage imageNamed:@"徽商-提现-图标1"] forState:(UIControlStateNormal)];
        [_timeBtn setImage:[UIImage imageNamed:@"徽商-提现-图标2"] forState:(UIControlStateSelected)];
        [_timeBtn setTitle:@"实时提现（单笔5万，10笔/单日）" forState:(UIControlStateNormal)];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"333"] forState:(UIControlStateNormal)];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_timeBtn addTarget:self action:@selector(timeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_timeBtn];
    }
    return _timeBtn;
}

- (void)timeAction:(UIButton *)sender{
    sender.selected = YES;
    
    self.bigMoneyBtn.selected = NO;

    self.secView.hidden = self.timeBtn.selected;
    self.txType = 0;
    
//    if (self.timeBlcok) {
//        self.timeBlcok();
//    }
//   
}

- (void)bigMoneyAction:(UIButton *)sender{
    sender.selected = YES;
    self.timeBtn.selected = NO;

    self.secView.hidden = self.timeBtn.selected;
    
    self.txType = 1;
    
//    if (self.bigBlcok) {
//        self.bigBlcok();
//    }
}

- (void)yesBtnAction:(UIButton *)sender{
    NSLog(@"开户行名称！！！");
    if (self.bankBlcok) {
        self.bankBlcok();
    }
}

- (UIButton *)bigMoneyBtn{
    if (!_bigMoneyBtn) {
        _bigMoneyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_bigMoneyBtn setImage:[UIImage imageNamed:@"徽商-提现-图标1"] forState:(UIControlStateNormal)];
        [_bigMoneyBtn setImage:[UIImage imageNamed:@"徽商-提现-图标2"] forState:(UIControlStateSelected)];
        [_bigMoneyBtn setTitle:@"大额提现（20万以上的提现请于工作日9:00-17:00选择大额提现）" forState:(UIControlStateNormal)];
        _bigMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_bigMoneyBtn setTitleColor:[UIColor colorWithHexString:@"333"] forState:(UIControlStateNormal)];
        _bigMoneyBtn.titleLabel.numberOfLines = 2;
        _bigMoneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_bigMoneyBtn addTarget:self action:@selector(bigMoneyAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:_bigMoneyBtn];
        
    }
    return _bigMoneyBtn;
}

- (void)setModel:(FMRTRebackMoneyModel *)model{
    _model = model;
    
    NSString *str = [model.signBankCard substringFromIndex:model.signBankCard.length- 4];
    
    self.titleLabel.text = [NSString stringWithFormat:@"徽商银行电子交易账户余额：%.2f元",model.acctAmt];
    self.bankLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",model.signBankName,str];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"实时提现（%@）",model.limitDesc] forState:(UIControlStateNormal)];
    [self.bigMoneyBtn setTitle:[NSString stringWithFormat:@"大额提现（%@）",model.largeDesc]forState:(UIControlStateNormal)];
}

- (void)setBankName:(NSString *)bankName{
    _bankName = bankName;
    self.bankDetail.text = bankName;
}

@end
