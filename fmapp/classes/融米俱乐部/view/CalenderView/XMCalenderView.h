//
//  XMCalenderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMCalenderView;
@class XMCalenderModel;
@class XMCalenderCellMonth;

@protocol XMCalenderViewDelegate <NSObject>

@optional
-(void)XMCalenderViewDidSelectItem:(XMCalenderView *)calenderView withModel:(XMCalenderModel *)model withCalenderCell:(XMCalenderCellMonth *)cell;
-(void)XMCalenderViewDidSelectMonth:(XMCalenderView *)calenderView withMonthAndYear:(NSString *)month;
@end

@interface XMCalenderView : UIView

@property (nonatomic, weak) id <XMCalenderViewDelegate> delegate;

@property (nonatomic, strong) NSArray * dataDict;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic,copy) NSString *presentDay;
@property (nonatomic, strong) UICollectionView * contentCollect;


-(void)showCurrentMonth;

@end
