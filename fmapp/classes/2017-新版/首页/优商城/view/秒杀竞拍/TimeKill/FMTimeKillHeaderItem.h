//
//  FMTimeKillHeaderItem.h
//  fmapp
//
//  Created by runzhiqiu on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMTimeKillHeaderItemModel;

typedef void(^timeKillHeaderItemButtonBlock)(NSInteger index);


@interface FMTimeKillHeaderItem : UIView

@property (nonatomic, strong) FMTimeKillHeaderItemModel * timeModel;
@property (nonatomic,copy) timeKillHeaderItemButtonBlock buttonBlock;

-(void)changeRedItem;
-(void)changeBlackItem;



@end


@interface FMTimeKillHeaderItemModel : NSObject

@property (nonatomic,copy) NSString *timeString;
@property (nonatomic,copy) NSString *status;
@property (nonatomic, assign) NSInteger index;

@end
