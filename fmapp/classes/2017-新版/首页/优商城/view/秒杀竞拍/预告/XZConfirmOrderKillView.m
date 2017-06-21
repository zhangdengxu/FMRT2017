//
//  XZConfirmOrderKillView.m
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZConfirmOrderKillView.h"
#import "XZConfirmOrderModel.h"
#import "XZShoppingOrderAddressModel.h"

#import "FMShopSpecModel.h"

@interface XZConfirmOrderKillView ()
/** 收货人 */
@property (nonatomic, strong) UILabel *labelUserName;
/** 收货人电话 */
@property (nonatomic, strong) UILabel *labelPhoneNumber;
/** 收货地址 */
@property (nonatomic, strong) UILabel *labelAdress;
@property (nonatomic, strong) UIView *tableHeaderHadAddress;
@property (nonatomic, strong) UIView *tableHeader;
@end

@implementation XZConfirmOrderKillView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置ConfirmOrderView子视图
        [self tableConfirmOrderViewHeaderViewNoDefaultAddress];
        [self tableConfirmOrderViewHeaderView];
    }
    return self;
}

/** 请选择地址 */
- (void)tableConfirmOrderViewHeaderViewNoDefaultAddress {
    UIView *tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)];
    [self addSubview:tableHeader];
    self.tableHeader = tableHeader;
    tableHeader.backgroundColor = [UIColor whiteColor];

    // 添加新地址按钮
    UIButton *addNewAdress = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeader addSubview:addNewAdress];
    [addNewAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeader.mas_centerY);
        make.centerX.equalTo(tableHeader.mas_centerX);
    }];
    [addNewAdress setImage:[UIImage imageNamed:@"添加新地址顶部按钮_03"] forState:UIControlStateNormal];
    [addNewAdress setTitle:@" 请选择地址" forState:UIControlStateNormal];
    [addNewAdress.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [addNewAdress setTitleColor:XZColor(245, 75, 22) forState:UIControlStateNormal];
    [addNewAdress.titleLabel setFont:[UIFont systemFontOfSize:15]];
    /** 整体覆盖的button */
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeader addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeader.mas_left);
        make.right.equalTo(tableHeader.mas_right);
        make.bottom.equalTo(tableHeader.mas_bottom).offset(-8);
        make.top.equalTo(tableHeader.mas_top);
    }];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickChooseAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    // 灰色线条
    UIView *line =  [[UIView alloc]initWithFrame:CGRectMake(0, 78, KProjectScreenWidth, 8)];
    [tableHeader addSubview:line];
    line.backgroundColor = KDefaultOrBackgroundColor;
}


/** 收货人 */
- (void)tableConfirmOrderViewHeaderView {
    UIView *tableHeaderHadAddress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)];
    [self addSubview:tableHeaderHadAddress];
    tableHeaderHadAddress.backgroundColor = [UIColor whiteColor];
    self.tableHeaderHadAddress = tableHeaderHadAddress;
    /** 收货人 */
    UILabel *labelUserName = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderHadAddress.mas_top).offset(10);
        make.left.equalTo(tableHeaderHadAddress.mas_left).offset(40);
        make.right.equalTo(tableHeaderHadAddress.mas_centerX).offset(30);
    }];
    self.labelUserName = labelUserName;
    labelUserName.font = [UIFont systemFontOfSize:15];
    /** 收货人电话 */
    UILabel *labelPhoneNumber = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelPhoneNumber];
    [labelPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelUserName.mas_top);
        make.left.equalTo(labelUserName.mas_right);
        make.right.equalTo(tableHeaderHadAddress.mas_right).offset(-10);
    }];
    self.labelPhoneNumber = labelPhoneNumber;
    labelPhoneNumber.font = [UIFont systemFontOfSize:15];
    labelPhoneNumber.textAlignment = NSTextAlignmentRight;
    //  图片
    UIImageView *imgAdress = [[UIImageView alloc]init];
    [tableHeaderHadAddress addSubview:imgAdress];
    [imgAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderHadAddress.mas_left).offset(10);
        make.top.equalTo(labelUserName.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@20);
    }];
    imgAdress.image = [UIImage imageNamed:@"确认订单页面（地址按钮）_03"];
    /** 收货地址 */
    UILabel *labelAdress = [[UILabel alloc]init];
    [tableHeaderHadAddress addSubview:labelAdress];
    [labelAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgAdress.mas_top);
        make.left.equalTo(imgAdress.mas_right).offset(10);
        make.right.equalTo(labelPhoneNumber.mas_right).offset(-20);
    }];
    self.labelAdress = labelAdress;
    labelAdress.font = [UIFont systemFontOfSize:14];
    labelAdress.numberOfLines = 2;
    //  地址信息
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderHadAddress addSubview:btnDetail];
    [btnDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelAdress.mas_right).offset(5);
        make.top.equalTo(labelAdress.mas_top).offset(8);
        make.height.equalTo(@15);
        make.width.equalTo(@8);
    }];
    [btnDetail setBackgroundImage:[UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"] forState:UIControlStateNormal];
    // 覆盖的button
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderHadAddress addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderHadAddress.mas_left);
        make.top.equalTo(imgAdress.mas_top);
        make.right.equalTo(tableHeaderHadAddress.mas_right);
        make.bottom.equalTo(labelAdress.mas_bottom);
    }];
    coverBtn.tag = 107;
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(didClickChooseAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    // 灰色线条
    UIView *line =  [[UIView alloc]initWithFrame:CGRectMake(0, 78, KProjectScreenWidth, 8)];
    [tableHeaderHadAddress addSubview:line];
    line.backgroundColor = KDefaultOrBackgroundColor;
}


// 点击地址信息按钮
- (void)didClickChooseAddressBtn {
    if (self.blockChooseAddress) {
        self.blockChooseAddress();
    }
}

#pragma mark - 给确认订单界面通过模型赋值
- (void)sendDataWithModel:(XZShoppingOrderAddressModel *)model {
    if (model.name.length == 0) { // 没有地址或者没有默认地址
        self.tableHeader.hidden = NO;
        self.tableHeaderHadAddress.hidden = YES;
    }else { // 有默认地址
        self.tableHeader.hidden = YES;
        self.tableHeaderHadAddress.hidden = NO;
        self.labelUserName.text = [NSString stringWithFormat:@"收货人: %@",model.name];
        self.labelPhoneNumber.text = model.mobile;// 手机号
        if (self.labelPhoneNumber.text == nil) {
            self.labelPhoneNumber.text = model.tel;// 座机号
        }

        NSArray *areaArr = [model.area componentsSeparatedByString:@":"];
        if (areaArr.count > 1) { // 有地址编码
            self.labelAdress.text = [NSString stringWithFormat:@"收货地址：%@ %@",areaArr[1],model.addr];
        }else {
            self.labelAdress.text = [NSString stringWithFormat:@"收货地址：%@ %@",areaArr[0],model.addr];
        }
    }
}

- (void)setModelProduct:(FMSelectShopInfoModel *)modelProduct {
    Log(@"%@---------%@--------%@",modelProduct.phone,modelProduct.address,modelProduct.recipients);
    if (![modelProduct.address isMemberOfClass:[NSNull class]]&&modelProduct.address) { // 前一个页面传值
        self.tableHeader.hidden = YES;
        self.tableHeaderHadAddress.hidden = NO;
        self.labelAdress.text = [NSString stringWithFormat:@"%@", modelProduct.address];
        self.labelUserName.text = [NSString stringWithFormat:@"%@", modelProduct.recipients];
        self.labelPhoneNumber.text = [NSString stringWithFormat:@"%@", modelProduct.phone];
     }else {
        self.tableHeader.hidden = NO;
        self.tableHeaderHadAddress.hidden = YES;
    }
}

@end
