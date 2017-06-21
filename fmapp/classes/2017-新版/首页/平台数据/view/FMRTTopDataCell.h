//
//  FMRTTopDataCell.h
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMOverViewModel;

@interface FMRTTopDataCell : UITableViewCell

@property (nonatomic, strong)FMOverViewModel *model;

+ (CGFloat)hightForTopDataCellWith:(FMOverViewModel *)model;

@end
