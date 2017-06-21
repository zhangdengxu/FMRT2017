//
//  XZTradeSuccessView.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/27.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZTradeSuccessView : UIView
@property (nonatomic, strong) UITableView *tableTradeSuccess;
/** 提交订单按钮 */
@property (nonatomic, strong) UIButton *btnAddEvaluation;
/** tableView的headerView */
- (UIView *)tableTradeSuccessViewHeaderView;
@end
