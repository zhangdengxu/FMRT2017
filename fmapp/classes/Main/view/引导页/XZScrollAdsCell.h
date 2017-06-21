//
//  XZScrollAdsCell.h
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class XZScrollAdsModel;
@interface XZScrollAdsCell : UICollectionViewCell
@property (nonatomic, strong) NSString *modelPicUrl;
@property (nonatomic, copy) void(^blockJumpButton)(UIButton *);

@property (nonatomic, assign) BOOL isHiddenJumpBtn;

@end
