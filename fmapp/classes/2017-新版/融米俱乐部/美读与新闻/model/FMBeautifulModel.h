//
//  FMBeautifulModel.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMBeautifulModel : NSObject

@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *author;

@property (nonatomic,copy) NSString *classone;
@property (nonatomic,copy) NSString *news_id;
@property (nonatomic,copy) NSString *recommend_app_first;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *videoPath;
@property (nonatomic,copy) NSString *videoThumb;


@property (nonatomic,copy) NSString *keyString;
- (NSMutableArray *)dataArrayFromArachiver;
- (void)saveUserObjectWithUser:(NSMutableArray *)dataArray;

@end
