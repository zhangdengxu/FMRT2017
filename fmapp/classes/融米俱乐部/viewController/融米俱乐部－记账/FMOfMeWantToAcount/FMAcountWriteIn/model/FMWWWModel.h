//
//  FMWWWModel.h
//  fmapp
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMWWWModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *bz;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *personName;
/**
 *  state如果为100，代表服务器未返回state状态，需要另作处理
 */
@property (nonatomic, copy) NSString *state;

@end
