//
//  FMShopCommentModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShopCommentModel.h"
#import "LWAlchemy.h"


@implementation FMShopCommentModel

+(instancetype)createFMShopCommentModelWithDictionary:(NSDictionary *)dict;
{
    FMShopCommentModel * model = [[FMShopCommentModel alloc]init];
    model.avatar = [NSURL URLWithString:dict[@"img"]];
    model.name = dict[@"name"];
    
    model.product_id = dict[@"product_id"];
    model.content = dict[@"comment"];
    
    model.comment_id = [NSString stringWithFormat:@"%@",dict[@"comment_id"]];
    
    if (dict[@"spec_info"]) {
        model.date = dict[@"spec_info"];
        if ([model.date isMemberOfClass:[NSNull class]]) {
            model.date = nil;
        }
    }
    
    if (dict[@"imgs"]) {
        model.imgs = dict[@"imgs"];
        if ([model.imgs isMemberOfClass:[NSNull class]]) {
            model.imgs = nil;
        }
        if (model.imgs.count == 0) {
            model.imgs = nil;
        }
        if ([[model.imgs firstObject] isEqualToString:@""]) {
            model.imgs = nil;
        }
    }
    if (dict[@"secondImgs"]) {
        model.secondImgs = dict[@"secondImgs"];
        if ([model.secondImgs isMemberOfClass:[NSNull class]]) {
            model.secondImgs = nil;
        }
        if (model.secondImgs.count == 0) {
            model.secondImgs = nil;
        }
        
    }
    
    if (dict[@"comment_id"]) {
        model.comment_id = dict[@"comment_id"];
        if ([model.comment_id isMemberOfClass:[NSNull class]]) {
            model.comment_id = nil;
        }
        if (model.comment_id.length == 0) {
            model.comment_id = nil;
        }
    }
    
    if (dict[@"order_id"]) {
        model.order_id = dict[@"order_id"];
        if ([model.order_id isMemberOfClass:[NSNull class]]) {
            model.order_id = nil;
        }
        if (model.order_id.length == 0) {
            model.order_id = nil;
        }
    }
    
    if (dict[@"secondComment"]) {
        model.secondContent = dict[@"secondComment"];
        if ([model.secondContent isMemberOfClass:[NSNull class]]) {
            model.secondContent = nil;
        }
        if (model.secondContent.length == 0) {
            model.secondContent = nil;
        }
        if ([[model.secondImgs firstObject] isEqualToString:@""]) {
            model.secondImgs = nil;
        }
    }
    return model;
}


+(instancetype)createFMShopCommentModelWithShopDetailDictionary:(NSDictionary *)dict;
{
    FMShopCommentModel * model = [[FMShopCommentModel alloc]init];
    model.avatar = [NSURL URLWithString:dict[@"avatar"]];
    model.name = dict[@"author"];
    model.statusGrade = dict[@"goods_point"];
    model.product_id = dict[@"product_id"];
    model.content = dict[@"comment"];
    
    model.comment_id = [NSString stringWithFormat:@"%@",dict[@"comment_id"]];
    
    if (dict[@"date"]) {
        NSString * dataString = dict[@"date"];
        if ([dataString isMemberOfClass:[NSNull class]]) {
            model.date = nil;
        }else
        {
            model.date = [NSString retStringFromTimeToyyyyYearMMMonthddDay:dataString];
        }
    }
    
    if (dict[@"imgs"]) {
        model.imgs = dict[@"imgs"];
        if ([model.imgs isMemberOfClass:[NSNull class]]) {
            model.imgs = nil;
        }
        if (model.imgs.count == 0) {
            model.imgs = nil;
        }
        if ([[model.imgs firstObject] isEqualToString:@""]) {
            model.imgs = nil;
        }
    }
    if (dict[@"secondImgs"]) {
        model.secondImgs = dict[@"secondImgs"];
        if ([model.secondImgs isMemberOfClass:[NSNull class]]) {
            model.secondImgs = nil;
        }
        if (model.secondImgs.count == 0) {
            model.secondImgs = nil;
        }
        if ([[model.secondImgs firstObject] isEqualToString:@""]) {
            model.secondImgs = nil;
        }
        
    }
    if (dict[@"secondComment"]) {
        model.secondContent = dict[@"secondComment"];
        if ([model.secondContent isMemberOfClass:[NSNull class]]) {
            model.secondContent = nil;
        }
        if (model.secondContent.length == 0) {
            model.secondContent = nil;
        }
    }
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
