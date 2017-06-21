//
//  XZRongMiSchoolCell.h
//  fmapp
//
//  Created by admin on 17/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRongMiSchoolModel;
@interface XZRongMiSchoolCell : UITableViewCell

@property (nonatomic, copy) void(^blockRongMiSchool)(UIButton *);

@property (nonatomic, strong)  XZRongMiSchoolModel *modelRongMi;

@end
