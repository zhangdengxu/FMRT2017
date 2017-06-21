//
//  FMShoppingListScanView.h
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveBlock)(NSError * error);

@interface FMShoppingListScanView : UIView

@property (nonatomic, copy) SaveBlock block;

- (instancetype)initWithData:(NSMutableArray *)imageData count:(NSInteger)count withQRImage:(UIImage *)QRImage;

@end
