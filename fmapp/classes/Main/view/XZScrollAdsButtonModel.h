//
//  XZScrollAdsButtonModel.h
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZScrollAdsButtonModel : NSObject
/** button链接 */
@property (nonatomic, copy) NSString *lianjie;
/** button类型 0：不能点击，1：web，2：原生--注册，3：原生--进入app*/
@property (nonatomic, copy) NSString *type;
/** web页的navTitle */
@property (nonatomic, copy) NSString *title;

@end
