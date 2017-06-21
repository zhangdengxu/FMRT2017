//
//  FMTimeKillHeaderItem.m
//  fmapp
//
//  Created by runzhiqiu on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillHeaderItem.h"

@interface FMTimeKillHeaderItem ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UIButton * itemButton;



@end

@implementation FMTimeKillHeaderItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setUpUIView];
    }
    return self;
}
-(void)setUpUIView
{
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@16);

    }];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@25);
        
    }];

    [self.itemButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];

}


-(void)changeRedItem;
{
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
}
-(void)changeBlackItem;
{
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
}

-(void)setTimeModel:(FMTimeKillHeaderItemModel *)timeModel
{
    _timeModel = timeModel;
    //红色为1，黑色为2，
    //秒杀中为1，即将开始为2，等待更新为3，次日更新4，
    if ([timeModel.status isEqualToString:@"11"]) {
        self.titleLabel.text = timeModel.timeString;
        self.detailLabel.text = @"秒杀中";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
    }else if ([timeModel.status isEqualToString:@"23"])
    {
        self.titleLabel.text = timeModel.timeString;
        self.detailLabel.text = @"等待更新";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    }else if([timeModel.status isEqualToString:@"12"])
    {
        self.titleLabel.text = timeModel.timeString;
        self.detailLabel.text = @"即将开始";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
    }else if ([timeModel.status isEqualToString:@"22"])
    {
        self.titleLabel.text = timeModel.timeString;
        self.detailLabel.text = @"即将开始";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    }else if([timeModel.status isEqualToString:@"24"])
    {
        self.titleLabel.text = timeModel.timeString;
        self.detailLabel.text = @"次日更新";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;

        _titleLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

-(UIButton *)itemButton
{
    if (!_itemButton) {
        _itemButton = [[UIButton alloc]init];

        _itemButton.backgroundColor = [UIColor clearColor];
        [_itemButton addTarget:self action:@selector(checkRulesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemButton];
    }
    return _itemButton;
}
-(void)checkRulesButtonOnClick:(UIButton *)button
{
    if (self.buttonBlock) {
        self.buttonBlock(self.timeModel.index);
    }
}

@end

@implementation FMTimeKillHeaderItemModel



@end
