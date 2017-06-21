//
//  YSSpikeParticipationRecordViewCell.m
//  fmapp
//
//  Created by yushibo on 16/8/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSSpikeParticipationRecordViewCell.h"

#import "SDWebImageManager.h"
#import "Fm_Tools.h"

@interface YSSpikeParticipationRecordViewCell ()
/**  商品名称 */
@property (nonatomic, strong) UILabel *goods_name;
/**  商品图片 */
@property (nonatomic, strong) UIImageView *goods_img;
/**  商品图片（缩略图）URL地址 */
@property (nonatomic, strong) NSString *goods_img_url;
/**  成交时间 */
@property (nonatomic, strong) UILabel *trans_time;
/**  交易金额 */
@property (nonatomic, strong) UILabel *trans_price;
/**  商品原价 */
@property (nonatomic, strong) UILabel *goods_price;

@end
@implementation YSSpikeParticipationRecordViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
    
}
- (void)createContentView{

    /** 上部分  */
    UILabel * canyuLabel = [[UILabel alloc]init];
    canyuLabel.text = @"参与时间";
    canyuLabel.font = [UIFont systemFontOfSize:14];
    canyuLabel.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    [self.contentView addSubview:canyuLabel];
    [canyuLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    /** 参与时间  */
    UILabel *trans_time = [[UILabel alloc]init];
    trans_time.font = [UIFont systemFontOfSize:15];
    trans_time.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    self.trans_time = trans_time;
    [self.contentView addSubview:trans_time];
    [trans_time makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(canyuLabel.mas_right);
        make.top.equalTo(canyuLabel.mas_top);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = KDefaultOrBackgroundColor;
    [self.contentView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(35);
        make.height.equalTo(1);
    }];
    
    /** 下部分  */
    
    /**  商品图片 */
    UIImageView * goods_img = [[UIImageView alloc]init];
    goods_img.backgroundColor = [UIColor redColor];
    self.goods_img = goods_img;
    [self.contentView addSubview:goods_img];
    [goods_img makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(canyuLabel.mas_left);
        make.top.equalTo(lineV.mas_bottom).offset(13);
        make.height.and.width.equalTo(70);
    }];
    
    /** 商品名字  */
    UILabel *goods_name = [[UILabel alloc]init];
    goods_name.textColor = [UIColor colorWithHexString:@"#1e1e1e"];
    goods_name.font = [UIFont systemFontOfSize:13];
    self.goods_name = goods_name;
    [self.contentView addSubview:goods_name];
    [goods_name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goods_img.mas_right).offset(15);
        make.top.equalTo(goods_img.mas_top);
        make.right.equalTo(self.contentView.mas_right);
    }];
    /** 商品原价  */
    UILabel *goods_price = [[UILabel alloc]init];
    goods_price.textColor = [UIColor colorWithHexString:@"#aaa"];
    goods_price.font = [UIFont systemFontOfSize:13];
    self.goods_price = goods_price;
    [self.contentView addSubview:goods_price];
    [goods_price makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goods_name.mas_left);
        make.bottom.equalTo(goods_img.mas_bottom);
    }];
    UIImageView *markLineV = [[UIImageView alloc]init];
    markLineV.backgroundColor = [UIColor colorWithHexString:@"#aaa"];
    [self.contentView addSubview:markLineV];
    [markLineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goods_price.mas_left);
        make.height.equalTo(1);
        make.right.equalTo(goods_price.mas_right);
        make.bottom.equalTo(goods_price.mas_bottom).offset(-6);
    }];
    
    /**  成交价格 */
    UILabel *trans_price = [[UILabel alloc]init];
    trans_price.textColor = [UIColor colorWithHexString:@"#ff0000"];
    trans_price.font = [UIFont systemFontOfSize:14];
    self.trans_price = trans_price;
    [self.contentView addSubview:trans_price];
    [trans_price makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goods_price.mas_left);
        make.bottom.equalTo(goods_price.mas_top).offset(-3);
    }];
    
    /**  秒杀成功图片 */
    UIImageView *activityV = [[UIImageView alloc]init];
    [activityV setImage:[UIImage imageNamed:@"秒杀成功_03"]];
    activityV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:activityV];
    [activityV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(30);
    }];
    
}

-(void)setStatus:(YSSpikeParticipationRecordModel *)status{

    _status = status;
    self.trans_price.text = [NSString stringWithFormat:@"¥%@", status.trans_price];
    self.goods_price.text = [NSString stringWithFormat:@"¥%@", status.goods_price];
    self.goods_name.text = [NSString stringWithFormat:@"%@", status.goods_name];

    
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:status.goods_img_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    
//    //时间戳转为时间
//    NSTimeInterval time=[status.trans_time doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    
//    self.trans_time.text = currentDateStr;

    self.trans_time.text = [Fm_Tools getTotalTimeWithSecondsFromString:status.trans_time];
}

@end
