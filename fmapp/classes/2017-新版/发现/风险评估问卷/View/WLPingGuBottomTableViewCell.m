//
//  WLPingGuBottomTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLPingGuBottomTableViewCell.h"
#import "Fm_Tools.h"

@interface WLPingGuBottomTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel,*ztLabel;

@end

@implementation WLPingGuBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, KProjectScreenWidth/2, 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[HXColor colorWithHexString:@"#333"]];
        [self.contentView addSubview:_nameLabel];
        
    }
    return _nameLabel;
}



-(UILabel *)ztLabel{
    
    if (!_ztLabel) {
        _ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-25, 0, KProjectScreenWidth/2, 50)];
        [_ztLabel setFont:[UIFont systemFontOfSize:16]];
        [_ztLabel setTextAlignment:NSTextAlignmentRight];
        [_ztLabel setTextColor:[HXColor colorWithHexString:@"#666"]];
        [self.contentView addSubview:_ztLabel];
    }
    return _ztLabel;
}

-(void)setModel:(WLPingGuModel *)model{
    _model = model;
    [self.nameLabel setText:[Fm_Tools getTimeFromString:model.Time]];
    [self.ztLabel setText:model.GradeName];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(25, 0, KProjectScreenWidth-50, 1)];
    if ([self.isLong isEqualToString:@"1"]) {
        [lineView setFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    }
    [lineView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    [self.contentView addSubview:lineView];
}


@end
