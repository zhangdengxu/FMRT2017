//
//  YSMyPartyViewCell.h
//  fmapp
//
//  Created by yushibo on 16/7/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMyPartyModel.h"
@interface YSMyPartyViewCell : UITableViewCell

/**
 *  模型数据
 */
@property (nonatomic, strong)YSMyPartyModel *dataSource;
@end
