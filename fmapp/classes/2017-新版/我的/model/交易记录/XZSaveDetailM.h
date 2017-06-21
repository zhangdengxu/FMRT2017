//
//  XZSaveDetailM.h
//  fmapp
//
//  Created by rongtuo on 16/4/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSaveDetailM : NSObject
/** 提交时间 */
@property (nonatomic, copy) NSString *jiaoyi;
/** 所属交易日 */
@property (nonatomic, copy) NSString *tijiao;
/** 提醒 */
@property (nonatomic, copy) NSString *msg;
/** 申请金额*/
@property (nonatomic, copy) NSString *jiner;



//后来添加参数
/** 商品ProductID*/
@property (nonatomic, copy) NSString *productId;
/** 图片链接地址*/
@property (nonatomic, copy) NSString *imageUrl;
/** 商品详情*/
@property (nonatomic, copy) NSString *productDetail;

@end
