//
//  XMMyScoreInAppHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMMyScoreInAppHeaderView;

@protocol XMMyScoreInAppHeaderViewDelegate <NSObject>

@optional
-(void)XMMyScoreInAppHeaderViewDidSelectStartTime:(XMMyScoreInAppHeaderView *)headerView;
-(void)XMMyScoreInAppHeaderViewDidSelectEndTime:(XMMyScoreInAppHeaderView *)headerView;
@end


@interface XMMyScoreInAppHeaderView : UIView
@property (nonatomic, strong) NSDictionary * dataSource;
@property (nonatomic, weak)id <XMMyScoreInAppHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;


@end
