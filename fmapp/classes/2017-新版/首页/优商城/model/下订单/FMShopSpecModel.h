//
//  FMShopSpecModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 商品属性Model  包括颜色、尺码
 */
@interface FMSpecProductModel : NSObject

@property (nonatomic,copy) NSString *marketable;
@property (nonatomic,copy) NSString *private_spec_value_id;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *spec_goods_images;
@property (nonatomic,copy) NSString *spec_image;
@property (nonatomic,copy) NSString *spec_value;
@property (nonatomic,copy) NSString *spec_value_id;
@property (nonatomic, strong) NSNumber *store;

////备用字段
//@property (nonatomic,copy) NSString *currentStyle;

@end




/*
 商品属性与商品属性名绑定，里边存有商品的细节
 */
@interface FMShopSpecModel : NSObject

@property (nonatomic, strong) NSArray * goods;//以FMSpecProductModel形式存储
@property (nonatomic,copy) NSString *spec_name;
@property (nonatomic, strong) NSNumber * store;

@end



/*
 商品属性与商品属性名绑定，里边存有商品的细节
 */
@interface FMSpecStringModel : NSObject

@property (nonatomic,copy) NSString *spec_name_value;//属性值
@property (nonatomic, strong) NSNumber * store;
@property (nonatomic,copy) NSString *product_id;


//自己定义的变量
@property (nonatomic,copy) NSString *spec_name;
@property (nonatomic, assign) BOOL isOnClick;
@property (nonatomic,copy) NSString *image;

@end


/*
 商品属性与商品属性名绑定，只保存颜色、尺码等各种属性，以FMSpecStringModel形式存储，在collectionView显示的时候易加载
 */
@interface FMShopSpecStringModel : NSObject

@property (nonatomic, strong) NSArray * styleStrings; //里边以FMSpecStringModel形势存储
@property (nonatomic,copy) NSString *spec_name;

@property (nonatomic, assign) BOOL isShowCountView;

@end




/*
 collectionView选择商品Model
 
 必须为：spec_name、contentString赋值
    spec_name为属性名、contentString为某个具体属性
 
 */
@interface FMShopCollectionInfoModel : NSObject
@property (nonatomic,copy) NSString *spec_name;
@property (nonatomic,copy) NSString *contentString;
@property (nonatomic, strong) NSIndexPath * indexPath;//肯定会用到
//以下是防备可能使用到
@property (nonatomic,copy) NSString *product_id;

@end


/*
 选定商品信息
 */
@class XZShoppingOrderAddressModel;
@interface FMSelectShopInfoModel : NSObject


@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * product_id;
/**
 *  图片
 */
@property (nonatomic,copy) NSString * image;

@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * mktPrice;
@property (nonatomic,copy) NSString * brief;
@property (nonatomic,copy) NSString * fulljifen_ex;//

@property (nonatomic, assign) BOOL isLoadActivity;

@property (nonatomic, assign) NSInteger fav;
@property (nonatomic,copy) NSString *md5_cart_info;//
@property (nonatomic,copy) NSString *sess_id;
@property (nonatomic,copy) NSString *video_thumb;//视频默认图片


//这个必须要设置值。值的对象为FMShopCollectionInfoModel类型
@property (nonatomic, strong) NSArray * locationArray;


@property (nonatomic,copy) NSString *currentStyle;
@property (nonatomic, strong) NSNumber * store;
@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, strong) NSNumber * jifen;
@property (nonatomic, assign) BOOL isAllShopInfo;
@property (nonatomic,copy) NSString *unselectInfo;


@property (nonatomic,copy) NSString *currentShowQuestion;



//单独为优商城加入购物车所用

@property (nonatomic, strong) NSIndexPath * shopListIndexPath;


/**
 *  后来为秒杀追加的字段
 */
@property (nonatomic, strong) NSArray * goods_spec;
@property (nonatomic, strong) NSArray * locationSpec;
/**
 *  收件地址
 */
@property (nonatomic,copy) NSString *address;
/**
 *  收件地址id
 */
@property (nonatomic,copy) NSString *address_id;
/**
 *  收件人
 */
@property (nonatomic,copy) NSString *recipients;
/**
 *  收件手机号
 */
@property (nonatomic,copy) NSString *phone;
/**
 *  是否可以使用抵价券
 */
@property (nonatomic, strong) NSNumber * ticket_state;
/**
 *  已使用抵价券的金额
 */
@property (nonatomic, strong) NSNumber * ticket_amount;
/**
 *  当前最高出价
 */
@property (nonatomic, strong) NSNumber * max_amount;
/**
 *  商品封顶价
 */
@property (nonatomic, strong) NSNumber * top_amount;

/**
 *  竞拍标示,若有值则kill_id为空，用来判断
 */
@property (nonatomic,copy) NSString *auction_id;
/**
 *  秒杀标示
 */
@property (nonatomic,copy) NSString *kill_id;
/**
 *  抵价券标识
 */
@property (nonatomic,copy) NSString *ticket_id;


// 支付方式
@property (nonatomic,copy) NSString *payment_name;
@property (nonatomic,copy) NSString *pay_app_id;
// 返回数据
@property (nonatomic,copy) NSString *record_id;
@property (nonatomic,copy) NSString *pay_trade_no;
//地址信息
@property (nonatomic, strong) XZShoppingOrderAddressModel *addressModel;
// 抵价券金额
@property (nonatomic, strong) NSString  *amount;

/**
 *  秒杀售价
 */
@property (nonatomic,copy) NSString *sale_price;

/** 不使用优惠券 */
@property (nonatomic,assign) BOOL unUseCoupon;

/** 余额支付 */
@property (nonatomic,assign) BOOL isBalancePay;
/** 同意全民夺宝服务协议 */
@property (nonatomic,assign) BOOL isAgreeDeal;
// 测试：老友价
//@property (nonatomic,assign) BOOL isFriendPrice;

@end



@interface FMSelectShopModelNew : NSObject


@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * product_id;
/**
 *  图片
 */
@property (nonatomic,copy) NSString * image;
@property (nonatomic,copy) NSString * priceDetail;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * mktPrice;
@property (nonatomic,copy) NSString * brief;
@property (nonatomic,copy) NSString * fulljifen_ex;//


@property (nonatomic, assign) BOOL isLoadActivity;

@property (nonatomic, assign) NSInteger fav;
@property (nonatomic,copy) NSString *md5_cart_info;
@property (nonatomic,copy) NSString *sess_id;


//这个必须要设置值。值的对象为FMShopCollectionInfoModel类型
@property (nonatomic, strong) NSArray * locationArray;


@property (nonatomic,copy) NSString *currentStyle;
@property (nonatomic, strong) NSNumber * store;
@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, strong) NSNumber * jifen;
@property (nonatomic, assign) BOOL isAllShopInfo;
@property (nonatomic,copy) NSString *unselectInfo;
@property (nonatomic,copy) NSString *currentShowQuestion;

@end



@interface FMALLShopModelInfo : NSObject
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *price_desc;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *store;
@property (nonatomic,copy) NSString *image;

@end


@interface FMALLSpecDescInfo : NSObject
@property (nonatomic,copy) NSString *kStyle;
@property (nonatomic, strong) NSMutableArray * vProductId;
@end









