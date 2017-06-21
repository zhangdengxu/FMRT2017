//
//  XZMySnatchCell.h
//  fmapp
//
//  Created by admin on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZMySnatchCell : UITableViewCell
// 上方图片
@property (nonatomic, strong) UIImageView *imgPhoto;
// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 红点
@property (nonatomic, strong) UIImageView *imgUnread;

@end
