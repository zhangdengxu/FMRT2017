//
//  FMWaitDetailViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZMyOrderGoodsModel;
// 申请售后按钮
typedef void(^blockAfterSalesBtn)(UIButton * button);

@interface FMWaitDetailViewCell : UITableViewCell


@property (nonatomic, copy) blockAfterSalesBtn blockAfterSalesBtn;

/** model */
@property (nonatomic, strong) XZMyOrderGoodsModel *goodsModel;

@property (nonatomic,copy) NSString *afterSalesBtnTitle;

/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView;

@end
