//
//  FMShoppingListGatherCell.m
//  fmapp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListGatherCell.h"


@interface FMShoppingListGatherCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *gatherButton;

@end

@implementation FMShoppingListGatherCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    
    [self.contentView addSubview: self.gatherButton];
    [self.gatherButton makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIButton *)gatherButton {
    if (!_gatherButton) {
        _gatherButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_gatherButton setTitle:@"去凑单>" forState:(UIControlStateNormal)];
        [_gatherButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        _gatherButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_gatherButton addTarget:self action:@selector(gatherButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gatherButton;
}

- (void)gatherButtonAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}


@end
