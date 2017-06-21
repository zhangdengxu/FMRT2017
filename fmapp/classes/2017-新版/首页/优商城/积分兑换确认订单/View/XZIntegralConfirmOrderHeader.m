//
//  XZIntegralConfirmOrderHeader.m
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//  积分确认订单头部地址

#import "XZIntegralConfirmOrderHeader.h"
#import "XZShoppingOrderAddressModel.h"
#import "FMShopSpecModel.h"

@interface XZIntegralConfirmOrderHeader ()
/** 有收货人地址 */
@property (nonatomic, strong) UIView *tableHeaderHadAddress;
/** 没有收货人地址 */
@property (nonatomic, strong) UIView *tableHeaderNoAddress;
/** 收货人 */
@property (nonatomic, strong) UILabel *labelUserName;
/** 收货人电话 */
@property (nonatomic, strong) UILabel *labelPhoneNumber;
/** 收货地址 */
@property (nonatomic, strong) UILabel *labelAdress;

@end


@implementation XZIntegralConfirmOrderHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConfirmPaymentHeader];
    }
    return self;
}

#pragma mark - 给确认订单界面通过模型赋值
- (void)sendDataWithModel:(XZShoppingOrderAddressModel *)model {
    if (model.name.length == 0) { // 没有地址
        self.tableHeaderNoAddress.hidden = NO;
        self.tableHeaderHadAddress.hidden = YES;
    }else { // 有默认地址
        self.tableHeaderNoAddress.hidden = YES;
        self.tableHeaderHadAddress.hidden = NO;
        self.labelUserName.text = [NSString stringWithFormat:@"收货人: %@",model.name];
        if (model.mobile.length == 0) {
            self.labelPhoneNumber.text = model.tel;// 座机号
        }else {
            self.labelPhoneNumber.text = model.mobile;// 手机号
        }
        
        NSArray *areaArr = [model.area componentsSeparatedByString:@":"];
        if (areaArr.count > 1) { // 有地址编码
            self.labelAdress.text = [NSString stringWithFormat:@"收货地址：%@ %@",areaArr[1],model.addr];
        }else {
            self.labelAdress.text = [NSString stringWithFormat:@"收货地址：%@ %@",areaArr[0],model.addr];
        }
    }
}

- (void)setUpConfirmPaymentHeader {
    // 添加有收货人地址的view
    [self headerViewWithUserNameAndNumber];
    
    // 添加有收货人地址的view
    [self headerViewNoDefaultAddress];
}

/** 有收货人地址 */
- (void)headerViewWithUserNameAndNumber {
    // WithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)
    UIView *tableHeaderHadAddress = [[UIView alloc]init];
    [self addSubview:tableHeaderHadAddress];
    [tableHeaderHadAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    tableHeaderHadAddress.backgroundColor = [UIColor whiteColor];
    self.tableHeaderHadAddress = tableHeaderHadAddress;
    /** 收货人 */
    UILabel *labelUserName = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderHadAddress).offset(10);
        make.left.equalTo(tableHeaderHadAddress).offset(35);
        make.right.equalTo(tableHeaderHadAddress.mas_centerX).offset(30);
    }];
    self.labelUserName = labelUserName;
    labelUserName.font = [UIFont systemFontOfSize:15];
    /** 收货人电话 */
    UILabel *labelPhoneNumber = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelPhoneNumber];
    [labelPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelUserName);
        make.left.equalTo(labelUserName.mas_right);
        make.right.equalTo(tableHeaderHadAddress).offset(-10);
    }];
    self.labelPhoneNumber = labelPhoneNumber;
    labelPhoneNumber.font = [UIFont systemFontOfSize:15];
    labelPhoneNumber.textAlignment = NSTextAlignmentRight;
    //  图片
    UIImageView *imgAdress = [[UIImageView alloc]init];
    [tableHeaderHadAddress addSubview:imgAdress];
    [imgAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderHadAddress).offset(10);
        make.top.equalTo(labelUserName.mas_bottom).offset(10);
        make.height.equalTo(@(33 * 0.6));
        make.width.equalTo(@(24 * 0.6));
    }];
    imgAdress.image = [UIImage imageNamed:@"确认订单页面（地址按钮）_03"];
    /** 收货地址 */
    UILabel *labelAdress = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelAdress];
    [labelAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgAdress).offset(5);
        make.left.equalTo(imgAdress.mas_right).offset(10);
        make.right.equalTo(labelPhoneNumber.mas_right).offset(-20);
    }];
    self.labelAdress = labelAdress;
//    labelAdress.textColor = XZColor(102, 102, 102);
    labelAdress.font = [UIFont systemFontOfSize:14];
    labelAdress.numberOfLines = 2;
    //  地址信息
    UIImageView *imageArrow = [[UIImageView alloc] init];
    [tableHeaderHadAddress addSubview:imageArrow];
    [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelPhoneNumber);
        make.top.equalTo(labelAdress).offset(5);
        make.width.equalTo(@(8 * 0.8)); // @(8 * 0.8)
        make.height.equalTo(@(15 * 0.8)); // @(15 * 0.8)
    }];
    imageArrow.image = [UIImage imageNamed:@"右键头"];
    // 覆盖的button
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderHadAddress addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderHadAddress);
        make.top.equalTo(tableHeaderHadAddress);
        make.right.equalTo(tableHeaderHadAddress);
        make.bottom.equalTo(tableHeaderHadAddress);
    }];
    coverBtn.tag = 107;
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickChooseAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    // 灰色线条
    UIView *lineBottom =  [[UIView alloc] initWithFrame:CGRectMake(0, 78, KProjectScreenWidth, 8)];
    [tableHeaderHadAddress addSubview:lineBottom];
    lineBottom.backgroundColor = XZBackGroundColor;
    
}

/** 请选择地址 */
- (void)headerViewNoDefaultAddress {
    // WithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)
    UIView *tableHeaderNoAddress = [[UIView alloc]init];
    [self addSubview:tableHeaderNoAddress];
    [tableHeaderNoAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.tableHeaderNoAddress = tableHeaderNoAddress;
    tableHeaderNoAddress.backgroundColor = [UIColor whiteColor];
    
    // 添加新地址按钮
    UIButton *addNewAdress = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderNoAddress addSubview:addNewAdress];
    [addNewAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeaderNoAddress);
        make.centerX.equalTo(tableHeaderNoAddress);
    }];
    [addNewAdress setImage:[UIImage imageNamed:@"添加新地址顶部按钮_03"] forState:UIControlStateNormal];
    [addNewAdress setTitle:@" 添加新地址" forState:UIControlStateNormal];
    [addNewAdress.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [addNewAdress setTitleColor:XZColor(245, 75, 22) forState:UIControlStateNormal];
    [addNewAdress.titleLabel setFont:[UIFont systemFontOfSize:15]];
    /** 整体覆盖的button */
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderNoAddress addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderNoAddress);
        make.right.equalTo(tableHeaderNoAddress);
        make.bottom.equalTo(tableHeaderNoAddress);
        make.top.equalTo(self);
    }];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickChooseAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    // 灰色线条
    UIView *lineBottom =  [[UIView alloc] initWithFrame:CGRectMake(0, 78, KProjectScreenWidth, 8)];
    [tableHeaderNoAddress addSubview:lineBottom];
    lineBottom.backgroundColor = KDefaultOrBackgroundColor;
}

// 点击地址信息按钮
- (void)didClickChooseAddressBtn {
    if (self.blockChooseAddress) {
        self.blockChooseAddress();
    }
}

@end
