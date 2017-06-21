//
//  FMJoinInNoteTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KDefaultIconImageRadio 20
#import "FMJoinInNoteTableViewCell.h"
#import "FMDuobaoClass.h"



@interface FMJoinInNoteTableViewCell ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * showImageView;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * luckeyLabel;
@property (nonatomic, strong) UIImageView * congratulate;


@property (nonatomic, strong) UIView  * lineView;
@end

@implementation FMJoinInNoteTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addmassary];
        
    }
    return self;
}



-(void)addmassary
{
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.height.equalTo(KDefaultIconImageRadio * 2);
    }];

    [self.showImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(8);
       
        
    }];

    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImageView.mas_right).offset(20);
        make.centerY.equalTo(self.showImageView.mas_centerY);
    }];

    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(8);
    }];

    [self.luckeyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];

    [self.congratulate makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

}



-(void)setDuobaoNotes:(FMDuobaoClassNotes *)duobaoNotes
{
    _duobaoNotes = duobaoNotes;
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:duobaoNotes.head_img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    
    if ([duobaoNotes.way_type integerValue] == 1) {
        //抽奖
        if ([duobaoNotes.way_unit_cost integerValue] == 1) {
             [self.showImageView setImage:[UIImage imageNamed:@"全新1币得"]];
        }else if ([duobaoNotes.way_unit_cost integerValue] == 5)
        {
            [self.showImageView setImage:[UIImage imageNamed:@"全新5币得"]];

        }else
        {
            
        }
        
        self.luckeyLabel.hidden = NO;
        
        self.luckeyLabel.text = [NSString stringWithFormat:@"幸运号码：%@",duobaoNotes.lucky_number];
        
    }else
    {
         self.luckeyLabel.hidden = YES;
        [self.showImageView setImage:[UIImage imageNamed:@"全新老友价"]];
    }
    
    
    
    //昵称
    if ((![duobaoNotes.nickname isMemberOfClass:[NSNull class]]) && duobaoNotes.nickname) {
        self.numberLabel.text = [NSString stringWithFormat:@"ID:%@",duobaoNotes.nickname];
        
    }else
    {
        if ([duobaoNotes.phone isMemberOfClass:[NSNull class]]) {
            self.numberLabel.text = @"ID:未设置";
        }else
        {
            NSString * startString = [duobaoNotes.phone substringToIndex:3];
            NSString * endNUmString =  [duobaoNotes.trans_time substringFromIndex:9];
            NSString * phoneNum = [NSString stringWithFormat:@"ID:%@****%@",startString,endNUmString];
            self.numberLabel.text = [NSString stringWithFormat:@"%@",phoneNum];
        }
    }

    
    NSString * timeString = duobaoNotes.trans_time;
    NSString * endString =  duobaoNotes.trans_time_ms;
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@:%@",[NSString retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:timeString],endString];
    
    if ([duobaoNotes.state integerValue] == 21) {
        self.congratulate.hidden = NO;
    }else
    {
        self.congratulate.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.layer.cornerRadius = KDefaultIconImageRadio;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}


-(UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_showImageView];
    }
    return _showImageView;
}


-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.font = [UIFont systemFontOfSize:15];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _numberLabel.text = @"ID:";
        [self.contentView addSubview:_numberLabel];
    }
    return _numberLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [HXColor colorWithHexString:@"#3f3f3f"];
        _timeLabel.text = @"时间：";
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UILabel *)luckeyLabel
{
    if (!_luckeyLabel) {
        _luckeyLabel = [[UILabel alloc]init];
        _luckeyLabel.textAlignment = NSTextAlignmentLeft;
        _luckeyLabel.font = [UIFont systemFontOfSize:14];
        _luckeyLabel.textColor = [HXColor colorWithHexString:@"#3f3f3f"];
        _luckeyLabel.text = @"5币抽奖";
        [self.contentView addSubview:_luckeyLabel];
    }
    return _luckeyLabel;
}

-(UIImageView *)congratulate
{
    if (!_congratulate) {
        _congratulate = [[UIImageView alloc]init];
        _congratulate.image = [UIImage imageNamed:@"1101恭喜中奖"];
        [self.contentView addSubview:_congratulate];
    }
    return _congratulate;
}

@end
