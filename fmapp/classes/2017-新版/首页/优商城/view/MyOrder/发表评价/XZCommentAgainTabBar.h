//
//  XZCommentAgainTabBar.h
//  fmapp
//
//  Created by admin on 16/12/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^blockCommentBtn)(UIButton *button);
@interface XZCommentAgainTabBar : UIView
@property (nonatomic, copy) blockCommentBtn blockCommentBtn;
@end
