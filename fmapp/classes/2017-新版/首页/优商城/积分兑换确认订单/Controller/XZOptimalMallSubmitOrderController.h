//
//  XZOptimalMallSubmitOrderController.h
//  fmapp
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
//@class XZIntegralConfirmOrderModel;
//FMShoppingListModel;
@interface XZOptimalMallSubmitOrderController : FMViewController
//@property (nonatomic, strong) FMDuobaoClassSelectStyle *duobaoShop;
//@property (nonatomic, strong) FMShoppingListModel *modelGoodsDetail;
//
@property (nonatomic, strong) NSMutableArray *shopDataSource;
//@property (nonatomic, strong) XZIntegralConfirmOrderModel *modelConfirm;
/** 判断是从详情页跳转还是购物车跳转 */
@property (nonatomic, strong) NSString *sess_id;
@end
