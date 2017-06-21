//
//  XZChooseCommentAgainView.h
//  fmapp
//
//  Created by admin on 16/5/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockCommentAgainBtn)(UIButton *);
@interface XZChooseCommentAgainView : UIView
@property (nonatomic, strong) blockCommentAgainBtn blockCommentAgainBtn;
@end
