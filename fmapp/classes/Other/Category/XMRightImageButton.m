//
//  XMRightImageButton.m
//  XMGoMoving
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "XMRightImageButton.h"

#import "UIView+Extension.h"
@implementation XMRightImageButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    CGFloat maxWidthX = CGRectGetMaxX(self.titleLabel.frame);
    if (self.titleLabel.x > imageViewFrame.origin.x) {
        
        self.titleLabel.x = imageViewFrame.origin.x;
        self.imageView.x = maxWidthX - self.imageView.frame.size.width;
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
