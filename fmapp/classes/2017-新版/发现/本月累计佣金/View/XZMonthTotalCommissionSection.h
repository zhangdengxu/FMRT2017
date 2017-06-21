//
//  XZMonthTotalCommissionSection.h
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XZMonthTotalCommissionSection;
@class XZEarningGroupModel;

@protocol XZSectionHeaderViewDelegate <NSObject>

@optional
- (void)touchAction:(XZMonthTotalCommissionSection *)sectionView;

@end

@interface XZMonthTotalCommissionSection : UIView

@property (nonatomic, weak) id<XZSectionHeaderViewDelegate> delegate;

@property (nonatomic, strong) XZEarningGroupModel *modelEarning;

@end
