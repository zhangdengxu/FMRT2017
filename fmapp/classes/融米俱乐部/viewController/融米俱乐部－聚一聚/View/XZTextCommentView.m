//
//  XZTextView.m
//  XZTextView
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
// 写评论

#import "XZTextCommentView.h"

#define MaxTextViewHeight 80 // 限制文字输入的高度

@interface  XZTextCommentView()<UITextViewDelegate,UIScrollViewDelegate>
{
    /** 设置占位符的文字 */
    NSString *placeholderText;
}
/** 输入框后面的白色背景 */
@property (nonatomic, strong) UIView *backGroundView;
/** 占位文字 */
@property (nonatomic, strong) UILabel *placeholderLabel;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation XZTextCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpCommentView];
    }
    return self;
}

- (void)setUpCommentView {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(KProjectScreenWidth-65);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(39);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
    
}

// 设置占位字
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
     // 设置占位符
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        self.sendButton.userInteractionEnabled = YES;
    }
}

#pragma  mark -- 发送事件
- (void)sendClick:(UIButton *)sender{
    [self.textView endEditing:YES];
    if (self.blockDidClickSendBtn) {
        self.blockDidClickSendBtn(self.textView.text);
    }
    
    // 发送成功之后清空
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    self.sendButton.userInteractionEnabled = NO;
}

#pragma mark --- 懒加载控件
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 49)];
        _backGroundView.backgroundColor = XZColor(230, 230, 230);
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.textColor = [UIColor grayColor];
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}

@end
