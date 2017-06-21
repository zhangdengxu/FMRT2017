//
//  XZIntegralConfirmOrderCell.h
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZConfirmOrderModel;
@interface XZIntegralConfirmOrderCell : UITableViewCell

// 当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModelCoins;
/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView;

@end
