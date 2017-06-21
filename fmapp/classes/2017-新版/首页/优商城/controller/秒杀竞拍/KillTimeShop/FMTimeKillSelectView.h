//
//  FMTimeKillSelectView.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>



@class FMSelectShopModelNew,FMSelectShopInfoModel;

typedef enum  {
    FMTimeKillShowSelectViewJingPai = 0,
    FMTimeKillShowSelectViewStyleMiaoSha = 1,
}FMTimeKillShowSelectViewStyle;


typedef void(^retKillSuccessNewModelBlock)(FMSelectShopModelNew * selectModel,NSInteger buttonTag);

typedef void(^retKillCloseModelBlock)(FMSelectShopInfoModel * selectModel);


typedef void(^retKillSuccessModelBlock)(FMSelectShopInfoModel * selectModel);




@interface FMTimeKillSelectView : UIViewController

//product_id必须传！！！
@property (nonatomic,copy) NSString * product_id;
//是否显示选择商品数
@property (nonatomic, assign) BOOL isShowCount;


#pragma -mark 回掉
@property (nonatomic,copy) retKillSuccessModelBlock successBlock;
@property (nonatomic,copy) retKillSuccessNewModelBlock successNewBlock;
@property (nonatomic,copy) retKillCloseModelBlock closeBlock;


//竞拍或夺宝的类型；
@property (nonatomic, assign) FMTimeKillShowSelectViewStyle selectStyle;

//底部button的数量
@property (nonatomic, strong) NSArray * buttonArray;



#pragma -mark 如果之前已经选择过商品。之前已选过商品
//选中商品的位置。
@property (nonatomic, assign) NSInteger lastSelectCount;




//这个主要是购物车界面中来调用。
//以Model来初始化；
-(void)createPresentModel:(FMSelectShopInfoModel *)presentModel;


@end
