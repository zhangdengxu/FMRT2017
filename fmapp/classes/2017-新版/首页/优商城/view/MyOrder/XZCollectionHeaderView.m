//
//  XZCategoryCollectionHeaderView.m
//  XZFoodCategory
//
//  Created by XUXUE on 15/1/11.
//  Copyright © 2015年 XUXUE. All rights reserved.
//

#import "XZCollectionHeaderView.h"

@implementation XZCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}
- (void)setUpChildView{
     self.backgroundColor = XZColor(230, 235, 240);
    /** 图片 */
    UIImageView *ImageOrder = [[UIImageView alloc]init];
    [self addSubview:ImageOrder];
    [ImageOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(40);
    }];
    ImageOrder.image = [UIImage imageNamed:@"无内容"];
    /** 第一个提示框 */
    UILabel *labelFirst = [[UILabel alloc]init];
    [self addSubview:labelFirst];
    [labelFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(ImageOrder.mas_bottom).offset(40);
    }];
    labelFirst.text = @"您还没有购买订单呢";
    labelFirst.textColor = [UIColor darkGrayColor];
    /** 第二个提示框 */
    UILabel *labelSecond = [[UILabel alloc]init];
    [self addSubview:labelSecond];
    [labelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(labelFirst.mas_bottom).offset(10);
    }];
    labelSecond.text = @"快去挑选自己喜欢的吧";
    labelSecond.textColor = [UIColor darkGrayColor];
    labelSecond.font = [UIFont systemFontOfSize:13];
    /** 第三个提示框 */
    UILabel *labelThird = [[UILabel alloc]init];
    [self addSubview:labelThird];
    [labelThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(10);
        make.top.equalTo(labelSecond.mas_bottom).offset(40);
        make.width.equalTo(@75);
    }];
    labelThird.text = @"您可能喜欢";
    labelThird.textColor = [UIColor darkGrayColor];
    labelThird.font = [UIFont systemFontOfSize:13];
    /** 图片 */
    UIImageView *ImageHome = [[UIImageView alloc]init];
    [self addSubview:ImageHome];
    [ImageHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelThird.mas_left).offset(-5);
        make.top.equalTo(labelThird.mas_top).offset(-3);
        make.height.and.width.equalTo(@(20));
    }];
    ImageHome.image = [UIImage imageNamed:@"order_no_content_house"];
    /** 左边线 */
    UILabel *leftLine = [[UILabel alloc]init];
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(ImageHome.mas_left).offset(-10);
        make.centerY.equalTo(ImageHome.mas_centerY);
        make.height.equalTo(@0.5);
    }];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    /** 右边线 */
    UILabel *rightLine = [[UILabel alloc]init];
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelThird.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(ImageHome.mas_centerY);
        make.height.equalTo(@0.5);
    }];
    rightLine.backgroundColor = [UIColor lightGrayColor];
}
@end
