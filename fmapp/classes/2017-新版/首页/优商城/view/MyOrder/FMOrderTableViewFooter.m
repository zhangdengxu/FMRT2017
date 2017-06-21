//
//  FMOrderTableViewFooter.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#define kDarkGrayTextColor XZColor(48, 48, 48)
#define kLightGrayTextColor XZColor(143, 143, 143)
#import "FMOrderTableViewFooter.h"
#import "XZMyOrderModel.h"
@interface FMOrderTableViewFooter ()

/** 提醒发货 */
@property (nonatomic, strong) UIButton *btnRemind;
/** 取消订单 */
@property (nonatomic, strong) UIButton *btnOrderTracking;
/** 延长收货 */
@property (nonatomic, strong) UIButton *btnExtendReceiving;

@property (nonatomic, weak) UILabel *labelNumber;

@property (nonatomic, weak)  UILabel *labelOrder;

@property (nonatomic, strong) UIView *line;
@end

@implementation FMOrderTableViewFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame =  CGRectMake(0, 0, KProjectScreenWidth, 80);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self tableViewSectionFooterView];
    }
    return self;
}
- (void)tableViewSectionFooterView {
    
    // 合计
    UILabel *labelOrder = [[UILabel alloc]init];
    self.labelOrder = labelOrder;
    [self.contentView addSubview:labelOrder];
    [labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(8);
    }];
    labelOrder.text = [NSString stringWithFormat:@"实付：￥5,160.00"];
    labelOrder.textColor = kDarkGrayTextColor;
    labelOrder.font = [UIFont systemFontOfSize:13];
    // 商品数
    UILabel *labelNumber = [[UILabel alloc]init];
    self.labelNumber = labelNumber;
    [self.contentView addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelOrder.mas_left).offset(-10);
        make.top.equalTo(labelOrder.mas_top);
    }];
    labelNumber.text = [NSString stringWithFormat:@"总计2件商品"];
    labelNumber.textColor = kDarkGrayTextColor;
    labelNumber.font = [UIFont systemFontOfSize:13];
    UIView *line = [[UIView alloc]init];
    self.line = line;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(labelNumber.mas_bottom).offset(10);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = XZColor(225, 230, 234);
    
    
}

-(UIButton *)btnRemind
{
    if (!_btnRemind) {
        /** 提醒发货 */
        UIButton *btnRemind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:btnRemind];
        [btnRemind mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.line.mas_bottom).offset(8);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _btnRemind = btnRemind;
        btnRemind.tag = 201;
        //    [btnRemind setTitle:@"提醒发货" forState:UIControlStateNormal];
        [btnRemind addTarget:self action:@selector(didClickRemindButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnRemind setTintColor:[UIColor whiteColor]];
        btnRemind.backgroundColor = XZColor(6, 41, 125);
        
        _btnRemind.layer.masksToBounds = YES;
        _btnRemind.layer.borderWidth = 0.5f;
        _btnRemind.layer.cornerRadius = 4;
    }
    return _btnRemind;
}

-(UIButton *)btnOrderTracking
{
    if (!_btnOrderTracking) {
        /** 取消订单 */
        UIButton *btnOrderTracking = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:btnOrderTracking];

        [btnOrderTracking mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnRemind.mas_left).offset(-10);
            make.top.equalTo(self.btnRemind.mas_top);
            make.width.equalTo(self.btnRemind.mas_width);
            make.height.equalTo(self.btnRemind.mas_height);
        }];
        btnOrderTracking.layer.masksToBounds = YES;
        btnOrderTracking.layer.borderWidth = 0.5f;
        btnOrderTracking.layer.cornerRadius = 4;
        
        btnOrderTracking.tag = 202;
        _btnOrderTracking = btnOrderTracking;
        [btnOrderTracking setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [btnOrderTracking addTarget:self action:@selector(didClickOrderTrackingButton:) forControlEvents:UIControlEventTouchUpInside];
        btnOrderTracking.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        btnOrderTracking.layer.borderWidth = 1.0f;
    }
    return _btnOrderTracking;
}
-(UIButton *)btnExtendReceiving
{
    if (!_btnExtendReceiving) {
        /** 延长收货 */
        UIButton *btnExtendReceiving = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:btnExtendReceiving];

        [btnExtendReceiving mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnOrderTracking.mas_left).offset(-10);
            make.top.equalTo(self.btnRemind.mas_top);
            make.width.equalTo(self.btnRemind.mas_width);
            make.height.equalTo(self.btnRemind.mas_height);
        }];
        _btnExtendReceiving = btnExtendReceiving;
        btnExtendReceiving.tag = 203;
        [btnExtendReceiving setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [btnExtendReceiving addTarget:self action:@selector(didClickExtendReceivingButton:) forControlEvents:UIControlEventTouchUpInside];
        btnExtendReceiving.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        btnExtendReceiving.layer.borderWidth = 1.0f;

    }
    return _btnExtendReceiving;
}

/** 延长收货 */
- (void)didClickExtendReceivingButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button,self.orderModel);
    }
}
/** 取消订单 */
- (void)didClickOrderTrackingButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button,self.orderModel);
    }
}
/** 提醒发货 */
- (void)didClickRemindButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button,self.orderModel);
    }
}

-(void)setOrderModel:(XZMyOrderModel *)orderModel
{
    _orderModel = orderModel;
    

    CGFloat totalMoney = [orderModel.total_amount floatValue];
    //CGFloat cost_shipping = [orderModel.cost_shipping floatValue];
    
    if ([orderModel.order_type integerValue] > 0) {
        NSString * allString = [NSString stringWithFormat:@"实付：%@积分",orderModel.used_jifen];
        self.labelOrder.text = allString;
    }else
    {
        NSString * allString = [NSString stringWithFormat:@"实付：￥%.2f",totalMoney];
        self.labelOrder.text = allString;
    }
    
    self.labelNumber.text = [NSString stringWithFormat:@"总计：%@件商品",orderModel.itemnum];
    
    if (self.isCommentFooter == 1) {
        
        [self hiddenAllButtonMassary];
        
        
    }else
    {
        [self changeMassaryWithShow];
        self.btnRemind.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        self.btnRemind.backgroundColor = XZColor(6, 41, 125);
        [self.btnRemind setTintColor:[UIColor whiteColor]];
        self.btnOrderTracking.layer.borderColor = [XZColor(235, 235, 242) CGColor];

        if (orderModel.orderStatusFM == 1) {
            //交易关闭
            [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = YES;
            self.btnExtendReceiving.hidden = YES;
        }else if(orderModel.orderStatusFM == 11)
        {
            //售后申请中
            [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = YES;
            self.btnExtendReceiving.hidden = YES;
            
        }else if(orderModel.orderStatusFM == 12)
        {
            //申请售后结束（退款成功）
            [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = YES;
            self.btnExtendReceiving.hidden = YES;
            
        }else if(orderModel.orderStatusFM == 21)
        {
            //交易成功（用户已评价）
            [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.btnOrderTracking setTitle:@"订单跟踪" forState:UIControlStateNormal];
            
            self.btnOrderTracking.layer.borderColor = [HXColor colorWithHexString:@"#333333"].CGColor;
            self.btnRemind.backgroundColor = XZColor(255, 255, 255);
            [self.btnRemind setTintColor:[HXColor colorWithHexString:@"#333333"]];
            
            self.btnOrderTracking.hidden = NO;
            self.btnExtendReceiving.hidden = YES;
        }else if(orderModel.orderStatusFM == 31)
        {
            //待评价
            [self.btnRemind setTitle:@"订单跟踪" forState:UIControlStateNormal];
            
            self.btnRemind.layer.borderColor = [HXColor colorWithHexString:@"#333333"].CGColor;
            self.btnRemind.backgroundColor = XZColor(255, 255, 255);
            [self.btnRemind setTintColor:[HXColor colorWithHexString:@"#333333"]];
            
            
            
            self.btnOrderTracking.hidden = YES;
            self.btnExtendReceiving.hidden = YES;
        }else if(orderModel.orderStatusFM == 41)
        {
            //待收货
            [self.btnRemind setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.btnOrderTracking setTitle:@"订单跟踪" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = NO;
            self.btnExtendReceiving.hidden = YES;
        }else if(orderModel.orderStatusFM == 51)
        {
            [self.btnRemind setTitle:@"提醒发货" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = YES;
            self.btnExtendReceiving.hidden = YES;
        }else if(orderModel.orderStatusFM == 61)
        {
            [self.btnRemind setTitle:@"付款" forState:UIControlStateNormal];
            [self.btnOrderTracking setTitle:@"取消订单" forState:UIControlStateNormal];
            self.btnOrderTracking.hidden = NO;
            self.btnExtendReceiving.hidden = YES;
        }
    }
    
}

-(void)hiddenAllButtonMassary;
{
    self.btnRemind.tag = 0;
    self.btnOrderTracking.tag = 0;
    self.btnExtendReceiving.tag = 0;

    [self.btnOrderTracking removeFromSuperview];
    [self.btnExtendReceiving removeFromSuperview];
    [self.btnRemind removeFromSuperview];
    
}
-(void)changeMassaryWithShow;
{
    if (self.btnRemind.tag != 0) {
        return;
    }
    
    [self.contentView addSubview:self.btnRemind];
    [self.contentView addSubview:self.btnOrderTracking];
    [self.contentView addSubview:self.btnExtendReceiving];

    
    self.btnRemind.tag = 201;
    self.btnOrderTracking.tag = 202;
    self.btnExtendReceiving.tag = 203;
    
    
    [self.btnRemind mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.line.mas_bottom).offset(8);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.btnOrderTracking mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnRemind.mas_left).offset(-10);
        make.top.equalTo(self.btnRemind.mas_top);
        make.width.equalTo(self.btnRemind.mas_width);
        make.height.equalTo(self.btnRemind.mas_height);
    }];
    
    [self.btnExtendReceiving mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnOrderTracking.mas_left).offset(-10);
        make.top.equalTo(self.btnRemind.mas_top);
        make.width.equalTo(self.btnRemind.mas_width);
        make.height.equalTo(self.btnRemind.mas_height);
    }];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
