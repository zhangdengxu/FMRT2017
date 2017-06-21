//
//  YYinstructionsCell.h
//  fmapp
//
//  Created by yushibo on 2016/12/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInstructionsModel.h"
@interface YYinstructionsCell : UITableViewCell
@property (nonatomic, strong)YYInstructionsModel *status;

+(CGFloat )heightForCellWith:(YYInstructionsModel *)model;

@end
