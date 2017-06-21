//
//  FMCommentHeaderViewTagMark.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LINE_BUTTON_MARGIN       10.0f
#define BOTTOM_BUTTON_MARGIN      10.0f

#import "FMCommentHeaderViewTagMark.h"

@interface FMCommentHeaderViewTagMark ()


@property (nonatomic, assign) CGRect previousFrame;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, strong) UIColor * itemBackageColor,*itemSelectBackColor,*textColor,*selectTextColor;
@property (nonatomic, strong) UIButton * currentButton;

@end

@implementation FMCommentHeaderViewTagMark

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.totalHeight = BOTTOM_BUTTON_MARGIN;
        self.frame=frame;
    }
    return self;
}


-(void)setTagMarkWithTagArray:(NSArray*)arr
{
    
    self.previousFrame = CGRectMake(0, BOTTOM_BUTTON_MARGIN, 0, 0);
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton * contentButton=[[UIButton alloc]initWithFrame:CGRectZero];
       
        contentButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [contentButton setBackgroundColor:self.itemBackageColor];
        [contentButton setTitleColor:self.textColor forState:UIControlStateNormal];
        [contentButton setTitleColor:self.selectTextColor forState:UIControlStateSelected];
        contentButton.tag = idx;
        [contentButton addTarget:self action:@selector(contentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        contentButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [contentButton setTitle:str forState:UIControlStateNormal];
        contentButton.layer.cornerRadius=5;
        contentButton.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING * 2;
        Size_str.height += VERTICAL_PADDING * 2;
        CGRect newRect = CGRectZero;
        if (self.previousFrame.origin.x + self.previousFrame.size.width + Size_str.width + LINE_BUTTON_MARGIN > self.bounds.size.width) {
            newRect.origin = CGPointMake(10, self.previousFrame.origin.y + Size_str.height + BOTTOM_BUTTON_MARGIN);
            self.totalHeight +=Size_str.height + BOTTOM_BUTTON_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(self.previousFrame.origin.x + self.previousFrame.size.width + LINE_BUTTON_MARGIN, self.previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [contentButton setFrame:newRect];
        self.previousFrame=contentButton.frame;
        [self setHight:self andHight:self.totalHeight+Size_str.height + BOTTOM_BUTTON_MARGIN];
        [self addSubview:contentButton];
        
        if (idx == 0) {
            [self contentButtonOnClick:contentButton];
        }
    }
    ];

}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
-(void)contentButtonOnClick:(UIButton *)button
{
    Log(@"button:%zi",button.tag);
    
    if (self.currentButton != button) {
        [self.currentButton setBackgroundColor:self.itemBackageColor];
        
        
        self.currentButton.selected = !self.currentButton.selected;
        
        self.currentButton = button;
        
        self.currentButton.selected = !self.currentButton.selected;
        [self.currentButton setBackgroundColor:self.itemSelectBackColor];
        
        
        
        
        if ([self.delegate respondsToSelector:@selector(FMCommentHeaderViewTagMark:didSelectItem:)]) {
            [self.delegate FMCommentHeaderViewTagMark:self didSelectItem:button.tag];
        }
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(UIColor *)itemBackageColor
{
    if (!_itemBackageColor) {
        _itemBackageColor = [HXColor colorWithHexString:@"#e5e9f2"];
    }
    return _itemBackageColor;
}
-(UIColor *)itemSelectBackColor
{
    if (!_itemSelectBackColor) {
        _itemSelectBackColor = [HXColor colorWithHexString:@"#ff6633"];
    }
    return _itemSelectBackColor;
}
-(UIColor *)textColor
{
    
    if (!_textColor) {
        _textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    }
    return _textColor;
    
}
-(UIColor *)selectTextColor
{
    if (!_selectTextColor) {
        _selectTextColor = [UIColor whiteColor];
    }
    return _selectTextColor;
}

@end
