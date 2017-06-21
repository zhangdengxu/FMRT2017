//
//  XZTextView.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZTextView.h"
#import "UIView+Extension.h"
@interface XZTextView ()
/**
 *  占位文字Label
 */
@property (weak, nonatomic) UILabel *phLabel;
@end

@implementation XZTextView
- (UILabel *)phLabel
{
    if (!_phLabel) {
        UILabel *phLabel = [[UILabel alloc] init];
        // 文字自动换行
        phLabel.numberOfLines = 0;
        phLabel.x = 10;
        phLabel.y = 7;
//        phLabel.textColor = self.color;
        [self addSubview:phLabel];
        self.phLabel = phLabel;
    }
    
    return _phLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.phLabel.textColor = [UIColor lightGrayColor];
        // 添加监听器，监听自己的文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
// 时刻监听文字键盘文字的变化，文字一旦改变便调用setNeedsDisplay方法
- (void)textDidChange
{
    // 有文字就隐藏
    self.phLabel.hidden = self.hasText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 确定label的宽度，高度由文字数量自动计算
    CGSize size = CGSizeMake(self.width - 2 * self.phLabel.x, MAXFLOAT);
    // 根据文字的字体属性、文字的数量动态计算label的尺寸
    self.phLabel.size = [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
}
// 占位文字
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.phLabel.text = placeholder;
    // 更新文字尺寸
    [self setNeedsLayout];
}
// 字体
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.phLabel.font = font;
    [self setNeedsLayout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
