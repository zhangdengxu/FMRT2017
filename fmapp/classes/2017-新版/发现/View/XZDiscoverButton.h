//
//  XZDiscoverButton.h
//  fmapp
//
//  Created by admin on 17/2/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZDiscoverButton : UIView

/** 图片 */
@property (nonatomic, strong) NSString *imageName;

/** 标题 */
@property (nonatomic, strong) NSString *title;

/** 副标题 */
@property (nonatomic, strong) NSString *subTitle;

/** btn的tag */
@property (nonatomic, assign) NSInteger tagNum;

@property (nonatomic, assign) BOOL isLeftButton;

/** 点击事件 */
- (void)addTarget:(id)idNumber action:(SEL)action;
@end
