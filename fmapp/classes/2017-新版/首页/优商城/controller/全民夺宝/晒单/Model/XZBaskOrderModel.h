//
//  XZBaskOrderModel.h
//  fmapp
//
//  Created by admin on 16/8/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZBaskOrderModel : NSObject
/** 用户评论——内容 */
@property (nonatomic, copy) NSString *comment_content;
/** 用户评论——标题 */
@property (nonatomic, copy) NSString *comment_title;
/** time */
@property (nonatomic, copy) NSString *time;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 头像地址 */
@property (nonatomic, copy) NSString *head_url;
/** 晒单的夺宝活动标识 */
@property (nonatomic, copy) NSString *won_id;
/** 夺宝揭晓时间，格式：时间戳 */
@property (nonatomic, copy) NSString *won_reveal;
/** 新夺宝揭晓时间，格式：时间戳 */
@property (nonatomic, copy) NSString *comment_time;
/** 晒单图片列表 */
@property (nonatomic, copy) NSMutableArray *img_list;
/** 手机号 */
@property (nonatomic, copy) NSString *phone;
/** 高度 */
@property (nonatomic, assign) CGFloat contentH;
//
///** 是新夺宝 */
//@property (nonatomic, assign) BOOL isNewIndiana;
@end
