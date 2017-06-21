//
//  FMTimeKillCommentCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KDefaultIconRadio 40
#import "FMKillTimeComment.h"

#import "FMTimeKillCommentCell.h"


@interface FMTimeKillCommentCell ()

@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * telePhoneLable;


@end

@implementation FMTimeKillCommentCell

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
    CGFloat titleWidth = KDefaultIconRadio;
    
    [self.iconImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10).priorityHigh();
        make.width.equalTo(titleWidth);
        make.height.equalTo(titleWidth);
    }];
    
    [self.nameLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [self.telePhoneLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(30);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.contentLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
      [self.lineView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(0.5);
    }];
}

-(void)setCommentModel:(FMKillTimeComment *)commentModel
{
    _commentModel = commentModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.head_picture_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.iconImageView.layer.cornerRadius = KDefaultIconRadio * 0.5;
   
    self.nameLabel.text = commentModel.nickname;
    self.telePhoneLable.text = commentModel.phone;
    self.contentLabel.text = commentModel.comment;
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
       
         _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"];
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


-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)telePhoneLable
{
    if (!_telePhoneLable) {
        _telePhoneLable = [[UILabel alloc]init];
        _telePhoneLable.font = [UIFont systemFontOfSize:16];
        _telePhoneLable.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_telePhoneLable];
    }
    return _telePhoneLable;
}


@end
