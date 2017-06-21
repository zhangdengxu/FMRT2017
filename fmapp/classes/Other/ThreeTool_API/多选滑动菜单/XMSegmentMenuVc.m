//
//  XMSegmentMenuVc.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#define WJSegmentMenuVcDefaultSpace             20
#define WJSegmentMenuVcDefaulTag                960
#define WJSegmentMenuVcDefaulButtonW            80
#define WJSegmentMenuVcDefaultButtonFont        [UIFont systemFontOfSize:16]
#define WJSegmentMenuVcDefaultUnselectedColor   [UIColor grayColor]
#define WJSegmentMenuVcDefaultSelectedColor     [UIColor blackColor]
#define WJSegmentMenuVcDefaultSlideColor        [UIColor colorWithRed:(183/255.0) green:(57/255.0) blue:(0/255.0) alpha:1]

#import "XMSegmentMenuVc.h"

@interface XMSegmentMenuVc ()<UIScrollViewDelegate>
@property (nonatomic,weak)   UIView         *view;
@property (nonatomic,weak)   UIScrollView   *contentScrollView;
@property (nonatomic,strong) NSMutableArray *vcArray;
@property (nonatomic, strong) NSMutableArray  * oldArrayCtr;
@property (nonatomic,strong) NSMutableArray *titlesArray;
@property (nonatomic,weak)   UIScrollView   *titleScrollView;


@property (nonatomic,assign) NSInteger      lastSelected;


@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation XMSegmentMenuVc

- (void)disTroyALLDate;
{
    [self.vcArray removeAllObjects];
    self.vcArray = nil;
    [self.oldArrayCtr removeAllObjects];
    self.oldArrayCtr = nil;
    
    [self.titlesArray  removeAllObjects];
    self.titlesArray = nil;
    _delegate = nil;
    self.contentScrollView.delegate = nil;
}

// 导入数据
- (void)addSubVc:(NSArray *)vc subTitles:(NSArray *)titles{
    self.lastSelected = -1;
    self.vcArray = [[NSMutableArray alloc]init];
    [self.vcArray addObjectsFromArray:vc];
    self.oldArrayCtr = [[NSMutableArray alloc]init];
    [self.oldArrayCtr addObjectsFromArray:vc];
    
    self.titlesArray = [NSMutableArray array];
    [self.titlesArray addObjectsFromArray:titles];
    [self initContentScrollview];
    [self initScrollviewWithTitles:titles];
}

// 初始化ContentScrollview
- (void)initContentScrollview{
    CGRect rect;
    CGSize size;
    rect = CGRectMake(0, CGRectGetMaxY(self.frame), self.superview.frame.size.width, KProjectScreenHeight - 49 - 20 - 40 - 49);
    
    size = CGSizeMake(self.superview.frame.size.width * self.vcArray.count,   KProjectScreenHeight - 49 - 20 - 40 - 49);
    if (self.typeComeFrom == 1) {
         rect = CGRectMake(0, CGRectGetMaxY(self.frame), self.superview.frame.size.width, KProjectScreenHeight - 49 - 20 - 40);
        size = CGSizeMake(self.superview.frame.size.width * self.vcArray.count,   KProjectScreenHeight - 49 - 20 - 40);
    }else if (self.typeComeFrom == 3)
    {
        rect = CGRectMake(0, CGRectGetMaxY(self.frame), self.superview.frame.size.width, KProjectScreenHeight - 20 - 40 - 49);
        size = CGSizeMake(self.superview.frame.size.width * self.vcArray.count,  KProjectScreenHeight - 20 - 40 - 49);
    }
    
    UIScrollView *scrollViewContent = [[UIScrollView alloc]initWithFrame:rect];
    scrollViewContent.delegate = self;
    scrollViewContent.bounces = NO;
    scrollViewContent.contentSize = size;
    
    scrollViewContent.showsHorizontalScrollIndicator = NO;
    scrollViewContent.showsVerticalScrollIndicator = NO;
    scrollViewContent.pagingEnabled = YES;
    [self.superview addSubview:scrollViewContent];
    self.contentScrollView = scrollViewContent;
}

// 初始化titleScrollView
- (void)initScrollviewWithTitles:(NSArray *)titles{
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:scrollView];
    self.titleScrollView = scrollView;
    
    
    CGFloat buttonWidth = KProjectScreenWidth / self.vcArray.count;
    for (int i = 0; i < titles.count; i ++) {

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(buttonWidth * i, 0 , buttonWidth - 0.5, self.bounds.size.height - 3)];
  
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        
        UIColor *color = self.unlSelectedColor ? self.unlSelectedColor : WJSegmentMenuVcDefaultUnselectedColor;
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.titleLabel.font = self.titleFont ? self.titleFont : WJSegmentMenuVcDefaultButtonFont;
        NSInteger tag = self.MenuButtontag ? self.MenuButtontag : WJSegmentMenuVcDefaulTag;
        btn.tag = tag + i;
        [btn addTarget:self action:@selector(segmentMenuTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addChildViewController:self.vcArray[i] title:titles[i]];
        
        UIColor *slideColor = self.SlideColor ? self.SlideColor : WJSegmentMenuVcDefaultSlideColor;
        
        if (i == 0) {
            if (self.MenuVcSlideType == WJSegmentMenuVcSlideTypeCaver) {
                UIView *view = [[UIView alloc]initWithFrame:btn.frame];
                view.backgroundColor = slideColor;
                view.layer.cornerRadius = 10;
                view.layer.masksToBounds = YES;
                [scrollView addSubview:view];
                self.view = view;
            }
            if (self.MenuVcSlideType == WJSegmentMenuVcSlideTypeSlide) {
                CGRect TempFrame = btn.frame;
                TempFrame.size.height = 3;
                TempFrame.origin.y = CGRectGetMaxY(btn.frame);
                UIView *view = [[UIView alloc]initWithFrame:TempFrame];
                view.backgroundColor = slideColor;
                
                view.layer.masksToBounds = YES;
                [scrollView addSubview:view];
                self.view = view;
            }
            
            [self addChildView:i];
        }
        if (i == 1 && self.advanceLoadNextVc) {
            [self addChildView:i];
        }
        [scrollView addSubview:btn];
        if (i == 0) {
            [self changeBtnTitleColorWithTag:i];
        }
        if (i != (titles.count - 1)) {
            UIView * midViewLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 8, 0.5, (self.frame.size.height - 8 * 2))];
            midViewLine.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:1];
            [scrollView addSubview:midViewLine];
                                                                                                             
        }
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}

// 视图控制器
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

// 添加子子控制器
-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle{
    UIViewController *superVC = [self findViewController:self];
    childVC.title = vcTitle;
    [superVC addChildViewController:childVC];
}

// 添加子控制器视图
- (void)addChildView:(NSInteger)index
{
    UIViewController *superVC = [self findViewController:self];
    UIViewController *vc = superVC.childViewControllers[index];
    CGRect frame = self.contentScrollView.bounds;
    frame.origin.x = self.superview.frame.size.width * index;
    vc.view.frame = frame;
    [self.contentScrollView addSubview:vc.view];
    
    
    
}

// 按钮点击事件
- (void)segmentMenuTitleClick:(UIButton *)btn{
    NSInteger tag = self.MenuButtontag ? self.MenuButtontag : WJSegmentMenuVcDefaulTag;
    [self changeBtnTitleColorWithTag:btn.tag-tag];
    [self buttonMoveWithIndex:btn.tag - tag];
    [self addChildView:btn.tag - tag];
    if ([self.delegate respondsToSelector:@selector(XMSegmentMenuVcDidSelectItem:withIndex:)]) {
        [self.delegate XMSegmentMenuVcDidSelectItem:self withIndex:(btn.tag - tag)];
    }
    self.contentScrollView.contentOffset = CGPointMake(self.superview.frame.size.width * (btn.tag - tag), 0);
    
       
}

// 改变菜单按钮字体颜色
- (void)changeBtnTitleColorWithTag:(NSInteger)tag{
    UIColor *color = self.unlSelectedColor ? self.unlSelectedColor : WJSegmentMenuVcDefaultUnselectedColor;
    UIColor *selectedColor = self.selectedColor ? self.selectedColor : WJSegmentMenuVcDefaultSelectedColor;
    NSInteger Temptag = self.MenuButtontag ? self.MenuButtontag : WJSegmentMenuVcDefaulTag;
    
    if (self.lastSelected >= 0) {
        UIButton *lastBtn = (UIButton *)[self viewWithTag:self.lastSelected + Temptag];
        [lastBtn.titleLabel setFont:self.titleFont];
        [lastBtn setTitleColor:color forState:UIControlStateNormal];
        
    }
    UIButton *btn = (UIButton *)[self viewWithTag:tag + Temptag];
    [btn setTitleColor:selectedColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:self.selectTitleFont];
    
    self.lastSelected = tag;
}

// scrollView滚动监听
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i  = self.contentScrollView.contentOffset.x / self.superview.frame.size.width;
    [self changeBtnTitleColorWithTag:i];
    [self addChildView:i];
    [self buttonMoveWithIndex:i];
    if ([self.delegate respondsToSelector:@selector(XMSegmentMenuVcDidSelectItem:withIndex:)]) {
        [self.delegate XMSegmentMenuVcDidSelectItem:self withIndex:i];
    }
    if (i < self.vcArray.count - 1 && self.advanceLoadNextVc) {
        [self addChildView:i+1];
    }
    
}

// 滑块移动动画
- (void)buttonMoveWithIndex:(NSInteger)clickIndex
{
    
    CGFloat width = self.frame.size.width / self.vcArray.count;
    CGFloat origin_x = clickIndex * width;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect tempFrame = self.view.frame;
        self.view.frame = CGRectMake(origin_x, tempFrame.origin.y,width, tempFrame.size.height);
    }];
    
}








@end
