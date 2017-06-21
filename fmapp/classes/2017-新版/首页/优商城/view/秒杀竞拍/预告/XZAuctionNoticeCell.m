//
//  XZAuctionNoticeCell.m
//  XZProject
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 admin. All rights reserved.
//  精品竞拍预告

#import "XZAuctionNoticeCell.h"
#import "XZAuctionNoticeModel.h"
#import "Fm_Tools.h"

@interface XZAuctionNoticeCell ()
// 上方图片
@property (nonatomic, strong) UIImageView *imgPhoto;
// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 竞拍价格
@property (nonatomic, strong) UILabel *labelPrice;
// 竞拍时间
@property (nonatomic, strong) UILabel *labelTime;
// 秒杀价格View
@property (nonatomic, strong) UIView *viewSecondKill;
// 实际价格
@property (nonatomic, strong) UILabel *labelCharge;
// 划线价格
@property (nonatomic, strong) UILabel *labelChargeLine;
// 竞拍结束图片
@property (nonatomic, strong) UIImageView *imgIcon;
@end

@implementation XZAuctionNoticeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置
        [self setUpAuctionNoticeCell];
    }
    return self;
}

// 设置
- (void)setUpAuctionNoticeCell {
    // 上方图片
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(KProjectScreenWidth /640 *300);
    }];
    self.imgPhoto = imgPhoto;
//    imgPhoto.image = [UIImage imageNamed:@"占位图_06"];
//    imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_left).offset(10);
        make.top.equalTo(imgPhoto.mas_bottom).offset(5);
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:13];
    
    // 竞拍价格
    UILabel *labelPrice = [[UILabel alloc] init];
    [self.contentView addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).offset(5);
    }];
    self.labelPrice = labelPrice;
    labelPrice.textColor = XZColor(244, 88, 45);
    labelPrice.font = [UIFont systemFontOfSize:13];
    
    // 竞拍时间
    UILabel *labelTime = [[UILabel alloc] init];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
        make.top.equalTo(labelPrice.mas_top);
    }];
    self.labelTime = labelTime;
    labelTime.textColor = XZColor(244, 88, 45);
    labelTime.font = [UIFont systemFontOfSize:13];
    
    // 底部黑色的线
    UILabel *blackLine = [[UILabel alloc] init];
    [self.contentView addSubview:blackLine];
    [blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.height.equalTo(@10);
        make.right.equalTo(imgPhoto.mas_right);
    }];
    blackLine.backgroundColor = [UIColor blackColor];
    
    // 秒杀价格View
    UIView *viewSecondKill = [[UIView alloc] init];
    [self.contentView addSubview:viewSecondKill];
    [viewSecondKill mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).offset(5);
    }];
    self.viewSecondKill = viewSecondKill;
    viewSecondKill.backgroundColor = [UIColor greenColor];
    
    // 实际价格
    UILabel *labelCharge = [[UILabel alloc] init];
    [viewSecondKill addSubview:labelCharge];
    [labelCharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).offset(5);
    }];
    self.labelCharge = labelCharge;
    labelCharge.textColor = XZColor(244, 88, 45);
    labelCharge.font = [UIFont systemFontOfSize:13];
    
    // 划线价格
    UILabel *labelChargeLine = [[UILabel alloc] init];
    [viewSecondKill addSubview:labelChargeLine];
    [labelChargeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelCharge.mas_right);
        make.top.equalTo(labelTitle.mas_bottom).offset(5);
    }];
    self.labelChargeLine = labelChargeLine;
    labelChargeLine.textColor = [UIColor lightGrayColor];
    labelChargeLine.font = [UIFont systemFontOfSize:13];
    
    // 竞拍结束图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.and.width.equalTo(@80);
    }];
    self.imgIcon = imgIcon;
}

- (void)setModelAuction:(XZAuctionNoticeModel *)modelAuction {
    _modelAuction = modelAuction;
    self.labelTitle.text = [NSString stringWithFormat:@"%@",modelAuction.goods_name];
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:modelAuction.notice_img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-376x142"]];
    NSString *timeStr = [Fm_Tools getTotalTimeWithString:[NSString stringWithFormat:@"%@",modelAuction.begin_time] andFormatter:@"yyyy-MM-dd/HH:mm:ss"];
    NSString *state = [NSString stringWithFormat:@"%@",modelAuction.activity_state];
    if ([modelAuction.flag isEqualToString:@"auction"]) { // 竞拍
        self.viewSecondKill.hidden = YES;
        self.labelPrice.text = [NSString stringWithFormat:@"%@元起竞拍",modelAuction.price];
        if ([state isEqualToString:@"3"]) { // 3已结束 2可以跳转
            self.labelPrice.textColor = [UIColor lightGrayColor];
            self.labelTime.textColor = [UIColor lightGrayColor];
            self.imgIcon.image = [UIImage imageNamed:@"竞拍结束icon_03"];
        }
        self.labelTime.text = [NSString stringWithFormat:@"竞拍时间:%@",timeStr];
    }else if ([modelAuction.flag isEqualToString:@"kill"]) { // 秒杀
        self.labelPrice.hidden = YES;
        self.labelCharge.text = [NSString stringWithFormat:@"￥%@/",modelAuction.sale_price];
        self.labelTime.text = [NSString stringWithFormat:@"秒杀时间:%@",timeStr];
        NSString *oldPrice = [NSString stringWithFormat:@"￥%@",modelAuction.price];
        // 给label划线
        NSUInteger length = [oldPrice length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
        [self.labelChargeLine setAttributedText:attri];
        if ([state isEqualToString:@"3"]) {
            self.labelPrice.textColor = [UIColor lightGrayColor];
            self.labelTime.textColor = [UIColor lightGrayColor];
            self.imgIcon.image = [UIImage imageNamed:@"秒杀已结束"];
        }
    }
   
//    @"秒杀时间：201-08-06/16:00:00"
//    self.labelCharge.text = @"￥300/";begin_time
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
@end
