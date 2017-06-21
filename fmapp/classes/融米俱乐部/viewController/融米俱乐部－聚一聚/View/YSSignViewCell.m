//
//  YSSignViewCell.m
//  fmapp
//
//  Created by yushibo on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSSignViewCell.h"

@interface YSSignViewCell()
/** 活动时间  */
@property (nonatomic, strong)UILabel *party_timelist;
/** 活动标题  */
@property (nonatomic, strong)UILabel *party_theme;
/** 主办发  */
@property (nonatomic, strong)UILabel *party_initiator;
/** 活动地点  */
@property (nonatomic, strong)UILabel *party_address;
/** 活动状态图片 */
@property (nonatomic, strong)UIImageView *imageV;
/** 活动状态 */
@property (nonatomic, strong)NSString *party_joinstatus;
@end
@implementation YSSignViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}
- (void)createContentView
{

    UIImageView *photoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"报名凭证-票"]];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:photoView];
    [photoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    UILabel *party_theme = [[UILabel alloc]init];
    self.party_theme = party_theme;
    party_theme.font = [UIFont systemFontOfSize:13];
//    party_theme.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    party_theme.textColor = [UIColor blackColor];
    [self.contentView addSubview:party_theme];
    [party_theme makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_top).offset(8);
        make.left.equalTo(photoView.mas_left).offset((KProjectScreenWidth - 35) / 7 * 2);
        make.width.equalTo((KProjectScreenWidth - 35) / 2);
    }];
    
    UILabel *party_initiator = [[UILabel alloc]init];
    self.party_initiator = party_initiator;
//    party_initiator.text = @"哈哈哈哈哈哈哈";
    party_initiator.font = [UIFont systemFontOfSize:10];
    party_initiator.textColor = [UIColor colorWithHexString:@"#646464"];
    [self.contentView addSubview:party_initiator];
    [party_initiator makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_theme.mas_bottom).offset(4);
        make.left.equalTo(party_theme.mas_left).offset(2);
    }];
    
    UILabel *party_timelist = [[UILabel alloc]init];
    self.party_timelist = party_timelist;
//    party_timelist.text = @"哈哈哈哈哈哈哈";
    party_timelist.font = [UIFont systemFontOfSize:10];
    party_timelist.textColor = [UIColor colorWithHexString:@"#646464"];
    [self.contentView addSubview:party_timelist];
    [party_timelist makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_initiator.mas_bottom).offset(4);
        make.left.equalTo(party_initiator.mas_left);
    }];
    
    UILabel *party_address = [[UILabel alloc]init];
    self.party_address = party_address;
//    party_address.text = @"哈哈哈哈哈哈哈";
    party_address.font = [UIFont systemFontOfSize:10];
    party_address.textColor = [UIColor colorWithHexString:@"#646464"];
    [self.contentView addSubview:party_address];
    [party_address makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_timelist.mas_bottom).offset(4);
        make.left.equalTo(party_timelist.mas_left);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
//    imageV.image = [UIImage imageNamed:@"我的参与_报名凭证_即将开始"];
    self.imageV = imageV;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_top);
        make.right.equalTo(photoView.mas_right);
    }];
    /**
     *  
     "pid": "4",
     "uid": "191",
     "join_time": "1456130753",
     "phone": "15966065659",
     "party_theme": "活动标题测试",
     "party_address": "济南融米俱乐部",
     "party_initiator": "liurui",
     "party_timelist": "2016-02-22至2016-03-22",
     "party_labletitle": "免费报名",
     "party_joinstatus": 3
     */
}

- (void)setDataSource:(YSSignModel *)dataSource{

    _dataSource = dataSource;
    if (![dataSource.party_address isKindOfClass:[NSNull class]]) {
        self.party_address.text = dataSource.party_address;
    }else{
        self.party_address.text = @"无";
    }
    if (![dataSource.party_initiator isKindOfClass:[NSNull class]]) {
        self.party_initiator.text = dataSource.party_initiator;
    }else{
        self.party_initiator.text = @"无";
    }
    if (![dataSource.party_theme isKindOfClass:[NSNull class]]) {
        self.party_theme.text = dataSource.party_theme;
    }else{
        self.party_theme.text = @"无";
    }
//    if (![dataSource.party_timelist isKindOfClass:[NSNull class]]) {
//        self.party_timelist.text = dataSource.party_timelist;
//    }else{
//        self.party_timelist.text = @"无";
//    }
    
    self.party_timelist.text = ![dataSource.party_timelist isKindOfClass:[NSNull class]] ? dataSource.party_timelist:@"无";
    
    
    self.party_joinstatus = dataSource.party_joinstatus;
    
    if ([self.party_joinstatus intValue] == 1) {
        self.imageV.image = [UIImage imageNamed:@"我的参与_报名凭证_即将开始"];
    }
    if ([self.party_joinstatus intValue] == 2) {
        self.imageV.image = [UIImage imageNamed:@"我的参与_报名凭证_已验票"];
    }
    if ([self.party_joinstatus intValue] == 3) {
        self.imageV.image = [UIImage imageNamed:@"我的参与_报名凭证_已结束"];
    }
    if ([self.party_joinstatus intValue] == 4) {
        self.imageV.image = [UIImage imageNamed:@"我的参与_报名凭证_已拒绝"];
    }

}
@end
