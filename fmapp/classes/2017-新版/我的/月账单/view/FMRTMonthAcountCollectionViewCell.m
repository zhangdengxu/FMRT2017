//
//  FMRTMonthAcountCollectionViewCell.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTMonthAcountCollectionViewCell.h"
#import "FMRTMonthAcountModel.h"

@interface FMRTMonthAcountCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel,*colorLabel;

@end

@implementation FMRTMonthAcountCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.colorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.left);
        make.centerY.equalTo(self.contentView.centerY).offset(-2);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"本月收益";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666"];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)colorLabel{
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc]init];
        _colorLabel.text = @"•";
        _colorLabel.textColor = [UIColor colorWithHexString:@"#2cb6f2"];
        _colorLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_colorLabel];
    }
    return _colorLabel;
}

- (void)setRow:(NSInteger)row{
    _row = row;

}

- (void)setNumber:(NSNumber *)number{
    _number = number;
    switch (_row) {
        case 0:{
            self.colorLabel.textColor = [UIColor colorWithHexString:@"#2cb6f2"];
            self.titleLabel.text = [NSString stringWithFormat:@"充值: %.2f元",[number doubleValue]];
            break;
        }
        case 1:{
            self.colorLabel.textColor = [UIColor colorWithHexString:@"#fd6165"];
            
            self.titleLabel.text = [NSString stringWithFormat:@"回款本金: %.2f元",[number doubleValue]];
            break;
        }
        case 2:{
            self.colorLabel.textColor = [UIColor colorWithHexString:@"#0159d5"];
            self.titleLabel.text = [NSString stringWithFormat:@"本月佣金: %.2f元",[number doubleValue]];
            
            break;
        }
        case 3:{
            self.colorLabel.textColor = [UIColor colorWithHexString:@"#3eb78a"];
            self.titleLabel.text = [NSString stringWithFormat:@"本月收益: %.2f元",[number doubleValue]];
            
            break;
        }
        case 4:{

            self.colorLabel.textColor = [UIColor colorWithHexString:@"#feb358"];
            self.titleLabel.text = [NSString stringWithFormat:@"其他收入: %.2f元",[number doubleValue]];
            
            break;
        }
        default:
            break;
    }
    
}

@end
