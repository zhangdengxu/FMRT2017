//
//  FMCommentLayout.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "LWLayout.h"
@class FMShopCommentModel;
@interface FMCommentLayout : LWLayout

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,copy) NSArray * imagePostionArray;
@property (nonatomic,copy) NSArray * imagePostionSecondArray;
@property (nonatomic,strong) FMShopCommentModel * statusModel;


- (id)initWithContainer:(LWStorageContainer *)container
            statusModel:(FMShopCommentModel *)statusModel
                  index:(NSInteger)index;

@end
