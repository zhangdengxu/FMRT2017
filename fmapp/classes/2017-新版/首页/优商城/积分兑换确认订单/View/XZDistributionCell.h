//
//  XZDistributionCell.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/26.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 点击快递信息按钮
typedef void(^blockDistributionBtn)(UIButton *);
@class XZConfirmOrderModel;
@interface XZDistributionCell : UITableViewCell

@property (nonatomic, copy) blockDistributionBtn blockDistributionBtn;
@property (nonatomic, strong) XZConfirmOrderModel *modelConfirm;

//@property (nonatomic, assign) BOOL isEnableOnClick;
/** 创建cell */
+ (instancetype )cellDistributionWithTableView:(UITableView *)tableView;
@end
