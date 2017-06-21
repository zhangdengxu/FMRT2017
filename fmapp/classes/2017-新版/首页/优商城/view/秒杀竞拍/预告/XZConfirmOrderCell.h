//
//  XZConfirmOrderCell.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/23.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMPriceModel;
@class FMShoppingListModel;
@class FMSelectShopInfoModel;
@interface XZConfirmOrderCell : UITableViewCell
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色尺码 */
@property (nonatomic, strong) UILabel *colorLabel;
/** 尺码 */
//@property (nonatomic, strong) UILabel *sizeLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *quantityLabel;
// 模型
@property (nonatomic, strong) FMShoppingListModel *model;
@property (nonatomic, strong) FMSelectShopInfoModel *modelShopInfo;

@property (nonatomic, strong) FMPriceModel *priceModel;
/** 创建cell */
+ (instancetype )cellConfirmOrderWithTableView:(UITableView *)tableView;

@end
