//
//  WLInfoTableViewCell.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLInfoModel.h"
@interface WLInfoTableViewCell : UITableViewCell
@property(nonatomic,strong)WLInfoModel *model;
+(CGFloat)hightForCell;

+ (instancetype)cellLingQianHasSaved:(UITableView *)tableView;

@end
