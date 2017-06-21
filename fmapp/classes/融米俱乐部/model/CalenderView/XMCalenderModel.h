//
//  XMCalenderModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMCalenderModel : NSObject

@property (nonatomic, strong) NSNumber * dayNumber;

@property (nonatomic,copy) NSString *currentTime;

@property (nonatomic, assign) BOOL isShowbackImage;

@property (nonatomic, assign) BOOL isShowOldMark;

@property (nonatomic, assign) BOOL isShowRepairSignIn;

@property (nonatomic, assign) BOOL isShowPresentBox;

@property (nonatomic, assign) BOOL buqian;

@end
