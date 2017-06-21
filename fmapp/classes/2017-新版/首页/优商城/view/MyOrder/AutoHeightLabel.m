//
//  AutoHeightLabel.m
//  XuXue
//
//  Created by XuXue on 14/11/3.
//  Copyright (c) 2015年 XuXue. All rights reserved.
//

#import "AutoHeightLabel.h"

@implementation AutoHeightLabel

// 重写set方法
-(void)setText:(NSString *)text{
    [super setText:text];
    self.numberOfLines = 0;
    NSString *str = text;
    CGSize  size = CGSizeMake(self.frame.size.width, 2000);
    NSDictionary *dic = @{NSFontAttributeName:self.font};
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect labelFrame = self.frame;
    labelFrame.size.height = rect.size.height;
    self.frame = labelFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
