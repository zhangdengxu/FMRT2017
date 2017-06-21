//
//  YYMyOrderNewCell.h
//  fmapp
//
//  Created by yushibo on 2016/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMyOrderNewModel.h"
@interface YYMyOrderNewCell : UITableViewCell
@property (nonatomic, copy) void(^shareBlockBtn)();
@property (nonatomic, copy) void(^wuliuBlockBtn)();
@property (nonatomic, copy) void(^payBlockBtn)();
@property (nonatomic, copy) YYMyOrderNewModel *status;
@end
