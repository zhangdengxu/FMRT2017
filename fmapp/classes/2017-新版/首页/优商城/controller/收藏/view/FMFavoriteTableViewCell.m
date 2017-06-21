//
//  FMFavoriteTableViewCell.m
//  fmapp
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMFavoriteTableViewCell.h"


@interface FMFavoriteTableViewCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *titleLabel, *moneyLabel, *oldMoneyLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation FMFavoriteTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
 
    [self.contentView addSubview:self.photoView];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(35);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(@100);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.photoView.mas_bottom).offset(-5).priorityHigh();
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10).priorityLow();
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
    [self.contentView addSubview:self.oldMoneyLabel];
    [self.oldMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(5);
        make.centerY.equalTo(self.moneyLabel.mas_centerY);
    }];
    
    [self.contentView addSubview:self.selectButton];
    [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    UIView *bottomGrayView = [[UIView alloc]init];
    bottomGrayView.backgroundColor = KDefaultOrBackgroundColor;
    [self.contentView addSubview:bottomGrayView];
    [bottomGrayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(@5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
//        _photoView.image = [UIImage imageNamed:@"t6"];
        _photoView.backgroundColor = [UIColor purpleColor];
    }
    return _photoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KContentTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
//        _titleLabel.text = @"泉都优蜜丝锐秋玻尿酸密集补水蚕丝面膜 你值得拥有";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
//        _moneyLabel.text = @"￥24800.00   ￥24800.00";
        _moneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLabel;
}

- (UILabel *)oldMoneyLabel {
    if (!_oldMoneyLabel) {
        _oldMoneyLabel = [[UILabel alloc]init];
        _oldMoneyLabel.textColor = kColorTextColorClay;
        _oldMoneyLabel.font = [UIFont systemFontOfSize:13];

    }
    return _oldMoneyLabel;
}

- (UIButton *)selectButton {
    
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_selectButton setImage:[UIImage imageNamed:@"t2-0"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"t2"] forState:(UIControlStateSelected)];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectButton;
}

- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender);
    }
}

- (void)sendeDataWithModel:(FMFavoriteModel *)model {
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.titleLabel.text = model.name;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    
    NSString *oldStr = [NSString stringWithFormat:@"￥%.2f",model.mktprice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
    self.oldMoneyLabel.attributedText = attribtStr;

    if (model.selectState) {
        self.selectButton.selected = YES;
    }else{
        self.selectButton.selected = NO;
    }
    
    if (model.navSelectState) {
        self.selectButton.hidden = NO;
        [self.photoView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(35);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.equalTo(@80);
        }];
        
    }else {
        self.selectButton.hidden = YES;
        [self.photoView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.equalTo(@80);
        }];
    }
}

@end
