//
//  FMRTBackEarningCell.m
//  fmapp
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTBackEarningCell.h"

@interface FMRTBackEarningCell ()

@property (nonatomic, strong) UILabel *nameLabel,*earningLabel,*totalLabel;

@end

@implementation FMRTBackEarningCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    
    [self.earningLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).offset(20);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.earningLabel.left).offset(10).priorityLow();
    }];
    
    [self.totalLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"企业经营贷170233444";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)earningLabel{
    if (!_earningLabel) {
        _earningLabel = [[UILabel alloc]init];
        _earningLabel.textColor = [UIColor colorWithHexString:@"#666"];
        _earningLabel.text = @"9.80";
        _earningLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_earningLabel];
    }
    return _earningLabel;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.text = @"0.4";
        _totalLabel.textColor = [UIColor colorWithHexString:@"#666"];
        _totalLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_totalLabel];
    }
    return _totalLabel;
}


@end
