//
//  XZTradeSuccessView.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/27.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZTradeSuccessView.h"

@implementation XZTradeSuccessView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置TradeSuccessView子视图
        [self setUpTradeSuccessView];
    }
    return self;
}

- (void)setUpTradeSuccessView {
    self.backgroundColor = XZColor(235, 235, 242);
    UITableView *tableTradeSuccess = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 50) style:UITableViewStyleGrouped];
    [self addSubview:tableTradeSuccess];
    tableTradeSuccess.sectionFooterHeight = 8;
    tableTradeSuccess.sectionHeaderHeight = 0;
    self.tableTradeSuccess = tableTradeSuccess;
    // 下方追加评价、订单跟踪、删除订单
    [self createAdditionalEvaluationView];
}

// 下方追加评价、订单跟踪、删除订单
- (void)createAdditionalEvaluationView {
    // 整体的view
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 50, KProjectScreenWidth, 50)];
    [self addSubview:payView];
    payView.backgroundColor = [UIColor whiteColor];
    /** 追加评价按钮 */
    UIButton *btnAddEvaluation = [UIButton buttonWithType:UIButtonTypeCustom];
    [payView addSubview:btnAddEvaluation];
    [btnAddEvaluation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payView.mas_right).offset(-10);
        make.centerY.equalTo(payView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    self.btnAddEvaluation = btnAddEvaluation;
    [btnAddEvaluation setTitle:@"追加评价" forState:UIControlStateNormal];
    btnAddEvaluation.backgroundColor = XZColor(6, 41, 125);
    /** 订单跟踪 */
    UIButton *btnOrderTracking = [UIButton buttonWithType:UIButtonTypeCustom];
    [payView addSubview:btnOrderTracking];
    [btnOrderTracking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnAddEvaluation.mas_left).offset(-10);
        make.centerY.equalTo(payView.mas_centerY);
        make.width.equalTo(btnAddEvaluation);
        make.height.equalTo(@30);
    }];
    [btnOrderTracking setTitle:@"订单跟踪" forState:UIControlStateNormal];
    [btnOrderTracking setTitleColor:XZColor(48, 48, 48) forState:UIControlStateNormal];
    btnOrderTracking.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    btnOrderTracking.layer.borderWidth = 1.0f;
    /** 删除订单 */
    UIButton *btnDeleteOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    [payView addSubview:btnDeleteOrder];
    [btnDeleteOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnOrderTracking.mas_left).offset(-10);
        make.centerY.equalTo(payView.mas_centerY);
        make.width.equalTo(btnAddEvaluation);
        make.height.equalTo(@30);
    }];
    [btnDeleteOrder setTitle:@"删除订单" forState:UIControlStateNormal];
    [btnDeleteOrder setTitleColor:XZColor(48, 48, 48) forState:UIControlStateNormal];
    btnDeleteOrder.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    btnDeleteOrder.layer.borderWidth = 1.0f;
}

/** tableView的headerView */
- (UIView *)tableTradeSuccessViewHeaderView {
    UIView *tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 110)];
//    tableHeader.backgroundColor = [UIColor yellowColor];
    /** 交易成功提示图 */
    UIImageView *imgPrompt = [[UIImageView alloc]init];
    [tableHeader addSubview:imgPrompt];
    [imgPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeader.mas_left);
        make.right.equalTo(tableHeader.mas_right);
        make.top.equalTo(tableHeader.mas_top);
        make.height.equalTo(@110);
    }];
    imgPrompt.image = [UIImage imageNamed:@"交易成功"];
    return tableHeader;
}

@end
