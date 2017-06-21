//
//  XZRongMiSchoolModel.h
//  fmapp
//
//  Created by admin on 17/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRongMiSchoolModel : NSObject

/** 题目高度 */
@property (nonatomic, assign) NSInteger titleHeight;

/** 图片地址 */
@property (nonatomic, strong) NSString *videoThumb;

/** 视频地址 */
@property (nonatomic, strong) NSString *videoPath;

/** 点赞数 */
@property (nonatomic, strong) NSNumber *like;

/** 视频题目 */
@property (nonatomic, strong) NSString *title;

/** 添加时间 */
@property (nonatomic, strong) NSString *addtime;

/** 来源 */
@property (nonatomic, strong) NSString *from;

/** 分享url */
@property (nonatomic, strong) NSString *shareUrl;

/** 内容 */
@property (nonatomic, strong) NSString *content;

/** 摘要 */
@property (nonatomic, strong) NSString *zhaiyao;

/** 是否展示标和商品的信息:0不显示 1显示最新标 2显示商品 */
@property (nonatomic, strong) NSNumber *extraDisplay;

/** 优商城产品id 根据id获取产品信息 */
@property (nonatomic, strong) NSString *selectedProduct;

/** 横屏/竖屏 */
@property (nonatomic, assign) BOOL isLandScape;

/** 内容高度 */
@property (nonatomic, assign) NSInteger contentHeight;


@end
