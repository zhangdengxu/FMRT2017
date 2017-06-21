//
//  FMRTProductCollectionViewCell.h
//  fmapp
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAucModel.h"

@interface FMRTProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^PBlock)(UIButton *sender,NSInteger type,NSString *auctionId ,NSString *productId,NSInteger endCount);
@property (nonatomic, copy) void(^RBlock)(NSString *auctionId);

@property (nonatomic, strong) FMRTAucFirstModel *model;

@end
