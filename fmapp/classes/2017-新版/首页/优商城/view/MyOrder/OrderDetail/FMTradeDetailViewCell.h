//
//  FMTradeDetailViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZMyOrderGoodsModel;
// 申请售后按钮
typedef void(^blockAfterSalesBtn)(UIButton * button);
@interface FMTradeDetailViewCell : UITableViewCell

@property (nonatomic, copy) blockAfterSalesBtn blockAfterSalesBtn;

/** model */
@property (nonatomic, strong) XZMyOrderGoodsModel *goodsModel;

@property (nonatomic,copy) NSString *afterSalesBtnTitle;

@property (nonatomic, assign) BOOL isShowComment;
//是否是订单详情页过来的

@property (nonatomic, assign) NSInteger isOrderDetail;
/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView;

@end
