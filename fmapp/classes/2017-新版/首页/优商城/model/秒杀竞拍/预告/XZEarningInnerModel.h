//
//  XZEarningInnerModel.h
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZEarningInnerModel : NSObject

@property (nonatomic, copy) NSString *jie_title;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *jiner;
@property (nonatomic, copy) NSString *tou_danhao;
@property (nonatomic, copy) NSString *jie_id;
@property (nonatomic, copy) NSString *jilu_id;
@property (nonatomic, copy) NSString *huan_id;

/** 描述 */
@property (nonatomic, copy) NSString *miaoshu;
/** 好友姓名 */
@property (nonatomic, copy) NSString *xingming;
/** 当日金额 */
@property (nonatomic, copy) NSString *lyyongjinshu;
/**
 类型为1能点，其他不能点；
 1为标的回款 可以 点击 2为零钱贯 不需要点击查看
 */
@property (nonatomic, copy) NSString *leixing;

/** 天 */
@property (nonatomic, copy) NSString *daynum;
/** 月日 */
@property (nonatomic, copy) NSString *day;
/** 收益 */
@property (nonatomic, copy) NSString *daytotal;

/** 区分已赚收益，累计佣金和好友贡献佣金 */
@property (nonatomic, copy) NSString *controllerName;


@end
