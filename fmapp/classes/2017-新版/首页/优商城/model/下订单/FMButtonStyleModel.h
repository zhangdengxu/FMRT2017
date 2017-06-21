//
//  FMButtonStyleModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMButtonStyleModel : NSObject

@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * selectTitleColor;
@property (nonatomic, strong) UIColor * backGroundColor;
@property (nonatomic, strong) UIColor * selectBackGroundColor;
@property (nonatomic,copy) NSString *title;

@property (nonatomic, assign) NSUInteger tag;


@property (nonatomic, assign) CGFloat textFont;
//可不设置
@property (nonatomic, assign) CGRect frame;

@end
