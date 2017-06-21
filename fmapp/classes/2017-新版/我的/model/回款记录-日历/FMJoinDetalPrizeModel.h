//
//  FMJoinDetalPrizeModel.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMJoinDetalPrizeModel : NSObject


@property (nonatomic,assign) NSInteger awardType;
@property (nonatomic,assign) NSInteger awardTrench;
@property (nonatomic,copy) NSString *awardTime;
@property (nonatomic,assign) double awardMoney;
@property (nonatomic,assign) double inviteeBidMoney;

@property (nonatomic,assign) NSInteger projDuration;

@end

