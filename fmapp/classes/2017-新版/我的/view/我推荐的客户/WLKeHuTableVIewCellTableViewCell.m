//
//  WLKeHuTableVIewCellTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLKeHuTableVIewCellTableViewCell.h"
#import "Fm_Tools.h"
@interface WLKeHuTableVIewCellTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel,*timeLabel,*ztLabel;

@end


@implementation WLKeHuTableVIewCellTableViewCell


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [self.contentView addSubview:_nameLabel];
        
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        [_timeLabel setFont:[UIFont systemFontOfSize:16]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [_timeLabel setText:@"2015-04-18"];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)ztLabel{

    if (!_ztLabel) {
        _ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-100, 0, 100, 50)];
        [_ztLabel setFont:[UIFont systemFontOfSize:16]];
        [_ztLabel setTextAlignment:NSTextAlignmentCenter];
        [_ztLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [_ztLabel setText:@"已投资"];
        [self.contentView addSubview:_ztLabel];
    }
    return _ztLabel;
}

-(void)setModel:(FMRTTuijianModel *)model{
    _model = model;
    
    [self.nameLabel setText:model.zhenshixingming];
    [self.timeLabel setText:[Fm_Tools getTimeFromString:model.reg_time]];
    if ([model.touzishu intValue]>0) {
      [self.ztLabel setText:@"已投资"];
    }else{
      [self.ztLabel setText:@"未投资"];
    }
    

}

@end
