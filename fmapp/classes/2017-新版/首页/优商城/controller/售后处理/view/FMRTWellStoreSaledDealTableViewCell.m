//
//  FMRTWellStoreSaledDealTableViewCell.m
//  fmapp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreSaledDealTableViewCell.h"
#import "HexColor.h"

@interface FMRTWellStoreSaledDealTableViewCell ()

@property (nonatomic, strong) UIView *backbottomView;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UILabel *timeLabel,*alertLabel,*titleLabel,*centerLabel,*numberLabel;

@end
@implementation FMRTWellStoreSaledDealTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.top).offset(15);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    [self.contentView addSubview:self.alertLabel];
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.timeLabel.centerY);
    }];
    
    [self.contentView addSubview:self.backbottomView];
    [self.backbottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLabel.bottom).offset(10);
        make.left.equalTo(self.contentView.left).offset(20);
        make.right.equalTo(self.contentView.right).offset(-10);
        make.height.equalTo(@200);
    }];
    
    
    [self.contentView addSubview:self.bottomView];
    self.bottomView.image = [UIImage imageNamed:@"优商城_售后处理中详情页－蓝色箭头_36"];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backbottomView.top).offset(8);
        make.right.equalTo(self.backbottomView.left);
    }];
    
    [self.backbottomView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backbottomView.top).offset(15);
        make.left.equalTo(self.backbottomView.left).offset(15);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.backbottomView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.backbottomView.right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.backbottomView addSubview:self.centerLabel];
    [self.centerLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(lineView.right);
    }];
    
    UIView *slineView = [[UIView alloc]init];
    slineView.backgroundColor = [UIColor whiteColor];
    [self.backbottomView addSubview:slineView];
    [slineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.centerLabel.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.backbottomView.right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.backbottomView addSubview:self.numberLabel];
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(slineView.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UIImageView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc]init];
    }
    return _bottomView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        _timeLabel.backgroundColor = [HXColor colorWithHexString:@"#ededed"];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        _alertLabel.font = [UIFont systemFontOfSize:12];
        _alertLabel.text = [NSString stringWithFormat:@"%@",@"● 系统消息"];
    }
    return _alertLabel;
}


- (UIView *)backbottomView{
    if (!_backbottomView) {
        _backbottomView = [[UIView alloc]init];
        _backbottomView.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
        _backbottomView.layer.masksToBounds = YES;
        _backbottomView.layer.cornerRadius = 5;
    }
    return _backbottomView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.font = [UIFont systemFontOfSize:15];
        _centerLabel.numberOfLines = 0;
    }
    return _centerLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:15];
    }
    return _numberLabel;
}

- (void)setModel:(FMRTWellStoreSaledDealModel *)model{
    _model = model;
    
    CGFloat width = (KProjectScreenWidth - 60);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    [self.backbottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(rect.size.height + 130);
    }];
    
    self.titleLabel.text = model.title;
    self.centerLabel.text = model.content;
    self.numberLabel.text = [NSString stringWithFormat:@"编号：%@",model.afterSaleID];
    self.alertLabel.text = [NSString stringWithFormat:@"●%@",model.msgTitle];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
}

+(CGFloat )heightForCellWith:(FMRTWellStoreSaledDealModel *)model{
    CGFloat width = (KProjectScreenWidth - 60);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.height + 190;
}

@end
