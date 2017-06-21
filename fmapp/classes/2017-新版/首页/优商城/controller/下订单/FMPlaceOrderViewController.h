//
//  FMPlaceOrderViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPlaceOrderViewController : UIViewController

@property (nonatomic,copy) NSString *product_id;

@property (nonatomic, assign) BOOL isLetSonViewScroll;

//是否是积分兑换商品，默认为0，是金钱购买，1为积分兑换商品
@property (nonatomic, assign) NSInteger isShopFullScore;


@property (nonatomic, assign) NSInteger goToGoodShopIndex;
@end
