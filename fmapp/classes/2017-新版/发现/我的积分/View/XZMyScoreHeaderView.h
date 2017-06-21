//
//  XZMyScoreHeaderView.h
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZMyScoreHeaderView : UICollectionReusableView

@property (nonatomic, copy) void(^blockDidClickButton)(UIButton *);

/** 用户积分 */
@property (nonatomic, strong) NSString *userJifen;

@end
