//
//  FMCalenderTypesALLTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMMonthDateModel,FMMonthDateReFoundMoneyModel;
typedef enum {
    FMCalenderTypesALLTableViewCellTypeMonth=0,//月
    FMCalenderTypesALLTableViewCellTypeNoneDate,//日，无数据
    FMCalenderTypesALLTableViewCellTypeHaveDate, //日，有数据
} FMCalenderTypesALLTableViewCellType;

@interface FMCalenderTypesALLTableViewCell : UITableViewCell


@property (nonatomic, assign) FMCalenderTypesALLTableViewCellType type;

@property (nonatomic, strong) FMMonthDateModel * dateModel;
@property (nonatomic, strong) FMMonthDateReFoundMoneyModel * reFoundMoney;

@property (nonatomic, assign) NSInteger isRecommendType;

@end

@interface FMMonthDateModel : NSObject
@property (nonatomic,copy) NSString *maturas;
@property (nonatomic,copy) NSString *commispabl;


@property (nonatomic, assign) BOOL isDay;

@end


@interface FMMonthDateReFoundMoneyModel : NSObject
@property (nonatomic,copy) NSString *outerTotalAmt;
@property (nonatomic,copy) NSString *insideTotalAmt;

@property (nonatomic, assign) BOOL isDay;

@end

