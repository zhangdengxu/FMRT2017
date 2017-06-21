//
//  XZAuctionNoticeCell.h
//  XZProject
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  XZAuctionNoticeModel;
@interface XZAuctionNoticeCell : UITableViewCell
@property (nonatomic, strong) XZAuctionNoticeModel *modelAuction;
/** 竞拍auction 秒杀kill */
@property (nonatomic, strong) NSString *flag;
@end
