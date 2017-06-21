//
//  FMGoodShopURL.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/22.
//  Copyright © 2016年 yk. All rights reserved.
//优商城界面接口

#ifndef FMGoodShopURL_h
#define FMGoodShopURL_h

//优商城首页，头部链接老链接
//#define  KGoodShop_Index_HeaderView_Url  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/mall"
//优商城首页，头部链接新链接
//#define  KGoodShop_Index_HeaderView_Url  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/malljiuwu"
//优商城首页，头部链接新链接 //作废 @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/malljiuwuios"
#define  KGoodShop_Index_HeaderView_Url @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/malljiuwuioserqi"

#define KGoodShop_Index_ShopList_Url     @"https://www.rongtuojinrong.com/qdy/wap/gallery-index_client.html"


//商品详情中的商品评价
#define KGoodShop_ShopDetail_CommentALL_Url  @"https://www.rongtuojinrong.com/qdy/wap/product-goodsDiscuss_client-436-2.html"


//商品详情中的商品加入购物车
#define KGoodShop_ShopDetail_AddShopList_Url @"https://www.rongtuojinrong.com/qdy/wap/cart-add_client-goods.html"
//商品详情中的商品加入收藏
#define KGoodShop_ShopDetail_AddFavirist_Url @"https://www.rongtuojinrong.com/qdy/wap/member/add_fav_client.html"
//商品详情中的商品从收藏中移除
#define KGoodShop_ShopDetail_DelFavirist_Url @"https://www.rongtuojinrong.com/qdy/wap/member/del_fav_client.html"

//确认订单中的管理收货地址
#define KGoodShop_ManageDress @"https://www.rongtuojinrong.com/qdy/wap/member-receiver_client.html"

//管理收货地址中我的收货地址选择所在地区
#define KGoodShop_ManageDress_MyDress_ChooseArea @"https://www.rongtuojinrong.com/qdy/wap/tools/showarea.html"


//我的订单中的删除某个订单
#define KMyOrder_OrderList_deleteOrder_Url @"https://www.rongtuojinrong.com/qdy/wap/member-delorder_client.html"
//我的订单中的取消某个订单
#define KMyOrder_OrderList_cancelOrder_Url @"https://www.rongtuojinrong.com/qdy/wap/member-canselorder_client.html"
//我的订单中的提醒发货
#define KMyOrder_OrderList_RemindDelivery_Url @"https://www.rongtuojinrong.com/qdy/wap/member-remindsend_client.html"
//我的订单中的确认收货
#define KMyOrder_OrderList_ConfirmOrder_Url @"https://www.rongtuojinrong.com/qdy/wap/member-dofinish_client.html"
//我的订单中的查看某个订单
#define KMyOrder_OrderList_OrderDetail_Url @"https://www.rongtuojinrong.com/qdy/wap/member-orderdetail_client.html"

/**
 *  购物车列表接口
 */
#define KFMShoppingListUrl @"https://www.rongtuojinrong.com/qdy/wap/cart/index_client.html"
/**
 *  购物车删除商品
 */
#define KFMShoppingListDeleteUrl @"https://www.rongtuojinrong.com/qdy/wap/cart-remove_client.html"
/**
 *  购物车更新商品数量
 */
#define KFMShoppingListUpdateNumberUrl @"https://www.rongtuojinrong.com/qdy/wap/cart-update.html"
/**
 *  分享(购物车、收藏等～等通用)
 */
//https://www.rongtuojinrong.com/qdy/wap/product/share/14106.html
#define KFMListShareUrl @"https://www.rongtuojinrong.com/qdy/jili/index.php/home/login/shareallpro"
/**
 *  收藏列表接口
 */
#define KFMFavoriteListUrl @"https://www.rongtuojinrong.com/qdy/wap/member/favorite_client.html"
/**
 *  收藏删除
 */
#define KFMFavoriteListDeleteUrl @"https://www.rongtuojinrong.com/qdy/wap/member/del_fav_client.html"
/**
 *  设置(优惠券\红包)
 */
#define KFMSettingsUrl @"https://www.rongtuojinrong.com/qdy/wap/member-coupon.html"
/**
 *  购物车凑单
 */
#define KFMGatherUrl @"https://www.rongtuojinrong.com/qdy/wap/cart-fororder_client.html"


#endif /* FMGoodShopURL_h */
