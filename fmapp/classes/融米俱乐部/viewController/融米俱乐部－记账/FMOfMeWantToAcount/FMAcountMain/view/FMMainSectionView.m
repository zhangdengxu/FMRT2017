//
//  FMMainSectionView.m
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMMainSectionView.h"

@interface FMMainSectionView ()

@property (nonatomic, strong) UILabel *timeLabel, *sectionRightLabel;

@end

@implementation FMMainSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor purpleColor];
        [self createSectionView];
    }
    return self;
}

- (void)createSectionView {
  
    [self addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.sectionRightLabel];
    [self.sectionRightLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = kColorTextColorClay;
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UILabel *)sectionRightLabel {
    if (!_sectionRightLabel) {
        _sectionRightLabel = [[UILabel alloc]init];
        _sectionRightLabel.textColor = kColorTextColorClay;
        _sectionRightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sectionRightLabel;
}

- (void)sendDataWithModel:(FMAcountSecModel *)model{
    
    if (model.secDate && model.lendTotalMoney && model.incomeTotalMoney) {
        self.timeLabel.text = model.secDate;
        self.sectionRightLabel.text = [NSString stringWithFormat:@"支:￥%@  收:￥%@",[NSString stringWithFormat:@"%.2f",[model.lendTotalMoney floatValue]],[NSString stringWithFormat:@"%.2f",[model.incomeTotalMoney floatValue]]];
    }
}

@end
