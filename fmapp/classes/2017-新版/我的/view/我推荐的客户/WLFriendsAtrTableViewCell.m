//
//  WLFriendsAtrTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLFriendsAtrTableViewCell.h"
@interface WLFriendsAtrTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel,*timeLabel,*ztLabel;

@end

@implementation WLFriendsAtrTableViewCell

- (UILabel *)nameLabel{//真实姓名
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [self.contentView addSubview:_nameLabel];
        
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{//手机号
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        [_timeLabel setFont:[UIFont systemFontOfSize:16]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)ztLabel{//投标金额
    
    if (!_ztLabel) {
        _ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-100, 0, 100, 50)];
        [_ztLabel setFont:[UIFont systemFontOfSize:16]];
        [_ztLabel setTextAlignment:NSTextAlignmentCenter];
        [_ztLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
        [self.contentView addSubview:_ztLabel];
    }
    return _ztLabel;
}

-(void)setModel:(FMRTTuijianModel *)model{
    _model = model;
    
    [self.nameLabel setText:model.zhenshixingming];
    NSString*string =model.shouji;
    [self.timeLabel setText:[NSString stringWithFormat:@"%@****%@",[string substringToIndex:3],[string substringFromIndex:7]]];
    [self.ztLabel setText:model.tbjiner];
    
}

@end
