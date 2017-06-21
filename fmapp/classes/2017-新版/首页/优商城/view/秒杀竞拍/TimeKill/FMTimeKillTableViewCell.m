//
//  FMTimeKillTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillTableViewCell.h"
#import "FMTimeKillShopModel.h"
#import "FMLinshiCellButton.h"



@interface FMTimeKillTableViewCell()

@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * beleftLabel;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * priceLable;
@property (nonatomic, strong) UILabel * oldPrice;
@property (nonatomic, strong) FMLinshiCellButton * killButton;
//@property (nonatomic, strong) UILabel * endTimeLable;
@end

@implementation FMTimeKillTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addMassory];
        
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondReduceOnceWithKillTime:) name:KDefaultSecondReduceOnce object:nil];

        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
-(void)secondReduceOnceWithKillTime:(NSNotification *)notification
{
    
    if ([self.model.activity_state_button isEqualToString:@"1"]) {
        self.killButton.cellType = FMLinshiCellButtonTypeDownTime;
        
        self.killButton.contentString = [self calculateBaseCount];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString: self.model.image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
        
    }else if([self.model.activity_state_button isEqualToString:@"2"])
    {
         self.killButton.cellType = FMLinshiCellButtonTypeActivity;
        self.killButton.contentString = @"秒杀";
        self.killButton.timeString = [self calculateBaseCount];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString: self.model.image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
        
    }else
    {
         self.killButton.cellType = FMLinshiCellButtonTypeEnd;
        self.killButton.contentString = @"已结束";

        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString: self.model.gray_image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
        
    }
    
    [self.killButton setUpData];
    
    
    if ([self.model.online_num integerValue] <= 0) {
        self.beleftLabel.text = @"已送完";
    }else
    {
        self.beleftLabel.text = [NSString stringWithFormat:@"剩余:%@", self.model.online_num];
    }
    
    
    
    
    
    
   
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)addMassory
{
    CGFloat titleWidth = 90;
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(titleWidth);
        make.height.equalTo(titleWidth);
    }];
    
    [self.beleftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView.mas_right);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10).priorityHigh();
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-57);
    }];
    
    [self.killButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(120);
        make.height.equalTo(45);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.priceLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.killButton.mas_top);
        make.width.equalTo(80);
    }];
    
    [self.oldPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.top.equalTo(self.priceLable.mas_bottom).offset(5);
        make.width.equalTo(80);
    }];
    
   
    
       [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(0.5);
    }];
}

-(void)setModel:(FMTimeKillShopModel *)model
{
    _model = model;
    
    if ([model.online_num integerValue] == 0) {
        self.beleftLabel.text = @"已送完";
    }else
    {
        self.beleftLabel.text = [NSString stringWithFormat:@"剩余:%@", model.online_num];
    }
    
    self.titleLable.text = model.goods_name;
    self.priceLable.text = [NSString stringWithFormat:@"¥%@",model.sale_price];
    
    
    
    // 给数字划线
    NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@",model.price];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleThick) range:NSMakeRange(0, oldPriceStr.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[HXColor colorWithHexString:@"#aaa"] range:NSMakeRange(0, oldPriceStr.length)];
    [self.oldPrice setAttributedText:attri];
    

    
    
    
    if ([self.model.activity_state_button isEqualToString:@"1"]) {
        self.killButton.cellType = FMLinshiCellButtonTypeDownTime;
        
        self.killButton.contentString = [self calculateBaseCount];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
        
    }else if([self.model.activity_state_button isEqualToString:@"2"])
    {
        self.killButton.cellType = FMLinshiCellButtonTypeActivity;
        self.killButton.contentString = @"秒杀";
        self.killButton.timeString = [self calculateBaseCount];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
        
        
    }else
    {
        self.killButton.cellType = FMLinshiCellButtonTypeEnd;
        self.killButton.contentString = @"已结束";
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString: self.model.gray_image_url] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    }
    
    [self.killButton setUpData];
    
}

-(NSString *)calculateBaseCount
{
    NSInteger currentTime = self.model.baseCount;
    
    if ([self.model.activity_state_button isEqualToString:@"3"]) {
        return  [NSString stringWithFormat:@"已结束"];
    }
    
    if (currentTime < 0) {
        
        NSInteger timeContinue = self.model.toEndTime + currentTime;
        if (timeContinue < 0) {
            //活动已结束
            return  [NSString stringWithFormat:@"已结束"];

        }else
        {
            //正在进行
            return  [NSString stringWithFormat:@"距结束 %@",[self retMiniteWithTime:timeContinue]];

        }
    }else
    {
        /**
         ＊还未开始
         */
        return  [NSString stringWithFormat:@"距开始 %@",[self retMiniteWithTime:currentTime]];
    }
   
}

-(NSString *)retMiniteWithTime:(NSInteger)currentTime
{
    
    NSString * retTimestring;
    if (currentTime / 60 < 1) {
        retTimestring = [NSString stringWithFormat:@"00:00:%02zi",currentTime % 60];
    }else
    {
        if (currentTime / 3600 < 1) {
            retTimestring = [NSString stringWithFormat:@"00:%02zi:%02zi",currentTime / 60,currentTime % 60];
        }else
        {
            NSInteger shengyuTime = currentTime % 3600;
            retTimestring = [NSString stringWithFormat:@"%02zi:%02zi:%02zi",currentTime / 3600,shengyuTime / 60,shengyuTime % 60];
        }
    }
    
    return retTimestring;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)killButtonOnClick:(FMLinshiCellButton *)button
{
    
        if (self.timeKillButton) {
            self.timeKillButton(self.model);
        }
    
}

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.numberOfLines = 0;
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel *)beleftLabel
{
    if (!_beleftLabel) {
        _beleftLabel = [[UILabel alloc]init];
        _beleftLabel.numberOfLines = 0;
        _beleftLabel.font = [UIFont systemFontOfSize:14];
        _beleftLabel.textColor = [UIColor whiteColor];
        _beleftLabel.backgroundColor = [HXColor colorWithHexString:@"#1e1e1e"];
        [self.iconImageView addSubview:_beleftLabel];
    }
    return _beleftLabel;
}
-(UILabel *)priceLable
{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc]init];
        _priceLable.font = [UIFont systemFontOfSize:16];
        _priceLable.textColor = [HXColor colorWithHexString:@"#ff0000"];
        [self.contentView addSubview:_priceLable];
    }
    return _priceLable;
}
-(UILabel *)oldPrice
{
    if (!_oldPrice) {
        _oldPrice = [[UILabel alloc]init];
        _oldPrice.font = [UIFont systemFontOfSize:16];
        _oldPrice.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_oldPrice];
    }
    return _oldPrice;
}


-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}



-(FMLinshiCellButton *)killButton
{
    if (!_killButton) {
        _killButton = [[FMLinshiCellButton alloc]init];
        [_killButton addTarget:self action:@selector(killButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _killButton.layer.cornerRadius = 5.0;
        _killButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_killButton];
    }
    return _killButton;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:(223/255.0) green:(230/255.0) blue:(233/255.0) alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


@end
