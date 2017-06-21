//
//  XZDiscoverHeaderView.m
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZDiscoverHeaderView.h"
#import "SDCycleScrollView.h" // 消息轮播
#import "XZDiscoverButton.h" //
#import "XZDiscoverNewModel.h" // 头部滚动条的model

@interface XZDiscoverHeaderView ()<SDCycleScrollViewDelegate>
//
@property (nonatomic, strong) SDCycleScrollView *msgCycleScroll;
//

@end

@implementation XZDiscoverHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpDiscoverHeaderView];
    }
    return self;
}

- (void)setUpDiscoverHeaderView {
    self.backgroundColor = [UIColor whiteColor];
    // 喇叭
    UIImageView *imgHorn = [[UIImageView alloc] init];
    [self addSubview:imgHorn];
    [imgHorn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@(30 * 0.5));
        make.height.equalTo(@(24 * 0.5));
    }];
    imgHorn.image = [UIImage imageNamed:@"帮助中心_公告_1702"];
    
    // 右侧箭头 15 * 24
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [self addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgHorn);
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(@(15 * 0.5));
        make.height.equalTo(@(24 * 0.5));
    }];
    imgArrow.image = [UIImage imageNamed:@"帮助中心_右箭头_1702"];
    
    //
    [self addSubview:self.msgCycleScroll];
    [self.msgCycleScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(imgArrow.mas_left).offset(-10);
//        make.width.equalTo(@(KProjectScreenWidth - (30 + 15) * 0.5 - 40));
        make.left.equalTo(imgHorn.mas_right);
        make.height.equalTo(@(30 + 24 * 0.5));
    }];
    
    // 右侧箭头
    UIButton *btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCover];
    [btnCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@50);
        make.height.equalTo(self.msgCycleScroll);
    }];
    btnCover.tag = 1001;
    [btnCover addTarget:self action:@selector(didClickCoverButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 投资者教育
    XZDiscoverButton *btnEducation = [[XZDiscoverButton alloc] init];
    [self addSubview:btnEducation];
    [btnEducation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.msgCycleScroll.mas_bottom).offset(10);
        make.width.equalTo(@(KProjectScreenWidth / 2.0));
        make.height.equalTo(@60);
    }];
    btnEducation.imageName = @"帮助中心_投资者教育_1702";
    btnEducation.title = @"投资者教育";
    btnEducation.subTitle = @"聪明投资者的选择";
    btnEducation.tagNum = 1003;
    btnEducation.isLeftButton = YES;
    [btnEducation addTarget:self action:@selector(didClickCoverButton:)];
    
    // 帮助中心
    XZDiscoverButton *btnHelpCenter = [[XZDiscoverButton alloc] init];
    [self addSubview:btnHelpCenter];
    [btnHelpCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(btnEducation);
        make.width.equalTo(btnEducation);
        make.height.equalTo(btnEducation);
    }];
    btnHelpCenter.imageName = @"帮助中心_帮助中心_1702";
    btnHelpCenter.title = @"帮助中心";
    btnHelpCenter.subTitle = @"专业全面 疑难解答";
    btnHelpCenter.tagNum = 1004;
    btnHelpCenter.isLeftButton = NO;
    [btnHelpCenter addTarget:self action:@selector(didClickCoverButton:)];
    
    // 聚一聚
    XZDiscoverButton *btnGetTogether = [[XZDiscoverButton alloc] init];
    [self addSubview:btnGetTogether];
    [btnGetTogether mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnEducation);
        make.top.equalTo(btnEducation.mas_bottom).offset(10);
        make.width.equalTo(btnEducation);
        make.height.equalTo(btnEducation);
    }];
    btnGetTogether.imageName = @"帮助中心_聚一聚_1702";
    btnGetTogether.title = @"聚一聚";
    btnGetTogether.subTitle = @"快乐生活 相聚你我";
    btnGetTogether.tagNum = 1005;
    btnGetTogether.isLeftButton = YES;
    [btnGetTogether addTarget:self action:@selector(didClickCoverButton:)];
    
    // 我要记账
    XZDiscoverButton *btnAccount = [[XZDiscoverButton alloc] init];
    [self addSubview:btnAccount];
    [btnAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnHelpCenter);
        make.top.equalTo(btnGetTogether);
        make.width.equalTo(btnEducation);
        make.height.equalTo(btnEducation);
    }];
    btnAccount.imageName = @"帮助中心_我要记账_1702";
    btnAccount.title = @"理财工具";
    btnAccount.subTitle = @"记账收益 了如指掌";
    btnAccount.tagNum = 1006;
    btnAccount.isLeftButton = NO;
    [btnAccount addTarget:self action:@selector(didClickCoverButton:)];
}

#pragma mark ----- 点击了按钮
- (void)didClickCoverButton:(UIButton *)button {
    if (self.blockCoverButton) {
        self.blockCoverButton(button);
    }
}

- (void)setArrayNew:(NSMutableArray *)arrayNew {
    _arrayNew = arrayNew;

    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (XZDiscoverNewModel *news in arrayNew) {
        [titles addObject:news.title];
    }
    self.msgCycleScroll.titlesGroup = titles;
}

#pragma mark ----- 懒加载
- (SDCycleScrollView *)msgCycleScroll {
    if (!_msgCycleScroll) {
        _msgCycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
        _msgCycleScroll.scrollDirection = UICollectionViewScrollDirectionVertical;
        _msgCycleScroll.onlyDisplayText = YES;
        _msgCycleScroll.backgroundColor = [UIColor whiteColor];
        _msgCycleScroll.titleLabelBackgroundColor = [UIColor whiteColor];
        _msgCycleScroll.titleLabelTextColor = KContentTextColor;
        _msgCycleScroll.titleLabelTextFont = [UIFont systemFontOfSize:13];
        _msgCycleScroll.autoScrollTimeInterval = 4.0;
        __weak __typeof(&*self)weakSelf = self;
        _msgCycleScroll.clickItemOperationBlock = ^(NSInteger currentIndex){
            if (weakSelf.blockClickScroll) {
                weakSelf.blockClickScroll(currentIndex);
            }
        };
    }
    return _msgCycleScroll;
}

@end
