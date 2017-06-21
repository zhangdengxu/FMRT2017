//
//  FMRTComDataShowCell.h
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMRTPlatformModel.h"
@interface FMRTComDataShowCell : UITableViewCell

@property (nonatomic, strong)Ent *model;

+(CGFloat)heightForCellWithModel:(Ent *)model;

@end
