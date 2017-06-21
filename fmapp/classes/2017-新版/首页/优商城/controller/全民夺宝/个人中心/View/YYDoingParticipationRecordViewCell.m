//
//  YYDoingParticipationRecordViewCell.m
//  fmapp
//
//  Created by yushibo on 2016/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//  参与记录 -- 正在进行 

#import "YYDoingParticipationRecordViewCell.h"

#import "Fm_Tools.h"
@interface YYDoingParticipationRecordViewCell ()
/** 夺宝商品名称  */
@property (nonatomic, strong) UILabel *goods_name;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) UIImageView *goods_img;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressV;
/** 1币得 / 5币得 / 老友价 */
@property (nonatomic, strong) UIImageView *numberBiView;
/** 开奖时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 百分数 */
@property (nonatomic, strong) UILabel *percentLabel;
@end
@implementation YYDoingParticipationRecordViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    /** 上细线  */
    UIView * topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    /** 商品图  */
    UIImageView *goodsView = [[UIImageView alloc]init];
    goodsView.image = [UIImage imageNamed:@"商品图_03"];
    self.goods_img = goodsView;
    [self.contentView addSubview:goodsView];
    [goodsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).offset(15);
        make.left.equalTo(topLine.mas_left).offset(15);
        make.height.and.width.equalTo(100);
    }];
    /** 商品名称  */
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.goods_name = nameLabel;
    nameLabel.text = @"苹果apple4.7电击死技术的安静的哭声几点开始";
    [self.contentView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsView.mas_right).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(goodsView.mas_top).offset(10);
    }];
    
    /** 1币得  */
    UIImageView *numberBiView = [[UIImageView alloc]init];
    numberBiView.image = [UIImage imageNamed:@"全新1币得"];
    self.numberBiView = numberBiView;
    [self.contentView addSubview:numberBiView];
    [numberBiView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(12);
        
    }];
    
    /** 百分数  */
    UILabel *percentLabel = [[UILabel alloc]init];
    percentLabel.text = @"92%";
    percentLabel.textColor = [UIColor colorWithHexString:@"#0099ff"];
    percentLabel.font = [UIFont systemFontOfSize:14];
    self.percentLabel = percentLabel;
    [self.contentView addSubview:percentLabel];
    [percentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.top.equalTo(numberBiView.mas_bottom).offset(10);
    }];
    /** 进度条  */
    UIProgressView *progressV = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressV.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    progressV.progress = 0.92;
    progressV.progressTintColor = [UIColor colorWithHexString:@"#0099ff"];
    self.progressV = progressV;
    [self.contentView addSubview:progressV];
    [progressV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(numberBiView.mas_bottom).offset(18);
        make.right.equalTo(percentLabel.mas_left).offset(-15);
        make.height.equalTo(4);
    }];
    
    /** 时间图标  */
    UIImageView *watchView = [[UIImageView alloc]init];
    watchView.image = [UIImage imageNamed:@"时间-改版"];
    [self.contentView addSubview:watchView];
    [watchView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(progressV.mas_bottom).offset(10);
        
    }];
    
    /** 付款时间  */
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"2017-08-23 12:12";
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchView.mas_right).offset(5);
        make.centerY.equalTo(watchView.mas_centerY);
    }];

}

- (void)setStatus:(YYParticipationRecordModel *)status{
    _status = status;
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:status.goods_img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.goods_name.text = status.goods_name;
    
    if([status.way_type integerValue] == 1){
        
        if ([status.way_unit_cost integerValue] == 1) {
            self.numberBiView.image = [UIImage imageNamed:@"全新1币得"];
        }else if ([status.way_unit_cost integerValue] == 5){
            self.numberBiView.image = [UIImage imageNamed:@"全新5币得"];
        }
    }

    /** 进度  */
    if ([status.goods_price floatValue] != 0) {
        CGFloat num = [status.sold_sum floatValue]/[status.goods_price floatValue];
        
        self.progressV.progress = num;
        self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", num * 100];
    }else{
        self.progressV.progress = 0;
        self.percentLabel.text = [NSString stringWithFormat:@"0%%"];
    }
    
    /** 付款时间 */
    self.timeLabel.text = [Fm_Tools getTotalTimeWithSecondsFromString:status.pay_time];
    
}
@end
