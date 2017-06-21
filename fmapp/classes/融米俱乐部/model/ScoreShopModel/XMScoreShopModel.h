//
//  XMScoreShopModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMScoreShopModel : NSObject

@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *datupic;

@property (nonatomic,copy) NSString *duihuansm;

@property (nonatomic,copy) NSString *erjilei;

@property (nonatomic,copy) NSString *jianjie;

@property (nonatomic,copy) NSString *kucun;

@property (nonatomic,copy) NSString *laiyuan;

@property (nonatomic,copy) NSString *leixing;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *shangpin_id;

@property (nonatomic,copy) NSString *shangpinmingcheng;

@property (nonatomic,copy) NSString *shpcanshu;

@property (nonatomic,copy) NSString *suoxujifen;

@property (nonatomic,copy) NSString *tuijian;

@property (nonatomic,copy) NSString *tupian;

@property (nonatomic, strong) NSNumber * beizhu;

+(instancetype)initWithScoreShopModelWithDictionary:(NSDictionary *)dictionary;

@end
