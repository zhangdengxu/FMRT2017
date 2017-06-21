//
//  XMConvertNoteHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMConvertNoteHeaderView.h"

@interface XMConvertNoteHeaderView ()



@end

@implementation XMConvertNoteHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"XMConvertNoteHeaderView" owner:self options:nil] lastObject];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth * (KProjectScreenWidth / 375), 180);
        [self.currentStatus addTarget:self action:@selector(currentStatesChange:) forControlEvents:UIControlEventValueChanged];
        self.currentStatus.tintColor = [UIColor colorWithRed:(7/255.0) green:(64/255.0) blue:(142/255.0) alpha:1];
    }
    return self;
}

-(void)currentStatesChange:(UISegmentedControl *)currentStates
{
    if ([self.delegate respondsToSelector:@selector(XMConvertNoteHeaderViewDidSelectSegmentedControl:)]) {
        [self.delegate XMConvertNoteHeaderViewDidSelectSegmentedControl:self];
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
