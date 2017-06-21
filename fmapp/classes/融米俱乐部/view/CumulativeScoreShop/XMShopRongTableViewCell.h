//
//  XMShopRongTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMScoreShopModel;
@class XMShopRongTableViewCell;

@protocol XMShopRongTableViewCellDelegate <NSObject>

@optional

-(void)XMShopRongTableViewCellDidOnClickItem:(XMShopRongTableViewCell *)shopRong withInfo:(XMScoreShopModel *)dataSource;

@end

@interface XMShopRongTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) CGFloat sizeCellHeigh;

@property (nonatomic,assign)id <XMShopRongTableViewCellDelegate> delegate;


+(instancetype)XMShopRongTableView:(UITableView *)tableView;
@end
