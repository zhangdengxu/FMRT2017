//
//  SignOnDeleteView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SignOnDeleteView : UIView

@property (nonatomic, copy)void(^sureBlock)(UIButton *sender);
@property (nonatomic, copy)void(^deleteBlock)(UIButton *sender);
@property (nonatomic, assign) NSInteger chexiao;

-(void)showSignViewWithTitle:(NSString *)title detail:(NSString *)detailContent;
-(void)hiddenSignView;
// 没有取消、确定按钮
- (void)showSignViewNoButtonWithTitle:(NSString *)title detail:(NSString *)detailContent;

// 只有上面和俩个按钮,没有中间说明
-(void)showSignViewWithTitle:(NSString *)title;
-(void)showSignViewWithTitle:(NSString *)title withTitleColor:(NSString *)titleColor withLineColor:(NSString *)lineColor;
@end
