//
//  XZPromotionCell.h
//  fmapp
//
//  Created by admin on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMShopOtherModel;
@interface XZPromotionCell : UITableViewCell
/** 创建cell */
+ (instancetype )cellPromotionWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) FMShopOtherModel * activityModel;

@end
