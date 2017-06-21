//
//  FMLinshiCellButton.m
//  fmapp
//
//  Created by runzhiqiu on 16/9/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMLinshiCellButton.h"



@interface FMLinshiCellButton ()

@property (nonatomic, strong) UILabel * titLabel;
@property (nonatomic, strong) UILabel * timeLabel;


@end

@implementation FMLinshiCellButton


-(UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc]init];
        _titLabel.numberOfLines = 0;
        _titLabel.textAlignment = NSTextAlignmentCenter;
        _titLabel.font = [UIFont systemFontOfSize:15];
        _titLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
        [self addSubview:_titLabel];
    }
    return _titLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)setUpData;
{
    if (self.cellType == FMLinshiCellButtonTypeActivity) {
        self.titLabel.hidden = NO;
         self.timeLabel.hidden = NO;
       self.titLabel.text = self.contentString;
       self.timeLabel.text = self.timeString;
        
        self.backgroundColor = [HXColor colorWithHexString:@"#ff0000"];
        
    }else if(self.cellType == FMLinshiCellButtonTypeDownTime)
    {
        //据开始
        self.titLabel.hidden = NO;
        self.timeLabel.hidden = YES;
          self.titLabel.text = self.contentString;
        
        self.backgroundColor = [HXColor colorWithHexString:@"#35ba4a"];
        
    }else if(self.cellType == FMLinshiCellButtonTypeEnd)
    {
        self.titLabel.hidden = NO;
        self.timeLabel.hidden = YES;
         self.titLabel.text = self.contentString;
        
        self.backgroundColor = [HXColor colorWithHexString:@"#aaaaaa"];
    }else
    {
        
    }
}

-(void)setCellType:(FMLinshiCellButtonType)cellType
{
    _cellType = cellType;
    
    if (cellType == FMLinshiCellButtonTypeActivity) {
        
         self.backgroundColor = [HXColor colorWithHexString:@"#ff0000"];
        [self addmessary_miaoshajinxingshi];
        
    }else if(cellType == FMLinshiCellButtonTypeDownTime)
    {
        //据开始
        self.backgroundColor = [HXColor colorWithHexString:@"#35ba4a"];
        [self addmessary_jukaishi];

    }else if(cellType == FMLinshiCellButtonTypeEnd)
    {
        self.backgroundColor = [HXColor colorWithHexString:@"#aaaaaa"];
        [self addmessary_yijieshu];
    }
}

-(void)addmessary_miaoshajinxingshi
{
    [self.titLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    
    [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titLabel.mas_bottom);
        make.height.equalTo(self.mas_height).multipliedBy(0.4);
    }];

}

-(void)addmessary_yijieshu
{
    
    [self.titLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    
    self.timeLabel.hidden = YES;
}

-(void)addmessary_jukaishi
{
    [self.titLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    
    self.timeLabel.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
