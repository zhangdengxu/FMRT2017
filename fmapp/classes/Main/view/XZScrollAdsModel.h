//
//  XZScrollAdsModel.h
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZScrollAdsModel : NSObject
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *pic;
/** button数组 */
@property (nonatomic, strong) NSMutableArray *btn;

- (void)setScrollAdsModelWithDic:(NSDictionary *)dic;
@end
