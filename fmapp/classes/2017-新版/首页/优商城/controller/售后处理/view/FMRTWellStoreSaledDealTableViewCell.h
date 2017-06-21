//
//  FMRTWellStoreSaledDealTableViewCell.h
//  fmapp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTWellStoreSaledDealModel.h"

@interface FMRTWellStoreSaledDealTableViewCell : UITableViewCell

@property (nonatomic, strong)FMRTWellStoreSaledDealModel *model;

+(CGFloat )heightForCellWith:(FMRTWellStoreSaledDealModel *)model;


@end
