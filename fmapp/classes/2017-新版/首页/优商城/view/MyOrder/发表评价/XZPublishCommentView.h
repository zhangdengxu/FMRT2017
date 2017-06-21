//
//  XZPublishCommentView.h
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZTextView;
@class AXRatingView;
@class XZMyOrderGoodsModel;
typedef void(^blockCommentBtn)(UIButton *button);
typedef void(^blockRatingView)(NSString *value);
@interface XZPublishCommentView : UIView
/** 填写评价 */
@property (nonatomic, strong) XZTextView *textComment;
@property (nonatomic, copy) blockCommentBtn blockCommentBtn;
@property (nonatomic, copy) blockRatingView blockRatingView;
/** 是否匿名评价 */
@property (nonatomic, strong) UIButton *btnAnonymousComment;
/** 评价图片 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 描述相符星星 */
@property (nonatomic, strong) AXRatingView *halfStepRatingView;
/** 发货速度星星 */
@property (nonatomic, strong) AXRatingView *speedView;
/** 描述相符星星 */
@property (nonatomic, strong) AXRatingView *serviceView;
// 图片model
@property (nonatomic, strong) XZMyOrderGoodsModel * sendModel;
@end
