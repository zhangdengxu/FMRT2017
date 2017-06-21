//
//  XZOptimalMallSubmitOrderCell.h
//  fmapp
//
//  Created by admin on 16/12/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZConfirmOrderModel,FMShoppingListModel;
@interface XZOptimalMallSubmitOrderCell : UITableViewCell
// 从商品详情跳入：当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModel;
// 从购物车跳入：cell的model
@property (nonatomic, strong) FMShoppingListModel *shopListModel;
/** 创建cell */
+ (instancetype )CellMallSubmitOrderWithTableView:(UITableView *)tableView;
@end
