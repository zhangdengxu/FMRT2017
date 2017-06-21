//
//  XZRongMiFamilyReusableView.h
//  fmapp
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZActivityModel;
@interface XZRongMiFamilyReusableView : UICollectionReusableView

@property (nonatomic, strong) void(^blockAlter)(UIButton *);

@property (nonatomic, strong) XZActivityModel *modelRongMi;
@end
