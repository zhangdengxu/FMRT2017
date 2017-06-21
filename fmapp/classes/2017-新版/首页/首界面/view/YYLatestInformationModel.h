//
//  YYLatestInformationModel.h
//  fmapp
//
//  Created by yushibo on 2016/12/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLatestInformationModel : NSObject
/** 标题  */
@property (nonatomic, strong) NSString *title;
/** news_id  */
@property (nonatomic, strong) NSString *news_id;
/** 摘要 */
@property (nonatomic, strong) NSString *zhaiyao;
/** 时间 */
@property (nonatomic, strong) NSString *addtime;
/** 视频截图图片 */
@property (nonatomic, strong) NSString *videoThumb;
/** 文章图片 */
@property (nonatomic, strong) NSString *thumb;
/** 作者 */
@property (nonatomic, strong) NSString *author;


@end
