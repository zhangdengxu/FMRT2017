//
//  XMCalenderViewItem.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/25.
//  Copyright © 2016年 yk. All rights reserved.

//@property (nonatomic, strong) NSNumber * dayNumber;
//@property (nonatomic, assign) BOOL isShowbackImage;
//@property (nonatomic, assign) BOOL isShowOldMark;
//@property (nonatomic, assign) BOOL isShowRepairSignIn;

#import "XMCalenderViewItem.h"
#import "XMCalenderModel.h"
@interface XMCalenderViewItem ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageSelect;
@property (weak, nonatomic) IBOutlet UILabel *shouDayNumber;
@property (weak, nonatomic) IBOutlet UIImageView *oldSelectDay;
@property (weak, nonatomic) IBOutlet UILabel *repairSignIn;
@property (weak, nonatomic) IBOutlet UIImageView *presentBox;

@end


@implementation XMCalenderViewItem

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"XMCalenderViewItem" owner:self options:nil] lastObject];
//    }
//    return self;
//}
-(void)setModel:(XMCalenderModel *)model
{
    _model = model;
    /**
     *  背景图片
     */
    if (!model.isShowbackImage) {
        self.backImageSelect.hidden = YES;
    }
    
    
   
    /**
     *  显示标记
     */
    if (!model.isShowOldMark) {
        self.oldSelectDay.hidden = YES;
    }else
    {
        if (model.isShowbackImage) {
            self.oldSelectDay.image = [UIImage imageNamed:@"签到对号_03"];
        }else
        {
            self.oldSelectDay.image = [UIImage imageNamed:@"对号_03"];
            
        }
    }
    /**
     *  显示日期
     */
    if (!model.dayNumber) {
        self.shouDayNumber.hidden = YES;
    }else
    {
        self.shouDayNumber.text = [NSString stringWithFormat:@"%@",model.dayNumber];
        if (model.isShowbackImage) {
            self.shouDayNumber.textColor = [UIColor whiteColor];
        }else
        {
            self.shouDayNumber.textColor = [UIColor grayColor];
            
        }
    }
    
    /**
     *  补签
     */
    if (!model.isShowRepairSignIn) {
        self.repairSignIn.hidden = YES;
    }else
    {
        if (model.isShowbackImage) {
            self.repairSignIn.textColor = [UIColor whiteColor];
        }else
        {
            self.repairSignIn.textColor = [UIColor blueColor];
        }
    }
    /**
     *  礼物盒子
     */
    if (!model.isShowPresentBox) {
        self.presentBox.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

@end
