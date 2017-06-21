//
//  FMShoppingListCell.m
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListCell.h"

#import "FMStyleModel.h"

@interface FMShoppingListCell ()

@property (nonatomic, strong) UIButton *selectButton, *editButton, *deleteButton, *minusButton, *plusButton, *typeButton;

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *titleLabel, *colorLabel, *nMoneyLabel, *dMoneyLabel, *selColorLabel, *numberLabel, *favorLabel;

@property (nonatomic, strong) UIView *nomalView, *selectView;

@property (nonatomic, copy) NSString *numberString;

@property (nonatomic, strong) UITextField *numberTextField;

@end

@implementation FMShoppingListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
    
    [self.contentView addSubview:self.selectButton];
    [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    [self.contentView addSubview:self.photoView];
    self.photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.equalTo(@80);
    }];
    
    [self.nomalView addSubview:self.titleLabel];

    [self.contentView addSubview:self.nomalView];
    [self.contentView addSubview:self.editButton];
    [self.contentView addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    [self.nomalView addSubview:self.colorLabel];
    [self.nomalView addSubview:self.nMoneyLabel];
    [self.nomalView addSubview:self.dMoneyLabel];
    [self.nomalView addSubview:self.numberLabel];
    
    [self.nomalView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_top);
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.right.equalTo(self.editButton.mas_left).offset(-10);
        make.bottom.equalTo(self.photoView.mas_bottom);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nomalView.mas_top);
        make.left.equalTo(self.nomalView.mas_left);
        make.right.equalTo(self.nomalView.mas_right);
    }];
    
    [self.editButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@25);
    }];
    
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editButton.mas_bottom).offset(10);
        make.left.equalTo(self.editButton.mas_left);
        make.width.equalTo(self.editButton.mas_width);
        make.height.equalTo(@30);
    }];
    
    [self.colorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nomalView.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    
    [self.nMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorLabel.mas_bottom).offset(5);
        make.left.equalTo(self.colorLabel.mas_left);
        make.bottom.equalTo(self.photoView.mas_bottom).offset(-5).priorityHigh();
    }];
    
    [self.dMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nMoneyLabel.mas_right).offset(10);
        make.bottom.equalTo(self.photoView.mas_bottom).offset(-5).priorityHigh();
    }];
    
    [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editButton.mas_right);
        make.bottom.equalTo(self.nMoneyLabel.mas_bottom);
    }];
    
    self.selectView.hidden = YES;
    [self.contentView addSubview:self.selectView];
    [self.selectView addSubview:self.numberTextField];
    [self.selectView addSubview:self.minusButton];
    [self.selectView addSubview:self.plusButton];
    [self.selectView addSubview:self.typeButton];
    [self.selectView addSubview:self.selColorLabel];
    [self.selectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_top);
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.right.equalTo(self.editButton.mas_left).offset(-10);
        make.bottom.equalTo(self.photoView.mas_bottom);
    }];
    
    [self.minusButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.selectView);
        make.width.equalTo(self.selectView.mas_width).dividedBy(3);
        make.height.equalTo(@40).priorityLow();
    }];
    
    [self.numberTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minusButton.mas_top);
        make.left.equalTo(self.minusButton.mas_right).offset(1);
        make.width.equalTo(self.minusButton.mas_width);
        make.height.equalTo(self.minusButton.mas_height);
    }];
    
    [self.plusButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minusButton.mas_top);
        make.left.equalTo(self.numberTextField.mas_right).offset(1);
        make.right.equalTo(self.selectView.mas_right);
        make.height.equalTo(self.minusButton.mas_height);
    }];
    
    [self.selColorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusButton.mas_left);
        make.top.equalTo(self.minusButton.mas_bottom).offset(1);
        make.bottom.equalTo(self.photoView.mas_bottom);
        make.right.equalTo(self.numberTextField.mas_right).offset(6);
        
    }];
    [self.typeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selColorLabel.mas_right);
        make.top.equalTo(self.selColorLabel.mas_top);
        make.bottom.equalTo(self.selColorLabel.mas_bottom);
        make.right.equalTo(self.plusButton.mas_right);
    }];
    
    [self.contentView addSubview:self.favorLabel];
    [self.favorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.nMoneyLabel.bottom).offset(5);
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

- (UIButton *)selectButton {
    
    if (!_selectButton) {
        _selectButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"t2-0"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"t2"] forState:(UIControlStateSelected)];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
          [_photoView setUserInteractionEnabled:YES];
        [_photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory)]];
    }
    return _photoView;
}

- (void)clickCategory {
    if (self.photoBlcok) {
        self.photoBlcok();
    }
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)favorLabel {
    if (!_favorLabel) {
        _favorLabel = [[UILabel alloc]init];
        _favorLabel.font = [UIFont systemFontOfSize:12];
        _favorLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    }
    return _favorLabel;
}


-(UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _deleteButton.backgroundColor = [HXColor colorWithHexString:@"#ff6633"];;
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:(UIControlStateNormal)];
        [_editButton setTitle:@"完成" forState:(UIControlStateSelected)];
        [_editButton.layer setBorderColor:KContentTextLightGrayColor.CGColor];
        [_editButton.layer setBorderWidth:1];
        [_editButton.layer setMasksToBounds:YES];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editButton setTitleColor:kColorTextColorClay forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}


- (UIView *)nomalView {
    if (!_nomalView) {
        _nomalView = [[UIView alloc]init];
        _nomalView.backgroundColor = [UIColor clearColor];
    }
    return _nomalView;
}

-(UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc]init];
        _colorLabel.textColor = kColorTextColorClay;
        _colorLabel.font = [UIFont systemFontOfSize:12];

    }
    return _colorLabel;
}


-(UILabel *)nMoneyLabel {
    if (!_nMoneyLabel) {
        _nMoneyLabel = [[UILabel alloc]init];
        _nMoneyLabel.font = [UIFont boldSystemFontOfSize:13];
        _nMoneyLabel.textColor = [HXColor colorWithHexString:@"ff6633"];
    }
    return _nMoneyLabel;
}

-(UILabel *)dMoneyLabel {
    if (!_dMoneyLabel) {
        _dMoneyLabel = [[UILabel alloc]init];
        _dMoneyLabel.font = [UIFont systemFontOfSize:13];
        _dMoneyLabel.textColor = kColorTextColorClay;
    }
    return _dMoneyLabel;
}

-(UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.backgroundColor = [UIColor whiteColor];
    }
    return _selectView;
}

-(UIButton *)minusButton {
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setTitleColor:kColorTextColorClay forState:(UIControlStateNormal)];
        _minusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_minusButton addTarget:self action:@selector(minusAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _minusButton.backgroundColor = KDefaultOrBackgroundColor;
        [_minusButton setTitle:@"—" forState:UIControlStateNormal];
    }
    return _minusButton;
}

-(UIButton *)plusButton {
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.backgroundColor = KDefaultOrBackgroundColor;
        _plusButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_plusButton setTitleColor:kColorTextColorClay forState:(UIControlStateNormal)];
        [_plusButton setTitle:@"+" forState:(UIControlStateNormal)];
        [_plusButton addTarget:self action:@selector(plusAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _plusButton;
}

-(UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeButton.backgroundColor = KDefaultOrBackgroundColor;
        [_typeButton addTarget:self action:@selector(typeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_typeButton setImage:[UIImage imageNamed:@"向下箭头黑色"] forState:(UIControlStateNormal)];
    }
    return _typeButton;
}

-(UILabel *)selColorLabel {
    if (!_selColorLabel) {
        _selColorLabel = [[UILabel alloc]init];
        _selColorLabel.backgroundColor = KDefaultOrBackgroundColor;
        _selColorLabel.textColor = kColorTextColorClay;
        _selColorLabel.font = [UIFont systemFontOfSize:13];
        _selColorLabel.textAlignment = NSTextAlignmentCenter;
//        _selColorLabel.text = @"颜色:橘色  尺码:L";
    }
    return _selColorLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont boldSystemFontOfSize:13];
        _numberLabel.textColor = kColorTextColorClay;
    }
    return _numberLabel;
}

- (UITextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc]init];
        [_numberTextField setBackgroundColor:KDefaultOrBackgroundColor];
        _numberTextField.text = @"1";
        _numberTextField.font = [UIFont boldSystemFontOfSize:14];
        _numberTextField.textAlignment = NSTextAlignmentCenter;

        _numberTextField.enabled = NO;
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numberTextField;
}

#pragma mark - buttonAction
- (void)plusAction:(UIButton *)sender {
    
    NSInteger number = [self.numberString integerValue];
    number ++;
    self.numberString = [NSString stringWithFormat:@"%ld",(long)number];
    self.numberTextField.text = self.numberString;
    
    if (self.plusBlcok) {
        self.plusBlcok(sender);
    }
}

- (void)minusAction:(UIButton *)sender {
    
    if (self.minusBlcok) {
        self.minusBlcok(sender);
    }
    
    NSInteger number = [self.numberString integerValue];

    if (number > 1) {
        number--;
        self.numberString = [NSString stringWithFormat:@"%ld",(long)number];
        self.numberTextField.text = self.numberString;
    }
 }

-(void)numberAction:(UIButton *)sender {
    if (self.numberBlcok) {
        self.numberBlcok(sender);
    }
}

- (void)typeAction:(UIButton *)sender {
    if (self.typeBlcok) {
        self.typeBlcok(sender);
    }
}

- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.selectBlcok) {
        self.selectBlcok(sender);
    }
}

-(void)deleteAction:(UIButton *)sender {
    if (self.deleteBlcok) {
        self.deleteBlcok(sender);
    }
}

- (void)editAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.editBlcok) {
        self.editBlcok(sender);
    }
    if (sender.selected) {
        self.nomalView.hidden = YES;
        self.deleteButton.hidden = NO;
        self.selectView.hidden = NO;
        [self.selectView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoView.mas_top);
            make.left.equalTo(self.photoView.mas_right).offset(5);
            make.right.equalTo(self.editButton.mas_left).offset(-5);
            make.bottom.equalTo(self.photoView.mas_bottom);
        }];
    }else{
        
        self.colorLabel.text =   self.selColorLabel.text;

        self.nomalView.hidden = NO;
        self.deleteButton.hidden = YES;
        self.selectView.hidden = YES;
    }
}

- (void)sendDataToCellWith:(FMShoppingListModel *)model {
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.selectCount];

    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.titleLabel.text = model.name;
    
    if (model.spec.count != 0) {
        self.colorLabel.text = model.currentStyle;
        self.selColorLabel.text = model.currentStyle;
    }else{
        self.colorLabel.text = NULL;
    }
    
    self.nMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price.buy_price floatValue]];

    NSString *oldStr = [NSString stringWithFormat:@"￥%.2f",[model.price.mktprice floatValue]];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
    self.dMoneyLabel.attributedText = attribtStr;

    self.numberTextField.text = [NSString stringWithFormat:@"%ld",(long)model.selectCount];;
    self.numberString = [NSString stringWithFormat:@"%ld",(long)model.selectCount];;
    if (model.selectState) {
        self.selectButton.selected = YES;
    }else{
        self.selectButton.selected = NO;
    }
    
    if (!model.navSelectState) {
        self.selColorLabel.textAlignment = NSTextAlignmentCenter;
        self.nomalView.hidden = NO;
        self.editButton.hidden = NO;
        self.selectView.hidden = YES;
        self.editButton.selected = NO;
        self.deleteButton.hidden = YES;

    }else {
        self.editButton.hidden = YES;
        self.nomalView.hidden = YES;
        self.selectView.hidden = NO;
        [self.selectView remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.photoView.mas_top);
            make.left.equalTo(self.photoView.mas_right).offset(10);
            make.bottom.equalTo(self.photoView.mas_bottom);
        }];
    }
    
    float favorPrice = [model.price.price floatValue]-[model.price.buy_price floatValue];
    if (favorPrice >0) {
        self.favorLabel.text = [NSString stringWithFormat:@"优惠：%.2f",[model.price.price floatValue]-[model.price.buy_price floatValue]];
        [self.favorLabel setHidden:NO];
    }else{
        [self.favorLabel setHidden:YES];
    }
}

- (void)sendDataToCellWithModel:(FMShoppingListModel *)model {
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.selectCount];
    if (model.spec.count!= 0) {

        self.selColorLabel.text = model.currentStyle;
    }else{
        self.selColorLabel.text =  NULL;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
