//
//  XMCalenderCellMonth.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMCalenderCellMonth;
@class XMCalenderModel;
@protocol XMCalenderCellMonthDelegate <NSObject>

@optional
-(void)XMCalenderCellMonthDidSelectItem:(XMCalenderCellMonth *)calenderCell withModel:(XMCalenderModel *)model;
@end

@interface XMCalenderCellMonth : UICollectionViewCell


@property (nonatomic, assign) CGSize sizeCell;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, weak) id <XMCalenderCellMonthDelegate> delegate;


@end
