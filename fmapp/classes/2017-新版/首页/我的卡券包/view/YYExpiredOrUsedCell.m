//
//  YYExpiredOrUsedCell.m
//  fmapp
//
//  Created by yushibo on 2016/12/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYExpiredOrUsedCell.h"
#import "Fm_Tools.h"

@interface YYExpiredOrUsedCell ()
/**  使用途径 */
@property (nonatomic, strong) UILabel *way;
/**  券码名称 */
@property (nonatomic, strong) UILabel *name;
/**  券码内容 */
@property (nonatomic, strong) UILabel *content;
/**  券码时间 */
@property (nonatomic, strong) UILabel *time;
/**  金额 额度 */
@property (nonatomic, strong) UILabel *jinEr;
/**  金额 单位 */
@property (nonatomic, strong) UILabel *danwei;
/**  下半部分 */
@property (nonatomic, strong) UIImageView *downView;
/**  上半部分 */
@property (nonatomic, strong) UIImageView *upView;

@end

@implementation YYExpiredOrUsedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"e5e9f2"];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    /**  上半部分图 */
    UIImageView *upView = [[UIImageView alloc]init];
    upView.contentMode = UIViewContentModeScaleToFill;
    upView.image = [UIImage imageNamed:@"新版_已使用或已过期券_06"];
    self.upView = upView;

    [self.contentView addSubview:upView];
    [upView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.height.equalTo(46);
    }];
    /**  券码名称 */
    UILabel *nameLabel = [[UILabel alloc]init];
    self.name = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"购物满300减10";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    [upView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left).offset(15);
        make.centerY.equalTo(upView.mas_centerY);
    }];
    /**  使用途径 */
    UILabel *wayLabel = [[UILabel alloc]init];
    self.way = wayLabel;
    wayLabel.textAlignment = NSTextAlignmentRight;
    wayLabel.text = @"购物使用";
    wayLabel.textColor = [UIColor whiteColor];
    wayLabel.font = [UIFont systemFontOfSize:14];
    [upView addSubview:wayLabel];
    [wayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upView.mas_right).offset(-15);
        make.centerY.equalTo(upView.mas_centerY);
    }];
    
    /**  下半部分图 */
    UIImageView *downView = [[UIImageView alloc]init];
    downView.contentMode = UIViewContentModeScaleToFill;
    downView.image = [UIImage imageNamed:@"新版_已使用或已过期券_05"];
    self.downView = downView;

    [self.contentView addSubview:downView];
    [downView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left);
        make.right.equalTo(upView.mas_right);
        make.top.equalTo(upView.mas_bottom);
        make.height.equalTo(46 * 164 / 76);
    }];
    
    /**  券码内容 */
    UILabel *contentLabel = [[UILabel alloc]init];
    self.content = contentLabel;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text = @"评价奖励-仅限优商城购物使用";
    contentLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    contentLabel.font = [UIFont systemFontOfSize:16];
    [downView addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView.mas_left).offset(15);
        make.right.equalTo(downView.mas_right).offset(-(KProjectScreenWidth / 5));
        make.top.equalTo(downView.mas_top).offset(10);
//        make.height.equalTo(45);
    }];
    /**  有效期 时间 */
    UILabel *timeLabel = [[UILabel alloc]init];
    self.time = timeLabel;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = @"有效期:2016-10-13";
    timeLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [downView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.bottom.equalTo(downView.mas_bottom).offset(-10);
        
    }];
    /**  元 */
    UILabel *yuanLabel = [[UILabel alloc]init];
    yuanLabel.textAlignment = NSTextAlignmentRight;
    yuanLabel.text = @"元";
    yuanLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    yuanLabel.font = [UIFont systemFontOfSize:14];
    self.danwei = yuanLabel;

    [downView addSubview:yuanLabel];
    [yuanLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downView.mas_right).offset(-15);
        make.bottom.equalTo(downView.mas_bottom).offset(-10);
    }];
    
    /**  金额 额度 */
    UILabel *jinErLabel = [[UILabel alloc]init];
    self.jinEr = jinErLabel;
    jinErLabel.textAlignment = NSTextAlignmentRight;
    jinErLabel.text = @"10000";
    jinErLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    jinErLabel.font = [UIFont boldSystemFontOfSize:24];
    [downView addSubview:jinErLabel];
    [jinErLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yuanLabel.mas_left).offset(-2);
        make.bottom.equalTo(yuanLabel.mas_bottom);
    }];
    
}
- (void)sendDataWithmodel:(YYCardPackageModel *)model withBtnTag:(NSString *)tag{
    
    self.name.text = model.Title;
    if (model.Status == 1) {
        self.way.text = @"已使用";
    }else{
        self.way.text = @"已过期";
    }
    self.content.text = model.Desc;
    self.time.text = [NSString stringWithFormat:@"有效期限:%@", [Fm_Tools getTimeFromString:model.PastTime]];
    if (([tag integerValue] == 1) || ([tag integerValue] == 3)) {
        self.jinEr.text = [NSString stringWithFormat:@"%.2f", model.Amt];
        self.danwei.text = @"元";
        
    }else{
        
        double d = model.Rate;
        double temp = d * 100;
        self.jinEr.text = [NSString stringWithFormat:@"%.1f", temp];
        self.danwei.text = @"%";
        
    }
    if (model.contentH > 45) {
        
        [self.downView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.upView.mas_left);
            make.right.equalTo(self.upView.mas_right);
            make.top.equalTo(self.upView.mas_bottom);
            make.height.equalTo(55 + 10 + model.contentH);
        }];
        
    }else{
        
        [self.downView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.upView.mas_left);
            make.right.equalTo(self.upView.mas_right);
            make.top.equalTo(self.upView.mas_bottom);
            make.height.equalTo(55 + 45);
        }];
        
    }
}
@end
