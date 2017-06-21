//
//  FMRTRemarkTableViewCell.m
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTRemarkTableViewCell.h"

#import "FMRTAucModel.h"

@interface FMRTRemarkTableViewCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *titleLabel, *remarkLabel, *nameLabel;

@end

@implementation FMRTRemarkTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
  
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.equalTo(@36);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.centerY.equalTo(self.photoView.mas_centerY);
        make.width.equalTo(@100);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.photoView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.remarkLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    UIView *bottomlineView = [UIView new];
    bottomlineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:bottomlineView];
    [bottomlineView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
        make.left.right.equalTo(self.contentView);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
        _photoView.layer.cornerRadius = 18;
        _photoView.layer.masksToBounds = YES;
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:self.photoView];
    }
    return _photoView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];

    }
    return _titleLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.font = [UIFont systemFontOfSize:14];
        _remarkLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:self.remarkLabel];

    }
    return _remarkLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_nameLabel];
        
    }
    return _nameLabel;
}


+ (CGFloat)hightForCellWith:(FMRTAucModel *)model{

    CGFloat width = KProjectScreenWidth - 70;
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGRect rect = [model.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height + 50 +10;
}

- (void)setModel:(FMRTAucModel *)model{
    _model = model;
    [self.photoView sd_setImageWithURL:model.head_picture_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.nickname];

    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.phone];
    self.remarkLabel.text = model.comment;
}


@end
