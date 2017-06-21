//
//  FMDuobaoSelectShopView.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMSelectShopModelNew,FMSelectShopInfoModel,FMDuobaoClassStyle;


typedef void(^retDuobaoSuccessNewModelBlock)(FMSelectShopModelNew * selectModel,NSInteger buttonTag);

typedef void(^retDuobaoCloseModelBlock)(FMSelectShopModelNew * selectModel);


typedef void(^retDuobaoSuccessModelBlock)(FMSelectShopModelNew * selectModel,FMDuobaoClassStyle *buttonStyle);



@interface FMDuobaoSelectShopView : FMViewController


#pragma -mark 回掉
@property (nonatomic,copy) retDuobaoSuccessModelBlock successBlock;
@property (nonatomic,copy) retDuobaoSuccessNewModelBlock successNewBlock;
@property (nonatomic,copy) retDuobaoCloseModelBlock closeBlock;




@property (nonatomic, strong) NSArray * buttonArray;

//是否显示选择商品数
@property (nonatomic, assign) BOOL isShowCount;

#pragma -mark 之前已选过商品，对此赋值
//选中商品的位置。

@property (nonatomic, assign) NSInteger lastSelectCount;
@property (nonatomic, strong) NSArray * lastLocationArray;

//product_id必须传！！！
@property (nonatomic,copy) NSString * product_id;
//以Model来初始化；
-(void)createPresentModel:(FMSelectShopInfoModel *)presentModel;


@property (nonatomic, strong) FMDuobaoClassStyle * buttonStyle;

@end




