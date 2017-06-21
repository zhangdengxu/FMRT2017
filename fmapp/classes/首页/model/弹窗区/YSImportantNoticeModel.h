//
//  YSImportantNoticeModel.h
//  fmapp
//
//  Created by yushibo on 16/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSImportantNoticeModel : NSObject
/*
 * 标题
 */
@property (nonatomic, strong)NSString *title;
/*
 * 称谓
 */
@property (nonatomic, strong)NSString *chengwei;
/*
 * 内容
 */
@property (nonatomic, strong)NSArray *neirong;
/*
 * 作者
 */
@property (nonatomic, strong)NSString *author;
/*
 * 时间
 */
@property (nonatomic, strong)NSString *date;
/*
 * 图片
 */
@property (nonatomic, strong)NSString *pic;
@end
