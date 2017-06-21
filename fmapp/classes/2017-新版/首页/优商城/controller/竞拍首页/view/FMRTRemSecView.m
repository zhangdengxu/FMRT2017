//
//  FMRTRemSecView.m
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTRemSecView.h"


@interface FMRTRemSecView ()

@property (nonatomic, strong) UIImageView *remPhotoView;
@property (nonatomic, strong) UIButton *remRuleBtn;
@property (nonatomic, strong) UIButton *juMarkBtn;
@property (nonatomic, strong) UIView *toplineView;

@end

@implementation FMRTRemSecView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 3/16 + 50);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createTopView];
    }
    return self;
}

- (void)createTopView{
    
    [self.toplineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(@1);
        make.left.right.equalTo(self.contentView);
    }];

    [self.remPhotoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.equalTo(30);
    }];

    [self.remRuleBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.centerY.equalTo(self.remPhotoView.mas_centerY);
    }];
    
    [self.juMarkBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top).offset(40);
        make.height.equalTo(KProjectScreenWidth * 3 / 16);
    }];
}

- (UIView *)toplineView {
    if (!_toplineView) {
        _toplineView = ({
            UIView *toplineView = [UIView new];
            toplineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
            toplineView;
        });
        [self.contentView addSubview:_toplineView];
    }
    return _toplineView;
}

- (UIImageView *)remPhotoView{
    if (!_remPhotoView) {
        _remPhotoView = ({
             UIImageView *remPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评价区-文字_28"]];
             remPhotoView.contentMode = UIViewContentModeScaleAspectFit;
              remPhotoView;
        });
        [self.contentView addSubview:_remPhotoView];
    }
    return _remPhotoView;
}

- (UIButton *)remRuleBtn{
    if (!_remRuleBtn) {
        _remRuleBtn = ({
            UIButton *remRuleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            //    zeroRuleBtn.backgroundColor = [UIColor redColor];
            [remRuleBtn setImage:[UIImage imageNamed:@"活动规则--问号_08"] forState:(UIControlStateNormal)];
            [remRuleBtn addTarget:self action:@selector(remruleAction) forControlEvents:(UIControlEventTouchUpInside)];
            [remRuleBtn setTitle:@"评价规则" forState:(UIControlStateNormal)];
            [remRuleBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:UIControlStateNormal];
            [remRuleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
            remRuleBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            remRuleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            remRuleBtn;
        });
        [self.contentView addSubview:_remRuleBtn];

    }
    return _remRuleBtn;
}

- (UIButton *)juMarkBtn{
    if (!_juMarkBtn) {
        _juMarkBtn = ({
            UIButton *juMarkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [juMarkBtn setBackgroundImage:[UIImage imageNamed:@"竞拍-评价bannr_02"] forState:(UIControlStateNormal)];
            [juMarkBtn addTarget:self action:@selector(remAction) forControlEvents:(UIControlEventTouchUpInside)];
            juMarkBtn;
        });
        [self.contentView addSubview:_juMarkBtn];
    }
    return _juMarkBtn;
}

- (void)remruleAction{
    
    if (self.remBlcok) {
        self.remBlcok();
    }
}

- (void)remAction{
    if (self.gormBlcok) {
        self.gormBlcok();
    }
}

@end
