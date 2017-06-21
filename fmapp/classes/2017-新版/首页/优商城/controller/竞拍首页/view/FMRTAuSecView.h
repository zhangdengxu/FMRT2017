//
//  FMRTAuSecView.h
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTAuSecView : UIView

@property (nonatomic, copy) void(^ruleBlcok)();
@property (nonatomic, copy) void(^auctionStartBlcok)();
@property (nonatomic, copy) void(^auctionEndBlcok)();
@property (nonatomic, assign) NSInteger typeCount;
@property (nonatomic, assign) NSInteger inAuctionTime;

- (void)sendDataWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime;

@end
