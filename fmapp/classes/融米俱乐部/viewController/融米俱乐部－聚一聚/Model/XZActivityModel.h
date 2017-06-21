//
//  XZActivityModel.h
//  fmapp
//
//  Created by admin on 16/7/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZActivityModel : NSObject

/** 报名信息（活动结束、报名满额、我要报名等） */
@property (nonatomic, copy) NSString *joininfo;
/** 1不能报名不需要弹出报名表单 0我要报名 */
@property (nonatomic, copy) NSString *joinsuccess;
/** 判断是否已赞:0未赞 1已赞 */
@property (nonatomic, copy) NSString *ispraise;
/** 赞的数量 */
@property (nonatomic, copy) NSString *praisenum;
/** 活动详情页webView */
@property (nonatomic, copy) NSString *party_info;
/** 评论数 */
@property (nonatomic, copy) NSString *commentnum;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 主题 */
@property (nonatomic, copy) NSString *party_theme;
/** 已报名人数 */
@property (nonatomic, copy) NSString *party_adder;
/** 限报名人数 */
@property (nonatomic, copy) NSString *party_number;
/** 发起时间 */
@property (nonatomic, copy) NSString *party_addtime;
/** 开始和结束时间 */
@property (nonatomic, copy) NSString *party_timelist;
/** 用户头像地址 */
@property (nonatomic, copy) NSString *avatar;
/** 地址 */
@property (nonatomic, copy) NSString *party_address;
/** 报名截止时间 */
@property (nonatomic, copy) NSString *party_enrolltime;
@property (nonatomic, copy) NSString *state;
/** 阅读量 */
@property (nonatomic, copy) NSString *readernum;
/** 分享数 */
@property (nonatomic, copy) NSString *sharenum;
/** 活动唯一标识 */
@property (nonatomic, copy) NSString *pid;
/** 电话号码 */
@property (nonatomic, copy) NSString *phone;
/** 验票数 */
@property (nonatomic, copy) NSString *checkticketdone;
/** 分享title */
@property (nonatomic, copy) NSString *sharetitle;
/** 分享url */
@property (nonatomic, copy) NSString *shareurl;
/** 分享pic */
@property (nonatomic, copy) NSString *sharepic;
/** 分享content */
@property (nonatomic, copy) NSString *sharecontent;

// 我的推荐识别二维码链接
@property (nonatomic, copy) NSString *linkUrl;
@end
