//
//  XZSignUpView.h
//  fmapp
//
//  Created by admin on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZSignUpView : UIView
// 点击提交按钮
@property (nonatomic, copy) void(^blockSubmitBtn)(NSString *,NSString *);
@property (nonatomic, copy) void(^blockCloseBtn)(UIButton *);
/** button的title */
@property (nonatomic, strong) NSString *btnTitle;
@end
