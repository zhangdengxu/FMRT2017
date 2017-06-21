//
//  FMOrderTableViewFooter.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZMyOrderModel;
typedef void(^blockOrderBtn)(UIButton *button,XZMyOrderModel * orderModel);
@interface FMOrderTableViewFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) blockOrderBtn blockOrderBtn;
@property (nonatomic, strong) XZMyOrderModel * orderModel;
//是否是评论过来的
@property (nonatomic, assign) NSInteger isCommentFooter;
@end
