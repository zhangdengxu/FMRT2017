//
//  FMRTCircleView.h
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, MYHCircleManageViewType) {
    MYHCircleManageViewTypeArc, //圆弧
    MYHCircleManageViewTypeRound //圆
};
@interface FMRTCircleView : UIView

@property(nonatomic , assign) CGRect fFrame;
@property(nonatomic , strong) NSMutableArray *dataArray; //数据数组
@property(nonatomic , assign) CGFloat circleRadius;//半径
//初始化
-(instancetype)initWithFrame:(CGRect)frame andWithDataArray:(NSArray *)dataArr andWithCircleRadius:(CGFloat)circleRadius type:(MYHCircleManageViewType)type;

@property (nonatomic, assign)NSInteger hasZheXian;

@end
