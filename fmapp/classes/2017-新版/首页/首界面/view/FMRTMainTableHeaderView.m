//
//  FMRTMainTableHeaderView.m
//  fmapp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTMainTableHeaderView.h"
#import "FMRTCenterFourView.h"


@interface FMRTMainTableHeaderView ()

@property (nonatomic, weak)   FMRTCenterFourView *fourView;

@end
@implementation FMRTMainTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = ({
            
            SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@"美读时光headerBack_02"]];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.showPageControl = NO;
            scrollView.autoScrollTimeInterval = 5.0;
            scrollView.autoScroll = YES;
            FMWeakSelf;
            scrollView.clickItemOperationBlock = ^(NSInteger currentIndex){
                if (weakSelf.scroBlock) {
                    weakSelf.scroBlock(currentIndex);
                }
            };
            
            scrollView.begingBlock = ^(){
                if (weakSelf.beginBlcok) {
                    weakSelf.beginBlcok();
                }
            };
            
            scrollView.endBlock = ^(){
                if (weakSelf.endBlcok) {
                    weakSelf.endBlcok();
                }
            };
            scrollView;
        });
    }
    return _scrollView;
}


- (void)createContentView{
    
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth * 376/640);
    }];

    FMWeakSelf;
    FMRTCenterFourView *fourView = [[FMRTCenterFourView alloc]init];
    self.fourView = fourView;
    fourView.fourBlock = ^(NSInteger tag){
        if (weakSelf.topFourBlock) {
            weakSelf.topFourBlock(tag);
        }
    };
    [self addSubview:fourView];
    [fourView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.scrollView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth/4);
    }];
    
    UIButton *bbBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [bbBtn addTarget:self action:@selector(bbAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bbBtn setBackgroundImage:[UIImage imageNamed:@"首页_宝贝计划_1702"] forState:(UIControlStateNormal)];
    [self addSubview:bbBtn];
    [bbBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(fourView.bottom);
        make.right.equalTo(self.right);
        make.left.equalTo(self.left);
        make.height.equalTo(KProjectScreenWidth *132/640);
    }];
}

- (void)bbAction{
    if (self.bbBlock) {
        self.bbBlock();
    }
}

- (void)setScroArr:(NSArray *)scroArr{
    _scroArr = scroArr;
    NSMutableArray *picArr = [NSMutableArray array];

    for (FMIndexHeaderModel *model in scroArr) {

        [picArr addObject:model.pic];
    }
    self.scrollView.imageURLStringsGroup = picArr;
}

@end

