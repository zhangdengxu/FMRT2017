//
//  XmConverNotesModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmConverNotesModel : NSObject

@property (nonatomic,copy) NSString *pic;

@property (nonatomic, copy) NSString * zhuangtai;
@property (nonatomic, copy) NSString *shangpinmingcheng;
@property (nonatomic, copy) NSString *dangejifen;
@property (nonatomic, copy) NSString * shuliang;
@property (nonatomic, copy) NSString *jilu_id;
@property (nonatomic, copy) NSString *shangpin_id;
@property (nonatomic,copy) NSString *leixing;
@property (nonatomic,copy) NSString *type;

+(instancetype)XmConverNotesModelCreateWithDictionary:(NSDictionary *)dict;

@end
