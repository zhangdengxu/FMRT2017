//
//  FMShopStandardTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2016/12/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShopStandardTableViewCell.h"
#import "FMShopOtherModel.h"

@interface FMShopStandardTableViewCell ()

@property (nonatomic, strong) UILabel * titleShopLabel;

@property (nonatomic, strong) UILabel * nameShopLabel;

@property (nonatomic, strong) UIView  * lineView;
@end

@implementation FMShopStandardTableViewCell


-(UILabel *)titleShopLabel
{
    if (!_titleShopLabel) {
        
        _titleShopLabel = [[UILabel alloc]init];
        _titleShopLabel.numberOfLines = 1;
        _titleShopLabel.font = [UIFont systemFontOfSize:14];
        _titleShopLabel.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
        [self.contentView addSubview:_titleShopLabel];
        
    }
    return _titleShopLabel;
}


-(UILabel *)nameShopLabel
{
    if (!_nameShopLabel) {
        _nameShopLabel = [[UILabel alloc]init];
        _nameShopLabel.numberOfLines = 1;
        _nameShopLabel.font = [UIFont systemFontOfSize:14];
        _nameShopLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_nameShopLabel];
        
    }
    return _nameShopLabel;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [HXColor colorWithHexString:@"#f6f6f6"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.titleShopLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.30);
            
        }];
        
        
        [self.nameShopLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.60);
        }];
        
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.height.equalTo(0.5);
            
        }];
    }
    return self;
}

-(void)setShopOtherModel:(FMShopStandardModel *)shopOtherModel
{
    _shopOtherModel = shopOtherModel;
    self.titleShopLabel.text = shopOtherModel.name;
    self.nameShopLabel.text = shopOtherModel.value;
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
