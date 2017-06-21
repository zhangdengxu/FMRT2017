//
//  YYScreeningDataCell.m
//  fmapp
//
//  Created by yushibo on 2017/2/28.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYScreeningDataCell.h"

@interface YYScreeningDataCell ()
@property (nonatomic, strong)UIImageView *backView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation YYScreeningDataCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
        [self createContentView];
    }
    return self;
}
- (void)createContentView{
    
    UIImageView *backView= [[UIImageView alloc]init];
    backView.image = [UIImage imageNamed:@"月账单_为选择-灰框_10_1702"];
    self.backView = backView;
    [self.contentView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
//    titleLabel.text = @"全部";
    titleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
    }];
    

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"全部" forState:UIControlStateNormal];
//    
//    
//    button.adjustsImageWhenHighlighted = NO;
//    
//    [button setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"月账单_为选择-灰框_10_1702"] forState:UIControlStateNormal];
//    [button setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateSelected];
//    [button setBackgroundImage:[UIImage imageNamed:@"月账单_选择-蓝框_07_1702"] forState:UIControlStateSelected];
//    self.button = button;
//    [self.contentView addSubview:button];
//    [button makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self.contentView);
//    }];

    
}
-(void)setModel:(YYScreeningDataModel *)model{

    _model = model;
    
    self.titleLabel.text = [model title];
    if(model.selectedState){
    
        self.backView.image = [UIImage imageNamed:@"月账单_选择-蓝框_07_1702"];
        self.titleLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];

    }else{
    
        self.backView.image = [UIImage imageNamed:@"月账单_为选择-灰框_10_1702"];
        self.titleLabel.textColor = [HXColor colorWithHexString:@"#999999"];

    }
}
@end
