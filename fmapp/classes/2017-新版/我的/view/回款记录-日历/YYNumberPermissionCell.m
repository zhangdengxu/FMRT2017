//
//  YYNumberPermissionCell.m
//  fmapp
//
//  Created by yushibo on 2017/3/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYNumberPermissionCell.h"

@interface YYNumberPermissionCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *iconView;
@end
@implementation YYNumberPermissionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];

        [self createContentView];
    }
    return self;
}
- (void)createContentView{
    
    UIImageView *iconView= [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"我的推荐_设置不选择（灰色）_1702"];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    [iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"0.5";
    titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView.mas_centerY);
        make.left.equalTo(iconView.mas_right).offset(7);
    }];
    
}

-(void)setDataItem:(YYPermissionSettingModel *)dataItem{

     _dataItem = dataItem;
    self.titleLabel.text = dataItem.title;
    if (dataItem.selectedState) {
        self.iconView.image = [UIImage imageNamed:@"我的推荐_设置-选择（蓝色）_1702"];
    }else{
        self.iconView.image = [UIImage imageNamed:@"我的推荐_设置不选择（灰色）_1702"];
    }
}
@end
