//
//  FMAccountDetailTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAccountDetailTableViewCell.h"
#import "FMKeepAccount.h"

@interface FMAccountDetailTableViewCell ()
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * timeImageView;
@end


@implementation FMAccountDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addMassory];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)addMassory
{
    CGFloat titleWidth = (KProjectScreenWidth - 50) * 0.5;
    CGFloat imageWidth = 15;
    
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.equalTo(titleWidth);
        make.bottom.equalTo(self.timeLable.mas_top).offset(-5);
    }];
    
    [self.priceLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.equalTo(titleWidth - 10);
        make.bottom.equalTo(self.titleLable.mas_bottom);
    }];
    
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20 + imageWidth + 8);
        make.top.equalTo(self.titleLable.mas_bottom).offset(5);
        make.width.equalTo(titleWidth);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.timeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLable.mas_left).offset(-5);
        make.centerY.equalTo(self.timeLable.mas_centerY);
        make.width.equalTo(imageWidth);
        make.height.equalTo(imageWidth);
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(0.5);
    }];
}

-(void)setModel:(FMKeepAccountDetailCellModel *)model
{
    _model = model;
    if (model.isAddOrReduce) {
        self.priceLable.textColor = [HXColor colorWithHexString:@"#15c733"];
    }else
    {
        self.priceLable.textColor = [HXColor colorWithHexString:@"#e63207"];
    }
    
    self.titleLable.text = model.titleLabel;
    self.priceLable.text = [NSString stringWithFormat:@"%@",model.priceLabel];
    self.timeLable.text = [NSString stringWithFormat:@"%@",model.timelabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.numberOfLines = 0;
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = [HXColor colorWithHexString:@"#222324"];
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel *)priceLable
{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc]init];
        _priceLable.font = [UIFont systemFontOfSize:14];
        _priceLable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLable];
    }
    return _priceLable;
}
-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLable];
    }
    return _timeLable;
}
-(UIImageView *)timeImageView
{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]init];
        _timeImageView.image = [UIImage imageNamed:@"明细的时间icon_07"];
        [self.contentView addSubview:_timeImageView];
    }
    return _timeImageView;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

/*
 
 */

@end
