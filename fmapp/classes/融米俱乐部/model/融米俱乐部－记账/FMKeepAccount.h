//
//  FMKeepAccount.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  我要记账－查询条件Model
 */
@interface FMKeepAccountSelectModel : NSObject

@property (nonatomic,copy) NSString *selectRange;

@property (nonatomic,copy) NSString *leftBottomMoney;
@property (nonatomic,copy) NSString *rightBottomMoney;

@end

/**
 *  我要记账－明细－头部Model
 */
@interface FMKeepAccountDetailHeaderModel : NSObject

@property (nonatomic,copy) NSString *dataTime;

@property (nonatomic,copy) NSString *leftBottomMoney;
@property (nonatomic,copy) NSString *rightBottomMoney;

@end

/**
 *  我要记账－明细－cell － Model
 */
@interface FMKeepAccountDetailCellModel : NSObject

@property (nonatomic,copy) NSString *pid;

@property (nonatomic,copy) NSString *titleLabel;

@property (nonatomic,copy) NSString *priceLabel;
@property (nonatomic,copy) NSString *timelabel;
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,copy) NSString *bz;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *state;
@property (nonatomic, assign) BOOL isAddOrReduce;




-(void)setUpDetailCellModelDataWithDictionary:(NSDictionary *)dict;


@end


/**
 *  我要记账－明细－头部Model
 */
@interface FMKeepAccountDetailCellSectionHeaderModel : NSObject

@property (nonatomic,copy) NSString *timeLabel;
@property (nonatomic,copy) NSString *expendLabel;
@property (nonatomic,copy) NSString *incomeLabel;
-(void)setUpAccountDetailCellSectionDataWithDictionary:(NSDictionary *)dict;


@end



@interface FMKeepAccount : NSObject

@property (nonatomic, strong) FMKeepAccountDetailCellSectionHeaderModel * sectionHeader;
@property (nonatomic, strong) NSMutableArray * dataSource;

-(void)setUpKeepAccountDataWithDictionary:(NSDictionary *)dict;
@end
