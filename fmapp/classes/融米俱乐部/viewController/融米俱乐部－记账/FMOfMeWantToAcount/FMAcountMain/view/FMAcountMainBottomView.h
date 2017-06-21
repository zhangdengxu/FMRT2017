//
//  FMAcountMainBottomView.h
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMAcountMainBottomView : UIView

@property (nonatomic, copy) void(^detailBlock)();
@property (nonatomic, copy) void(^formBlock)();

@end
