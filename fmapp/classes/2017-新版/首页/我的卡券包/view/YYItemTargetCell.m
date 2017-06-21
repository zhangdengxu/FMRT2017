//
//  YYItemTargetCell.m
//  fmapp
//
//  Created by yushibo on 2016/12/15.
//  Copyright © 2016年 yk. All rights reserved.
//  可投项目标

#import "YYItemTargetCell.h"
#import "Fm_Tools.h"
@interface YYItemTargetCell ()
/**  预期年化收益 */
@property (nonatomic, strong) UILabel *income;
/**  项目名称类型 */
@property (nonatomic, strong) UILabel *name;
/**  项目内容 */
@property (nonatomic, strong) UILabel *content;
/**  项目时间 */
@property (nonatomic, strong) UILabel *time;
/**  单位 元 */
@property (nonatomic, strong) UILabel *yuan;
/**  加息 */
@property (nonatomic, strong) UILabel *jiaXi;
/**  预期年化收益文字   更新约束用 */
@property (nonatomic, strong) UILabel *label2;
@end
@implementation YYItemTargetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = [UIColor greenColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    /**  中线 */
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self.contentView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(KProjectScreenWidth / 8 * 3);
        make.width.equalTo(1);
        make.height.equalTo(100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
   
    
    /**  预期年化收益文字 */
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"预期年化收益(%)";
    self.label2 = label2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithHexString:@"#a5a5a5"];
    label2.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(lineV.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);


        
    }];
    
    /**  预期年化收益 */
    UILabel *label1 = [[UILabel alloc]init];
//    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"12%";
    self.income = label1;
    label1.textColor = [UIColor colorWithHexString:@"#fb5558"];
    label1.font = [UIFont systemFontOfSize:35];
    [self.contentView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left);
//        make.right.equalTo(lineV.mas_left);
        
        make.centerX.equalTo(label2.mas_centerX).offset(-15);
        make.bottom.equalTo(label2.mas_top);
    }];
    /**  预期年化收益 */
    UILabel *label3 = [[UILabel alloc]init];
    label3.textAlignment = NSTextAlignmentCenter;
 //   label3.text = @"+0.1";
    self.jiaXi = label3;
//    self.yuan = label3;
    label3.textColor = [UIColor colorWithHexString:@"#fb5558"];
    label3.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.contentView.mas_left);
        //        make.right.equalTo(lineV.mas_left);
        make.left.equalTo(label1.mas_right);
        make.bottom.equalTo(label1.mas_bottom).offset(-5);
    }];
    
    
    /**  右侧箭头 */
    UIImageView *arrowImage = [[UIImageView alloc]init];
    arrowImage.image = [UIImage imageNamed:@"新版_小箭头右侧_36"];
    [self.contentView addSubview:arrowImage];
    [arrowImage makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(14);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    /**  项目内容 */
    UILabel *contentLabel = [[UILabel alloc]init];
    self.content = contentLabel;
    contentLabel.contentMode = UIViewContentModeScaleAspectFit;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text = @"融资金额100万:期限6个月";
    contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    contentLabel.font = [UIFont systemFontOfSize:14 ];
    [self.contentView addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_right).offset(20);
        make.right.equalTo(arrowImage.mas_left).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    /**  项目名称 */
    UILabel *nameLabel = [[UILabel alloc]init];
    self.name = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"企业经营贷(保理)";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_right).offset(20);
        make.right.equalTo(arrowImage.mas_left).offset(-20);
        make.bottom.equalTo(contentLabel.mas_top).offset(-15);
    }];
    /**  项目时间 */
    UILabel *timeLabel = [[UILabel alloc]init];
    self.time = timeLabel;
    
    timeLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    timeLabel.layer.borderWidth = 0.5f;
    timeLabel.layer.masksToBounds = YES;
    
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = @"2016-10-12 14:00开标";
    timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_right).offset(20);
//        make.right.equalTo(arrowImage.mas_left).offset(-20);
        make.top.equalTo(contentLabel.mas_bottom).offset(15);
    }];

}
- (void)setModel:(YYUsedBidModel *)model{

    _model = model;
    if ([model.jiaxi doubleValue] > 0) {
        self.income.text = model.lilv;
        [self.income remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.label2.mas_centerX).offset(-15);
            make.bottom.equalTo(self.label2.mas_top);

        }];
        self.jiaXi.text = [NSString stringWithFormat:@"+%@", model.jiaxi];
        
        
    }else{
        double d = [model.lilv doubleValue];
        
        self.income.text = [NSString stringWithFormat:@"%.1f", d];
        [self.income remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.label2.mas_centerX);
            make.bottom.equalTo(self.label2.mas_top);

        }];
        self.jiaXi.text = @"";

    }
    self.name.text = model.title;
    self.content.text = [NSString stringWithFormat:@"融资金额%@·期限%@个月", model.jiner, model.qixian];
    self.time.text = [NSString stringWithFormat:@"%@开标", [Fm_Tools YYminStringFromString:model.start_time]];
}

@end
