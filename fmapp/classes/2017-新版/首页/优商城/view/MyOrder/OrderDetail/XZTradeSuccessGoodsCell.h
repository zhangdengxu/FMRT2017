//
//  XZTradeSuccessGoodsCell.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/28.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZMyOrderGoodsModel;

// 申请售后按钮
typedef void(^blockAfterSalesBtn)(UIButton * button);
// 申请售后按钮
@interface XZTradeSuccessGoodsCell : UITableViewCell

@property (nonatomic, copy) blockAfterSalesBtn blockAfterSalesBtn;


/** model */
@property (nonatomic, strong) XZMyOrderGoodsModel *goodsModel;
/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView;
@end
