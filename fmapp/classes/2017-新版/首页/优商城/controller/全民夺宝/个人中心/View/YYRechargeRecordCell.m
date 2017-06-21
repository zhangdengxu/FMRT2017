//
//  YYRechargeRecordCell.m
//  fmapp
//
//  Created by yushibo on 2016/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYRechargeRecordCell.h"

#import "Fm_Tools.h"
@interface YYRechargeRecordCell ()
/** 获得数量  */
@property (nonatomic, strong) UILabel *numberLabel;
/** 获得时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 获得方式 */
@property (nonatomic, strong) UILabel *wayLabel;
@end
@implementation YYRechargeRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}
- (void)createContentView{

    /**  获得数量   */
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.font =[UIFont systemFontOfSize:14];
    //    numberLabel.backgroundColor = [UIColor redColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithHexString:@"#ff6633"];
    self.numberLabel = numberLabel;
    [self.contentView addSubview:numberLabel];
    [numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo((KProjectScreenWidth-30) / 10 * 3);
    }];
    
    /**  获得时间   */
    UILabel *timeLabel = [[UILabel alloc]init];
    if (KProjectScreenWidth > 320) {
        timeLabel.font =[UIFont systemFontOfSize:13];
    }else{
        timeLabel.font =[UIFont systemFontOfSize:11];
    }
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(numberLabel.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    /**  获得方式   */
    UILabel *wayLabel = [[UILabel alloc]init];
    wayLabel.font =[UIFont systemFontOfSize:14];
    wayLabel.textAlignment = NSTextAlignmentCenter;
    wayLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.wayLabel = wayLabel;
    [self.contentView addSubview:wayLabel];
    [wayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(numberLabel.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];

}

- (void)setStatus:(YYRechargeRecordModel *)status{

    _status = status;
    self.timeLabel.text = [Fm_Tools getTotalTimeWithSecondsFromString:status.deal_time];
    self.numberLabel.text = status.coin;
    self.wayLabel.text = status.trench_text;
}
@end
