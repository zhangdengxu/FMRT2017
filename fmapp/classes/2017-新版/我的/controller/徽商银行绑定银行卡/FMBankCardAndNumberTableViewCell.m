//
//  FMBankCardAndNumberTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMBankCardAndNumberTableViewCell.h"

@interface FMBankCardAndNumberTableViewCell ()

@property (nonatomic, strong) UILabel * leftTitleLabel;
@property (nonatomic, strong) UILabel * rightTitleLabel;



@end


@implementation FMBankCardAndNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置TradeSuccessGoodsCell子视图
        [self setUpCell];
        
    }
    return self;
}

-(UILabel *)leftTitleLabel
{
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.font = [UIFont systemFontOfSize:14];
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftTitleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        
    }
    return _leftTitleLabel;
}


-(UILabel *)rightTitleLabel
{
    if (!_rightTitleLabel) {
        _rightTitleLabel = [[UILabel alloc]init];
        _rightTitleLabel.font = [UIFont systemFontOfSize:14];
        _rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rightTitleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        
    }
    return _rightTitleLabel;
}


-(void)setUpCell
{
    [self.contentView addSubview:self.leftTitleLabel];
    
    [self.contentView addSubview:self.rightTitleLabel];
    
    [self.leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    [self.rightTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

-(void)setCardModel:(FMBankCardAndNumberModel *)cardModel
{
    _cardModel = cardModel;
    _leftTitleLabel.text = cardModel.leftTitleString;
    _rightTitleLabel.text = cardModel.rightTitleString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation FMBankCardAndNumberModel



@end
