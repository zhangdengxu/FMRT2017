//
//  FMDuobaoSelectShopView.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMSelectShopModelNew,FMShopCollectionInfoModel,FMSelectShopInfoModel;

typedef void(^retSuccessModelBlock)(FMSelectShopInfoModel * selectModel,NSInteger buttonTag);

typedef void(^retSuccessNewModelBlock)(FMSelectShopModelNew * selectModel,NSInteger buttonTag);

typedef void(^retCloseModelBlock)(FMSelectShopModelNew * selectModel);

@interface FMGoodsShopSelectShopView : UIViewController

#pragma -mark 回掉
@property (nonatomic,copy) retSuccessModelBlock successBlock;
@property (nonatomic,copy) retSuccessNewModelBlock successNewBlock;
@property (nonatomic,copy) retCloseModelBlock closeBlock;




@property (nonatomic, strong) NSArray * buttonArray;

//是否显示选择商品数
@property (nonatomic, assign) BOOL isShowCount;

#pragma -mark 之前已选过商品，对此赋值
//选中商品的位置。


@property (nonatomic, assign) NSInteger lastSelectCount;
@property (nonatomic, strong) NSArray * lastLocationArray;

//product_id必须传！！！
@property (nonatomic,copy) NSString *product_id;
//以Model来初始化；
-(void)createPresentModel:(FMSelectShopInfoModel *)presentModel;





//是否是积分兑换商品，默认为0，是金钱购买，1为积分兑换商品
@property (nonatomic, assign) NSInteger isShopFullScore;
@end





