//
//  LoadViewHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 15/12/30.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "LoadViewHeaderView.h"

@interface LoadViewHeaderView ()

@property (nonatomic,strong)UIButton * selectButton;

@end

@implementation LoadViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * titleView = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 21) * 0.5, frame.size.width - 100, 21)];
        
        titleView.font = [UIFont systemFontOfSize:13];
        titleView.textColor = [UIColor grayColor];
        self.titleView = titleView;
        [self addSubview:titleView];
    }
    return self;
}

@end
