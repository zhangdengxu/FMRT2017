//
//  FMMessageAlterView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMMessageAlterViewDelegate <NSObject>

@required
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^dismissWithOperation)();

typedef NS_ENUM(NSUInteger, FMMessageAlterViewDirection) {
    kFMMessageAlterViewDirectionLeft = 1,
    kFMMessageAlterViewDirectionRight
};

@interface FMMessageAlterView : UIView

@property (nonatomic, weak) id<FMMessageAlterViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;

//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(FMMessageAlterViewDirection)direction;

//弹出
- (void)pop;
//消失
- (void)dismiss;

@end


@interface FMMessageModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isRedSpot;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName isShowRed:(BOOL)isRedSpot;

@end