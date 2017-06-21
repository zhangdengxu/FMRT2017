//
//  HTTPClient+Interaction.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (RoadCondition)

///首页轮播
- (void)getFirstViewTopImagesWithcompletion:(WebAPIRequestCompletionBlock)completion;
///零钱罐
- (void)getLingQianGuanWithcompletion:(WebAPIRequestCompletionBlock)completion;

- (void)getLingAlerDataWithcompletion:(WebAPIRequestCompletionBlock)completion;

///我的零钱罐
- (void)getMyLingQianGuanWithcompletion:(WebAPIRequestCompletionBlock)completion;


@end
