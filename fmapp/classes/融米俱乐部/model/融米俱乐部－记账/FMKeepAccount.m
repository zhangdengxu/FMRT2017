//
//  FMKeepAccount.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMKeepAccount.h"

@implementation FMKeepAccount


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)setUpKeepAccountDataWithDictionary:(NSDictionary *)dict;
{
   
    
    FMKeepAccountDetailCellSectionHeaderModel * sectionHeader = [[FMKeepAccountDetailCellSectionHeaderModel  alloc]init];
    [sectionHeader setUpAccountDetailCellSectionDataWithDictionary:dict];
    self.sectionHeader = sectionHeader;
    if (dict[@"detailListArr"]) {
        
        NSArray * detailListArr = dict[@"detailListArr"];
        [self.dataSource removeAllObjects];
        
        for (NSDictionary * detailDict in detailListArr) {
             FMKeepAccountDetailCellModel * cell1 = [[FMKeepAccountDetailCellModel alloc]init];
            [cell1 setUpDetailCellModelDataWithDictionary:detailDict];
            
            [self.dataSource addObject:cell1];
        }
    }
}

@end


@implementation FMKeepAccountDetailHeaderModel

@end



@implementation FMKeepAccountDetailCellModel
-(void)setUpDetailCellModelDataWithDictionary:(NSDictionary *)dict;
{
    if (dict) {
        
        
        self.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
        self.titleLabel = [NSString stringWithFormat:@"%@",dict[@"type"]] ;
        if ([self.titleLabel isMemberOfClass:[NSNull class]]) {
            self.titleLabel = @"";
        }
        self.priceLabel = [NSString stringWithFormat:@"%@",dict[@"money"]];
        if ([self.priceLabel isMemberOfClass:[NSNull class]]) {
            self.priceLabel = @"0.00";
        }

        self.personName = dict[@"personName"];

        self.bz = dict[@"beizhu"];
        
      
        NSString * dateTime = [NSString stringWithFormat:@"%@",dict[@"date"]] ;
        self.timelabel = [[NSString retStringFromTimeToyyyyYearMMMonthddDay:dateTime] substringFromIndex:12];
        self.time = [NSString stringWithFormat:@"%@ %@",dict[@"time"],self.timelabel] ;
        
        
        NSString * states = dict[@"state"];
        if (![states isMemberOfClass:[NSNull class]]) {
            self.state = states;
            if ([states isEqualToString:@"1"]) {
                self.isAddOrReduce = NO;
            }else
            {
                self.isAddOrReduce = YES;
            }
        }else
        {
            self.state = @"100";
        }
        
       
    }
}

@end

@implementation FMKeepAccountDetailCellSectionHeaderModel


-(void)setUpAccountDetailCellSectionDataWithDictionary:(NSDictionary *)dict;
{
    if (dict[@"secDate"]) {
        self.timeLabel = [NSString stringWithFormat:@"%@",dict[@"secDate"]];
        if ([self.timeLabel isMemberOfClass:[NSNull class]]) {
            self.timeLabel = @"";
        }
    }
    if (dict[@"incomeTotalMoney"]) {
        
        if ([dict[@"incomeTotalMoney"] isMemberOfClass:[NSNull class]]) {
            self.incomeLabel = @"收:¥ 0.00";
        }
        self.incomeLabel = [NSString stringWithFormat:@"收:¥ %@",dict[@"incomeTotalMoney"]];
    }
    if (dict[@"lendTotalMoney"]) {
        
        if ([dict[@"lendTotalMoney"] isMemberOfClass:[NSNull class]]) {
            self.expendLabel = @"支:¥ 0.00";
        }
        self.expendLabel = [NSString stringWithFormat:@"支:¥ %@",dict[@"lendTotalMoney"]];
    }
    
}
@end

@implementation FMKeepAccountSelectModel

@end


