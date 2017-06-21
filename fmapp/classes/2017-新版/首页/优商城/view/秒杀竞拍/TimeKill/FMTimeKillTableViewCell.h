//
//  FMTimeKillTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTimeKillShopModel;
typedef void(^timeKillButtonItemOnClickBlock)(FMTimeKillShopModel * shopModel);


@interface FMTimeKillTableViewCell : UITableViewCell


@property (nonatomic, strong) FMTimeKillShopModel * model;

@property (nonatomic,copy) timeKillButtonItemOnClickBlock timeKillButton;

@end
