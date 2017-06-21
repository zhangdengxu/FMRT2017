//
//  XZRongMiSchoolHeader.h
//  fmapp
//
//  Created by admin on 17/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRongMiSchoolModel;
@interface XZRongMiSchoolHeader : UIView

// 全屏按钮点击事件
@property (nonatomic, copy) void(^blockFullScreenBtn)(UIButton *);

// 全屏通知：是否点击了全屏按钮，旋转方向
@property (nonatomic, copy) void(^blockFullScreen)(BOOL,NSString *);

@property (nonatomic, strong) XZRongMiSchoolModel *modelRongMi;

// 修改
- (void)setPlayLayerFrame:(BOOL)isSetFrame;

// 点击左上角返回时，调用
- (void)viewWillDisapperPause;
@end
