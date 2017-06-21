//
//  FMfinanceAndReadHeaderViewNew.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMfinanceAndReadHeaderViewNew.h"
#import "FMBeautifulModel.h"


@interface FMfinanceAndReadHeaderViewNew()

@property (strong, nonatomic) UIImageView * iconImage;

@property (nonatomic, strong) UIView * backGroundView;

@property (strong, nonatomic) UILabel * titlelabel;

@property (nonatomic, strong) UIButton * preButton;

@end


@implementation FMfinanceAndReadHeaderViewNew


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = 320 * (KProjectScreenWidth / 320);
        rect.size.height = 145 * (KProjectScreenWidth / 320);
        self.frame = rect;
        
        [self addmassory];

    }
    return self;
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
        
    }
}


-(void)addmassory
{
    [self.iconImage makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self);
        
    }];
    
    [self.backGroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iconImage);
        make.bottom.equalTo(self.iconImage.mas_bottom);
        make.height.equalTo(@45);
        
        
    }];
    
    [self.titlelabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iconImage);
        make.bottom.equalTo(self.iconImage.mas_bottom);
        make.height.equalTo(@45);
    }];
    
    [self.preButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self);

    }];
    
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIButton *)preButton
{
    if (!_preButton) {
        _preButton = [[UIButton alloc]init];
        _preButton.tag = 301;
        [_preButton addTarget:self action:@selector(backGroundButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
    }
    return _preButton;
}

-(void)backGroundButtonOnclick:(UIButton *)button
{
    if (self.buttonBlock) {
        self.buttonBlock(self.dataSource);
    }
}


-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}


-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        _titlelabel.numberOfLines = 1.0;
        _titlelabel.font = [UIFont systemFontOfSize:17];
        _titlelabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _titlelabel.text = @"我行遍世间所有的路，只为今生与你邂逅";
        
        [self addSubview:_titlelabel];
        
    }
    return _titlelabel;
}


-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.image = [UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"];
        [self addSubview:_iconImage];
    }
    return _iconImage;
}


@end
