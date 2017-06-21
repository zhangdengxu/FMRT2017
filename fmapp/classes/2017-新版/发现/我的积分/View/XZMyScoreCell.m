//
//  XZMyScoreCell.m
//  fmapp
//
//  Created by admin on 17/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZMyScoreCell.h"
#import "XZMyScoreGoodsModel.h" // model

@interface XZMyScoreCell ()
// 商品图片
@property (nonatomic, strong) UIImageView *imgGoods;
// 商品名
@property (nonatomic, strong) UILabel *labelTitle;
// 积分数
@property (nonatomic, strong) UILabel *labelCoins;
// 数量
@property (nonatomic, strong) UILabel *labelCount;

@end

@implementation XZMyScoreCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMyScoreCell];
    }
    return self;
}

- (void)setUpMyScoreCell {
    // XZRandomColor
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 商品图片
    UIImageView *imgGoods = [[UIImageView alloc] init];
    [self.contentView addSubview:imgGoods];
    [imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.size.equalTo(@((KProjectScreenWidth - 50) / 2.0));
    }];
    self.imgGoods = imgGoods;
    
    CGFloat font = 13.0f;
    if (KProjectScreenWidth < 350) {
        font = 12.0f;
    }
    
    // 数量
    UILabel *labelCount = [[UILabel alloc] init];
    [self.contentView addSubview:labelCount];
    [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgGoods).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    labelCount.textColor = [HXColor colorWithHexString:@"#999999"];
    labelCount.font = [UIFont systemFontOfSize:font];
    self.labelCount = labelCount;
    
    // 积分数
    UILabel *labelCoins = [[UILabel alloc] init];
    [self.contentView addSubview:labelCoins];
    [labelCoins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods).offset(-5);
        make.top.equalTo(labelCount);
    }];
    labelCoins.textColor = [HXColor colorWithHexString:@"#FF3333"];
    labelCoins.font = [UIFont systemFontOfSize:font];
    self.labelCoins = labelCoins;
    
    // 商品名
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelCoins.mas_centerY).offset(-28);
        make.left.equalTo(imgGoods).offset(-5);
        make.right.equalTo(imgGoods);
    }];
    labelTitle.textColor = [HXColor colorWithHexString:@"#333333"];
    labelTitle.font = [UIFont systemFontOfSize:13.0f];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.numberOfLines = 2;
    self.labelTitle = labelTitle;
    
}

- (void)setModelMyScore:(XZMyScoreGoodsModel *)modelMyScore {
    _modelMyScore = modelMyScore;
    NSMutableAttributedString *(^makeUnitSmall)(NSString *,NSString *) = ^(NSString *redStr,NSString *text) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSInteger length = [redStr length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[HXColor colorWithHexString:@"#FF3333"] range:NSMakeRange(2, length)];
        return attrStr;
    };
    
    CGFloat width = [modelMyScore.title getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 30) WithFont:[UIFont systemFontOfSize:15.0f]].width;
    
    if (width > ((KProjectScreenWidth - 50) / 2.0 + 10)) {
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        
    }else {
        self.labelTitle.textAlignment = NSTextAlignmentLeft;
    }
    
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:modelMyScore.img] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-100x100"]];
    //苹果 Apple iMac 21.5 多色可选 可折叠
    self.labelTitle.text = modelMyScore.title;
    
    if ([modelMyScore.type isEqualToString:@"normal"]) { // 正常商品
        // 钱数
        self.labelCoins.text = [NSString stringWithFormat:@"%.2f元",[modelMyScore.price floatValue]];
    }else { // 积分商品：全积分购买
        // 积分数
        self.labelCoins.text = [NSString stringWithFormat:@"%@",modelMyScore.needjifen];
    }
    
    if ([modelMyScore.remaining integerValue] > 0) {
        // 剩余商品数量
        NSString *count = [NSString stringWithFormat:@"%@",modelMyScore.remaining];
        self.labelCount.attributedText = makeUnitSmall(count,[NSString stringWithFormat:@"仅剩%@个",modelMyScore.remaining]);
    }else {
        self.labelCount.text = @"已兑完";
    }
    
}

@end
