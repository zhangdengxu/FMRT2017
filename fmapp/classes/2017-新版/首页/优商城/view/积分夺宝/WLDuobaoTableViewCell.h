//
//  WLDuobaoTableViewCell.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZBaskOrderModel;
@class WLAllPelpleModel;
@interface WLDuobaoTableViewCell : UITableViewCell
@property (nonatomic, strong) XZBaskOrderModel *modelBaskOrder;
@property (nonatomic, strong) WLAllPelpleModel *model;
@end
