//
//  FMRTRebackMoneyCell.h
//  fmapp
//
//  Created by apple on 2017/5/31.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMRTRebackMoneyModel;

@interface FMRTRebackMoneyCell : UITableViewCell

@property (nonatomic, copy)void(^bankBlcok) ();

@property (nonatomic, copy)void(^sureBlcok) (NSInteger txType,NSString* money);

@property (nonatomic, strong)FMRTRebackMoneyModel *model;

@property (nonatomic, copy)NSString *bankName;
@property (nonatomic, assign)NSInteger txtType;

//+(CGFloat)heightForCellRowWith:(FMRTRebackMoneyModel *)model;

@property (nonatomic, copy)void(^timeBlcok) (NSInteger type);
@property (nonatomic, copy)void(^bigBlcok) (NSInteger type);

@end
