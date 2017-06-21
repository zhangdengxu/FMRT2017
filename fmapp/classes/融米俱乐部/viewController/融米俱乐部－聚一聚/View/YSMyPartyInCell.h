//
//  YSMyPartyInCell.h
//  fmapp
//
//  Created by yushibo on 16/7/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMyPartyModel.h"
typedef void(^blockBtn)(UIButton *);
@interface YSMyPartyInCell : UITableViewCell

/**
 *  模型数据
 */
@property (nonatomic, strong)YSMyPartyModel *dataSource;
@property (nonatomic, copy) blockBtn blockBtn;
@end
