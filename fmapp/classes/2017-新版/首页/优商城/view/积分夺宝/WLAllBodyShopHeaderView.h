//
//  WLAllBodyShopHeaderView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backGroundButtonBlock)(NSInteger index);
typedef void(^moreBlock)();
@interface WLAllBodyShopHeaderView : UIView
@property (nonatomic,copy) backGroundButtonBlock  headButtonOnClick;
@property (nonatomic,copy) moreBlock  moreBlock;
-(void)changeTableViewHeaderData:(NSArray *)banner Withscrolling_message:(NSArray *)message;

@end
