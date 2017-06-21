//
//  FMShowWaitView.h
//  fmapp
//
//  Created by runzhiqiu on 16/7/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FMShowWaitViewTpyeFitALL,//
    FMShowWaitViewTpyeFitDeleteNavigation,//
} FMShowWaitViewType;

typedef void(^blockLoadViewBtn)();

@interface FMShowWaitView : UIView


@property (nonatomic, copy) blockLoadViewBtn loadBtn;

@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, assign) FMShowWaitViewType waitType;

-(void)showViewWithFatherView:(UIView *)fatherView;
-(void)hiddenGifView;

-(void)showLoadDataFail:(UIView *)fatherView;

@end
