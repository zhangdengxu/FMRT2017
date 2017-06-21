//
//  XZRongMiSchoolFooter.h
//  fmapp
//
//  Created by admin on 17/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRongMiSchoolProjectModel;
@interface XZRongMiSchoolFooter : UIView

@property (nonatomic, copy) void(^blockFooter)();

@property (nonatomic, strong) XZRongMiSchoolProjectModel *modelProject;
@end
