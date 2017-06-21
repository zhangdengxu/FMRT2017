//
//  XZWeakTimer.h
//  XZProject
//
//  Created by XZ on 16/8/4.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XZTimerHandler)(id userInfo);
@interface XZWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(XZTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;
@end
