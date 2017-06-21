//
//  FMCommentLayoutInMyOrder.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "LWLayout.h"
@class FMShopCommentModel;

@interface FMCommentLayoutInMyOrder : LWLayout

@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,copy) NSArray * imagePostionArray;
@property (nonatomic,copy) NSArray * imagePostionSecondArray;
@property (nonatomic,strong) FMShopCommentModel * statusModel;


- (id)initWithContainer:(LWStorageContainer *)container
            statusModel:(FMShopCommentModel *)statusModel
                  index:(NSInteger)index;
@end
