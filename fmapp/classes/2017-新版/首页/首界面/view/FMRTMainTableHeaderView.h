//
//  FMRTMainTableHeaderView.h
//  fmapp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMIndexHeaderModel.h"
#import "SDCycleScrollView.h"

@interface FMRTMainTableHeaderView : UIView

@property (nonatomic, copy)void(^scroBlock)(NSInteger index);
@property (nonatomic, copy)void(^topFourBlock)(NSInteger tag);
@property (nonatomic, copy)void(^bbBlock)();

@property (nonatomic, strong) NSArray *scroArr;
@property (nonatomic, assign) NSInteger loginState;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, copy)void(^beginBlcok)();
@property (nonatomic, copy)void(^endBlcok)();

@end
