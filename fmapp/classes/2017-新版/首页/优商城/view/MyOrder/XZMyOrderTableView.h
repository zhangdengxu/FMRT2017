//
//  XZMyOrderTableView.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/29.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
// 提醒发货、订单按钮
typedef void(^blockOrderBtn)(UIButton *);
@class XZMyOrderModel;
@interface XZMyOrderTableView : UIView
// 
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) blockOrderBtn blockOrderBtn;
/** 提醒发货 */
@property (nonatomic, strong) UIButton *btnRemind;
/** 取消订单 */
@property (nonatomic, strong) UIButton *btnOrderTracking;
/** 延长收货 */
@property (nonatomic, strong) UIButton *btnExtendReceiving;
/** 订单编号行的label */
@property (nonatomic, strong) UILabel *labelOrderPay;
/** 模型 */
@property (nonatomic, strong) XZMyOrderModel *myOrder;
/** tableView的sectionHeaderView */
- (UIView *)tableViewSectionHeaderView;
/** tableView的sectionFooterView */
- (UIView *)tableViewSectionFooterView;
@end
