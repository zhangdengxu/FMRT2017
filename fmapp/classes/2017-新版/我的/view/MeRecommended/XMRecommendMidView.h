//
//  XMRecommendMidView.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMRecommendMidView;

@protocol XMRecommendMidViewDelegate <NSObject>

@optional

-(void)XMRecommendMidViewWithView:(XMRecommendMidView *)midView withDidSelectOnClick:(NSInteger)index;

@end

@interface XMRecommendMidView : UIView

/**
 *  创建view并设置类型
 */
-(instancetype)initWithMidViewWithCount:(NSInteger)count;

@property (nonatomic, strong) NSDictionary * dataSource;
@property (nonatomic, weak) id <XMRecommendMidViewDelegate> delegate;

@end
