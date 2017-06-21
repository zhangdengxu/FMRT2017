//
//  WLNewProductPushView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^theXinpinBlock)(NSString *xiayibu,NSString *laiyuan,NSString *buttonText);
@interface WLNewProductPushView : UIView

@property(nonatomic,strong)NSDictionary *chanpin;
@property(nonatomic,copy)theXinpinBlock theXinpinBlock;

- (instancetype)initWithDic:(NSDictionary *)chanpin;
-(void)hiddenSignView;

@end
