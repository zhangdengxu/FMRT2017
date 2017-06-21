//
//  FMRTRebackHeaderView.h
//  fmapp
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMRTRebackMoneyModel;
@interface FMRTRebackHeaderView : UIView

@property (nonatomic, copy)void(^bankBlcok) ();

@property (nonatomic, copy)void(^sureBlcok) (NSInteger txType,NSString* money);

@property (nonatomic, strong)FMRTRebackMoneyModel *model;

@property (nonatomic, copy)NSString *bankName;

//@property (nonatomic, copy)void(^timeBlcok) ();
//@property (nonatomic, copy)void(^bigBlcok) ();


@end
