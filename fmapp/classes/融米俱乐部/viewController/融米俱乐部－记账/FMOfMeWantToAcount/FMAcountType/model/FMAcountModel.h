//
//  FMAcountModel.h
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface FMAcountLendModel : NSObject<MJKeyValue>
/**
 id = 13;
 leibie = 1;
 pid = 11;
 title = "\U516c\U4ea4";
 token = 0;
 "user_id" = 0;
 utoken = "<null>";
 */
@property (nonatomic, copy) NSString *leibie;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *utoken;
@property (nonatomic, copy) NSString *ID;

@end

@interface FMAcountModel : NSObject<MJKeyValue>

/**
 id = 1;
 leibie = 1;
 pid = 0;
 title = "\U9910\U996e";
 token = 0;
 typeDetailArr
 typeTotalName = "\U9910\U996e";
 "user_id" = 0;
 utoken = "<null>";
 */
@property (nonatomic, copy) NSString *DID;
@property (nonatomic, copy) NSString *typeTotalName;
@property (nonatomic, copy) NSString *leibie;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *utoken;
@property (nonatomic, copy) NSArray  *typeDetailArr;

@end
