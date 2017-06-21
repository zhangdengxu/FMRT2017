//
//  XZDiscoverButton.m
//  fmapp
//
//  Created by admin on 17/2/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZDiscoverButton.h"

@interface XZDiscoverButton ()

@property (nonatomic, strong) UIImageView *imgLeft;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubTitle;
@property (nonatomic, strong) UIButton *btnCover;
@end

@implementation XZDiscoverButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpDiscoverButton];
    }
    return self;
}

- (void)setUpDiscoverButton {
    UIImageView *imgLeft = [[UIImageView alloc] init];
    [self addSubview:imgLeft];
//    [imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.centerY.equalTo(self);
//        make.size.equalTo(@(56 * 0.5));
//    }];
    self.imgLeft = imgLeft;
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self addSubview:labelTitle];
//    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imgLeft.mas_right).offset(15);
//        make.bottom.equalTo(self.centerY).offset(-2);
//    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *labelSubTitle = [[UILabel alloc] init];
    [self addSubview:labelSubTitle];
//    [labelSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(labelTitle);
//        make.top.equalTo(self.centerY).offset(2);
//    }];
    self.labelSubTitle = labelSubTitle;
    if (KProjectScreenWidth < 350) {
        labelSubTitle.font = [UIFont systemFontOfSize:11.0f];
    }else {
        labelSubTitle.font = [UIFont systemFontOfSize:12.0f];
    }
    // [HXColor colorWithHexString:@"#999999"]
    labelSubTitle.textColor = XZColor(143,151,162);
    
    UIButton *btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCover];
    [btnCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    btnCover.tag = 0;
    self.btnCover = btnCover;
}

- (void)addTarget:(id)idNumber action:(SEL)action {
    [self.btnCover addTarget:idNumber action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTagNum:(NSInteger)tagNum {
    _tagNum = tagNum;
    self.btnCover.tag = tagNum;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imgLeft.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.labelTitle.text = self.title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.labelSubTitle.text = self.subTitle;
}

- (void)setIsLeftButton:(BOOL)isLeftButton {
    _isLeftButton = isLeftButton;
    if (isLeftButton) {// 左边
        // 图片
        [self.imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.size.equalTo(@(56 * 0.5));
        }];
        // 标题
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgLeft.mas_right).offset(15);
            make.bottom.equalTo(self.centerY).offset(-2);
        }];
        // 副标题
        [self.labelSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelTitle);
            make.top.equalTo(self.centerY).offset(2);
        }];

    }else { // 右边
        // 副标题
        [self.labelSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.centerY).offset(2);
        }];
        
        // 标题
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelSubTitle);
            make.bottom.equalTo(self.centerY).offset(-2);
        }];
        
        // 图片
        [self.imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.labelSubTitle.mas_left).offset(-15);
            make.centerY.equalTo(self);
            make.size.equalTo(@(56 * 0.5));
        }];
        
    }
}
@end
