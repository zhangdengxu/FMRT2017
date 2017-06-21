//
//  FMShopCommentModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMShopCommentModel : NSObject
//

@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *order_id;

@property (nonatomic,copy) NSString *comment_id;
@property (nonatomic,copy) NSString *good_id;
@property (nonatomic,copy) NSString *product_id;

@property (nonatomic,strong) NSURL* avatar;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,strong) NSArray* imgs;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSNumber *statusID;
@property (nonatomic,copy) NSString* shopCommentFirst;
@property (nonatomic,copy) NSArray* likeList;
@property (nonatomic,strong) NSNumber * statusGrade;

//二次回复
@property (nonatomic,copy) NSString *secondContent;
@property (nonatomic,strong) NSArray* secondImgs;
@property (nonatomic,copy) NSString* shopCommentSecond;


+(instancetype)createFMShopCommentModelWithDictionary:(NSDictionary *)dict;
+(instancetype)createFMShopCommentModelWithShopDetailDictionary:(NSDictionary *)dict;
@end
