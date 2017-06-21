//
//  XZMultiFunctionScrollAdsCell.h
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZMultiFunctionScrollAdsCell : UICollectionViewCell
@property (nonatomic, copy) void(^blockCellButton)(UIButton *);
@property (nonatomic, copy) void(^blockJumpButton)(UIButton *);
///** 左滑手势 */
//@property (nonatomic, copy) void(^blockSwipeGestureLeft)(UISwipeGestureRecognizer *);
// "跳过"按钮
@property (nonatomic, strong) UIButton *buttonJump;
// web页的url
@property (nonatomic, strong) NSString *modelPicUrl;
//// 跑秒
//@property (nonatomic, assign) dispatch_source_t timerX;
///** 不跑秒 */
//@property (nonatomic, assign) BOOL noSeconds;

@end
