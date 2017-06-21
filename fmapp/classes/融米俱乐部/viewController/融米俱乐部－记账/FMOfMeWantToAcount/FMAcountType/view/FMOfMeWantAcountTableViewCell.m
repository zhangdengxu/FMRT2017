//
//  FMOfMeWantAcountTableViewCell.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMOfMeWantAcountTableViewCell.h"


@interface FMOfMeWantAcountTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FMOfMeWantAcountTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0.5);
        make.height.equalTo(@1);
    }];
    
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = KContentTextColor;
    }
    return _titleLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)sendDataWithModel:(FMAcountLendModel *)model{
    
    self.titleLabel.text = model.title;
}

@end
