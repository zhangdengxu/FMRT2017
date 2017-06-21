//
//  XZOptimalMallRecommendView.h
//  fmapp
//
//  Created by admin on 17/1/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZActivityModel;
@interface XZOptimalMallRecommendView : UIView
/** navTitle */
@property (nonatomic, strong) NSString *navTitle;
/** model */
@property (nonatomic, strong) XZActivityModel *modelActivity;

@property (nonatomic, copy) void(^blockJumpDetail)();
@end
