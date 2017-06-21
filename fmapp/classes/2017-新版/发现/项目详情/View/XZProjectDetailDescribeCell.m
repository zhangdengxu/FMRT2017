//
//  XZProjectDetailDescribeCell.m
//  fmapp
//
//  Created by admin on 17/4/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZProjectDetailDescribeCell.h"

@implementation XZProjectDetailDescribeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpProjectDetailDescribeCell];
    }
    return self;
}

- (void)setUpProjectDetailDescribeCell {
    //
    UILabel *labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
    }];
    labelContent.text = @"本项目投标已结束，为保护借款人隐私暂不支持查看。";
    
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
