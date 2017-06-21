//
//  XZRongMiSchoolFooter.m
//  fmapp
//
//  Created by admin on 17/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//  融米学堂footer

#import "XZRongMiSchoolFooter.h"
#import "XZRongMiSchoolProjectModel.h"

@interface XZRongMiSchoolFooter ()

// 商品图片
@property (nonatomic, strong) UIImageView *imgGoods;
// 商品名
@property (nonatomic, strong) UILabel *labelGoodsName;
// 价格
@property (nonatomic, strong) UILabel *labelPrice;
// 商品背景
@property (nonatomic, strong) UIView *bgGoods;
// 项目背景
@property (nonatomic, strong) UIView *bgProject;

// 年化收益率
@property (nonatomic, strong) UILabel *labelRate;
// 预期年化收益
@property (nonatomic, strong) UILabel *labelEarnings;
// 项目名称
@property (nonatomic, strong) UILabel *labelProName;
// 项目明细
@property (nonatomic, strong) UILabel *labelProDetail;
// 项目时间
@property (nonatomic, strong) UILabel *labelProTime;
@end

@implementation XZRongMiSchoolFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XZBackGroundColor;
        // 推荐项目
        [self setUpRongMiSchoolFooterProject];
        // 推荐商品
        [self setUpRongMiSchoolFooterGoods];
        // 添加点击事件
        [self addTargetOnView];
    }
    return self;
}

// 推荐商品
- (void)setUpRongMiSchoolFooterGoods {
    // 商品背景
    UIView *bgGoods = [[UIView alloc] init];
    [self addSubview:bgGoods];
    [bgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(1);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self.frame.size.height);
    }];
    self.bgGoods = bgGoods;
    bgGoods.backgroundColor = [UIColor whiteColor];
    
    // 商品图片
    UIImageView *imgGoods = [[UIImageView alloc] init];
    [bgGoods addSubview:imgGoods];
    [imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgGoods).offset(10);
        make.centerY.equalTo(bgGoods);
        make.size.equalTo(@(132 * 0.7));
    }];
    self.imgGoods = imgGoods;
    
    // 箭头 融米学堂_小返回_1702
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [bgGoods addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgGoods).offset(-10);
        make.centerY.equalTo(bgGoods);
        make.width.equalTo(@(11 * 0.6));
        make.height.equalTo(@(20 * 0.6));
    }];
    imgArrow.image = [UIImage imageNamed:@"融米学堂_小返回_1702"];
    
    // 商品名
    UILabel *labelGoodsName = [[UILabel alloc] init];
    [bgGoods addSubview:labelGoodsName];
    [labelGoodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods.mas_right).offset(15);
        make.bottom.equalTo(imgGoods.mas_centerY).offset(-8);
        make.right.equalTo(imgArrow.mas_left).offset(-10);
    }];
    self.labelGoodsName = labelGoodsName;
    labelGoodsName.font = [UIFont systemFontOfSize:16.0];
    labelGoodsName.textColor = [HXColor colorWithHexString:@"#333333"];
    labelGoodsName.numberOfLines = 2;
    
    // 价格
    UILabel *labelPrice = [[UILabel alloc] init];
    [bgGoods addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelGoodsName);
        make.top.equalTo(imgGoods.mas_centerY).offset(7);
    }];
    self.labelPrice = labelPrice;
    labelPrice.font = [UIFont systemFontOfSize:16.0];
    labelPrice.textColor = [HXColor colorWithHexString:@"#ff6633"];
    
}

// 推荐项目
- (void)setUpRongMiSchoolFooterProject {
    // 项目背景
    UIView *bgProject = [[UIView alloc] init];
    [self addSubview:bgProject];
    [bgProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(1);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self.frame.size.height);
    }];
    self.bgProject = bgProject;
    bgProject.backgroundColor = [UIColor whiteColor];
    
    CGFloat offset = 132 * 0.7 * 0.5 + 10;
    if (KProjectScreenWidth > 350) {
        offset = 132 * 0.7 * 0.5 + 20;
    }
    // 年化收益率
    UILabel *labelRate = [[UILabel alloc] init];
    [bgProject addSubview:labelRate];
    [labelRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgProject.left).offset(offset);
        make.centerY.equalTo(bgProject).offset(-10);
    }];
    self.labelRate = labelRate;
    labelRate.font = [UIFont systemFontOfSize:30.0f];
    labelRate.textColor = [HXColor colorWithHexString:@"#ff6633"];
    
    // 预期年化收益
    UILabel *labelEarnings = [[UILabel alloc] init];
    [bgProject addSubview:labelEarnings];
    [labelEarnings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelRate);
        make.top.equalTo(labelRate.mas_bottom).offset(10);
    }];
    self.labelEarnings = labelEarnings;
    labelEarnings.font = [UIFont systemFontOfSize:13.0f];
    labelEarnings.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
    
    // 竖线
    UILabel *line = [[UILabel alloc] init];
    [bgProject addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelRate.centerX).offset(offset);
        make.centerY.equalTo(bgProject);
        make.height.equalTo(@(132 * 0.7));
        make.width.equalTo(@0.5);
    }];
    line.backgroundColor = [HXColor colorWithHexString:@"#aaaaaa"];
    
    // 箭头 融米学堂_小返回_1702
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [bgProject addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgProject).offset(-10);
        make.centerY.equalTo(bgProject);
        make.width.equalTo(@(11 * 0.6));
        make.height.equalTo(@(20 * 0.6));
    }];
    imgArrow.image = [UIImage imageNamed:@"融米学堂_小返回_1702"];
    
    // 项目名称
    UILabel *labelProName = [[UILabel alloc] init];
    [bgProject addSubview:labelProName];
    [labelProName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(25);
        make.right.equalTo(imgArrow.mas_left).offset(-10);
        make.top.equalTo(bgProject).offset(30);
    }];
    self.labelProName = labelProName;
    self.labelProName.textColor = [HXColor colorWithHexString:@"#333333"];
    labelProName.font = [UIFont systemFontOfSize:16.0f];
    
    // 项目明细
    UILabel *labelProDetail = [[UILabel alloc] init];
    [bgProject addSubview:labelProDetail];
    [labelProDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelProName);
        make.right.equalTo(labelProName);
        make.top.equalTo(labelProName.mas_bottom).offset(10);
    }];
    self.labelProDetail = labelProDetail;
    labelProDetail.textColor = [HXColor colorWithHexString:@"#333333"];
    labelProDetail.font = [UIFont systemFontOfSize:13.0f];
    
    // 项目时间
    UILabel *labelProTime = [[UILabel alloc] init];
    [bgProject addSubview:labelProTime];
    [labelProTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelProName);
        make.top.equalTo(labelProDetail.mas_bottom).offset(10);
    }];
    self.labelProTime = labelProTime;
    labelProTime.layer.borderWidth = 0.5f;
    labelProTime.layer.borderColor = [HXColor colorWithHexString:@"#333333"].CGColor;
    labelProTime.textColor = [HXColor colorWithHexString:@"#333333"];
    labelProTime.textAlignment = NSTextAlignmentCenter;
    labelProTime.font = [UIFont systemFontOfSize:12.0f];
}

#pragma mark --- 添加点击事件
- (void)addTargetOnView {
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [cover addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickButton {
    if (self.blockFooter) {
        self.blockFooter();
    }
}

- (void)setModelProject:(XZRongMiSchoolProjectModel *)modelProject {
    _modelProject = modelProject;
    if ([modelProject.extraDisplay intValue] == 2) { // 显示商品
        self.bgGoods.hidden = NO;
        self.bgProject.hidden = YES;
        NSString *imgUrl = [modelProject.images firstObject];
        [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-100x100"]];
        self.labelGoodsName.text = [NSString stringWithFormat:@"%@",modelProject.title];
        if ([modelProject.type isEqualToString:@"normal"]) { // 正常商品
            CGFloat product_price = [modelProject.product_price[@"price"] floatValue];
            self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",product_price];

        }else { // 是积分商品 fulljifen
           self.labelPrice.text = [NSString stringWithFormat:@"%@积分",modelProject.fulljifen_ex];
        }
    
    }else if ([modelProject.extraDisplay intValue] == 1) { // 显示最新标
        NSMutableAttributedString *(^makeUnitSmall)(NSString *) = ^(NSString *redStr) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:redStr];
            NSInteger length = [redStr length];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(length - 1, 1)];
            return attrStr;
        };
        self.bgGoods.hidden = YES;
        self.bgProject.hidden = NO;
        NSString *rate = [NSString stringWithFormat:@"%@%%",modelProject.lilv];
        self.labelRate.attributedText = makeUnitSmall(rate);
        self.labelEarnings.text = @"预期年化收益";
        self.labelProName.text = [NSString stringWithFormat:@"%@",modelProject.title];
        // @"融资金额100万·期限6个月"
        self.labelProDetail.text = [NSString stringWithFormat:@"融资金额%@·期限%@个月",modelProject.jiner,modelProject.qixian];
        // @"2016-10-12 14：00开标"
        NSString *subString = [modelProject.start_time substringWithRange:NSMakeRange(0, [modelProject.start_time length] - 3)];
        NSString *start_time = [NSString stringWithFormat:@"%@开标",subString];
        self.labelProTime.text = start_time;
        // @"2016-10-12 14：00开标"
        CGFloat width = [start_time getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 20) WithFont:[UIFont systemFontOfSize:12.0f]].width + 8;
        [self.labelProTime updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
        }];
    }else { // 不显示footer
        self.bgGoods.hidden = YES;
        self.bgProject.hidden = YES;
    }
}

@end
