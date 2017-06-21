//
//  FMHomeNewsModel.h
//  fmapp
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 biaoti = "\U878d\U76ca\U76c8YY201654\U671f\U7ed3\U7b97\U5229\U606f";
 "mess_id" = 53980;
 title = "\U878d\U76ca\U76c8YY201654\U671f\U7ed3\U7b97\U5229\U606f";
 url = "https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixinshow/mess_id/53980";
 */
@interface FMHomeNewsModel : NSObject

@property (nonatomic, copy) NSString *biaoti;
@property (nonatomic, copy) NSString *mess_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end
