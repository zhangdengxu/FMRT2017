//
//  FMJionPrizeHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMJionPrizeHeaderViewModel;

typedef void(^jionPrizeHeaderViewButtonOnClickBlock)(NSInteger index);

@interface FMJionPrizeHeaderView : UIView
@property (nonatomic, strong) FMJionPrizeHeaderViewModel * headerModel;
@property (nonatomic,copy) jionPrizeHeaderViewButtonOnClickBlock blockHeaderView;
@property (nonatomic,copy) NSString *calenderString;
-(void)haveNoAnyDate;
-(void)haveALLdataSource;


@end


@interface FMJionPrizeHeaderViewModel : NSObject

@property (nonatomic, assign) double  awardCashAmt;
@property (nonatomic, assign) NSInteger  awardRedPacketSum;
@property (nonatomic, assign) double  awardRedPacketAmt;
@property (nonatomic, assign) NSInteger  inviteSum;

@end
