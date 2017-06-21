//
//  FMOrderTableViewHeader.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/22.
//  Copyright © 2016年 yk. All rights reserved.
//
#define kDarkGrayTextColor XZColor(48, 48, 48)
#define kLightGrayTextColor XZColor(143, 143, 143)
#import "FMOrderTableViewHeader.h"
#import "XZMyOrderModel.h"

@interface FMOrderTableViewHeader ()
// 编号
@property (nonatomic, strong) UILabel *labelOrderNumber;
/** 订单编号行的label */
@property (nonatomic, strong) UILabel *labelOrderPay;

@end

@implementation FMOrderTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 40);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self tableViewSectionHeaderView];
    }
    return self;
}

/** tableView的sectionHeaderView */
- (void)tableViewSectionHeaderView {
    
    UIView *line = [[UIView alloc]init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(@8);
    }];
    line.backgroundColor = XZColor(225, 230, 234);
    // 订单编号
    UILabel *labelOrder = [[UILabel alloc]init];
    [self.contentView addSubview:labelOrder];
    [labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        //        make.centerY.equalTo(header.mas_centerY);
        make.top.equalTo(line.mas_bottom).offset(8);
    }];
    labelOrder.text = @"订单编号：";
    labelOrder.textColor = kLightGrayTextColor;
    labelOrder.font = [UIFont systemFontOfSize:13];
    // 编号
    UILabel *labelOrderNumber = [[UILabel alloc]init];
    [self.contentView addSubview:labelOrderNumber];
    [labelOrderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelOrder.mas_right).offset(2);
        make.centerY.equalTo(labelOrder.mas_centerY);
        //        make.top.equalTo(line.mas_bottom).offset(3);
    }];
    self.labelOrderNumber = labelOrderNumber;
    //    labelOrderNumber.text = @"Q14411725235377476";
    labelOrderNumber.textColor = kDarkGrayTextColor;
    labelOrderNumber.font = [UIFont systemFontOfSize:13];
    // 买家已付款
    UILabel *labelOrderPay = [[UILabel alloc]init];
    [self.contentView addSubview:labelOrderPay];
    [labelOrderPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(labelOrderNumber.mas_centerY);
    }];
    self.labelOrderPay = labelOrderPay;
    labelOrderPay.text = @"买家已付款";
    labelOrderPay.font = [UIFont systemFontOfSize:13];
    //    labelOrderPay.backgroundColor = XZColor(245, 81, 50);
    labelOrderPay.textColor = XZColor(245, 81, 50);//[UIColor whiteColor];
    
}


-(void)setOrderModel:(XZMyOrderModel *)orderModel
{
    _orderModel = orderModel;
    self.labelOrderNumber.text = orderModel.order_id;
    
    if (orderModel.orderStatusFM == 1) {
        self.labelOrderPay.text = @"交易关闭";
    }else if(orderModel.orderStatusFM == 11)
    {
        self.labelOrderPay.text = @"申请售后中";
        
        
    }else if(orderModel.orderStatusFM == 12)
    {
        self.labelOrderPay.text = @"退款成功";
        
        
    }else if(orderModel.orderStatusFM == 21)
    {
        self.labelOrderPay.text = @"交易成功";
        
    }else if(orderModel.orderStatusFM == 31)
    {
        self.labelOrderPay.text = @"交易成功";
        
    }else if(orderModel.orderStatusFM == 41)
    {
        self.labelOrderPay.text = @"卖家已发货";
        
    }else if(orderModel.orderStatusFM == 51)
    {
        self.labelOrderPay.text = @"买家已付款";
        
    }else if(orderModel.orderStatusFM == 61)
    {
        self.labelOrderPay.text = @"等待买家付款";
        
    }else
    {
        self.labelOrderPay.hidden = YES;
    }
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
