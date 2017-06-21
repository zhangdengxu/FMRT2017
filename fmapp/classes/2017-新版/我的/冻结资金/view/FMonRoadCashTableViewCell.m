//
//  FMonRoadCashTableViewCell.m
//  fmapp
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMonRoadCashTableViewCell.h"


@interface FMonRoadCashTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel, *timeLabel, *moneyLabel, *statusLabel;
@property (nonatomic, strong) UIView *view;
@end

@implementation FMonRoadCashTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.lessThanOrEqualTo(self.moneyLabel.mas_left).offset(-8);
    }];
    
//    UIView *lineLiew = [[UIView alloc]init];
//    lineLiew.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
//    [self.contentView addSubview:lineLiew];
//    [lineLiew makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.contentView.mas_left); // .offset(15)
//        make.right.equalTo(self.contentView.mas_right); // .offset(-15)
//        make.top.equalTo(self.moneyLabel.mas_bottom).offset(15);
//        make.height.equalTo(@1);
//    }];
    
    UIView *view = [[UIView alloc] init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.view = view;
    view.backgroundColor = XZColor(229, 229, 229);
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(view.mas_centerY);// .offset(10)
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(view.mas_centerY);//.offset(10)
    }];
    
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.textColor = KContentTextLightGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];

    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];

    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_moneyLabel];
    }
    
    return _moneyLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        _statusLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_statusLabel];

    }
    return _statusLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
}

- (void)sendDataWithModel:(FMOnRoadModel *)model {
    self.statusLabel.text = model.mingcheng;
    self.moneyLabel.text = model.jiner;
    self.titleLabel.text = model.xiangmuming;
    self.timeLabel.text = model.shijian;
}

@end
