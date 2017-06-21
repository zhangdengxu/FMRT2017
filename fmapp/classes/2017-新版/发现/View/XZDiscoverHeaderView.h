//
//  XZDiscoverHeaderView.h
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZDiscoverHeaderView : UIView

@property (nonatomic, copy) void(^blockCoverButton)(UIButton *);

@property (nonatomic, copy) void(^blockClickScroll)(NSInteger);

/** 数组 */
@property (nonatomic, strong) NSMutableArray *arrayNew;

@end
