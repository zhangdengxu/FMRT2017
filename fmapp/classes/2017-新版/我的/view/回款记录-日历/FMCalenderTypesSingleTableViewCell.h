//
//  FMCalenderTypesSingleTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//
#define KCellFontDefault 15
#import <UIKit/UIKit.h>

@class FMRecommendDayDateModel,FMRefoundMoneyListModel;

@interface FMCalenderTypesSingleTableViewCell : UITableViewCell

@property (nonatomic, strong) FMRecommendDayDateModel * dateModel;

@property (nonatomic, strong) FMRefoundMoneyListModel * reFoundMoney;

@property (nonatomic, assign) NSInteger isReturnMoney;
@end




@interface FMRecommendDayDateModel : NSObject
@property (nonatomic,copy) NSString *lyriqi;
@property (nonatomic,copy) NSString *jiekuantitle;
@property (nonatomic,copy) NSString *lyjiner;
@property (nonatomic,copy) NSString *lyyongjinshu;
@property (nonatomic,copy) NSString *lyjie_id;


@property (nonatomic, assign) BOOL isDay;

@end


@interface FMRefoundMoneyListModel : NSObject

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *BidId;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *projId;
@property (nonatomic,copy) NSString *projName;
@property (nonatomic,copy) NSString *interest;
@property (nonatomic,copy) NSString *principal;

@property (nonatomic, assign) BOOL isDay;

@end
