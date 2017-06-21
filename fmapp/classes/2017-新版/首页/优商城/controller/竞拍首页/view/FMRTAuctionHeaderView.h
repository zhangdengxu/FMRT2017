//
//  FMRTAuctionHeaderView.h
//  fmapp
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAucDataModel.h"

@interface FMRTAuctionHeaderView : UIView

@property (nonatomic, strong) FMRTAucDataModel *model;

@property (nonatomic, copy) void(^RBlock)(NSString *auctionId);//记录
@property (nonatomic, copy) void(^PBlock)(UIButton *sender,NSInteger type, NSString *auctionId,NSString *productId,NSInteger count);//竞拍
@property (nonatomic, copy) void(^ABlock)();//竞拍规则
@property (nonatomic, copy) void(^startBlock)();//开始竞拍－刷新表格＋请求数据
@property (nonatomic, copy) void(^endBlock)();//竞拍结束
@property (nonatomic, copy) void(^topImageBlock)();//轮播跳转
@property (nonatomic, copy) void(^productDetailBlock)(NSString *goods_id,NSString *auctionId,NSString *activityState,NSString *price);//商品详情跳转


- (void)sendDataWithModel:(FMRTAucDataModel *)model;

@end
