//
//  UIScrollView+XMPageing.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XMPageing)
@property (nonatomic, strong) UIScrollView *secondScrollView;


- (void)addFirstScrollViewFooter;
- (void)endHeaderRefreshing;
@end
