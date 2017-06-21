//
//  XMSegmentMenuVc.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WJSegmentMenuVcSlideTypeCaver = 0,
    WJSegmentMenuVcSlideTypeSlide = 1,
} WJSegmentMenuVcSlideType;

@class XMSegmentMenuVc;
@protocol XMSegmentMenuVcDelegate <NSObject>

@optional

-(void)XMSegmentMenuVcDidSelectItem:(XMSegmentMenuVc *)segmentMenu withIndex:(NSInteger)index;

@end


@interface XMSegmentMenuVc : UIView
/** 字体大小 */
@property (nonatomic,strong)UIFont     *titleFont;

/** 选中字体大小 */
@property (nonatomic,strong)UIFont     *selectTitleFont;

/** 没选择时标题颜色 */
@property (nonatomic,strong)UIColor    *unlSelectedColor;

/** 选择时标题颜色 */
@property (nonatomic,strong)UIColor    *selectedColor;

/** 滑块的颜色 */
@property (nonatomic,strong)UIColor    *SlideColor;

/** 是否提前加载下一个view */
@property (nonatomic,assign)BOOL       advanceLoadNextVc;


@property (nonatomic, assign) NSInteger typeComeFrom;

/** 滑块的样式 */
@property (nonatomic,assign)WJSegmentMenuVcSlideType MenuVcSlideType;

/** 控制中button的tag赋值(防止与其他tag有冲突) */
@property (nonatomic,assign)NSInteger  MenuButtontag;
@property (nonatomic, weak) id <XMSegmentMenuVcDelegate> delegate;

/** 导入数据 */
- (void)addSubVc:(NSArray *)vc subTitles:(NSArray *)titles;

- (void)disTroyALLDate;

@end
