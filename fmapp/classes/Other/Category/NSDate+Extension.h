//
//  NSDate+Extension.h
//  fmapp
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  获得跟当前时间（now）的差值
 */
- (NSDateComponents *)intervalToNow;
@end
