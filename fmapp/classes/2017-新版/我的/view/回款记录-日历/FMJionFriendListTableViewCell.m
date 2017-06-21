//
//  FMJionFriendListTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMJionFriendListTableViewCell.h"
#import "NSDate+CategoryPre.h"
#import "NSString+Extension.h"




@interface FMJionFriendListTableViewCell ()

@property (nonatomic, strong) UILabel * mobileLabel;
@property (nonatomic, strong) UILabel * timeLable;

@end

@implementation FMJionFriendListTableViewCell



-(UILabel *)mobileLabel
{
    if (!_mobileLabel) {
        
        _mobileLabel = [[UILabel alloc]init];
        _mobileLabel.numberOfLines = 1;
        _mobileLabel.textAlignment = NSTextAlignmentLeft;
        if (KProjectScreenWidth == 320) {
            _mobileLabel.font = [UIFont systemFontOfSize:15];

        }else
        {
            _mobileLabel.font = [UIFont systemFontOfSize:17];

        }
        _mobileLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_mobileLabel];
        
    }
    return _mobileLabel;
}


-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.numberOfLines = 1;
        _timeLable.textAlignment = NSTextAlignmentCenter;
        if (KProjectScreenWidth == 320) {
            _timeLable.font = [UIFont systemFontOfSize:15];

        }else
        {
            _timeLable.font = [UIFont systemFontOfSize:17];

        }
        
        _timeLable.textColor = [HXColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_timeLable];
        
    }
    return _timeLable;
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
    [self.mobileLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).offset(-KProjectScreenWidth * 0.25 - 20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).offset(KProjectScreenWidth * 0.25);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

-(void)setJoinModel:(FMJoinFriendModel *)joinModel
{
    _joinModel = joinModel;
    self.mobileLabel.text = joinModel.mobile;
    self.timeLable.text = [NSString retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:joinModel.timeString] ;
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

@implementation FMJoinFriendModel

@end

