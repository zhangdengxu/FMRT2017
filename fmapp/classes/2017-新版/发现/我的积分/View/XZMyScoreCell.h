//
//  XZMyScoreCell.h
//  fmapp
//
//  Created by admin on 17/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZMyScoreGoodsModel;
@interface XZMyScoreCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

/** model */
@property (nonatomic, strong) XZMyScoreGoodsModel *modelMyScore;

@end
