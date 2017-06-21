//
//  MPAlertView.h
//  zgbb
//
//  Created by apple on 13-7-5.
//  Copyright (c) 2013年 9ask.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPAlertView : UIView

- (void)hide;

- (void)showAlertView:(NSString*)title;

- (void)showAlertView:(NSString*)title withOffsetX:(CGFloat)dx withOffsetY:(CGFloat)dy;

@end
