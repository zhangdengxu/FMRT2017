//
//  FMTimeKillNoteTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillNoteTableViewCell.h"
#import "FMTimeKillnoteModel.h"



@interface FMTimeKillNoteTableViewCell ()
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * sectionTitle;
@property (nonatomic, strong) UILabel * titleabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * oldPrice;
@property (nonatomic, strong) UIImageView * flagImageView;
@property (nonatomic, strong) UIView  * grayLineView;
@end


@implementation FMTimeKillNoteTableViewCell


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
    CGFloat titleWidth = 90;
    [self.sectionTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@25);
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.sectionTitle.mas_bottom).offset(10);
        make.height.equalTo(@0.5);
    }];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.width.equalTo(titleWidth);
        make.height.equalTo(titleWidth);
    }];
    
    [self.titleabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
    }];
    
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.titleabel.mas_bottom).offset(15);
    }];
    
    [self.oldPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];

    [self.flagImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.grayLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.oldPrice.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@8);
    }];
    
}


-(void)setKillNote:(FMTimeKillnoteModel *)killNote
{
    _killNote = killNote;
    
    self.titleabel.text = killNote.goods_name;
    self.sectionTitle.text = [NSString stringWithFormat:@"参与时间 %@",[NSString retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:killNote.trans_time]];
    
    self.priceLabel.text = killNote.trans_price;
    self.oldPrice.text = killNote.goods_price;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:killNote.goods_img_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.flagImageView.image = [UIImage imageNamed:@"秒杀成功_03"];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(UIImageView *)flagImageView
{
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_flagImageView];
    }
    return _flagImageView;
}
-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:(223/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UIView *)grayLineView
{
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc]init];
        _grayLineView.backgroundColor = [UIColor colorWithRed:(223/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        [self.contentView addSubview:_grayLineView];
    }
    return _grayLineView;
}


-(UILabel *)sectionTitle
{
    if (!_sectionTitle) {
        _sectionTitle = [[UILabel alloc]init];
        _sectionTitle.font = [UIFont systemFontOfSize:18];
        _sectionTitle.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_sectionTitle];
    }
    return _sectionTitle;
}
-(UILabel *)titleabel
{
    if (!_titleabel) {
        _titleabel = [[UILabel alloc]init];
        _titleabel.numberOfLines = 0;
        _titleabel.font = [UIFont systemFontOfSize:15];
        _titleabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_titleabel];
    }
    return _titleabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.numberOfLines = 0;
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)oldPrice
{
    if (!_oldPrice) {
        _oldPrice = [[UILabel alloc]init];
        _oldPrice.font = [UIFont systemFontOfSize:14];
        _oldPrice.textColor = [HXColor colorWithHexString:@"#aaa"];
        [self.contentView addSubview:_oldPrice];
    }
    return _oldPrice;
}



@end
