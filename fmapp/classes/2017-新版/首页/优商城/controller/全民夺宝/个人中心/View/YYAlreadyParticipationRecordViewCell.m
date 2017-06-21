//
//  YYAlreadyParticipationRecordViewCell.m
//  fmapp
//
//  Created by yushibo on 2016/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//  参与记录--- 已经揭晓

#import "YYAlreadyParticipationRecordViewCell.h"

#import "Fm_Tools.h"
@interface YYAlreadyParticipationRecordViewCell ()
/** 夺宝商品名称  */
@property (nonatomic, strong) UILabel *goods_name;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) UIImageView *goods_img;
/** 获奖用户 */
@property (nonatomic, strong) UILabel *winLabel;
/** 中奖号码 */
@property (nonatomic, strong) UILabel *luckyNumber;
/** 开奖时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 是否中奖印章 */
@property (nonatomic, strong) UIImageView *winPrintView;
/** 1币得 / 5币得 / 老友价 */
@property (nonatomic, strong) UIImageView *numberBiView;

@end
@implementation YYAlreadyParticipationRecordViewCell
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
    [self.contentView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsView.mas_right).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(goodsView.mas_top);
    }];
    
    /** 1币得  */
    UIImageView *numberBiView = [[UIImageView alloc]init];
    self.numberBiView = numberBiView;
    [self.contentView addSubview:numberBiView];
    [numberBiView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(7);
        
    }];
    
    /** 获奖用户  */
    UILabel *winLabel = [[UILabel alloc]init];
    winLabel.textColor = [UIColor colorWithHexString:@"#0099ff"];
    winLabel.font = [UIFont systemFontOfSize:14];
    self.winLabel = winLabel;
    [self.contentView addSubview:winLabel];
    [winLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(numberBiView.mas_bottom).offset(12);
    }];
    /** 中奖号码  */
    UILabel *luckyNumber = [[UILabel alloc]init];
    luckyNumber.textColor = [UIColor colorWithHexString:@"#666666"];
    luckyNumber.font = [UIFont systemFontOfSize:14];
    self.luckyNumber = luckyNumber;
    [self.contentView addSubview:luckyNumber];
    [luckyNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(winLabel.mas_bottom).offset(5);
    }];
    /** 时间图标  */
    UIImageView *watchView = [[UIImageView alloc]init];
    watchView.image = [UIImage imageNamed:@"时间-改版"];
    [self.contentView addSubview:watchView];
    [watchView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(luckyNumber.mas_bottom).offset(7);
        
    }];
    
    /** 开奖时间  */
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchView.mas_right).offset(5);
        make.centerY.equalTo(watchView.mas_centerY);
    }];
    
    /** 是否中奖印章  */
    UIImageView *winPrintView = [[UIImageView alloc]init];
    self.winPrintView = winPrintView;
//    winPrintView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:winPrintView];
    [winPrintView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameLabel.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
-(void)setStatus:(YYParticipationRecordModel *)status{

    _status = status;
    self.goods_name.text = status.goods_name;
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:status.goods_img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    /**  1币得,5币得 图标*/
    if([status.way_type integerValue] == 1){
        
        if ([status.way_unit_cost integerValue] == 1) {
            self.numberBiView.image = [UIImage imageNamed:@"全新1币得"];
        }else if ([status.way_unit_cost integerValue] == 5){
            self.numberBiView.image = [UIImage imageNamed:@"全新5币得"];
        }
    }
    
    /**  获奖用户 */
    self.winLabel.text = [NSString stringWithFormat:@"获奖用户:%@",status.win_user_phone];

    /**  中奖号码 */
    self.luckyNumber.text = [NSString stringWithFormat:@"中奖号码:%@",status.win_number];
    
    /**  开奖时间 */
    self.timeLabel.text = [Fm_Tools getTotalTimeWithSecondsFromString:status.reveal];
    
    if ([status.is_win integerValue] == 0) {
        self.winPrintView.image = [UIImage imageNamed:@"未中奖"];
    }else if([status.is_win integerValue] == 1){
        self.winPrintView.image = [UIImage imageNamed:@"1101恭喜中奖"];
    }

}
@end
