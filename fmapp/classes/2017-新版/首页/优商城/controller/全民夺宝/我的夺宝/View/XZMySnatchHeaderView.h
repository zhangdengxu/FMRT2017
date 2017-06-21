//
//  XZMySnatchHeaderView.h
//  fmapp
//
//  Created by admin on 16/10/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZIndianaCurrencyModel;
@interface XZMySnatchHeaderView : UIView
@property (nonatomic, copy) void(^blockMySnatchHeader)(UIButton *);
@property (nonatomic, strong)  XZIndianaCurrencyModel *modelMySnatch;
@end
