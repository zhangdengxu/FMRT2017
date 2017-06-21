//
//  FMRTMainSectionView.m
//  fmapp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTMainSectionView.h"


@interface FMRTMainSectionView ()

@property (nonatomic, weak)UILabel *titleLable, *moreLabel;
@property (nonatomic, weak)UIImageView *indicateView;

@end

@implementation FMRTMainSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UILabel *titleLable = [[UILabel alloc]init];
    self.titleLable = titleLable;
    titleLable.text = @"最新优质项目";
    titleLable.textColor = [HXColor colorWithHexString:@"#333333"];
    titleLable.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.centerY);
        make.centerX.equalTo(self.centerX);
    }];
    
    UIImageView *indicateView = [[UIImageView alloc]init];
    self.indicateView = indicateView;
    indicateView.image = [UIImage imageNamed:@"首页_项目标题箭头_1702"];
    [self addSubview:indicateView];
    [indicateView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(titleLable.right).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.height.equalTo(1);
        make.bottom.equalTo(self.bottom);
    }];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)];
    [self addGestureRecognizer:singleTap];
    
}

- (void)selectAction{
    if (self.sectionBlock) {
        self.sectionBlock();
    }
}

@end
