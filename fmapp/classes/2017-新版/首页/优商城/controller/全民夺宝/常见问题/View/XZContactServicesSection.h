//
//  XZContactServicesSection.h
//  fmapp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZContactServicesSection;
@class XZContactServicesModel;
@protocol XZContactServicesSectionDelegate <NSObject>

@optional
- (void)touchAction:(XZContactServicesSection *)section;

@end

@interface XZContactServicesSection : UIView
@property (nonatomic, weak) id <XZContactServicesSectionDelegate> delegate;

@property (nonatomic, strong) XZContactServicesModel *modelContactSer;
@end
