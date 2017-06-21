//
//  FMMonthAccountTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMMonthAccountTableViewCell.h"

#import "FMMonthAddReduceModel.h"


@interface FMMonthAccountTableViewCell ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * addPriceLabel;
@property (nonatomic, strong) UILabel * reducePriceLabel;
@property (nonatomic, strong) UILabel * endpriceLabel;

@property (nonatomic, strong) UIView * lineView;

@end


@implementation FMMonthAccountTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addMassory];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)setMonthModel:(FMMonthAddReduceModel *)monthModel
{
    _monthModel = monthModel;
    self.timeLabel.text = monthModel.month;
    self.addPriceLabel.text = monthModel.shouru;
    self.reducePriceLabel.text = monthModel.zhichu;
    self.endpriceLabel.text = monthModel.shouzhicha;
}

-(void)addMassory
{
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.addPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(40);
        make.top.equalTo(self.contentView.mas_top).offset(10);

    }];
    
    [self.reducePriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPriceLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.endpriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    CGFloat widthLineView = KProjectScreenWidth;
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(widthLineView);
        make.height.equalTo(@5);
    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)addPriceLabel
{
    if (!_addPriceLabel) {
        _addPriceLabel = [[UILabel alloc]init];
        _addPriceLabel.font = [UIFont systemFontOfSize:14];
        _addPriceLabel.textColor = [HXColor colorWithHexString:@"#15c733"];
        [self.contentView addSubview:_addPriceLabel];
    }
    return _addPriceLabel;
}
-(UILabel *)reducePriceLabel
{
    if (!_reducePriceLabel) {
        _reducePriceLabel = [[UILabel alloc]init];
        _reducePriceLabel.font = [UIFont systemFontOfSize:14];
        _reducePriceLabel.textColor = [HXColor colorWithHexString:@"#e63207"];
        [self.contentView addSubview:_reducePriceLabel];
    }
    return _reducePriceLabel;
}
-(UILabel *)endpriceLabel
{
    if (!_endpriceLabel) {
        
        _endpriceLabel = [[UILabel alloc]init];
        _endpriceLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_endpriceLabel];
    }
    return _endpriceLabel;
}

@end
