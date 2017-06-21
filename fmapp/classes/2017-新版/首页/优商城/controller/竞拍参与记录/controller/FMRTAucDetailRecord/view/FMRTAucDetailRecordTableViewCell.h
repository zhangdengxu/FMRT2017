//
//  FMRTAucDetailRecordTableViewCell.h
//  fmapp
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAucDetailRecordModel.h"

@interface FMRTAucDetailRecordTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^recordBlcok)(NSString *auctionId);

@property (nonatomic, copy) void(^addPriceBlcok)(NSString *auctionId,NSString *proId);

@property (nonatomic, strong) FMRTAucDetailRecordModel *model;

@end
