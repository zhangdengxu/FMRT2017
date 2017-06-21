//
//  FMSelectAccountModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSelectAccountModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *title_id;

@end


@interface FMSelectAccountEnd : NSObject

@property (nonatomic, strong) FMSelectAccountModel * rangeModel;
@property (nonatomic, strong) FMSelectAccountModel * dateModel;
@property (nonatomic,copy) NSString *currentMonth;

@property (nonatomic,copy) NSString *firstTime;
@property (nonatomic,copy) NSString *endTime;

@property (nonatomic,copy) NSString *firstMoney;
@property (nonatomic,copy) NSString *endMoney;

@property (nonatomic,copy) NSString *keyString;

/**
 *  0为天，1为周，2为月，3为三个月，4为季，5为年，6为7天，7为30天 ,8为年与月,9为没变日期
 */
@property (nonatomic, assign) NSInteger grade;

@end
