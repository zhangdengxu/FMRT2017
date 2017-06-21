//
//  XZRongMiClubModel.h
//  fmapp
//
//  Created by admin on 16/11/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRongMiClubModel : NSObject
/**  */
@property (nonatomic, strong) NSString *classone;
/** 添加日期 */
@property (nonatomic, strong) NSString *addtime;
/**  */
@property (nonatomic, strong) NSString *recommend_app_first;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 分享内容 */
@property (nonatomic, strong) NSString *shareContent;
/**  */
@property (nonatomic, strong) NSString *news_id;
/** title */
@property (nonatomic, strong) NSString *title;
/** 图片链接 */
@property (nonatomic, strong) NSString *thumb;
/** 视频地址 */
@property (nonatomic, strong) NSString *videoPath;
/** 视频图片 */
@property (nonatomic, strong) NSString *videoThumb;

@end
