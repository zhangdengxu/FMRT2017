//
//  FMTradeTableViewFooter.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTradeTableViewFooter.h"
#import "XZMyOrderModel.h"

#define kDarkGrayTextColor XZColor(48, 48, 48)
#define kLightGrayTextColor XZColor(143, 143, 143)

@interface FMTradeTableViewFooter()<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrInfo;
@property (nonatomic, strong) NSMutableArray *arrNumber;
@property (nonatomic, strong) UIView *whiteViewDetail;
///** 运费视图 */
//@property (nonatomic, strong) UILabel *carriageMoney;
////* 积分抵扣右侧视图 
//@property (nonatomic, strong) UILabel *integralMoney;
///** 实付款右侧按钮 */
//@property (nonatomic, strong) UILabel *totalMoney;
///** 返积分多少的label */
//@property (nonatomic, strong)UILabel *labelIntegral;

@end

@implementation FMTradeTableViewFooter
- (NSMutableArray *)arrInfo {
    if (!_arrInfo) {
//        _arrInfo = [NSMutableArray arrayWithObjects:@"订单编号：",@"支付交易号：",@"创建时间：",@"付款时间：",@"成交时间：", nil];
          _arrInfo = [NSMutableArray array];
    }
    return _arrInfo;
}
- (NSMutableArray *)arrNumber {
    if (!_arrNumber) {
        _arrNumber = [NSMutableArray array];
        
//        NSArray *arr = @[self.footerVModel.order_id,self.footerVModel.payNum,self.footerVModel.createtime,self.footerVModel.paytime,self.footerVModel.delivTime,self.footerVModel.finishtime];
        
//        _arrNumber = [NSMutableArray arrayWithObjects:self.footerVModel.order_id,self.footerVModel.payNum,self.footerVModel.createtime,self.footerVModel.paytime,self.footerVModel.finishtime, nil];
        if (self.footerVModel.order_id != nil && self.footerVModel.order_id.length > 0) {
            [self.arrInfo addObject:@"订单编号："];
            [_arrNumber addObject:self.footerVModel.order_id];
        }
        if (self.footerVModel.payNum != nil && self.footerVModel.payNum.length > 0) {
            [self.arrInfo addObject:@"支付交易："];
            [_arrNumber addObject:self.footerVModel.payNum];
        }
        if (self.footerVModel.createtime != nil && self.footerVModel.createtime.length > 0) {
            [self.arrInfo addObject:@"创建时间："];
            [_arrNumber addObject:self.footerVModel.createtime];
        }
        if (self.footerVModel.paytime != nil && self.footerVModel.paytime.length > 0) {
            [self.arrInfo addObject:@"付款时间："];
            [_arrNumber addObject:self.footerVModel.paytime];
        }
        if (self.footerVModel.send_time != nil && self.footerVModel.send_time.length > 0) {
            [self.arrInfo addObject:@"发货时间："];
            [_arrNumber addObject:self.footerVModel.send_time];
        }
        if (self.footerVModel.finishtime != nil && self.footerVModel.finishtime.length > 0) {
            if (![self.footerVModel.finishtime isEqualToString:@"1970-01-01 08:00:00"]) {
                [self.arrInfo addObject:@"成交时间："];
                [_arrNumber addObject:self.footerVModel.finishtime];
            }
        }
    }
    return _arrNumber;
}

- (instancetype)initWithorderModel:(FMOrderDetailGoodsModel *)headerModel;
{
    self = [super init];
    if (self) {
        _footerVModel = headerModel;
        self.backgroundColor = XZColor(235, 235, 242);
        CGFloat origin_Y = 0;
        
        UIView *viewCost = [[UIView alloc]init];
        [self addSubview:viewCost];
        [viewCost mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@80);
        }];
        viewCost.backgroundColor = [UIColor whiteColor];
#pragma mark ---- 费用的view
        /** 运费 */
        UILabel *labelCarriage = [[UILabel alloc]init];
        [viewCost addSubview:labelCarriage];
        [labelCarriage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewCost.mas_left).offset(10);
            make.top.equalTo(viewCost.mas_top).offset(10);
        }];
        labelCarriage.textColor = kDarkGrayTextColor;
        labelCarriage.font = [UIFont systemFontOfSize:14];
        /** 积分抵扣 */
        UILabel *labelIntegralReduce = [[UILabel alloc]init];
        [viewCost addSubview:labelIntegralReduce];
        [labelIntegralReduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelCarriage.mas_left);
            make.top.equalTo(labelCarriage.mas_bottom).offset(5);
        }];
        labelIntegralReduce.textColor = kDarkGrayTextColor;
        labelIntegralReduce.font = [UIFont systemFontOfSize:14];
        
        /** 优惠券抵扣 */     // 已隐藏
        UILabel *labelCoupons = [[UILabel alloc]init];
        [viewCost addSubview:labelCoupons];
        [labelCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelIntegralReduce.mas_left);
            make.top.equalTo(labelIntegralReduce.mas_bottom).offset(5);
        }];
        labelCoupons.textColor = kDarkGrayTextColor;
        labelCoupons.font = [UIFont systemFontOfSize:14];

        
        /** 实付款 */
        UILabel *labelPayment = [[UILabel alloc]init];
        [viewCost addSubview:labelPayment];
        labelPayment.textColor = kDarkGrayTextColor;
        labelPayment.text = @"实付款(含运费)";
        labelPayment.font = [UIFont systemFontOfSize:15];
        /*
         self.carriageMoney.text = [NSString stringWithFormat:@"￥%.2f",[footerVModel.cost_shipping floatValue]];// 运费
         self.integralMoney.text = [NSString stringWithFormat:@"-￥%.2f",[footerVModel.score_u floatValue]];// 积分抵扣
         self.totalMoney.text = [NSString stringWithFormat:@"￥%.2f",[footerVModel.total_amount floatValue]];// 实付款
         self.labelIntegral.text =  [NSString stringWithFormat:@"返积分%.1f点",[footerVModel.score_g floatValue]];// 返积分
         */
        
        
        UIView * currentView;
        CGFloat viewCostHeight = 0;
        if (![headerModel.cost_shipping isEqualToString:@"0.000"]) {
             labelCarriage.text = @"运费";
            [labelCarriage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewCost.mas_left).offset(10);
                make.top.equalTo(viewCost.mas_top).offset(5);
                make.height.equalTo(@30);
            }];
            /** 运费右侧视图 */
            [self createRightLabelWithSuperView:viewCost centerView:labelCarriage font:15 text:[NSString stringWithFormat:@"￥%.2f",[headerModel.cost_shipping floatValue]] textColor:kDarkGrayTextColor];

            viewCostHeight += 35;
            
            currentView = labelCarriage;
        }
        
        
        if ([headerModel.jifen_discount floatValue] != 0) {
            labelIntegralReduce.text = @"积分抵扣";
            if (currentView) {
                
                [labelIntegralReduce mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(currentView.mas_left);
                    make.top.equalTo(currentView.mas_bottom).offset(5);
                    make.height.equalTo(@30);

                }];
            }
            /** 积分抵扣右侧视图 */
            [self createRightLabelWithSuperView:viewCost centerView:labelIntegralReduce font:15 text:[NSString stringWithFormat:@"-￥%.2f",[headerModel.jifen_discount floatValue]] textColor:kDarkGrayTextColor];
            currentView = labelIntegralReduce;
            
            viewCostHeight += 35;
        }
        
        
        if ([headerModel.quan_discount floatValue] != 0) {
            labelCoupons.text = @"优惠券抵扣";
            if (currentView) {
                
                [labelCoupons mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(currentView.mas_left);
                    make.top.equalTo(currentView.mas_bottom).offset(5);
                    make.height.equalTo(@30);

                }];
            }
            
            /** 优惠券抵扣右侧视图 */
            [self createRightLabelWithSuperView:viewCost centerView:labelCoupons font:15 text:[NSString stringWithFormat:@"-￥%.2f",[headerModel.quan_discount floatValue]] textColor:kDarkGrayTextColor];
            viewCostHeight += 35;
            
            currentView = labelCoupons;

        }
        if (currentView) {
            [labelPayment  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(currentView.mas_left);
                make.top.equalTo(currentView.mas_bottom).offset(5);
                make.height.equalTo(@35);
                
            }];

        }else
        {
            [labelPayment  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewCost.mas_left).offset(10);
                make.top.equalTo(viewCost.mas_top).offset(10);
            }];
        }
       
        viewCostHeight += 45;

        if (![headerModel.order_type isMemberOfClass:[NSNull class]] &&[headerModel.order_type integerValue] > 0) {
            [self createRightLabelWithSuperView:viewCost centerView:labelPayment font:18 text:[NSString stringWithFormat:@"%zi积分",[headerModel.used_jifen integerValue]] textColor:[UIColor redColor]];
        }else
        {
            [self createRightLabelWithSuperView:viewCost centerView:labelPayment font:18 text:[NSString stringWithFormat:@"￥%.2f",[headerModel.total_amount floatValue]] textColor:[UIColor redColor]];
        }

        
        [viewCost remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(viewCostHeight);
        }];

        origin_Y += viewCostHeight;

//        if ([headerModel.cost_shipping isEqualToString:@"0.000"]) {// 运费为0
//            labelCarriage.text = @"";
//            if ([headerModel.jifen_discount floatValue] == 0) {// 积分为0
//                labelIntegralReduce.text = @"";
//                [viewCost remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.mas_left);
//                    make.right.equalTo(self.mas_right);
//                    make.top.equalTo(self.mas_top);
//                    make.height.equalTo(@40);
//                }];
//                origin_Y = origin_Y + 40;
//            }else { // 积分不为0
//                labelIntegralReduce.text = @"积分抵扣";
//                [viewCost remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.mas_left);
//                    make.right.equalTo(self.mas_right);
//                    make.top.equalTo(self.mas_top);
//                    make.height.equalTo(@60);
//                }];
//                /** 积分抵扣右侧视图 */
//                [self createRightLabelWithSuperView:viewCost centerView:labelIntegralReduce font:15 text:[NSString stringWithFormat:@"-￥%.2f",[headerModel.jifen_discount floatValue]] textColor:kDarkGrayTextColor];
//                origin_Y = origin_Y + 60;
//            }
//        }else { // 运费不为0
//            labelCarriage.text = @"运费";
//            /** 运费右侧视图 */
//            [self createRightLabelWithSuperView:viewCost centerView:labelCarriage font:15 text:[NSString stringWithFormat:@"￥%.2f",[headerModel.cost_shipping floatValue]] textColor:kDarkGrayTextColor];
//            if ([headerModel.jifen_discount floatValue] == 0) {// 积分为0
//                [viewCost remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.mas_left);
//                    make.right.equalTo(self.mas_right);
//                    make.top.equalTo(self.mas_top);
//                    make.height.equalTo(@60);
//                }];
//                origin_Y = origin_Y + 60;
//            }else { // 积分不为0
//                labelIntegralReduce.text = @"积分抵扣";
//                /** 积分抵扣右侧视图 */
//                [self createRightLabelWithSuperView:viewCost centerView:labelIntegralReduce font:15 text:[NSString stringWithFormat:@"-￥%.2f",[headerModel.jifen_discount floatValue]] textColor:kDarkGrayTextColor];
//                origin_Y = origin_Y + 80;
//            }
//        }
        
//        [self createRightLabelWithSuperView:viewCost centerView:labelCoupons font:15 text:@"-￥3.00" textColor:kDarkGrayTextColor];
        /** 实付款右侧按钮 */
        
#pragma mark ---- 积分
        UIView *viewIntegral = [[UIView alloc]init];
        [self addSubview:viewIntegral];
        [viewIntegral mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(viewCost.mas_bottom).offset(1);
            make.height.equalTo(@44);
        }];
        origin_Y = origin_Y + 45;
        viewIntegral.backgroundColor = [UIColor whiteColor];
        // 积分
        UIButton *btnIntegral = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewIntegral addSubview:btnIntegral];
        [btnIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewIntegral.mas_left).offset(10);
            make.centerY.equalTo(viewIntegral.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@45);
        }];
        btnIntegral.backgroundColor = XZColor(246, 81, 27);
        [btnIntegral setTitle:@"积分" forState:UIControlStateNormal];
        btnIntegral.titleLabel.font = [UIFont systemFontOfSize:14];
        btnIntegral.userInteractionEnabled = NO;
        // 返积分多少的label
        UILabel *labelIntegral = [[UILabel alloc]init];
        [viewIntegral addSubview:labelIntegral];
        [labelIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnIntegral.mas_right).offset(15);
            make.centerY.equalTo(btnIntegral.mas_centerY);
        }];
        labelIntegral.text = [NSString stringWithFormat:@"返积分%.0f点",[headerModel.score_g floatValue]];
        labelIntegral.font = [UIFont systemFontOfSize:15];
        labelIntegral.textColor = kDarkGrayTextColor;
        
#pragma mark ---- 联系商家，拨打电话
        UIView *viewContact = [[UIView alloc]init];
        [self addSubview:viewContact];
        [viewContact mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(viewIntegral.mas_bottom).offset(1);
            make.height.equalTo(@60);
        }];
        origin_Y = origin_Y + 61;
        viewContact.backgroundColor = [UIColor whiteColor];
        // 联系商家
        UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewContact addSubview:btnContact];
        [btnContact mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewContact.mas_left).offset(10);
            make.centerY.equalTo(viewContact.mas_centerY);
            make.right.equalTo(viewContact.mas_centerX).offset(-10);
            make.height.equalTo(@40);
        }];
        [btnContact setTitle:@" 联系商家" forState:UIControlStateNormal];
        [btnContact setImage:[[UIImage imageNamed:@"小电话"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btnContact setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        btnContact.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        btnContact.layer.borderWidth = 1.0f;
        [btnContact addTarget:self action:@selector(didClickContactAction:) forControlEvents:UIControlEventTouchUpInside];
        // 拨打电话
        UIButton *btnPhoneCall = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewContact addSubview:btnPhoneCall];
        [btnPhoneCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewContact.mas_centerX).offset(10);
            make.centerY.equalTo(viewContact.mas_centerY);
            make.right.equalTo(viewContact.mas_right).offset(-10);
            make.height.equalTo(@40);
        }];
        [btnPhoneCall setTitle:@" 拨打电话" forState:UIControlStateNormal];
        [btnPhoneCall setImage:[[UIImage imageNamed:@"小小电话"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btnPhoneCall setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        btnPhoneCall.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        btnPhoneCall.layer.borderWidth = 1.0f;
        [btnPhoneCall addTarget:self action:@selector(didClickPhoneCallAction:) forControlEvents:UIControlEventTouchUpInside];
        //======================================
        
        UIView * whiteViewDetail = [[UIView alloc]initWithFrame:CGRectMake(0, origin_Y + 10, KProjectScreenWidth, self.arrNumber.count * 35 + 10)];
        whiteViewDetail.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteViewDetail];
        _whiteViewDetail = whiteViewDetail;
        origin_Y = origin_Y + self.arrNumber.count * 35 + 10;
//        NSLog(@"self.arrNumber.count = %lu", (unsigned long)self.arrNumber.count);
        for (int i = 0; i < self.arrNumber.count; i++) {
            if (self.arrNumber[i] == nil) {
                continue;
            }
//            else if ([self.footerVModel.finishtime isEqualToString:@"1970-01-01 08:00:00"]) {
//                continue;
//            }
            /** 支付交易号 */
            [self createLabelWithNumber:i withWhiteView:whiteViewDetail];
        }
        /** 复制按钮 */
        UIButton *btnCopy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [whiteViewDetail addSubview:btnCopy];
        [btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteViewDetail.mas_top).offset(8);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@80);
            make.height.equalTo(@22);
        }];
        
        [btnCopy setTitle:@"复制" forState:UIControlStateNormal];
        [btnCopy setTitleColor:kLightGrayTextColor forState:UIControlStateNormal];
        btnCopy.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        [btnCopy addTarget:self action:@selector(didClickCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
        btnCopy.layer.borderWidth = 1.0f;
        
        
        //=========================
        origin_Y = origin_Y + 10;
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, origin_Y);
    }
    return self;

}

// 创建左侧label
- (void)createLabelWithNumber:(int)number withWhiteView:(UIView *)whiteView
{
    UILabel *labelPaymentTrade = [[UILabel alloc]init];
    [whiteView addSubview:labelPaymentTrade];
    [labelPaymentTrade mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left).offset(10);
        make.top.equalTo(whiteView.mas_top).offset(35 * number + 10);
        make.height.equalTo(25);
    }];
    labelPaymentTrade.textColor = kLightGrayTextColor;
    labelPaymentTrade.text = self.arrInfo[number];
    labelPaymentTrade.font = [UIFont systemFontOfSize:14];
    // 编号
    UILabel *labelPaymentNumber = [[UILabel alloc]init];
    [whiteView addSubview:labelPaymentNumber];
    labelPaymentNumber.numberOfLines = 2;
    [labelPaymentNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPaymentTrade.mas_right);
        make.centerY.equalTo(labelPaymentTrade.mas_centerY);
    }];
    labelPaymentNumber.textColor = kLightGrayTextColor;
    labelPaymentNumber.text = self.arrNumber[number];
    labelPaymentNumber.font = [UIFont systemFontOfSize:14];
}

- (UILabel *)createRightLabelWithSuperView:(UIView *)superView  centerView:(UIView *)centerView font:(CGFloat)font text:(NSString *)text  textColor:(UIColor *)color{
    UILabel *labelCarriageM = [[UILabel alloc]init];
    [superView addSubview:labelCarriageM];
    [labelCarriageM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-10);
        make.centerY.equalTo(centerView.mas_centerY);
    }];
    labelCarriageM.textColor = color;
    labelCarriageM.text = text;
    labelCarriageM.font = [UIFont systemFontOfSize:font];
    return labelCarriageM;
}

// 点击联系商家按钮
- (void)didClickContactAction:(UIButton *)button {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        //老版QQ  2718534215  840772463
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self addSubview:webView];
        
    }else{
        
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"打开客服提醒" message:@"您尚未安装QQ，请安装QQ后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
        
    }
}
// 点击拨打电话按钮
- (void)didClickPhoneCallAction:(UIButton *)button {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-878-8686"]];
}

- (void)didClickCopyBtn:(UIButton *)button {
    if (self.blockCopyBtn) {
        self.blockCopyBtn(button);
    }
}
//// 给View赋值
//- (void)setFooterVModel:(FMOrderDetailGoodsModel *)footerVModel {
//    _footerVModel = footerVModel;
//    self.arrNumber = [NSMutableArray arrayWithObjects:footerVModel.order_id,footerVModel.payNum,footerVModel.createtime,footerVModel.paytime,footerVModel.delivTime,footerVModel.finishtime, nil];
////    self.labelCarriage.text = footerVModel.cost_shipping;// 运费
////    self.labelPayment.text = footerVModel.total_amount;// 实付款
////    self.labelIntegral.text = footerVModel.score_g;// 返积分
////    self.labelIntegralReduce.text = footerVModel.score_u;// 积分抵扣
//    
////    int number = 1;
////    for (NSString *str in self.arrNumber) {
////        if (str != nil) {
////            number = number + 1;
////        }
////    }
//    NSLog(@"number = %ld,arrNumber = %@",(unsigned long)self.arrNumber.count,self.arrNumber);
//    for (int i = 0; i < self.arrNumber.count; i++) {
//        /** 支付交易号 */
//        [self createLabelWithNumber:i withWhiteView:_whiteViewDetail];
//    }
//   
//}

@end
