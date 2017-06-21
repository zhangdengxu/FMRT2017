//
//  FMProfmptBoxView.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^blockBtn)(UIButton *);


@interface FMProfmptBoxView : UIView


- (instancetype)initWithFrame:(CGRect)frame;
// 赋值
- (void)profmptBoxWithTitle:(NSString *)title andContent:(NSString *)content andBtnTitle:(NSString *)btnTitle andHadImage:(BOOL)hadImage;
@property (nonatomic, copy) blockBtn blockBtn;

-(void)showViewAlertView;
-(void)hiddenViewAlertView;
@end
