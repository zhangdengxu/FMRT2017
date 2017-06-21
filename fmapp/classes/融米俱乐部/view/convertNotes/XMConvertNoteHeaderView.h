//
//  XMConvertNoteHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMConvertNoteHeaderView;

@protocol XMConvertNoteHeaderViewDelegate <NSObject>

@optional
-(void)XMConvertNoteHeaderViewDidSelectSegmentedControl:(XMConvertNoteHeaderView *)headerView;

@end

@interface XMConvertNoteHeaderView : UIView

@property (weak, nonatomic) IBOutlet UISegmentedControl *currentStatus;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (nonatomic, weak) id <XMConvertNoteHeaderViewDelegate> delegate;


@end
