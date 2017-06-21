//
//  YSFootPrintViewCell.m
//  fmapp
//
//  Created by yushibo on 16/7/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSFootPrintViewCell.h"

@interface YSFootPrintViewCell()
/** 时间  */
@property (nonatomic, strong)UILabel *party_time;
/** 标题  */
@property (nonatomic, strong)UILabel *party_theme;
/** 活动名  */
@property (nonatomic, strong)UILabel *party_actname;//UIView *lineV
@property (nonatomic, strong)UIView *lineV;//

/** 时间 */
/** 时间 */
/** 时间 */
/** 时间 */
@end

@implementation YSFootPrintViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }

    return self;
}
- (void)createContentView{

    UILabel *party_time = [[UILabel alloc]init];
    party_time.font = [UIFont systemFontOfSize:12];
    party_time.textColor = [UIColor colorWithHexString:@"#003399"];
    party_time.backgroundColor = [UIColor colorWithHexString:@"#DCF1FB"];
    party_time.layer.masksToBounds = YES;
    party_time.adjustsLetterSpacingToFitWidth = YES;
    party_time.layer.cornerRadius = 5;
    self.party_time = party_time;
    [self.contentView addSubview:party_time];
    [party_time makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(13);
    }];
    
    UILabel *party_actname = [[UILabel alloc]init];
    party_actname.font = [UIFont boldSystemFontOfSize:14];
    party_actname.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    self.party_actname = party_actname;
    [self.contentView addSubview:party_actname];
    [party_actname makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(party_time.mas_right).offset(5);
    }];
    
    UILabel *party_theme = [[UILabel alloc]init];
    party_theme.textColor = [UIColor blackColor];
    party_theme.font = [UIFont systemFontOfSize:13];
    self.party_theme = party_theme;
    [self.contentView addSubview:party_theme];
    [party_theme makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_time.mas_bottom).offset(13);
        make.left.equalTo(self.contentView.mas_left).offset(40);
    }];
//轴线
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#DCF1FB"];
    self.lineV = lineV;
    [self.contentView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_time.mas_bottom).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.equalTo(2);
        make.height.equalTo(38);
    }];
}

- (void)setDataSource:(YSFootPrintModel *)dataSource{

    _dataSource = dataSource;
    self.party_time.text =  [NSString stringWithFormat:@"  %@  ",dataSource.party_time ];
    self.party_theme.text = dataSource.party_theme;
    self.party_actname.text = dataSource.party_actname;
    
    if (IsStringEmptyOrNull(dataSource.party_theme)) {
        self.lineV.hidden = YES;
//        [self.lineV updateConstraints:^(MASConstraintMaker *make) {//此方法越狱手机不可用
//            make.height.equalTo(@0);
//        }];
    }else{
        self.lineV.hidden = NO;

    }
}

@end
