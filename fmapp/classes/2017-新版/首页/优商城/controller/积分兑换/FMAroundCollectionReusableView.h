//
//  FMAroundCollectionReusableView.h
//  fmapp
//
//  Created by runzhiqiu on 2016/12/16.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^contractsdcycleOnClickBlock)(NSInteger index);

@interface FMAroundCollectionReusableView : UICollectionReusableView


@property (nonatomic, strong) NSArray * slidesArray;
@property (nonatomic, copy) contractsdcycleOnClickBlock cycleIndex;

@end
