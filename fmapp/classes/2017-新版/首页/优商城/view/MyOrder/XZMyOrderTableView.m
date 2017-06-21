//
//  XZMyOrderTableView.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/29.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZMyOrderTableView.h"
#import "XZMyOrderModel.h"
#define kDarkGrayTextColor XZColor(48, 48, 48)
#define kLightGrayTextColor XZColor(143, 143, 143)

@interface XZMyOrderTableView ()
// 编号
@property (nonatomic, strong) UILabel *labelOrderNumber;
@end

@implementation XZMyOrderTableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置MyOrderTableView子视图
//        [self setUpMyOrderTableView];
    }
    return self;
}
// 设置MyOrderTableView子视图
//- (void)setUpMyOrderTableView {
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 110) style:UITableViewStyleGrouped];
//    [self addSubview:self.tableView];
//}
/** tableView的sectionHeaderView */
- (UIView *)tableViewSectionHeaderView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 40)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]init];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left);
        make.right.equalTo(header.mas_right);
        make.top.equalTo(header.mas_top);
        make.height.equalTo(@8);
    }];
    line.backgroundColor = XZColor(225, 230, 234);
    // 订单编号
    UILabel *labelOrder = [[UILabel alloc]init];
    [header addSubview:labelOrder];
    [labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(10);
//        make.centerY.equalTo(header.mas_centerY);
        make.top.equalTo(line.mas_bottom).offset(8);
    }];
    labelOrder.text = @"订单编号：";
    labelOrder.textColor = kLightGrayTextColor;
    labelOrder.font = [UIFont systemFontOfSize:13];
    // 编号
    UILabel *labelOrderNumber = [[UILabel alloc]init];
    [header addSubview:labelOrderNumber];
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
    [header addSubview:labelOrderPay];
    [labelOrderPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header.mas_right).offset(-10);
        make.centerY.equalTo(labelOrderNumber.mas_centerY);
    }];
    self.labelOrderPay = labelOrderPay;
    labelOrderPay.text = @"买家已付款";
    labelOrderPay.font = [UIFont systemFontOfSize:13];
    labelOrderPay.backgroundColor = XZColor(245, 81, 50);
    labelOrderPay.textColor = [UIColor whiteColor];
    return header;
}
/** tableView的sectionFooterView */
- (UIView *)tableViewSectionFooterView {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 80)];
    footer.backgroundColor = [UIColor whiteColor];
    // 合计
    UILabel *labelOrder = [[UILabel alloc]init];
    [footer addSubview:labelOrder];
    [labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footer.mas_right).offset(-10);
        make.top.equalTo(footer.mas_top).offset(5);
    }];
    labelOrder.text = [NSString stringWithFormat:@"合计：￥5,160.00(含运费￥0.00)"];
    labelOrder.textColor = kDarkGrayTextColor;
    labelOrder.font = [UIFont systemFontOfSize:13];
    // 商品数
    UILabel *labelNumber = [[UILabel alloc]init];
    [footer addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelOrder.mas_left).offset(-10);
        make.top.equalTo(labelOrder.mas_top);
    }];
    labelNumber.text = [NSString stringWithFormat:@"总计2件商品"];
    labelNumber.textColor = kDarkGrayTextColor;
    labelNumber.font = [UIFont systemFontOfSize:13];
    UIView *line = [[UIView alloc]init];
    [footer addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left);
        make.right.equalTo(footer.mas_right);
        make.top.equalTo(labelNumber.mas_bottom).offset(10);
        make.height.equalTo(@2);
    }];
    line.backgroundColor = XZColor(225, 230, 234);
    /** 提醒发货 */
    UIButton *btnRemind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [footer addSubview:btnRemind];
    [btnRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footer.mas_right).offset(-10);
        make.top.equalTo(line.mas_bottom).offset(8);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    self.btnRemind = btnRemind;
    btnRemind.tag = 201;
//    [btnRemind setTitle:@"提醒发货" forState:UIControlStateNormal];
    [btnRemind addTarget:self action:@selector(didClickRemindButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnRemind setTintColor:[UIColor whiteColor]];
    btnRemind.backgroundColor = XZColor(6, 41, 125);
    /** 取消订单 */
    UIButton *btnOrderTracking = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [footer addSubview:btnOrderTracking];
    [btnOrderTracking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnRemind.mas_left).offset(-10);
        make.top.equalTo(btnRemind.mas_top);
        make.width.equalTo(btnRemind.mas_width);
        make.height.equalTo(btnRemind.mas_height);
    }];
    btnOrderTracking.tag = 202;
    self.btnOrderTracking = btnOrderTracking;
//    [btnOrderTracking setTitle:@"取消订单" forState:UIControlStateNormal];
    [btnOrderTracking setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
    [btnOrderTracking addTarget:self action:@selector(didClickOrderTrackingButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOrderTracking.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    btnOrderTracking.layer.borderWidth = 1.0f;
    /** 延长收货 */
    UIButton *btnExtendReceiving = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [footer addSubview:btnExtendReceiving];
    [btnExtendReceiving mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnOrderTracking.mas_left).offset(-10);
        make.top.equalTo(btnRemind.mas_top);
        make.width.equalTo(btnRemind.mas_width);
        make.height.equalTo(btnRemind.mas_height);
    }];
    self.btnExtendReceiving = btnExtendReceiving;
    btnExtendReceiving.tag = 203;
//    [btnExtendReceiving setTitle:@"延长收货" forState:UIControlStateNormal];
    [btnExtendReceiving setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
    [btnExtendReceiving addTarget:self action:@selector(didClickExtendReceivingButton:) forControlEvents:UIControlEventTouchUpInside];
    btnExtendReceiving.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    btnExtendReceiving.layer.borderWidth = 1.0f;
    return footer;
}
/** 延长收货 */
- (void)didClickExtendReceivingButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button);
    }
}
/** 取消订单 */
- (void)didClickOrderTrackingButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button);
    }
}
/** 提醒发货 */
- (void)didClickRemindButton:(UIButton *)button {
    if (self.blockOrderBtn) {
        self.blockOrderBtn(button);
    }
}
- (void)setMyOrder:(XZMyOrderModel *)myOrder {
    _myOrder = myOrder;
    self.labelOrderNumber.text = myOrder.order_id;
    
    if (myOrder.orderStatusFM == 1) {
        self.labelOrderPay.text = @"交易关闭";
        [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
        self.btnOrderTracking.hidden = YES;
        self.btnExtendReceiving.hidden = YES;
    }else if(myOrder.orderStatusFM == 11)
    {
        self.labelOrderPay.text = @"申请售后中";
        [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
        self.btnOrderTracking.hidden = YES;
        self.btnExtendReceiving.hidden = YES;
        
    }else if(myOrder.orderStatusFM == 12)
    {
        self.labelOrderPay.text = @"申请售后关闭";
        [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
        self.btnOrderTracking.hidden = YES;
        self.btnExtendReceiving.hidden = YES;
        
    }else if(myOrder.orderStatusFM == 21)
    {
        self.labelOrderPay.text = @"交易成功";
        [self.btnRemind setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.btnOrderTracking setTitle:@"订单跟踪" forState:UIControlStateNormal];
        self.btnExtendReceiving.hidden = YES;
    }else if(myOrder.orderStatusFM == 31)
    {
        self.labelOrderPay.text = @"待评价";
        [self.btnRemind setTitle:@"收货评价" forState:UIControlStateNormal];
        self.btnOrderTracking.hidden = YES;
        self.btnExtendReceiving.hidden = YES;
    }else if(myOrder.orderStatusFM == 41)
    {
        self.labelOrderPay.text = @"卖家已发货";
        [self.btnRemind setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.btnOrderTracking setTitle:@"订单跟踪" forState:UIControlStateNormal];
        self.btnExtendReceiving.hidden = YES;
    }else if(myOrder.orderStatusFM == 51)
    {
        self.labelOrderPay.text = @"买家已付款";
        [self.btnRemind setTitle:@"提醒发货" forState:UIControlStateNormal];
        self.btnOrderTracking.hidden = YES;
        self.btnExtendReceiving.hidden = YES;
    }else if(myOrder.orderStatusFM == 61)
    {
        self.labelOrderPay.text = @"等待买家付款";
        [self.btnRemind setTitle:@"付款" forState:UIControlStateNormal];
        [self.btnOrderTracking setTitle:@"取消订单" forState:UIControlStateNormal];
        self.btnExtendReceiving.hidden = YES;
    }
    

}
@end
