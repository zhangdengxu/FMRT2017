//
//  WLJYJTableViewCell.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/7/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZBankListModel;
@interface WLJYJTableViewCell : UITableViewCell

@property (nonatomic, strong) XZBankListModel *bankModel;
@property (nonatomic, assign) BOOL isAddCard;

@end
