//
//  FMDuobaoSHopCellFooter.m
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDuobaoSHopCellFooter.h"

@interface FMDuobaoSHopCellFooter()


@property (nonatomic, strong) UIView  * fourViewContent;
@property (nonatomic, strong) UIButton * fourViewThrowMoney;

@property (nonatomic, strong) UIImageView  * iconImageView;
@end

@implementation FMDuobaoSHopCellFooter

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView setImage:[UIImage imageNamed:@"收起1014"]];
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
    }
    return _iconImageView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 40);
        self.contentView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];;
        [self tableViewSectionHeaderView];
    }
    return self;
}


-(void)tableViewSectionHeaderView
{
    
    [self fourViewContent];
    [self iconImageView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)prepareForReuse
{
    [super prepareForReuse];
}


-(void)winTheShopMoneyButtonOnClick:(UIButton *)button
{
    if (self.buttonBlock) {
        self.buttonBlock(self.section);
    }
}
-(UIView *)fourViewContent
{
    if (!_fourViewContent) {
        _fourViewContent = [[UIView alloc]init];
        _fourViewContent.backgroundColor = [UIColor whiteColor];
        _fourViewContent.frame = CGRectMake(0, 0, KProjectScreenWidth, 40);
        [self.contentView addSubview:_fourViewContent];
        [self.fourViewThrowMoney makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fourViewContent.mas_left);
            make.right.equalTo(_fourViewContent.mas_right);
            make.centerY.equalTo(_fourViewContent.mas_centerY);
        }];
        
    }
    
    return _fourViewContent;
}




-(UIButton *)fourViewThrowMoney
{
    if (!_fourViewThrowMoney) {
        _fourViewThrowMoney = [[UIButton alloc]init];
        _fourViewThrowMoney.tag = 421;
        [_fourViewThrowMoney setBackgroundColor:[UIColor whiteColor]];
        [_fourViewThrowMoney addTarget:self action:@selector(winTheShopMoneyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        
        [self.fourViewContent addSubview:_fourViewThrowMoney];
    }
    return _fourViewThrowMoney;
}

@end
