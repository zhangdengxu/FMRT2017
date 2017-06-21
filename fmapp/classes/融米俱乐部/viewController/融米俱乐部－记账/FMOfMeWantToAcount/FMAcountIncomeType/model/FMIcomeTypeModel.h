//
//  FMIcomeTypeModel.h
//  fmapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMIcomeTypeModel : NSObject
/**
 id = 132;
 leibie = 2;
 pid = 0;
 title = "\U5de5\U8d44\U85aa\U6c34";
 token = 0;
 "user_id" = 0;
 utoken = "<null>";
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *leibie;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *utoken;

@end
