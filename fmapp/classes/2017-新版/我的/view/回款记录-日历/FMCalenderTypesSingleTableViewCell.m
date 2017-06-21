//
//  FMCalenderTypesSingleTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMCalenderTypesSingleTableViewCell.h"

@interface FMCalenderTypesSingleTableViewCell ()

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * middleLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation FMCalenderTypesSingleTableViewCell

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.numberOfLines = 0;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont systemFontOfSize:KCellFontDefault];
        _leftLabel.textColor = [HXColor colorWithHexString:@"#0059d5"];
        [self.contentView addSubview:_leftLabel];
        
    }
    return _leftLabel;
}

-(UILabel *)middleLabel
{
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc]init];
        _middleLabel.numberOfLines = 2;
        _middleLabel.textAlignment = NSTextAlignmentRight;
        _middleLabel.font = [UIFont systemFontOfSize:KCellFontDefault];
        _middleLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_middleLabel];
        
    }
    return _middleLabel;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.numberOfLines = 2;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:KCellFontDefault];
        _rightLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_rightLabel];
        
    }
    return _rightLabel;
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self massory];
    }
    return self;
}

- (void)massory
{
    CGFloat widthCell = 100;
    if (KProjectScreenWidth < 375) {
        widthCell = 135;
    }else if(KProjectScreenWidth < 400)
    {
        widthCell = 165;
    }else
    {
        widthCell = 185;
    }
    
    [self.leftLabel remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(widthCell);
    }];

    
    
    [self.middleLabel remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLabel.mas_right).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo((KProjectScreenWidth - widthCell - 60)* 0.5);
        
        
    }];
        
    
    [self.rightLabel remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.middleLabel.mas_right).offset(8).priorityLow();
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
}

-(void)setDateModel:(FMRecommendDayDateModel *)dateModel
{
    _dateModel = dateModel;
    if (self.isReturnMoney > 0) {
        self.leftLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    }else
    {
        self.leftLabel.textColor = [HXColor colorWithHexString:@"#0059d5"];
    }
    
    self.leftLabel.text = [NSString stringWithFormat:@"%@",dateModel.jiekuantitle];
    self.rightLabel.text = [NSString stringWithFormat:@"%.2f",[dateModel.lyjiner floatValue]];
    self.middleLabel.text = [NSString stringWithFormat:@"%.2f",[dateModel.lyyongjinshu floatValue]];
    
    
}

-(void)setReFoundMoney:(FMRefoundMoneyListModel *)reFoundMoney
{
    _reFoundMoney = reFoundMoney;
    if (self.isReturnMoney > 0) {
        self.leftLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    }else
    {
        self.leftLabel.textColor = [HXColor colorWithHexString:@"#0059d5"];
    }
    self.leftLabel.text = [NSString stringWithFormat:@"%@",reFoundMoney.projName];
    self.middleLabel.text = [NSString stringWithFormat:@"%.2f",[reFoundMoney.interest floatValue]];
    self.rightLabel.text = [NSString stringWithFormat:@"%.2f",[reFoundMoney.principal floatValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

@end


@implementation FMRecommendDayDateModel;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation FMRefoundMoneyListModel;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


