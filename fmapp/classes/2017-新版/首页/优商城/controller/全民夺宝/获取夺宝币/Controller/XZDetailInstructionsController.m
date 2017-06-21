//
//  XZDetailInstructionsController.m
//  fmapp
//
//  Created by admin on 16/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//  详细说明

#import "XZDetailInstructionsController.h"


@interface XZDetailInstructionsController ()
/** 白色视图 */
@property (nonatomic, strong) UIView *viewWhite;
@property (nonatomic, strong) NSArray *arrInstruction;
//@property (nonatomic, strong) NSMutableArray *heightArr;
@end

@implementation XZDetailInstructionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"详细说明"];
    self.view.backgroundColor = XZColor(229, 233, 242);
    self.arrInstruction = @[@"新用户注册成功即可获得5枚夺宝币；",
                            @"融米积分兑换100:1，即原有100积分，可兑换1枚夺宝币；",
                            @"注资活动专标，每充值1000元，送一枚夺宝币，单次存入上限10币；",
                            @"转发活动页面至微信朋友圈，及邀请好友注册成功，均可抽取5-10积分，最高获得夺宝币1枚（每天限领3次），邀请好友不限次数。"
                            ];
//    self.heightArr = [NSMutableArray array];
    // 创建子视图
    [self createChildView];
}

- (void)createChildView {
    /** 白色视图 */
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 240)];
    [self.view addSubview:viewWhite];
    viewWhite.backgroundColor = [UIColor whiteColor];
    self.viewWhite = viewWhite;
//    CGFloat height = 0;
//    for (int i = 0; i < self.arrInstruction.count; i++) {
//        CGFloat height = [self.arrInstruction[i - 1] getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15]].height;
//        NSString *heightStr = [NSString stringWithFormat:@"%.2f",height];
//        [self.heightArr addObject:heightStr];
//        NSLog(@"height = %.0f",height);
//       
//    }
    
    UILabel *labelOne = [self createLabelWithTopView:viewWhite OffSet:25 index:0];
    
    CGFloat height1 = [self.arrInstruction[0] getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15]].height;
    UILabel *lableTwo = [self createLabelWithTopView:labelOne OffSet:(height1 + 15)  index:1];
    
    CGFloat height2 = [self.arrInstruction[1] getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15]].height;
    UILabel *lableThree = [self createLabelWithTopView:lableTwo OffSet:(height2 + 15)  index:2];
    
    CGFloat height3 = [self.arrInstruction[2] getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15]].height;
    [self createLabelWithTopView:lableThree OffSet:(height3 + 15)  index:3];
}

- (UILabel *)createLabelWithTopView:(UIView *)topView OffSet:(CGFloat)offSet index:(int)index {
    /** 数字标注 */
    UILabel *labelNumber = [[UILabel alloc] init];
    [self.viewWhite addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(offSet);
        make.left.equalTo(self.viewWhite).offset(10);
        make.width.equalTo(@15);
        //            make.right.equalTo(viewWhite).offset(-10);
        //            make.bottom.equalTo(viewWhite).offset(-20);
    }];

    labelNumber.font = [UIFont systemFontOfSize:15];
    labelNumber.textColor = XZColor(102, 102, 102);
    labelNumber.text = [NSString stringWithFormat:@"%d.",(index + 1)];
//    labelNumber.backgroundColor = [UIColor greenColor];
    
    /** 说明文字 */
    UILabel *labelInstr = [[UILabel alloc] init];
    [self.viewWhite addSubview:labelInstr];
    [labelInstr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelNumber);
        make.left.equalTo(labelNumber.mas_right);
        make.right.equalTo(self.viewWhite).offset(-10);
    }];
    labelInstr.numberOfLines = 0;
    labelInstr.font = [UIFont systemFontOfSize:15];
    labelInstr.textColor = XZColor(102, 102, 102);
    labelInstr.text = [NSString stringWithFormat:@"%@",self.arrInstruction[index]];
//    labelInstr.backgroundColor = [UIColor redColor];
    return labelInstr;
}

@end
