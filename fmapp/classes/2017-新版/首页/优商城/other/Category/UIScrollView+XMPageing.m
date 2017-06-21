//
//  UIScrollView+XMPageing.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//
#import "MJRefresh.h"
#import "UIScrollView+XMPageing.h"
static const float kAnimationDuration = 0.50f;

static const char xm_originContentHeight;
static const char xm_secondScrollView;

@interface UIScrollView ()

@property (nonatomic, assign) float originContentHeight;

@end


@implementation UIScrollView (XMPageing)


- (void)setOriginContentHeight:(float)originContentHeight {
    objc_setAssociatedObject(self, &xm_originContentHeight, @(originContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)originContentHeight {
    return [objc_getAssociatedObject(self, &xm_originContentHeight) floatValue];
}


- (void)setFirstScrollView:(UIScrollView *)firstScrollView {
    [self addFirstScrollViewFooter];
}

- (UIScrollView *)secondScrollView {
    return objc_getAssociatedObject(self, &xm_secondScrollView);
}

- (void)setSecondScrollView:(UIScrollView *)secondScrollView {
    objc_setAssociatedObject(self, &xm_secondScrollView, secondScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addFirstScrollViewFooter];
    
    CGRect frame = self.bounds;
    frame.origin.y = self.contentSize.height + self.mj_footer.frame.size.height;
    secondScrollView.frame = frame;
    
    [self addSubview:secondScrollView];
    
//    [self addSecondScrollViewHeader];
}

- (void)addFirstScrollViewFooter {
    __weak __typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf endFooterRefreshing];
    }];
    footer.triggerAutomaticallyRefreshPercent = 1;
    [footer setTitle:@"继续拖动,查看图文详情" forState:MJRefreshStateIdle];
    
    self.mj_footer = footer;
}

- (void)addSecondScrollViewHeader {
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf endHeaderRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉,返回宝贝详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放,返回宝贝详情" forState:MJRefreshStatePulling];
    
    self.secondScrollView.mj_header = header;
}

- (void)endFooterRefreshing {
    [self.mj_footer endRefreshing];
    self.mj_footer.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.mj_header.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect rect = self.frame;
        self.frame = CGRectMake(0, 20, rect.size.width, rect.size.height);
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height - self.mj_footer.frame.size.height, 0, 0, 0);
    }];
    
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
}

- (void)endHeaderRefreshing {
    [self.secondScrollView.mj_header endRefreshing];
    self.secondScrollView.mj_header.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect rect = self.frame;
        self.frame = CGRectMake(0, 20, rect.size.width, rect.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, self.mj_footer.frame.size.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
    
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self addFirstScrollViewFooter];
}




@end
