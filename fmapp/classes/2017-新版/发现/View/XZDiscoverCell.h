//
//  XZDiscoverCell.h
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZDiscoverCell : UITableViewCell

/** 数据 */
@property (nonatomic, strong) NSArray *discovers;
/** 点击每一行item */
@property (nonatomic, copy) void(^blockDidClickItem)(NSIndexPath *);
/** 点击融讯融言 */
@property (nonatomic, copy) void(^blockCoverButton)();
@end
