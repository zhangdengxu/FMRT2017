//
//  FMRTAucDetailRecordTableViewCell.m
//  fmapp
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucDetailRecordTableViewCell.h"



@interface FMRTAucDetailRecordTableViewCell ()

@property (nonatomic, strong)UILabel *timeLabel, *statusLabel, *titleLabel, *currentPriceLabel, *myPriceLabel, *priceAlertLabel;
@property (nonatomic, strong)UIImageView *photoView, *statusView;
@property (nonatomic, strong)UIButton *addPriceBtn, *recordBtn,*directBtn;

@property (nonatomic, copy) NSString *auctionId,*producId;
@end

@implementation FMRTAucDetailRecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
 
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.contentView addSubview:self.photoView];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.height.equalTo(70);
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:lineView2];
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
        
    UIButton *directBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [directBtn setImage:[UIImage imageNamed:@"向右_03"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:directBtn];
    [directBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(lineView2.mas_bottom).offset(5);

    }];
    
    [self.contentView addSubview:self.recordBtn];
    [self.recordBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView2.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@20);
    }];
    

    [self.contentView addSubview:self.myPriceLabel];
    [self.myPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.photoView.mas_bottom).offset(3);
        make.left.equalTo(self.photoView.mas_right).offset(10);
    }];
    
    [self.contentView addSubview:self.currentPriceLabel];
    [self.currentPriceLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.bottom.equalTo(self.myPriceLabel.mas_top).offset(-5);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_top).offset(-2);
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.lessThanOrEqualTo(self.currentPriceLabel.mas_top).offset(-5);
    }];
    
    [self.contentView addSubview:self.priceAlertLabel];
    [self.priceAlertLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.myPriceLabel.mas_centerY);
        make.left.equalTo(self.myPriceLabel.mas_right).offset(5);
    }];
    
    [self.contentView addSubview:self.addPriceBtn];
    [self.addPriceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.centerY.equalTo(self.myPriceLabel.mas_centerY);
        make.width.equalTo(@58);
        make.height.equalTo(@18);
    }];

    
    [self.contentView addSubview:self.statusView];
    [self.statusView makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.photoView.mas_centerY);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
    }
    return _photoView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _timeLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        _statusLabel.font = [UIFont systemFontOfSize:12];
    }
    return _statusLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)currentPriceLabel{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc]init];
        _currentPriceLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];;
        _currentPriceLabel.font = [UIFont systemFontOfSize:13];
    }
    return _currentPriceLabel;
}

- (UILabel *)myPriceLabel{
    if (!_myPriceLabel) {
        _myPriceLabel = [[UILabel alloc]init];
        _myPriceLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        if (KProjectScreenWidth >320) {
            _myPriceLabel.font = [UIFont systemFontOfSize:12];
            
        }else{
            _myPriceLabel.font = [UIFont systemFontOfSize:11];
        }
    }
    return _myPriceLabel;
}

- (UILabel *)priceAlertLabel{
    if (!_priceAlertLabel) {
        _priceAlertLabel = [[UILabel alloc]init];
        _priceAlertLabel.textColor = [HXColor colorWithHexString:@"#ff0000"];
        if (KProjectScreenWidth >320) {
            _priceAlertLabel.font = [UIFont systemFontOfSize:12];
            
        }else{
            _priceAlertLabel.font = [UIFont systemFontOfSize:10];
        }
    }
    return _priceAlertLabel;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_recordBtn setTitle:@"我的竞拍记录" forState:(UIControlStateNormal)];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_recordBtn setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:(UIControlStateNormal)];
        _recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_recordBtn addTarget:self action:@selector(recordAciton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordBtn;
}

- (UIButton *)addPriceBtn{
    if (!_addPriceBtn) {
        _addPriceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_addPriceBtn setTitle:@"继续加价" forState:(UIControlStateNormal)];
        _addPriceBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_addPriceBtn setBackgroundColor:[UIColor redColor]];
        [_addPriceBtn addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
        _addPriceBtn.layer.cornerRadius = 9;
    }
    return _addPriceBtn;
}

- (UIImageView *)statusView{
    if (!_statusView) {
        _statusView = [[UIImageView alloc]init];
    }
    return _statusView;
}

- (void)recordAciton:(UIButton *)sender{

    if (self.recordBlcok) {
        self.recordBlcok(self.auctionId);
    }
    
}

- (void)addAction{

    if (self.addPriceBlcok) {
        self.addPriceBlcok(self.auctionId, self.producId);
    }
}

- (void)setModel:(FMRTAucDetailRecordModel *)model{
    _model = model;
    
    self.producId = model.product_id;
    self.auctionId = model.auction_id;
    self.timeLabel.text = [NSString stringWithFormat:@"竞拍时间%@",[NSString retStringFromTimeToyyyyYearMMMonthddDayHHMMSS:model.begin_time] ];
    
    if ([model.activity_state integerValue] == 0) {
        self.statusLabel.text = @"未审核";
        self.addPriceBtn.hidden = YES;
        self.statusView.hidden = YES;
        self.priceAlertLabel.hidden = YES;
    }else if([model.activity_state integerValue] == 1){
        self.statusLabel.text = @"未开始";
        self.addPriceBtn.hidden = YES;
        self.statusView.hidden = YES;
        self.priceAlertLabel.hidden = YES;
    }else if([model.activity_state integerValue] == 2){
        self.statusLabel.text = @"正在进行中";
        self.statusView.hidden = YES;
        self.priceAlertLabel.hidden = NO;
        if ([model.cur_max_price floatValue] == [model.my_cur_max_price floatValue]) {
            self.priceAlertLabel.text = @"当前您是最高价";
            self.addPriceBtn.hidden = YES;
        }else{
            self.priceAlertLabel.text = @"您的出价已被超越";
            self.addPriceBtn.hidden = NO;

        }
    }else if ([model.activity_state integerValue] == 3){
        self.statusLabel.text = @"已结束";
        self.addPriceBtn.hidden = YES;
        self.statusView.hidden = NO;
        self.priceAlertLabel.hidden = YES;
        if ([model.buy_state integerValue] == 4) {
            self.statusView.image = [UIImage imageNamed:@"竞拍失败_03"];
        }else if([model.buy_state integerValue] == 3){
            self.statusView.image = [UIImage imageNamed:@"竞拍成功_03"];
        }
    }else if ([model.activity_state integerValue] == 4){
        self.statusLabel.text = @"已过期";
        self.addPriceBtn.hidden = YES;
        self.statusView.hidden = NO;
        self.priceAlertLabel.hidden = YES;
        if ([model.buy_state integerValue] == 4) {
            self.statusView.image = [UIImage imageNamed:@"竞拍失败_03"];
        }else if([model.buy_state integerValue] == 3){
            self.statusView.image = [UIImage imageNamed:@"竞拍成功_03"];
        }
    }
    [self.photoView sd_setImageWithURL:model.goods_img_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.titleLabel.text = model.goods_name;
    self.currentPriceLabel.text =[NSString stringWithFormat:@"当前竞拍价¥%@",model.cur_max_price];
    self.myPriceLabel.text = [NSString stringWithFormat:@"我的出价:¥%@",model.my_cur_max_price];
}

@end
