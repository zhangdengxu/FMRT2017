//
//  FMRTWellStoreCollectionModel.h
//  fmapp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTWellStoreCollectionModel : NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;

+(NSArray *)dataSource;
+(NSArray *)dataArr;


@end
