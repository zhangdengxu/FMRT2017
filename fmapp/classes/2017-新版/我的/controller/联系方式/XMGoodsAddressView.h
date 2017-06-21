//
//  XMGoodsAddressView.h
//  fmapp
//
//  Created by runzhiqiu on 16/2/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGoodsAddressView;
@protocol XMGoodsAddressViewDelegate <NSObject>

@optional

-(void)XMGoodsAddressViewDidOnClickOperateButton:(XMGoodsAddressView *)goodsAddress withInfo:(NSDictionary *)dataInfo;

@end

@interface XMGoodsAddressView : UIView

@property (nonatomic, strong) NSDictionary * datasource;

@property (nonatomic, weak) id <XMGoodsAddressViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *operateButton;

@end
