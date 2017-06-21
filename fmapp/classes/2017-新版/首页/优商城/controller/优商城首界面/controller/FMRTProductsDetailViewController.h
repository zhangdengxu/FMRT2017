//
//  FMRTProductsDetailViewController.h
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "ZJScrollPageViewDelegate.h"

@protocol ZJPageViewControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end


@interface FMRTProductsDetailViewController :FMViewController<ZJScrollPageViewChildVcDelegate>

@property(weak, nonatomic)id<ZJPageViewControllerDelegate> delegate;

@property (nonatomic, copy) void(^selectBlock)();
@property (nonatomic, copy) NSString *cateID;


@end
