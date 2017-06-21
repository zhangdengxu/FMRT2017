//
//  XZRepayAndRecordHeader.m
//  fmapp
//
//  Created by admin on 17/4/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZRepayAndRecordHeader.h"

@interface XZRepayAndRecordHeader ()
@property (nonatomic, strong) NSArray *arrayRAR;
//@property (nonatomic, strong) NSArray *arrayBidR;
@end

@implementation XZRepayAndRecordHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setUpRepayAndRecordHeader];
    }
    return self;
}

- (void)setUpRepayAndRecordHeader {
    self.backgroundColor = XZBackGroundColor;
    
    CGFloat width = KProjectScreenWidth / self.arrayRAR.count;
    for (int i = 0; i < self.arrayRAR.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, 40)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.arrayRAR[i];
        label.tag = 1000 + i;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor lightGrayColor];
    }
}

// 移除创建的label
- (void)removeLabelFromRepayAndRecordHeader {
    for (int i = 0; i < self.arrayRAR.count; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:(1000 + i)];
        [label removeFromSuperview];
    }
}

- (void)setCurrnetIndex:(NSInteger)currnetIndex {
    _currnetIndex = currnetIndex;
    if (currnetIndex == 1) {// 还款模型
        [self removeLabelFromRepayAndRecordHeader];
        _arrayRAR = @[@"期数",@"本金",@"利息",@"时间"];
        [self setUpRepayAndRecordHeader];
    }else if (currnetIndex == 2) { // 投标记录
        [self removeLabelFromRepayAndRecordHeader];
        _arrayRAR = @[@"投资人",@"投资金额",@"投标时间"];
        [self setUpRepayAndRecordHeader];
    }else {
        [self removeLabelFromRepayAndRecordHeader];
    }
}

@end
