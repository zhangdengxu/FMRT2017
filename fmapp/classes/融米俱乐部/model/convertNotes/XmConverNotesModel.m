//
//  XmConverNotesModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XmConverNotesModel.h"

@implementation XmConverNotesModel


- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(instancetype)XmConverNotesModelCreateWithDictionary:(NSDictionary *)dict;
{
    XmConverNotesModel * convertNote = [[XmConverNotesModel alloc]init];
    NSArray * goods_items = dict[@"goods_items"];
    if (goods_items && ![goods_items isMemberOfClass:[NSNull class]]) {
        NSDictionary * shopDetail = goods_items[0];
        convertNote.shangpinmingcheng = shopDetail[@"name"];
        
        convertNote.shuliang = dict[@"itemnum"];
        
        convertNote.shangpin_id =  shopDetail[@"product_id"];
        
        
        convertNote.leixing = dict[@"leixing"];
        
        convertNote.jilu_id = dict[@"order_id"];
        
        convertNote.type = dict[@"type"];
        
        convertNote.dangejifen = dict[@"used_jifen"];
        convertNote.pic = shopDetail[@"thumbnail_pic"];
    }
    

    return convertNote;
}

@end
