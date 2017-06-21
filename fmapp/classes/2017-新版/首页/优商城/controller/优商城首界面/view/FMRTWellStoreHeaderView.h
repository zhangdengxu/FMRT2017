//
//  FMRTWellStoreHeaderView.h
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface FMRTWellStoreHeaderView : UIView

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@property (nonatomic, copy)void(^scroBlock)(NSInteger index);
@property (nonatomic, copy)void(^collectionBlock)(NSInteger index);
@property (nonatomic, copy)void(^allTakeBlcok)();
@property (nonatomic, copy)void(^killBlock)();
@property (nonatomic, copy)void(^jinfenBlock)();

@property (nonatomic, strong) NSArray *scrollArr;
@property (nonatomic, copy)   NSString *tuijian;
@property (nonatomic, copy)void(^beginBlcok)();
@property (nonatomic, copy)void(^endBlcok)();

@end
