//
//  FMTimeKillTableViewFooterView.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillTableViewFooterView.h"

@interface FMTimeKillTableViewFooterView ()

@property (nonatomic, strong) UIButton * addMoreDataButton;
@property (nonatomic, strong) UIView * backGrouneView;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * detailLabel;

@end

@implementation FMTimeKillTableViewFooterView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 45 + 65) ;
        self.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1];
        
        [self createImageHeaderAndScrollView];
        
    }
    return self;
}




-(void)createImageHeaderAndScrollView
{
    [self addMoreDataButton];
    [self backGrouneView];
    [self titleLable];
    [self detailLabel];
    
    
}
-(UIView *)backGrouneView
{
    if (!_backGrouneView) {
        _backGrouneView = [[UIView alloc]init];
        _backGrouneView.frame = CGRectMake(0, 45, KProjectScreenWidth, 65);
        _backGrouneView.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
        [self addSubview:_backGrouneView];
    }
    return _backGrouneView;
}

-(UIButton *)addMoreDataButton
{
    if (!_addMoreDataButton) {
        _addMoreDataButton = [[UIButton alloc]init];
        _addMoreDataButton.tag = 789;
        _addMoreDataButton.backgroundColor = [UIColor colorWithRed:(223/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        _addMoreDataButton.frame = CGRectMake(0, 0, KProjectScreenWidth, 45);
        [_addMoreDataButton setTitle:@"加载更多" forState:UIControlStateNormal];
        [_addMoreDataButton setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:UIControlStateNormal];
        _addMoreDataButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_addMoreDataButton addTarget:self action:@selector(addMoreDataButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addMoreDataButton];
    }
    return _addMoreDataButton;
}

-(void)changeBottomTitle;
{
    [self.addMoreDataButton setTitle:@"没有更多评论数据" forState:UIControlStateNormal];
}



-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.frame = CGRectMake(0, CGRectGetMaxY(self.addMoreDataButton.frame) + 5, KProjectScreenWidth, 25);
        _titleLable.numberOfLines = 1;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.text = @"最终解释权归融托金融所有，";
        [self addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLable.frame) + 5, KProjectScreenWidth, 25);
        _detailLabel.numberOfLines = 1;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.text = @"如有疑问可联系微信客服rongtuojinrong001或拨打4008788686";
        if (KProjectScreenWidth == 320) {
            _detailLabel.font = [UIFont systemFontOfSize:10];
        }else
        {
            _detailLabel.font = [UIFont systemFontOfSize:12];
        }
        
        _detailLabel.textColor = [UIColor whiteColor];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}


-(void)addMoreDataButtonOnClick:(UIButton *)button
{
    if(self.buttonBlock)
    {
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
