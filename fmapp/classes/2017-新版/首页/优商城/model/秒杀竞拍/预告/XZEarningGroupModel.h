//
//  XZEarningGroupModel.h
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZEarningGroupModel : NSObject

@property (nonatomic, strong) NSMutableArray *Monthlist;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *Monthtotal;
@property (nonatomic, strong) NSString *jiner;
@property (nonatomic, strong) NSString *jie_title;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, assign) BOOL isFirst;
- (void)setEarningWithDic:(NSDictionary *)dic;

/** 能否被点击 */
@property (nonatomic, assign) BOOL isCanClick;


@end
