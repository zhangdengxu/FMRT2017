//
//  XZContactServicesModel.m
//  fmapp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZContactServicesModel.h"
#import "XZContactSerContentModel.h"

@implementation XZContactServicesModel
- (void)setContactServicesWithDic:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.detail) {
        XZContactSerContentModel *Content = [[XZContactSerContentModel alloc] init];
        [Content setValuesForKeysWithDictionary:dict];
        if (self.isCommonProblems) { // 新的“常见问题”
            Content.contentH =  [self autoCalculateWidthOrHeight:MAXFLOAT width:(KProjectScreenWidth - 20) fontsize:13 content:Content.content];
        }else {// 旧的“常见问题”
            Content.contentH = [self autoCalculateWidthOrHeight:MAXFLOAT width:(KProjectScreenWidth - 40) fontsize:13 content:Content.content];
        }
        [temp addObject:Content];
    }
    self.detail = [NSMutableArray arrayWithArray:temp];
}

- (float)autoCalculateWidthOrHeight:(float)height
                             width:(float)width
                          fontsize:(float)fontsize
                           content:(NSString*)content
{
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    
    //判断计算的是宽还是高
    if (height == MAXFLOAT) {
        return rect.size.height + 30;
    }else
    {
        return rect.size.width;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
