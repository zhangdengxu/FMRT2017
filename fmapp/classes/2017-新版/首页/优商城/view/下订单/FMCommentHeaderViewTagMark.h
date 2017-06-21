//
//  FMCommentHeaderViewTagMark.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMCommentHeaderViewTagMark;

@protocol FMCommentHeaderViewTagMarkDelegate <NSObject>

@optional

-(void)FMCommentHeaderViewTagMark:(FMCommentHeaderViewTagMark *)headerView didSelectItem:(NSInteger)index;

@end

@interface FMCommentHeaderViewTagMark : UIView
@property (nonatomic, weak) id<FMCommentHeaderViewTagMarkDelegate> delegate;

/**
 *  标签文本赋值
 */
-(void)setTagMarkWithTagArray:(NSArray*)arr;

@end
