//
//  FMTimeKillSectionSectionHeader.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultHeaderHeigh 100

#import "FMTimeKillSectionSectionHeader.h"



@interface FMTimeKillSectionSectionHeader ()

@property (nonatomic, strong) UIImageView * halfKillArea;

@property (nonatomic, strong) UIButton * checkRules;

@property (nonatomic, strong) UIButton * commentButton;

@end

@implementation FMTimeKillSectionSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth * 3 / 16) +  38);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self tableViewSectionHeaderView];
    }
    return self;
}



-(UIImageView *)halfKillArea
{
    if (!_halfKillArea) {
        _halfKillArea = [[UIImageView alloc]init];
        _halfKillArea.frame = CGRectMake(12, 11.5, 80, 15);
        _halfKillArea.image = [UIImage imageNamed:@"评价区-文字_28"];
        [self.contentView addSubview:_halfKillArea];
        
    }
    return _halfKillArea;
}

-(UIButton *)checkRules
{
    if (!_checkRules) {
        _checkRules = [[UIButton alloc]init];
        _checkRules.tag = 445;
        _checkRules.frame = CGRectMake(KProjectScreenWidth - 80 - 10, 4, 80, 30);
        [_checkRules setTitle:@"评论规则" forState:UIControlStateNormal];
        [_checkRules setTitleColor:[HXColor colorWithHexString:@"#ff0000"] forState:UIControlStateNormal];
        _checkRules.titleLabel.font = [UIFont systemFontOfSize:13];

        [_checkRules setImage:[UIImage imageNamed:@"活动规则--问号_08"] forState:UIControlStateNormal];
        [_checkRules addTarget:self action:@selector(checkRulesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkRules];
    }
    return _checkRules;
}

-(UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc]init];
        _commentButton.tag = 444;
        _commentButton.frame = CGRectMake(0, 40, KProjectScreenWidth, KProjectScreenWidth * 3 / 16);
        [_commentButton setTitleColor:[HXColor colorWithHexString:@"#ff0000"] forState:UIControlStateNormal];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"评价banner_02"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(checkRulesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentButton];
    }
    return _commentButton;
}

-(void)tableViewSectionHeaderView
{
    [self halfKillArea];
    [self checkRules];
    [self commentButton];
    
    
}
-(void)checkRulesButtonOnClick:(UIButton *)button
{
    if (self.buttonBlock) {
        self.buttonBlock(button.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
