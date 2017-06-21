//
//  XZCancelOrderCell.h
//  fmapp
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
// 点击按钮
typedef void(^blockSelectedBtn)(UIButton *button);
@interface XZCancelOrderCell : UITableViewCell
/** 取消的信息 */
@property (nonatomic, strong) UILabel *labelCancelInfo;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *btnSelected;
/** 创建cell */
+ (instancetype )cellCancelOrderWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) blockSelectedBtn blockSelectedBtn;
- (void)selectedBtnAction:(UIButton *)button;

@end
