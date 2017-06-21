//
//  FMfinanceAndReadTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMfinanceAndReadTableViewCell.h"
#import "FMBeautifulModel.h"


@interface FMfinanceAndReadTableViewCell ()

@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  UILabel *titlelabel;
@property (strong, nonatomic)  UILabel *detailLabel;
@property (strong, nonatomic)  UILabel *timelabel;
@property (nonatomic, strong) UIView * lineView;

@end



@implementation FMfinanceAndReadTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUIMassary];
    }
    return self;
}

-(void)setUpUIMassary
{
    
    
    [self.iconImage makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.3);
        make.height.equalTo(self.iconImage.mas_width).multipliedBy(0.7);
        
    }];
    
    [self.titlelabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImage.mas_right).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.equalTo(self.titlelabel.mas_width).multipliedBy(0.4);
        
        
    }];
    
    [self.timelabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.equalTo(self.titlelabel.mas_width).multipliedBy(0.5);
        
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
    
}




-(void)setDataSource:(FMBeautifulModel *)dataSource
{
    _dataSource = dataSource;
    
    if (dataSource) {
        
        if (![dataSource.thumb isMemberOfClass:[NSNull class]]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:dataSource.thumb] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
        }else
        {
            [self.iconImage setImage:[UIImage imageNamed:@"敬请稍后new_03"]];
        }
        
        if (![dataSource.title isMemberOfClass:[NSNull class]]) {
            self.titlelabel.text = dataSource.title;
        }else
        {
            self.titlelabel.text = @"";
        }
        
        if (![dataSource.author isMemberOfClass:[NSNull class]]) {
            self.detailLabel.text = dataSource.author;
        }else
        {
            self.detailLabel.text = @"";
        }
        
        if (![dataSource.addtime isMemberOfClass:[NSNull class]]) {
            self.timelabel.text = dataSource.addtime;
        }else
        {
            self.timelabel.text = @"";
        }
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



-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        _titlelabel.numberOfLines = 2.0;
        _titlelabel.font = [UIFont systemFontOfSize:17];
        _titlelabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _titlelabel.text = @"我行遍世间所有的路，只为今生与你邂逅";
        
        [self.contentView addSubview:_titlelabel];
        
    }
    return _titlelabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
        _detailLabel.text = @"小融微言";
        
        [self.contentView addSubview:_detailLabel];
        
    }
    return _detailLabel;
}

-(UILabel *)timelabel
{
    if (!_timelabel) {
        _timelabel = [[UILabel alloc]init];
        _timelabel.textAlignment = NSTextAlignmentRight;
        _timelabel.font = [UIFont systemFontOfSize:14];
        _timelabel.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
        _timelabel.text = @"2016-10-22";
        
        [self.contentView addSubview:_timelabel];
        
    }
    return _timelabel;
}



-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.image = [UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"];
        [self.contentView addSubview:_iconImage];
    }
    return _iconImage;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [HXColor colorWithHexString:@"#aaaaaa"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
    
}


@end
