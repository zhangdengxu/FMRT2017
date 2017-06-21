//
//  XMSelectDataPick.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    XMSelectDataPickStyleStart = 1,
    XMSelectDataPickStyleend = 2
}XMSelectDataPickStyle;
@class XMSelectDataPick;

@protocol XMSelectDataPickDelegate <NSObject>

@optional

-(void)XMSelectDataPickDidSelectTime:(XMSelectDataPick *)dataPick withTurnTime:(NSString *)time;

@end

@interface XMSelectDataPick : UIView

@property (nonatomic, weak) id <XMSelectDataPickDelegate> delegate;

@property (nonatomic, assign) XMSelectDataPickStyle typeStyle;

-(void)showTimeWithCurrentTime:(NSDate *)date;
-(NSDate *)turnToTimeWithNSString:(NSString *)string;
-(NSString *)turnNSStringToTime:(NSDate *)date;
@end
