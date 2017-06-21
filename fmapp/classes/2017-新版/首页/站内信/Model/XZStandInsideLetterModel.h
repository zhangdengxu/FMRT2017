//
//  XZStandInsideLetterModel.h
//  fmapp
//
//  Created by admin on 16/11/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZStandInsideLetterModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *biaoti;
/** 时间 */
@property (nonatomic, strong) NSString *shijian;
/** 类型 */
@property (nonatomic, strong) NSString *leixing;
/** 消息id */
@property (nonatomic, strong) NSString *mess_id;
/** 内容 */
@property (nonatomic, strong) NSString *neirong;
/** 状态 */
@property (nonatomic, strong) NSString *zhuangtai;
/** user_id */
@property (nonatomic, strong) NSString *user_id;
/** kanshijian */
@property (nonatomic, strong) NSString *kanshijian;
///** 消息已读 */
//@property (nonatomic, assign) BOOL hasRead;
/** 行高 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
