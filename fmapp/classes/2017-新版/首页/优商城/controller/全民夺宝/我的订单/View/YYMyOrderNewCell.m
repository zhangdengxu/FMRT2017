//
//  YYMyOrderNewCell.m
//  fmapp
//
//  Created by yushibo on 2016/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYMyOrderNewCell.h"

#import "Fm_Tools.h"

@interface YYMyOrderNewCell ()
/** 夺宝商品名称  */
@property (nonatomic, strong) UILabel *goods_name;
/** 下单时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 投币数  */
@property (nonatomic, strong) UILabel *coin;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) UIImageView *goods_img;
/** 夺宝订单的状态  */
@property (nonatomic, strong) UILabel *state;
/** 付款按钮  */
@property (nonatomic, strong) UIButton *paymentBtn;
/** 晒单按钮  */
@property (nonatomic, strong) UIButton *shareBtn;
/** 物流查询按钮  */
@property (nonatomic, strong) UIButton *wuliuBtn;
/** 1币得 / 5币得 / 老友价 */
@property (nonatomic, strong) UIImageView *numberBiView;

@end
@implementation YYMyOrderNewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContentView];
        
    }
    return self;
}

- (void)createContentView{
   
    /** 商品图  */
    UIImageView *goodsView = [[UIImageView alloc]init];
    self.goods_img = goodsView;
    [self.contentView addSubview:goodsView];
    [goodsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        if (KProjectScreenWidth > 320) {
            make.height.and.width.equalTo(100);
        }else{
        make.height.and.width.equalTo(90);
        }
    }];
    /** 商品名称  */
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.goods_name = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.left.equalTo(goodsView.mas_right).offset(15);
        }else{
            make.left.equalTo(goodsView.mas_right).offset(10);
        }
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(goodsView.mas_top);
    }];
    
    /** 1币得  */
    UIImageView *numberBiView = [[UIImageView alloc]init];
    self.numberBiView = numberBiView;
    [self.contentView addSubview:numberBiView];
    [numberBiView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(7);
        
    }];
    
    /** 订单状态  */
    UILabel *zhuangtaiLabel = [[UILabel alloc]init];
    zhuangtaiLabel.text = @"订单状态:";
    zhuangtaiLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    zhuangtaiLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:zhuangtaiLabel];
    [zhuangtaiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(numberBiView.mas_bottom).offset(20);
        
    }];
    
    UILabel *stateLabel = [[UILabel alloc]init];
    stateLabel.textColor = [UIColor colorWithHexString:@"#0099ff"];
    stateLabel.font = [UIFont systemFontOfSize:14];
    self.state = stateLabel;
    [self.contentView addSubview:stateLabel];
    [stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhuangtaiLabel.mas_right);
        make.top.equalTo(zhuangtaiLabel.mas_top);
        
    }];

    
    /** 时间图标  */
    UIImageView *watchView = [[UIImageView alloc]init];
    watchView.image = [UIImage imageNamed:@"时间-改版"];
    watchView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:watchView];
    [watchView makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.left.equalTo(nameLabel.mas_left);
        }else{
            make.left.equalTo(nameLabel.mas_left).offset(-5);
        }
        make.top.equalTo(zhuangtaiLabel.mas_bottom).offset(15);
    }];
    
    /** 下单时间  */
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    if (KProjectScreenWidth > 320) {
        timeLabel.font = [UIFont systemFontOfSize:12];
    }else{
        timeLabel.font = [UIFont systemFontOfSize:11];
    }
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchView.mas_right).offset(5);
        make.centerY.equalTo(watchView.mas_centerY);
    }];
    
    
    /** 下细线  */
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];

    [self.contentView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    
        /** 付款按钮#da2b40  */
    UIButton *paymentBtn = [[UIButton alloc]init];
    [paymentBtn setTitle:@"付款" forState:UIControlStateNormal];
    [paymentBtn setTitleColor:[UIColor colorWithHexString:@"#f5f5f5"] forState:UIControlStateNormal];
    paymentBtn.layer.cornerRadius = 2;
    paymentBtn.layer.masksToBounds = YES;
    paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#fc673d"];
    [paymentBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.paymentBtn = paymentBtn;
    
    [self.contentView addSubview:paymentBtn];
    [paymentBtn makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(timeLabel.mas_bottom);
        if (KProjectScreenWidth > 320) {
            make.width.equalTo(@80);
            make.height.equalTo(30);
        }else{
            make.width.equalTo(@70);
            make.height.equalTo(30);
        }

    }];
    /** 物流信息按钮#da2b40  */
    UIButton *wuliuBtn = [[UIButton alloc]init];
    [wuliuBtn setTitle:@"物流信息" forState:UIControlStateNormal];
    [wuliuBtn setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    wuliuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    wuliuBtn.layer.cornerRadius = 2;
    wuliuBtn.layer.masksToBounds = YES;
    wuliuBtn.layer.borderWidth = 1;
    wuliuBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099ff"].CGColor;
    wuliuBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [wuliuBtn addTarget:self action:@selector(wuliuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.wuliuBtn = wuliuBtn;
    
    [self.contentView addSubview:wuliuBtn];
    [wuliuBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(timeLabel.mas_bottom);
        if (KProjectScreenWidth > 320) {
            make.width.equalTo(@80);
            make.height.equalTo(30);
        }else{
            make.width.equalTo(@70);
            make.height.equalTo(30);
        }
    }];

    /** 晒单按钮#0159d5  */
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setTitle:@"晒单" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor colorWithHexString:@"#f5f5f5"] forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 2;
    shareBtn.layer.masksToBounds = YES;
    shareBtn.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn = shareBtn;
    
    [self.contentView addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(wuliuBtn.mas_top).offset(-15);
        if (KProjectScreenWidth > 320) {
            make.width.equalTo(@80);
            make.height.equalTo(30);
        }else{
            make.width.equalTo(@70);
            make.height.equalTo(30);
        }
        
    }];

    
}
- (void)shareBtnAction:(UIButton *)button{
  //晒单
    if (self.shareBlockBtn) {
        self.shareBlockBtn();
    }
    NSLog(@"+++++++");

}
- (void)wuliuBtnAction:(UIButton *)button{
   //物流

    if (self.wuliuBlockBtn) {
        self.wuliuBlockBtn();
    }
    NSLog(@"+++++++");
}
- (void)clickBtnAction:(UIButton *)button{
    //付款

    if (self.payBlockBtn) {
        self.payBlockBtn();
    }
    NSLog(@"+++++++");
}

-(void)setStatus:(YYMyOrderNewModel *)status{
    _status = status;
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:status.goods_img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.goods_name.text = status.goods_name;
    
    /** 1币得,5币得 和老友价判断 */
    if([status.way_type integerValue] == 1){
    
        if ([status.way_unit_cost integerValue] == 1) {
            self.numberBiView.image = [UIImage imageNamed:@"全新1币得"];
        }else if ([status.way_unit_cost integerValue] == 5){
            self.numberBiView.image = [UIImage imageNamed:@"全新5币得"];
        }
    }else if ([status.way_type integerValue] == 2){
        self.numberBiView.image = [UIImage imageNamed:@"全新老友价"];
    }
    
    /** 订单状态 */
    if ([status.state integerValue] == 0) {
        self.state.text = @"超时取消";//已取消
        self.state.textColor = [UIColor colorWithHexString:@"#666666"];
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 1){
        self.state.text = @"支付失败";//已下单(未支付)
        self.state.textColor = [UIColor colorWithHexString:@"#ff6633"];
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = NO;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 10){ //已付款
        if([status.way_type integerValue] == 1){
            self.state.text = @"未开奖";//夺宝
            self.state.textColor = [UIColor colorWithHexString:@"#ff6633"];

        }else if ([status.way_type integerValue] == 2){
            self.state.text = @"暂未发货";//老友价
            self.state.textColor = [UIColor colorWithHexString:@"#666666"];

        }
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 20){
        self.state.text = @"未开奖";//等待揭晓
        self.state.textColor = [UIColor colorWithHexString:@"#ff6633"];
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 21){
        self.state.text = @"已中奖";
        self.state.textColor = [UIColor colorWithHexString:@"#0099ff"];
        self.shareBtn.hidden = NO;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = NO;
    }else if ([status.state integerValue] == 22){
        self.state.text = @"未中奖";
        self.state.textColor = [UIColor colorWithHexString:@"#666666"];
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 23){
        self.state.text = @"已退款";
        self.state.textColor = [UIColor colorWithHexString:@"#666666"];
        self.shareBtn.hidden = YES;
        self.paymentBtn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([status.state integerValue] == 99){//已发货
        if([status.way_type integerValue] == 1){
            self.state.text = @"已中奖";//夺宝
            self.state.textColor = [UIColor colorWithHexString:@"#0099ff"];
            self.shareBtn.hidden = NO;
            self.paymentBtn.hidden = YES;
            self.wuliuBtn.hidden = NO;

        }else if ([status.way_type integerValue] == 2){
            self.state.text = @"已发货";//老友价
            self.state.textColor = [UIColor colorWithHexString:@"#0099ff"];
            self.shareBtn.hidden = YES;
            self.paymentBtn.hidden = YES;
            self.wuliuBtn.hidden = NO;

        }
    }
    
    /** 下单时间 */
    self.timeLabel.text = [Fm_Tools getTotalTimeWithSecondsFromString:status.order_time];
    
}
@end
