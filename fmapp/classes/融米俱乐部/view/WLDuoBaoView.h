//
//  WLDuoBaoView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^theLinkBlock)(NSString *url);
@interface WLDuoBaoView : UIView

@property (nonatomic, weak) UIView * backgroundView;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *lianjie;
@property (nonatomic, copy)theLinkBlock block;

-(void)hiddenSignView;
- (instancetype)initWithPic:(NSString *)pic andUrl:(NSString *)lianjie;
@end
