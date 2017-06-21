//
//  FMShowMenuBottomView.h
//  fmapp
//
//  Created by runzhiqiu on 2017/5/9.
//  Copyright © 2017年 yk. All rights reserved.
//

#define KDefaultMenuHeigh 47.0
#import <UIKit/UIKit.h>


typedef void(^showMenuBottomViewBtnBlock)(NSInteger index);
typedef void(^showMenuBottomViewCloseBtnBlock)();


@interface FMShowMenuBottomView : UIView

-(instancetype)initWithFrameContent:(CGRect)frame WithMenuArray:(NSArray *)menuArray;

-(void)selectMenuIndex:(NSInteger )selectIndex;

@property (nonatomic, strong) NSArray * menuArray;


@property (nonatomic, assign) NSInteger currentSelect;

@property (nonatomic,copy) showMenuBottomViewBtnBlock selectBlock;
@property (nonatomic,copy) showMenuBottomViewCloseBtnBlock closeBlock;

-(void)menuViewHidden;
-(void)menuViewShow;



@end
