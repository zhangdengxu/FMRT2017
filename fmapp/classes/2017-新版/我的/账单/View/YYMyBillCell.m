//
//  YYMyBillCell.m
//  fmapp
//
//  Created by yushibo on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYMyBillCell.h"
#import "Fm_Tools.h"
@interface YYMyBillCell ()
/**  回款 */
@property (nonatomic, strong) UILabel *iconLabel;
/**  变化金额 */
@property (nonatomic, strong) UILabel *moneyLabel;
/**  时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/**  资金解释 */
@property (nonatomic, weak) UILabel *explainLabel;

@end
@implementation YYMyBillCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
    iconLabel.backgroundColor = [HXColor colorWithHexString:@"#fdab55"];
    iconLabel.layer.masksToBounds = YES;
    iconLabel.layer.cornerRadius = 20.0f;
    self.iconLabel = iconLabel;
    iconLabel.font = [UIFont systemFontOfSize:14];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:iconLabel];

    
    UILabel *moneyLabel = [[UILabel alloc]init];
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont systemFontOfSize:17];
    moneyLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:moneyLabel];
    [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconLabel.mas_right).offset(10);
        make.top.equalTo(iconLabel.mas_top).offset(-4);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(moneyLabel.mas_bottom);
    }];

    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.font = [UIFont systemFontOfSize:14];
    self.explainLabel = explainLabel;
    explainLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:explainLabel];
    [explainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(moneyLabel.mas_bottom).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
}

-(void)setRecords:(Records *)records{

    _records = records;
    self.iconLabel.text = records.Name;

    if ([records.Trench integerValue] == 0) { //其他
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#66ccff"];

    }else if ([records.Trench integerValue] == 1){ //充值
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#0099ff"];

    }else if ([records.Trench integerValue] == 2){ //提现
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#ff6666"];

    }else if ([records.Trench integerValue] == 3){ //投资
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#ff6666"];

    }else if ([records.Trench integerValue] == 4){ //回款
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#fdab55"];

    }else if ([records.Trench integerValue] == 5){ //奖励
        self.iconLabel.backgroundColor = [HXColor colorWithHexString:@"#fdab55"];

    }
    
    if ([records.Type integerValue] == 1) { //收入
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", records.Money];
    }else if([records.Type integerValue] == 2){ //支出
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", records.Money];
    
    }
    
    
    
    self.explainLabel.text = records.Desc;

  //  NSLog(@"%@", [Fm_Tools hourStringFromString:records.Time]);
    if ([[Fm_Tools yyTimeWithSHHmmFromString:records.Time] isEqualToString:@"00:00"]) {
        self.timeLabel.text = [Fm_Tools yyTimeWithSMMddFromString:records.Time];

    }else{
        self.timeLabel.text = [Fm_Tools yyTimeWithSMMddHHmmFromString:records.Time];

    }

    

}
@end
