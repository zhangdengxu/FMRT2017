//
//  FMIndexHeaderModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/9/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMIndexHeaderModel : NSObject

@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *lianjie;
@property (nonatomic,copy) NSString *fenxiangpic;
@property (nonatomic,copy) NSString *fenxiangbiaoti;
@property (nonatomic,copy) NSString *fenxiangneirong;
@property (nonatomic,copy) NSString *fenxianglianjie;
// 需要登录验证:如果是1,判断用户是否登录、未登录跳转到登录界面
@property (nonatomic,copy) NSString *yanzheng;
@end
