//
//  XZTextView.h
//  XZTextView
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZTextCommentView : UIView
/** 输入框 */
@property (nonatomic, strong) UITextView *textView;
/** 点击发送按钮 */
@property (nonatomic,copy) void (^blockDidClickSendBtn)(NSString *);
/** 设置占位文字 */
- (void)setPlaceholderText:(NSString *)text;

@end
