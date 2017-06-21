//
//  FMRTWellStoreGrayTableViewCell.m
//  fmapp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreGrayTableViewCell.h"
#import "HexColor.h"

@interface FMRTWellStoreGrayTableViewCell ()

@property (nonatomic, strong) UIView *backbottomView;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UILabel *timeLabel,*titleLabel,*contentLabel;

@end

@implementation FMRTWellStoreGrayTableViewCell


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
    
    
    [self.contentView addSubview:self.backbottomView];
    [self.backbottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLabel.bottom).offset(10);
        make.left.equalTo(self.contentView.left).offset(10);
        make.right.equalTo(self.contentView.right).offset(-20);
        make.height.equalTo(@200);
    }];
    
    [self.contentView addSubview:self.bottomView];
    self.bottomView.image = [UIImage imageNamed:@"优商城_售后处理中详情页－灰色箭头_36"];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backbottomView.top).offset(8);
        make.left.equalTo(self.backbottomView.right);
    }];
    
    [self.backbottomView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backbottomView.top).offset(15);
        make.left.equalTo(self.backbottomView.left).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#cccccc"];
    [self.backbottomView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.backbottomView.right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.backbottomView addSubview:self.contentLabel];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(lineView.right);
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


- (UIView *)backbottomView{
    if (!_backbottomView) {
        _backbottomView = [[UIView alloc]init];
        _backbottomView.backgroundColor = [HXColor colorWithHexString:@"#ededed"];
        _backbottomView.layer.masksToBounds = YES;
        _backbottomView.layer.cornerRadius = 5;
    }
    return _backbottomView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [HXColor colorWithHexString:@"#666666"];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

+(CGFloat )heightForCellWith:(FMRTWellStoreSaledDealModel *)model{
    CGFloat width = (KProjectScreenWidth - 60);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];

    return rect.size.height + 140;
}

- (void)setModel:(FMRTWellStoreSaledDealModel *)model{
    _model = model;
    
    CGFloat width = (KProjectScreenWidth - 60);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    [self.backbottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(rect.size.height + 80);
    }];
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
}

@end
