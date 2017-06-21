//
//  FMRTWellStoreCollectionModel.m
//  fmapp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreCollectionModel.h"

@implementation FMRTWellStoreCollectionModel

+(NSArray *)dataSource{
    NSArray *titles = [NSArray arrayWithObjects:@"订单",@"购物车",@"收藏",@"兑换记录",@"推荐", nil];
    NSArray *pics = [NSArray arrayWithObjects:@"优商城首页_订单_36",@"优商城首页_购物车_36",@"优商城首页_收藏_36",@"优商城首页_兑换记录_36",@"优商城首页_推荐_36", nil];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        FMRTWellStoreCollectionModel *model = [[FMRTWellStoreCollectionModel alloc]init];
        model.pic = pics[i];
        model.title = titles[i];
        [arr addObject:model];
    }
    return arr;
}
+(NSArray *)dataArr{
    NSArray *titles = [NSArray arrayWithObjects:@"订单",@"购物车",@"收藏",@"兑换记录",nil];
    NSArray *pics = [NSArray arrayWithObjects:@"优商城首页_订单_36",@"优商城首页_购物车_36",@"优商城首页_收藏_36",@"优商城首页_兑换记录_36",nil];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        FMRTWellStoreCollectionModel *model = [[FMRTWellStoreCollectionModel alloc]init];
        model.pic = pics[i];
        model.title = titles[i];
        [arr addObject:model];
    }
    return arr;
}

@end
