//
//  XZRecommendView.h
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/22.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZLargeButton;
@interface XZRecommendView : UIView
/** 今日收入 */
@property (nonatomic, strong) UILabel *labelIncome;
/** 月收入 */
@property (nonatomic, strong) UILabel *labelMonthlyIncome;
/** 总收入 */
@property (nonatomic, strong) UILabel *labelTotalIncome;
/** 我的销售订单 */
@property (nonatomic, strong) XZLargeButton *btnSalesOrder;
/** 我的推荐人管理 */
@property (nonatomic, strong) XZLargeButton *btnRefereeMag;
@end
