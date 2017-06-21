//
//  FMCountButtonInOrder.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMCountButtonInOrder.h"

@interface FMCountButtonInOrder ()
@property (nonatomic, weak)  UIButton * countButton;
@property (nonatomic, weak) UILabel * titleCommentLabel;
@end

@implementation FMCountButtonInOrder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIButton * countButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
        self.countButton = countButton;
        if (KProjectScreenWidth == 320) {
            countButton.titleLabel.font = [UIFont systemFontOfSize:11];
        }else
        {
            countButton.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        countButton.layer.cornerRadius = 15;
        countButton.layer.masksToBounds = YES;
        [countButton setBackgroundColor:[UIColor orangeColor]];
        [countButton setTitle:[NSString stringWithFormat:@"%zi",0] forState:UIControlStateNormal];
        [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:countButton];
        
        UILabel * titleComment = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(countButton.frame) + 8, frame.size.width, 20)];
        self.titleCommentLabel = titleComment;
        
        titleComment.textAlignment = NSTextAlignmentCenter;
        titleComment.textColor = [UIColor lightGrayColor];
        if (KProjectScreenWidth == 320) {
            titleComment.font = [UIFont systemFontOfSize:12];
        }else
        {
            titleComment.font = [UIFont systemFontOfSize:14];
        }
        [self addSubview:titleComment];
        
        countButton.center = CGPointMake(frame.size.width * 0.5, countButton.center.y);
        titleComment.center = CGPointMake(frame.size.width * 0.5, titleComment.center.y);

    }
    return self;
}
-(void)setCount:(NSString *)count
{
    _count = count;
    [self.countButton setTitle:count forState:UIControlStateNormal];
}
-(void)setTitleComment:(NSString *)titleComment
{
    _titleComment = titleComment;
    self.titleCommentLabel.text = titleComment;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
