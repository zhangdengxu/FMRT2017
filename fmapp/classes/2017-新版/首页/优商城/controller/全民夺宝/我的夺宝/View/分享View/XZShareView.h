//
//  XZShareView.h
//  fmapp
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZActivityModel;
@interface XZShareView : UIView
@property (nonatomic, strong) XZActivityModel *modelShare;
@property (nonatomic, copy) void(^blockShareAction)(UIButton *);
/** 分享点击事件 */
-(void)shareAction:(UIButton *)button handlerDelegate:(id)target;
// 分享成功的回调
@property (nonatomic, copy) void(^blockShareSuccess)();

//新增加的方法。为了获取动画效果，将infoView上的button删除，重新添加获取动画；
-(XZShareView *)retViewWithSelf;
@end
