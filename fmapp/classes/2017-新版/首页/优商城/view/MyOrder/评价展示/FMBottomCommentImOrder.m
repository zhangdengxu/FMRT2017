//
//  FMBottomCommentImOrder.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMBottomCommentImOrder.h"

@interface FMBottomCommentImOrder ()

@property (nonatomic, strong) UIView * bottomView;

@end

@implementation FMBottomCommentImOrder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * lineView = [[UIView  alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 5, frame.size.width, 5)];
        self.bottomView = bottomView;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.bottomView.backgroundColor = [UIColor orangeColor];
    }else
    {
        self.bottomView.backgroundColor = [UIColor whiteColor];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
