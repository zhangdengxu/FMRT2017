//
//  FMSendCommentModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSendCommentModel : NSObject

@property (nonatomic,copy) NSString *product_id;

@property (nonatomic,copy) NSString *commentString;
@property (nonatomic,copy) NSString *shopImage;
@property (nonatomic, strong) NSMutableArray * imageArray;



@property (nonatomic, assign) NSInteger similarShop;

@property (nonatomic, assign) NSInteger sendSpeed;

@property (nonatomic, assign) NSInteger serveGrade;

//是否匿名
@property (nonatomic, assign) BOOL isAnonymous;
@end
