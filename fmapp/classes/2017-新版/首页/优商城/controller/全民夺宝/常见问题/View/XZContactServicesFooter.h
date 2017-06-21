//
//  XZContactServicesFooter.h
//  fmapp
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZContactServicesFooter : UIView
@property (nonatomic, copy) void(^blockContactServices)(UIButton *);
@property (nonatomic, assign) BOOL isCommonProblem;
@end
