//
//  XZOneMoreAgainModel.h
//  fmapp
//
//  Created by admin on 16/6/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol  OneMoreAgainDelegate <NSObject>

@optional

-(void)oneOrderAgainWithProductID:(NSString *)productID;

@end

// 首先创建一个实现了JSExport协议的协议
@protocol OneMoreAgainProtocol <JSExport>

-(void)oneMoreOrderAgainWithProductID:(NSString *)productID;

@end

// 让我们创建的类实现上边的协议
@interface XZOneMoreAgainModel : NSObject<OneMoreAgainProtocol>
@property (nonatomic, weak) id <OneMoreAgainDelegate> delegate;
@end
