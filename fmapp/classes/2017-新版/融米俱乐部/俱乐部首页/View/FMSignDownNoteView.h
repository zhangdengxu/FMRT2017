//
//  FMSignDownNoteView.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMSignDownNoteView : UIView
@property (nonatomic, assign) NSInteger signCount;



- (instancetype)initWithSignCount:(NSInteger)signCount;

-(void)showViewWithCurrentView:(UIView *)currentView;

-(void)showViewWithKeyWindow;

@end
