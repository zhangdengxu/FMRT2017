//
//  FMRTWellStoreProductFooterView.h
//  fmapp
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTWellStoreProductFooterView : UICollectionReusableView

@property (nonatomic, copy) void(^block)();
@property (nonatomic, assign) NSInteger hasmore;

@end
