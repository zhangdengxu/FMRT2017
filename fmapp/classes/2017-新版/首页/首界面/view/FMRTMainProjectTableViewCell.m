//
//  FMRTMainProjectTableViewCell.m
//  fmapp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTMainProjectTableViewCell.h"
#import "ProgressCircleView.h"

#import "Fm_Tools.h"

@interface FMRTMainProjectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel,*timeLabel,*earnLabel,*moneyLabel,*stausLabel,*rongziLabel;
@property (nonatomic, strong) ProgressCircleView *circleView;
@property (nonatomic, strong) UIImageView *iconeView;


@end
@implementation FMRTMainProjectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {

    [self.contentView addSubview:self.iconeView];
    [self.iconeView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.right).offset(-8);
        make.top.equalTo(self.contentView.top).offset(13);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.top).offset(13);
        make.left.equalTo(self.contentView.left).offset(18);
        make.right.lessThanOrEqualTo(self.timeLabel.left).offset(-30);
    }];

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(1);
        make.top.equalTo(self.titleLabel.bottom).offset(13);
    }];
    
    [self.contentView addSubview:self.earnLabel];
    [self.earnLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).dividedBy(2).offset(-20);
        make.centerY.equalTo(lineView.bottom).offset(25);
    }];
    
    UILabel *expectLabel = [[UILabel alloc]init];
    expectLabel.text = @"预期年化收益率";
    expectLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    expectLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:expectLabel];
    [expectLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.earnLabel.bottom).offset(7);
        make.centerX.equalTo(self.earnLabel.centerX);
    }];
    
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).offset(10);
        make.centerY.equalTo(self.earnLabel.centerY);
    }];
    
    UILabel *typeLabel = [[UILabel alloc]init];
    self.rongziLabel = typeLabel;
    typeLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    typeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:typeLabel];
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.earnLabel.bottom).offset(7);
        make.centerX.equalTo(self.moneyLabel.centerX);
    }];
    
    UIView *bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.contentView addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(5);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    ProgressCircleView *bottomPro = [[ProgressCircleView alloc]initWithFrame:CGRectMake(KProjectScreenWidth - 80, 55, 55, 55)];
    bottomPro.pregressColor = [UIColor colorWithHexString:@"#cccccc"];
    bottomPro.progressWidth = 2.0;
    bottomPro.pregressValue = 1.0;
    [self.contentView addSubview:bottomPro];
    
    _circleView = [[ProgressCircleView alloc]initWithFrame:CGRectMake(KProjectScreenWidth - 80, 55, 55, 55)];
    _circleView.pregressColor = [UIColor colorWithHexString:@"#0159d5"];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.progressWidth = 2.0;
    _circleView.pregressValue = 0.6;
    [self.contentView addSubview:_circleView];
    
    _stausLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth - 80, 55, 55, 55)];
    _stausLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
    _stausLabel.font = [UIFont systemFontOfSize:12];
    _stausLabel.textAlignment = NSTextAlignmentCenter;
    _stausLabel.numberOfLines = 0;
    [self.contentView addSubview:self.stausLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        _timeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeLabel;
}

- (UILabel *)earnLabel{
    if (!_earnLabel) {
        _earnLabel = [[UILabel alloc]init];
        _earnLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        _earnLabel.font = [UIFont systemFontOfSize:15];
    }
    return _earnLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
    }
    return _moneyLabel;
}

- (UIImageView *)iconeView{
    if (!_iconeView) {
        _iconeView = [[UIImageView alloc]init];
        _iconeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconeView;
}

- (void)setModel:(FMRTXiangmuModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = [Fm_Tools dateStringFromString:model.start_time];
   // Huodong：0为普通，1为活动标、2加息标、3体验金、4新手标
    if (model.huodong) {
        [self.iconeView setHidden:NO];
        if ([model.huodong integerValue] == 1) {
            _iconeView.image = [UIImage imageNamed:@"首页_活动标_36"];
        }else if ([model.huodong integerValue]== 2){
            _iconeView.image = [UIImage imageNamed:@"首页_加息标_36"];
        }else if ([model.huodong integerValue]== 3){
            _iconeView.image = [UIImage imageNamed:@"首页_体验金_36"];
        }else if ([model.huodong integerValue]== 4){
            _iconeView.image = [UIImage imageNamed:@"首页_新手标_36"];
        }
    }else{
        [self.iconeView setHidden:YES];
    }
    
    self.circleView.pregressValue = [model.jindu floatValue]/100;
    
    if ([model.kaishi integerValue]) {//未开始
        self.stausLabel.text = [NSString stringWithFormat:@"%@\n开标",[Fm_Tools hourStringFromString:model.start_time]];
    }else{//0开始
        
        if ([model.jindu floatValue]/100 <1) {
            
            self.stausLabel.text = [NSString stringWithFormat:@"%@%%",model.jindu];
        }else{
            
            if ([model.zhuangtai integerValue]==4) {
                self.stausLabel.text = @"满标";
            }else if([model.zhuangtai integerValue]==6){
                self.stausLabel.text = @"售罄";
            }else if([model.zhuangtai integerValue]==8){
                self.stausLabel.text = @"还款\n完成";
            }else if([model.zhuangtai integerValue]==10){
                self.stausLabel.text = [NSString stringWithFormat:@"%@%%",model.jindu];
            }
        }
    }
    
    self.rongziLabel.text = model.rongzifangshiname;
    NSString *earn = [NSString stringWithFormat:@"%@",model.lilv];
    NSString *lilvAll = [NSString stringWithFormat:@"%@%%",earn];
    
    NSMutableAttributedString *lilvStr = [[NSMutableAttributedString alloc]initWithString:lilvAll];
    NSRange range3 = [lilvAll rangeOfString:earn];
    [lilvStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:range3];
    self.earnLabel.attributedText = lilvStr;
    
    
    NSString *money = [NSString stringWithFormat:@"%@",model.jinernew];

    NSString *month;
    NSString *titleAll;
    if ([model.qixian integerValue]<1) {
        
        month = [NSString stringWithFormat:@"%@",model.tianshu];
        titleAll = [NSString stringWithFormat:@"%@天|%@万",month,money];
    }else{
        
        month = [NSString stringWithFormat:@"%@",model.qixian];
        titleAll = [NSString stringWithFormat:@"%@个月|%@万",month,money];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
    NSRange range = [titleAll rangeOfString:month];
    NSRange range1 = [titleAll rangeOfString:money];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range1];
    self.moneyLabel.attributedText = attrStr;
    
}

@end
