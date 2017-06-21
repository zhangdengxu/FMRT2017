//
//  XMRecommendView.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMRecommendView;

@protocol XMRecommendViewDelegate <NSObject>

@optional

/**
 *  index代表类型
 *  0 代表日历
 *  1 代表本月类及佣金
 *  2 代表累计已收佣金
 */
-(void)XMRecommendViewWithView:(XMRecommendView *)recommendView withOnClickIndex:(NSInteger) index;

@end

@interface XMRecommendView : UIView

@property (nonatomic, strong) NSDictionary * dataSource;
@property (nonatomic, weak) id <XMRecommendViewDelegate> delegate;

@end
