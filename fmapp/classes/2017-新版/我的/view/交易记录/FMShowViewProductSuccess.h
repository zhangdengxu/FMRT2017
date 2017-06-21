//
//  FMShowViewProductSuccess.h
//  fmapp
//
//  Created by runzhiqiu on 2017/6/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMShowViewProductSuccessModel;
typedef void(^showViewShowButtonOnClickBlock)(NSString * producrId);

@interface FMShowViewProductSuccess : UIView

@property (nonatomic, strong) FMShowViewProductSuccessModel * productModel;

+(instancetype)showFMMessageViewShow:(FMShowViewProductSuccessModel *)productModel WithBolok:(showViewShowButtonOnClickBlock)block;


@end


@interface FMShowViewProductSuccessModel : NSObject

/** 商品ProductID*/
@property (nonatomic, copy) NSString *productId;
/** 图片链接地址*/
@property (nonatomic, copy) NSString *imageUrl;
/** 商品详情*/
@property (nonatomic, copy) NSString *productDetail;

@end

