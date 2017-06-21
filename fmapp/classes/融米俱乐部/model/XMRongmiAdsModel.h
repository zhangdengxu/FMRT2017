//
//  XMRongmiAdsModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMRongmiAdsModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *lianjie;
@property (nonatomic,copy) NSString *neirong;
// 判断是大转盘还是砸金蛋
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *sharepic;
@end
