//
//  FMShopOtherModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMShopOtherModel : NSObject

@property (nonatomic,copy) NSString *imageTitle;
@property (nonatomic,copy) NSString *contentString;

@end


@interface FMShopDetailAudioModel : NSObject

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *audioUrl;

@end



@interface FMShopStandardModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *value;

@end


