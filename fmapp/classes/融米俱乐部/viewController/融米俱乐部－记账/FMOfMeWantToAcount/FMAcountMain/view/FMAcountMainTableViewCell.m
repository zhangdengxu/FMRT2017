//
//  FMAcountMainTableViewCell.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountMainTableViewCell.h"


@interface FMAcountMainTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel, *timeLabel, *moneyLabel, *statusLabel;

@end

@implementation FMAcountMainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
  
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"明细的时间icon_07"];
    [self.contentView addSubview:iconView];
    [iconView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.height.equalTo(@15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconView.mas_right).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
//        _titleLabel.text = @"工资薪水";
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.text = @"9:00";
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = XZColor(63, 204, 78);
//        _moneyLabel.text = @"1500.00";
        _moneyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
//        _statusLabel.text = @"日常账本";
        _statusLabel.font = [UIFont systemFontOfSize:11];
    }
    return _statusLabel;
}

- (void)sendDataWithModel:(FMAcountDetailModel *)model{
    
    self.statusLabel.text = model.detailAbout;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[model.money floatValue]];
    self.timeLabel.text = model.time;
    self.titleLabel.text = model.type;
    if ([model.yanse integerValue] == 1) {
        self.moneyLabel.textColor = [HXColor colorWithHexString:@"#e63207"];
    }else{
        self.moneyLabel.textColor = XZColor(63, 204, 78);
    }
}


@end
