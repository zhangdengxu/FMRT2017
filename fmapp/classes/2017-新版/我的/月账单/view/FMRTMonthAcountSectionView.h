//
//  FMRTMonthAcountSectionView.h
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMRTMonthDataModel;

@interface FMRTMonthAcountSectionView : UIView

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong)FMRTMonthDataModel *model;


@end
