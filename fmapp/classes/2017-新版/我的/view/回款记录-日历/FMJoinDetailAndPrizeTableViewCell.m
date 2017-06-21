//
//  FMJoinDetailAndPrizeTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMJoinDetailAndPrizeTableViewCell.h"
#import "FMJoinDetalPrizeModel.h"
#import "NSString+Extension.h"

@interface FMJoinDetailAndPrizeTableViewCell ()

@property (nonatomic, strong) UIImageView * leftIconImageLine;
@property (nonatomic, strong) UIImageView * leftIconImageZero;


@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * numberDetail;
@property (nonatomic, strong) UILabel * dateLabel;



@end

@implementation FMJoinDetailAndPrizeTableViewCell




-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.numberOfLines = 1;
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#ff6666"];
        [self.contentView addSubview:_numberLabel];
        
    }
    return _numberLabel;
}


-(UILabel *)numberDetail
{
    if (!_numberDetail) {
        _numberDetail = [[UILabel alloc]init];
        _numberDetail.numberOfLines = 1;
        _numberDetail.font = [UIFont systemFontOfSize:13];
        _numberDetail.textColor = [HXColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_numberDetail];
        
    }
    return _numberDetail;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_dateLabel];
        
    }
    return _dateLabel;
}

-(UIImageView *)leftIconImageLine
{
    if (!_leftIconImageLine) {
        _leftIconImageLine = [[UIImageView alloc]init];
        _leftIconImageLine.image = [UIImage imageNamed:@"积分明细签到icon线"];//积分明细签到icon线
        [self.contentView addSubview:_leftIconImageLine];
    }
    return _leftIconImageLine;
}


-(UIImageView *)leftIconImageZero
{
    if (!_leftIconImageZero) {
        _leftIconImageZero = [[UIImageView alloc]init];
        _leftIconImageZero.image = [UIImage imageNamed:@"积分明细签到icon圆"];//积分明细签到icon线
        [self.contentView addSubview:_leftIconImageZero];

    }
    return _leftIconImageZero;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addMassary];
    }
    return self;
}
-(void)addMassary
{
    [self.leftIconImageLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(22.5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.leftIconImageZero makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIconImageLine.mas_centerX);
        make.centerY.equalTo(self.leftIconImageLine.mas_centerY);
    }];
    
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIconImageLine.mas_right).offset(20);
        make.bottom.equalTo(self.leftIconImageLine.mas_centerY).offset(-5);
    }];
    [self.numberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIconImageLine.mas_right).offset(20);
        make.top.equalTo(self.leftIconImageLine.mas_centerY).offset(5);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    
}



-(void)setModel:(FMJoinDetalPrizeModel *)model
{
    
    /*
     
     AwardType	int	"奖励类型
     1：现金 2：红包"
     AwardTrench	int	"奖励渠道
     1：首次 2：三十日内投资"
     */
    _model = model;
    //self.numberLabel = ;
    
    switch (model.awardType) {
        case 1:
        {
            if (model.awardTrench == 1) {
                
                self.numberLabel.text = [NSString stringWithFormat:@"+%.2f元",model.awardMoney];
                //[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%@",model.inviteeBidMoney]]
                
                self.numberDetail.text = [NSString stringWithFormat:@"好友投资%@元,%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",model.inviteeBidMoney]],model.projDuration];
                self.dateLabel.text = [NSString retStringFrom:@"yyyy-MM-dd" withtimeString:[NSString stringWithFormat:@"%@",model.awardTime]];
                
            }else if (model.awardTrench  == 2) {
                
                self.numberLabel.text = [NSString stringWithFormat:@"+%@元",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",model.awardMoney]]];
                self.numberDetail.text = [NSString stringWithFormat:@"好友投资%@元,%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",model.inviteeBidMoney]],model.projDuration];
                self.dateLabel.text = [NSString retStringFrom:@"yyyy-MM-dd" withtimeString:[NSString stringWithFormat:@"%@",model.awardTime]];
                
            }else
            {
            
            }
        }
            break;
        case 2:
        {
            if (model.awardTrench == 1) {
                
                self.numberLabel.text = [NSString stringWithFormat:@"+%.2f元红包",model.awardMoney];
                //[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%@",model.inviteeBidMoney]]
                
                self.numberDetail.text = @"好友首次投资成功";
                self.dateLabel.text = [NSString retStringFrom:@"yyyy-MM-dd" withtimeString:[NSString stringWithFormat:@"%@",model.awardTime]];
                
            }else if (model.awardTrench == 2) {
                
                self.numberLabel.text = [NSString stringWithFormat:@"+%.2f元",model.awardMoney];
                //[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%@",model.inviteeBidMoney]]
                
                self.numberDetail.text = [NSString stringWithFormat:@"好友投资%@元,%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",model.inviteeBidMoney]],model.projDuration];
                self.dateLabel.text = [NSString retStringFrom:@"yyyy-MM-dd" withtimeString:[NSString stringWithFormat:@"%@",model.awardTime]];
                
            }else
            {
                
            }

        }
            break;
            
        default:
            break;
    }
    
    
}

-(NSString *)retMoneyWithMakeBid:(NSString *)money
{
    NSString * moneyString = money;
    CGFloat  moneyFolat = [moneyString floatValue];
    NSString * retString;
    if ((moneyFolat / 10000 ) >= 1) {
        retString = [NSString stringWithFormat:@"%.2f万",(moneyFolat / 10000 )];
    }else
    {
        retString = moneyString;
    }
    
    return retString;
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
