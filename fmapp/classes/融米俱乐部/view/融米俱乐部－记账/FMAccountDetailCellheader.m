//
//  FMAccountDetailCellheader.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAccountDetailCellheader.h"

#import "FMKeepAccount.h"


@interface FMAccountDetailCellheader ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * expendLabel;
@property (nonatomic, strong) UILabel * incomeLabel;



@end


@implementation FMAccountDetailCellheader



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 40);
        self.contentView.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        [self tableViewSectionAddmassory];
    }
    return self;
}
-(void)tableViewSectionAddmassory
{
//    CGFloat midWidth = KProjectScreenWidth * 0.25;
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.expendLabel.mas_left).offset(-5).priorityLow();

    }];
    
    [self.expendLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.incomeLabel.mas_left).offset(-8);

    }];
    
    [self.incomeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expendLabel.mas_right).offset(8);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        
    }];

    
}

-(void)setSectionModel:(FMKeepAccountDetailCellSectionHeaderModel *)sectionModel
{
    _sectionModel = sectionModel;
    
    self.timeLabel.text = sectionModel.timeLabel;
    
    self.expendLabel.text = sectionModel.expendLabel;

    
    self.incomeLabel.text = sectionModel.incomeLabel;

    
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [HXColor colorWithHexString:@"#222324"];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)expendLabel
{
    if (!_expendLabel) {
        _expendLabel = [[UILabel alloc]init];
        _expendLabel.font = [UIFont systemFontOfSize:14];
        _expendLabel.textColor = [HXColor colorWithHexString:@"#222324"];
        [self.contentView addSubview:_expendLabel];
    }
    return _expendLabel;
}
-(UILabel *)incomeLabel
{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.font = [UIFont systemFontOfSize:14];
        _incomeLabel.textColor = [HXColor colorWithHexString:@"#222324"];
        [self.contentView addSubview:_incomeLabel];
    }
    return _incomeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
