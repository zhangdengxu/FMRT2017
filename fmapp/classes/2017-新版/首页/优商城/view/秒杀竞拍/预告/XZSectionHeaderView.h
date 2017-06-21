//
//  XZSectionHeaderView.h
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZSectionHeaderView;
@class XZEarningGroupModel;
@protocol XZSectionHeaderViewDelegate <NSObject>

@optional
- (void)touchAction:(XZSectionHeaderView *)sectionView;

@end

@interface XZSectionHeaderView : UIView
@property (nonatomic, weak) id<XZSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) UILabel *labelLeft;
@property (nonatomic, strong) UILabel *labelRight;
@property (nonatomic, strong) XZEarningGroupModel *modelEarning;
@end
