//
//  XZConfirmPaymentCell.h
//  fmapp
//
//  Created by admin on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class FMPriceModel;
//@class FMShoppingListModel;
@class FMDuobaoClassSelectStyle;
@interface XZConfirmPaymentCell : UITableViewCell
// 模型
//@property (nonatomic, strong) FMPriceModel *priceModel;
//@property (nonatomic, strong) FMShoppingListModel *model;
//@property (nonatomic, strong) FMSelectShopInfoModel *modelShopInfo;
@property (nonatomic, strong) FMDuobaoClassSelectStyle *duobaoClass;
/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView;
@end
