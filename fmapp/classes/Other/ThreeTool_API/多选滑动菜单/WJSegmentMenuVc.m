//
//  WJSegmentMenuVc.m
//  WJSegmentMeunVc
//
//  Created by 吴计强 on 16/4/5.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//


#define WJSegmentMenuVcDefaultSpace             20
#define WJSegmentMenuVcDefaulTag                960
#define WJSegmentMenuVcDefaulButtonW            80
#define WJSegmentMenuVcDefaultButtonFont        [UIFont systemFontOfSize:16]
#define WJSegmentMenuVcDefaultUnselectedColor   [UIColor grayColor]
#define WJSegmentMenuVcDefaultSelectedColor     [UIColor blackColor]
#define WJSegmentMenuVcDefaultSlideColor        [UIColor colorWithRed:(183/255.0) green:(57/255.0) blue:(0/255.0) alpha:1]

#import "WJSegmentMenuVc.h"

@interface WJSegmentMenuVc ()<UIScrollViewDelegate>

@property (nonatomic,weak)   UIView         *view;
@property (nonatomic,weak)   UIScrollView   *contentScrollView;
@property (nonatomic,strong) NSMutableArray *vcArray;
@property (nonatomic, strong) NSMutableArray  * oldArrayCtr;
@property (nonatomic,strong) NSMutableArray *titlesArray;
@property (nonatomic,weak)   UIScrollView   *titleScrollView;


@property (nonatomic,assign) NSInteger      lastSelected;

@property (nonatomic, strong) NSArray * titleFrameArray;

@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation WJSegmentMenuVc

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
    
    UIScrollView *scrollViewContent = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), self.superview.frame.size.width, KProjectScreenHeight - 64 - 40)];
    scrollViewContent.delegate = self;
    scrollViewContent.bounces = NO;
    
    scrollViewContent.contentSize = CGSizeMake(self.superview.frame.size.width * self.vcArray.count,   KProjectScreenHeight - 64 - 40 );
    scrollViewContent.showsHorizontalScrollIndicator = NO;
    scrollViewContent.showsVerticalScrollIndicator = NO;
    scrollViewContent.pagingEnabled = YES;
    [self.superview addSubview:scrollViewContent];
    self.contentScrollView = scrollViewContent;
}

-(NSMutableArray *)getTitleFrameInfo:(NSArray *)titles
{
    NSMutableArray * muarray = [NSMutableArray array];
    for (NSString * title in titles) {
        CGSize size =[title getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - WJSegmentMenuVcDefaultSpace * 2) WithFont:self.selectTitleFont];
        NSValue * value = [NSValue valueWithCGSize:size];
        [muarray addObject:value];
    }
    return muarray;
}

// 初始化titleScrollView
- (void)initScrollviewWithTitles:(NSArray *)titles{
    
    self.titleFrameArray = [self getTitleFrameInfo:titles];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.titleScrollView = scrollView;
    
    CGFloat first_x = WJSegmentMenuVcDefaultSpace;
    for (int i = 0; i < self.titleFrameArray.count; i ++) {
        NSValue * itemValue = self.titleFrameArray[i];
        CGSize  itemSize = [itemValue CGSizeValue];
        
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(first_x, (self.frame.size.height - itemSize.height) * 0.5 , itemSize.width, itemSize.height + 2)];
        
        first_x = first_x + itemSize.width + WJSegmentMenuVcDefaultSpace + WJSegmentMenuVcDefaultSpace;
        
        
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
                TempFrame.origin.y = self.frame.size.height - 3;
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
    }
    scrollView.contentSize = CGSizeMake(first_x - WJSegmentMenuVcDefaultSpace, self.frame.size.height);
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
    [self viewFrameAutoWith:self.view.frame WithIndex:btn.tag - tag];
    [self addChildView:btn.tag - tag];
    self.contentScrollView.contentOffset = CGPointMake(self.superview.frame.size.width * (btn.tag - tag), 0);
    
    if ([self.delegate respondsToSelector:@selector(WJSegmentMenuVcChange:withController:)]) {
        [self.delegate WJSegmentMenuVcChange:self withController:self.oldArrayCtr[btn.tag - tag]];
    }
    
}

// titleScrollView frame自适应
- (void)viewFrameAutoWith:(CGRect)frame WithIndex:(NSInteger)index
{
    if (index == 0) {
        [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(index == (self.titleFrameArray.count - 1))
    {
        [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentSize.width - KProjectScreenWidth, 0) animated:YES];
    }else
    {
        NSValue * itemLastValue = self.titleFrameArray[index - 1];
        CGSize  itemLastSize = [itemLastValue CGSizeValue];
        
        NSValue * itemNextValue = self.titleFrameArray[index + 1];
        CGSize  itemNextSize = [itemNextValue CGSizeValue];
        
        CGFloat MaxX = CGRectGetMaxX(frame) + WJSegmentMenuVcDefaultSpace * 3 + itemNextSize.width;
        CGFloat MinX = CGRectGetMinX(frame) - WJSegmentMenuVcDefaultSpace * 3 - itemLastSize.width;
        if (self.lastIndex < index) {
            //向后
            if (MaxX > (self.titleScrollView.contentOffset.x + KProjectScreenWidth))
            {
                if ((self.titleScrollView.contentSize.width - (frame.origin.x - WJSegmentMenuVcDefaultSpace)) < KProjectScreenWidth) {
                    [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentSize.width - KProjectScreenWidth, 0) animated:YES];
                }else{
                    [self.titleScrollView setContentOffset:CGPointMake(frame.origin.x - WJSegmentMenuVcDefaultSpace, 0) animated:YES];
                }
            }
        }else
        {
            //向前
            if (MinX < self.titleScrollView.contentOffset.x) {
                if ((CGRectGetMaxX(frame) + WJSegmentMenuVcDefaultSpace - KProjectScreenWidth) < 0) {
                    [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }else{
                    [self.titleScrollView setContentOffset:CGPointMake(CGRectGetMaxX(frame) + WJSegmentMenuVcDefaultSpace - KProjectScreenWidth, 0) animated:YES];
                }
            }
        }
    }
    self.lastIndex = index;
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
    if ([self.delegate respondsToSelector:@selector(WJSegmentMenuVcChange:withController:)]) {
        [self.delegate WJSegmentMenuVcChange:self withController:self.oldArrayCtr[i]];
    }
    
    [self viewFrameAutoWith:self.view.frame WithIndex:i];
    if (i < self.vcArray.count - 1 && self.advanceLoadNextVc) {
        [self addChildView:i+1];
    }
    
}


- (void)selectItemTitle:(NSInteger )index;
{
    
    [self changeBtnTitleColorWithTag:index];
    [self addChildView:index];
    [self buttonMoveWithIndex:index];
    self.contentScrollView.contentOffset = CGPointMake(self.superview.frame.size.width * (index), 0);
    if ([self.delegate respondsToSelector:@selector(WJSegmentMenuVcChange:withController:)]) {
        [self.delegate WJSegmentMenuVcChange:self withController:self.oldArrayCtr[index]];
    }
    
    [self viewFrameAutoWith:self.view.frame WithIndex:index];
    if (index < self.vcArray.count - 1 && self.advanceLoadNextVc) {
        [self addChildView:index+1];
    }
}

// 滑块移动动画
- (void)buttonMoveWithIndex:(NSInteger)clickIndex
{
    
    CGFloat origin_x = WJSegmentMenuVcDefaultSpace;
    for (NSInteger i = 0; i < clickIndex; i ++) {
        NSValue * itemValue = self.titleFrameArray[i];
        CGSize  itemSize = [itemValue CGSizeValue];
        origin_x = origin_x + itemSize.width + WJSegmentMenuVcDefaultSpace + WJSegmentMenuVcDefaultSpace;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        NSValue * itemValue = self.titleFrameArray[clickIndex];
        CGSize  itemSize = [itemValue CGSizeValue];
        CGRect tempFrame = self.view.frame;
        self.view.frame = CGRectMake(origin_x, tempFrame.origin.y, itemSize.width, tempFrame.size.height);
    }];
    
}

@end
