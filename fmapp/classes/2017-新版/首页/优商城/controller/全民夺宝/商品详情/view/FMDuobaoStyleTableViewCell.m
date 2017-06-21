//
//  FMDuobaoStyleTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/10/15.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDuobaoStyleTableViewCell.h"


@interface FMDuobaoStyleTableViewCell ()

@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation FMDuobaoStyleTableViewCell

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        
    }
    return _contentLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return self;
}

-(void)setContentString:(NSString *)contentString
{
    self.contentLabel.text = contentString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
