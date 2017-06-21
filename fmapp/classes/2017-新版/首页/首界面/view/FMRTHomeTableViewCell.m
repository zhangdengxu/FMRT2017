//
//  FMRTHomeTableViewCell.m
//  fmapp
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTHomeTableViewCell.h"
#import "FMRTMainListModel.h"
#import "Fm_Tools.h"

@interface FMRTHomeTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel,*titleLabel,*earnedLabel,*earnNameLabel,*centerLabel,*moneyLabel,*statusLabel,*percentLabel,*shijianLabel,*alertLabel;
@property (nonatomic, strong)UIProgressView *sProgressView;

@end
@implementation FMRTHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.contentView.top).offset(15);
        make.width.equalTo(44);
        make.height.equalTo(21);
    }];
    
    [self.shijianLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.timeLabel.centerY);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.right).offset(10);
        make.top.equalTo(self.contentView.top).offset(15);
        make.right.lessThanOrEqualTo(self.shijianLabel.left).offset(-5);
    }];
    
    [self.earnedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.timeLabel.bottom).offset(8);
    }];
    
    [self.earnNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.earnedLabel.bottom).offset(8);
    }];

    [self.centerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX).offset(-10);
        make.top.equalTo(self.earnedLabel.bottom).offset(10);
    }];

    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.top.equalTo(self.earnedLabel.bottom).offset(10);
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.earnedLabel.centerY);
        make.width.equalTo(70);
        make.height.equalTo(21);
    }];
    

    [self.percentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.earnedLabel.centerY).offset(5);
    }];
    
//    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.centerLabel.left);
//        make.right.equalTo(self.percentLabel.left).offset(-10);
//        make.centerY.equalTo(self.earnedLabel.centerY).offset(5);
//        make.height.equalTo(@3);
//    }];
    
    [self.sProgressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLabel.left);
        make.right.equalTo(self.percentLabel.left).offset(-10);
        make.centerY.equalTo(self.earnedLabel.centerY).offset(8);
        make.height.equalTo(@3);
    }];
    
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sProgressView.left).priorityLow();
        make.right.equalTo(self.sProgressView.right).priorityLow();
        make.bottom.equalTo(self.sProgressView.top).offset(-5);
        make.centerX.equalTo(self.sProgressView.centerX).offset(0).priorityHigh();
        
    }];
    
    UIView *bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.contentView addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(10);
        make.right.equalTo(self.contentView.right).offset(-10);
        make.height.equalTo(1);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"18个月";
        _timeLabel.layer.cornerRadius = 4;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
        _timeLabel.layer.borderWidth = 1;
        _timeLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"企业经营贷17020602";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_titleLabel];

    }
    return _titleLabel;
}

- (UILabel *)earnedLabel{
    if (!_earnedLabel) {
        _earnedLabel = [[UILabel alloc]init];
        _earnedLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        [self.contentView addSubview:_earnedLabel];

    }
    return _earnedLabel;
}

- (UILabel *)earnNameLabel{
    if (!_earnNameLabel) {
        _earnNameLabel = [[UILabel alloc]init];
        _earnNameLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        _earnNameLabel.text = @"预期年化利率(%)";
        CGFloat size=13;
        if (KProjectScreenWidth>375) {
            size = 14;
        }else{
            size = 13;
        }
        
        _earnNameLabel.font = [UIFont systemFontOfSize:size];
        [self.contentView addSubview:_earnNameLabel];
    }
    return _earnNameLabel;
}


- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        CGFloat size=13;
        if (KProjectScreenWidth>375) {
            size = 14;
        }else{
            size = 13;
        }
        
        _centerLabel.font = [UIFont systemFontOfSize:size];
        _centerLabel.text = @"先息后本";
        [self.contentView addSubview:_centerLabel];
    }
    return _centerLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        CGFloat size=13;
        if (KProjectScreenWidth>375) {
            size = 14;
        }else{
            size = 13;
        }
        
        _moneyLabel.font = [UIFont systemFontOfSize:size];
        
        _moneyLabel.text = @"融资总额100.00万元";
        [self.contentView addSubview:_moneyLabel];

    }
    return _moneyLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.text = @"已售罄";
        _statusLabel.layer.cornerRadius = 4;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
        _statusLabel.layer.borderWidth = 1;
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
        [self.contentView addSubview:_statusLabel];

    }
    return _statusLabel;
}

- (UILabel *)percentLabel{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc]init];
        _percentLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        CGFloat size=13;
        if (KProjectScreenWidth>375) {
            size = 14;
        }else{
            size = 13;
        }
        
        _percentLabel.font = [UIFont systemFontOfSize:size];
        _percentLabel.text = @"60%";
        [self.contentView addSubview:_percentLabel];
        
    }
    return _percentLabel;
}

- (UILabel *)shijianLabel{
    if (!_shijianLabel) {
        _shijianLabel = [[UILabel alloc]init];
        _shijianLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        
        _shijianLabel.font = [UIFont systemFontOfSize:13];
        _shijianLabel.text = @"2017-02-10";
        [self.contentView addSubview:_shijianLabel];
        
    }
    return _shijianLabel;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
//        _alertLabel.backgroundColor  =[UIColor purpleColor];
        _alertLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
        _alertLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_alertLabel];
    }
    return _alertLabel;
}


- (UIProgressView *)sProgressView{
    if (!_sProgressView) {
        _sProgressView = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        _sProgressView.progressTintColor = [UIColor colorWithHexString:@"#0159d5"];
        _sProgressView.trackTintColor = [UIColor colorWithHexString:@"#e5e9f2"];
        [self.contentView addSubview:self.sProgressView];
    }
    return  _sProgressView;
}


- (void)setModel:(FMRTXiangmuModel *)model{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%@个月", model.qixian];
    self.titleLabel.text = model.title;

    NSInteger jiaxi  = [model.jiaxi integerValue];
    if (jiaxi == 0) {

        NSString *earnLilv = [NSString stringWithFormat:@"%.1f",[model.lilv floatValue]];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:earnLilv];
        NSRange range = [earnLilv rangeOfString:earnLilv];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:33] range:range];
        
        self.earnedLabel.attributedText = attrStr;
    }else{
        NSString *earnBack = [NSString stringWithFormat:@"+%@",model.jiaxi];
        NSString *earnLilv = [NSString stringWithFormat:@"%@%@",model.lilv,earnBack];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:earnLilv];
        NSRange range = [earnLilv rangeOfString:model.lilv];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:33] range:range];
        
        self.earnedLabel.attributedText = attrStr;
    }
    
    if ([model.kaishi integerValue]>0) {//未开始
        [self.shijianLabel setHidden:NO];
        [self.sProgressView setHidden:YES];
        [self.alertLabel setHidden:YES];
        [self.percentLabel setHidden:YES];
        self.statusLabel.text = [NSString stringWithFormat:@"%@开标",[Fm_Tools hourStringFromString:model.start_time]];
        [self.statusLabel setHidden:NO];

        self.shijianLabel.text = [Fm_Tools dateStringFromString:model.start_time];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.jineryiqi];
        self.statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
        self.statusLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
        self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
        self.timeLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
        self.titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        self.earnedLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];

        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.contentView.right).offset(-90);
        }];
        
    }else{//0开始
        [self.shijianLabel setHidden:YES];

        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.contentView.right).offset(-10);
        }];
        if ([model.jindu floatValue]/100 <1) {
            [self.sProgressView setHidden:NO];
            [self.percentLabel setHidden:NO];
            [self.statusLabel setHidden:YES];
            [self.alertLabel setHidden:NO];

            float progress = [model.jindu floatValue]/100;
            self.sProgressView.progress = progress;
            float prowidth;
            prowidth = (KProjectScreenWidth/2-25)*(progress-0.5);
            NSString *alertString = [NSString stringWithFormat:@"%@万元可投",model.ketouqianshu];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:alertString];
            NSRange range = [alertString rangeOfString:model.ketouqianshu];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
            self.alertLabel.attributedText =attrStr;
            
            [self.alertLabel remakeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.sProgressView.top).offset(-5);
                make.centerX.equalTo(self.sProgressView.centerX).offset(prowidth).priorityLow(100);
                make.left.greaterThanOrEqualTo(self.sProgressView.left);
                make.right.lessThanOrEqualTo(self.sProgressView.right);
                
            }];
            
            
            self.percentLabel.text = [NSString stringWithFormat:@"%@%%",model.jindu];
            self.moneyLabel.text = [NSString stringWithFormat:@"融资总额%@元",model.jineryiqi];
            self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
            self.timeLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
            self.titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
            self.earnedLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];

        }else{
            [self.statusLabel setHidden:NO];

            if ([model.zhuangtai integerValue]==4) {//满标=已售罄
                [self.sProgressView setHidden:YES];
                [self.percentLabel setHidden:YES];
                [self.alertLabel setHidden:YES];

                self.statusLabel.text = @"已售罄";
                self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.jineryiqi];
                self.statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.statusLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.titleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.earnedLabel.textColor = [HXColor colorWithHexString:@"#999999"];

            }else if([model.zhuangtai integerValue]==6){//还款中=收益中
                [self.sProgressView setHidden:YES];
                [self.percentLabel setHidden:YES];
                [self.alertLabel setHidden:YES];

                self.statusLabel.text = @"收益中";
                self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.jineryiqi];
                self.statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.statusLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.titleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.earnedLabel.textColor = [HXColor colorWithHexString:@"#999999"];

            }else if([model.zhuangtai integerValue]==8){//还款完成=已结清
                [self.sProgressView setHidden:YES];
                [self.percentLabel setHidden:YES];
                [self.alertLabel setHidden:YES];

                self.statusLabel.text = @"已结清";
                self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.jineryiqi];
                self.statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.statusLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#999999"].CGColor;
                self.timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.titleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
                self.earnedLabel.textColor = [HXColor colorWithHexString:@"#999999"];

            }else if([model.zhuangtai integerValue]==10){
                [self.alertLabel setHidden:NO];

                [self.sProgressView setHidden:NO];
                float progress = [model.jindu floatValue]/100;
                self.sProgressView.progress = progress;
                float prowidth;
                prowidth = (KProjectScreenWidth/2-25)*(progress-0.5);
                
                NSString *alertString = [NSString stringWithFormat:@"%@万元可投",model.ketouqianshu];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:alertString];
                NSRange range = [alertString rangeOfString:model.ketouqianshu];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
                self.alertLabel.attributedText =attrStr;
                
                
                [self.alertLabel remakeConstraints:^(MASConstraintMaker *make) {

                    make.bottom.equalTo(self.sProgressView.top).offset(-5);
                    make.centerX.equalTo(self.sProgressView.centerX).offset(prowidth).priorityLow(100);
                    make.left.greaterThanOrEqualTo(self.sProgressView.left);
                    make.right.lessThanOrEqualTo(self.sProgressView.right);

                }];
                
                [self.percentLabel setHidden:NO];
                [self.statusLabel setHidden:YES];
                
                self.percentLabel.text = [NSString stringWithFormat:@"%@%%",model.jindu];
                self.moneyLabel.text = [NSString stringWithFormat:@"融资总额%@元",model.jineryiqi];
                self.statusLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
                self.statusLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
                self.timeLabel.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
                self.timeLabel.textColor = [HXColor colorWithHexString:@"#0159d5"];
                self.titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
                self.earnedLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];

            }
        }
    }
}

@end
