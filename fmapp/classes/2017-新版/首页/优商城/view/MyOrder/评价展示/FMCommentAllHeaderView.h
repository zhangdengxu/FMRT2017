//
//  FMCommentAllHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMCommentAllHeaderView;

@protocol FMCommentAllHeaderViewDelegate <NSObject>

@optional

-(void)FMCommentAllHeaderView:(FMCommentAllHeaderView *)headerView didOnClickItem:(NSInteger)index;

@end

@interface FMCommentAllHeaderView : UIView
@property (nonatomic, weak) id<FMCommentAllHeaderViewDelegate> delegate;


@property (nonatomic, strong) NSArray  * commentArray;

@end
