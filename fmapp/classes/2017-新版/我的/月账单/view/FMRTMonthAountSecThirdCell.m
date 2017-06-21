//
//  FMRTMonthAountSecThirdCell.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTMonthAountSecThirdCell.h"
#import "FMRTMonthAcountModel.h"

@interface FMRTMonthAountSecThirdCell ()

@property (nonatomic, strong) UILabel *titleLabel,*numberLabel;

@end

@implementation FMRTMonthAountSecThirdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#333"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#666"];
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.text = @"-1000.00";
        [self.contentView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (void)setRow:(NSInteger)row{
    _row = row;
    
    if (self.section == 1) {
        
        if (row == 0) {
            self.titleLabel.text = @"本月投标金额";
        }else{
            self.titleLabel.text = @"本月提现金额";
        }
        
    }else{
        if (row == 0) {
            self.titleLabel.text = @"本月获得积分";

        }else{
            self.titleLabel.text = @"本月消耗积分";
        }
    }
}

- (void)setModel:(FMRTMonthDataModel *)model{
    _model = model;
    
    if (self.section == 1) {
        
        if (self.row == 0) {
            _numberLabel.text = [NSString stringWithFormat:@"-%.2f",model.BidAmt];

        }else{
            _numberLabel.text = [NSString stringWithFormat:@"-%.2f",model.WithdrawAmt];
        }
        
    }else{
        if (self.row == 0) {
            _numberLabel.text = [NSString stringWithFormat:@"%d分",model.IncomeScore];

            
        }else{
            _numberLabel.text = [NSString stringWithFormat:@"%d分",model.ConsumeScore];
        }
    }
    
}

@end
