//
//  FMKeyBoardNumberHeader.h
//  fmapp
//
//  Created by runzhiqiu on 2017/3/28.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^keyBoardDownBlock)();

@interface FMKeyBoardNumberHeader : UIView
@property (nonatomic,copy) keyBoardDownBlock blockKey;

+(instancetype)initKeyBoardNumberHeaderCreate:(keyBoardDownBlock)block;

@end
