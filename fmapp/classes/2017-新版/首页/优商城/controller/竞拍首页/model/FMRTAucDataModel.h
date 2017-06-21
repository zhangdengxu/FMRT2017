//
//  FMRTAucDataModel.h
//  fmapp
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTAucDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *aucDataSource;
@property (nonatomic, strong) NSMutableArray *remDataSource;
@property (nonatomic, strong) NSMutableArray *topPhotoArr;
@property (nonatomic, assign) NSInteger currentPage;

@end
