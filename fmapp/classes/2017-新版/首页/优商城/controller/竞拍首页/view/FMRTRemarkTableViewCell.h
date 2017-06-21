//
//  FMRTRemarkTableViewCell.h
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAucModel.h"

@interface FMRTRemarkTableViewCell : UITableViewCell

+ (CGFloat)hightForCellWith:(FMRTAucModel *)model;

@property (nonatomic, strong)FMRTAucModel *model;

@end
