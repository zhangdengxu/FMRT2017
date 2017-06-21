//
//  XZExchangeSuccessfulController.m
//  fmapp
//
//  Created by admin on 16/12/23.
//  Copyright © 2016年 yk. All rights reserved.
//  兑换成功

#import "XZExchangeSuccessfulController.h"
#import "XZDeliveryOwnModel.h" // 自提地址model
#import "FMPlaceOrderViewController.h" // 商品详情

@interface XZExchangeSuccessfulController ()<UIScrollViewDelegate>
// 联系电话
@property (nonatomic, strong) UILabel *labelTelephone;
// 地址
@property (nonatomic, strong) UILabel *labelAddress;
// 自提地址背景
@property (nonatomic, strong) UIView *viewYellow;
// 无自提联系电话
@property (nonatomic, strong) UILabel *labelTelephoneNoRecive;
// 请您于7个工作日内领取
@property (nonatomic, strong) UILabel *labelTimeRecive;
@end

@implementation XZExchangeSuccessfulController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"兑换成功"];
    // 创建页面
    [self createExchangeSuccessfulChildView];
    
    __weak __typeof(&*self)weakSelf = self;
    
    // 点击返回商品详情页
    self.navBackButtonRespondBlock = ^{
        for (UIViewController *vc in weakSelf.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[FMPlaceOrderViewController class]]) {
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
    };

}

- (void)createExchangeSuccessfulChildView {
    // 剪刀手
    UIImageView *imgTop = [[UIImageView alloc] init];
    [self.view addSubview:imgTop];
    [imgTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-8);
        make.top.equalTo(self.view).offset(35);
        make.width.equalTo(120);
        make.height.equalTo(340 * 120 / 366.0);
    }];
    imgTop.image = [UIImage imageNamed:@"活动兑换成功-图标"];
    
    // 恭喜您兑换成功！
    UILabel *labelExchange = [[UILabel alloc] init];
    [self.view addSubview:labelExchange];
    [labelExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(8);
        make.top.equalTo(imgTop.mas_bottom).offset(25);
    }];
    labelExchange.text = @"恭喜您兑换成功！";
    labelExchange.textColor = [HXColor colorWithHexString:@"fe554d"];
    labelExchange.font = [UIFont systemFontOfSize:30.0f];
    
    // 请您于7个工作日内领取
    UILabel *labelTimeRecive = [[UILabel alloc] init];
    [self.view addSubview:labelTimeRecive];
    [labelTimeRecive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(labelExchange.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(KProjectScreenWidth - 40);
    }];
    self.labelTimeRecive = labelTimeRecive;
    labelTimeRecive.textAlignment = NSTextAlignmentCenter;
    labelTimeRecive.numberOfLines = 0;
    labelTimeRecive.textColor = [HXColor colorWithHexString:@"#333333"];
    labelTimeRecive.font = [UIFont systemFontOfSize:20.0f];
    
    // 自提地址背景
    UIView *viewYellow = [[UIView alloc] init];
    [self.view addSubview:viewYellow];
    [viewYellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(KProjectScreenWidth - 40);
        make.top.equalTo(labelTimeRecive.mas_bottom).offset(30);
        make.height.equalTo(100);
    }];
    viewYellow.backgroundColor = [HXColor colorWithHexString:@"#fff7cb"];
    self.viewYellow = viewYellow;
    
    // 领取地址
    UILabel *labelReciveAddress = [[UILabel alloc] init];
    [viewYellow addSubview:labelReciveAddress];
    [labelReciveAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewYellow).offset(10);
        make.top.equalTo(viewYellow).offset(10);
        make.width.equalTo(102);
    }];
    labelReciveAddress.text = @"领取地址：";
    labelReciveAddress.font = [UIFont systemFontOfSize:20.0f];
    labelReciveAddress.textColor = [HXColor colorWithHexString:@"#333333"];
    
    // 地址
    UILabel *labelAddress = [[UILabel alloc] init];
    [viewYellow addSubview:labelAddress];
    [labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelReciveAddress.mas_right);
        make.right.equalTo(viewYellow).offset(-10);
        make.top.equalTo(viewYellow).offset(10);
    }];
    labelAddress.numberOfLines = 0;
    labelAddress.font = [UIFont systemFontOfSize:20.0f];
    labelAddress.textColor = [HXColor colorWithHexString:@"#333333"];
    self.labelAddress = labelAddress;
    
    // 联系电话
    UILabel *labelTelephone = [[UILabel alloc] init];
    [viewYellow addSubview:labelTelephone];
    [labelTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelReciveAddress);
        make.right.equalTo(viewYellow).offset(-10);
        make.top.equalTo(labelAddress.mas_bottom).offset(10);
    }];
    labelTelephone.font = [UIFont systemFontOfSize:20.0f];
    labelTelephone.textColor = [HXColor colorWithHexString:@"#333333"];
    self.labelTelephone = labelTelephone;
    
    // 无自提联系电话
    UILabel *labelTelephoneNoRecive = [[UILabel alloc] init];
    [self.view addSubview:labelTelephoneNoRecive];
    [labelTelephoneNoRecive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelExchange);
        make.top.equalTo(viewYellow.mas_bottom).offset(30);
    }];
    labelTelephoneNoRecive.font = [UIFont systemFontOfSize:20.0f];
    labelTelephoneNoRecive.textColor = [HXColor colorWithHexString:@"#333333"];
    labelTelephoneNoRecive.text = @"联系电话：400-878-8686";
    self.labelTelephoneNoRecive = labelTelephoneNoRecive;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.modelDelivery.deliveryWay isEqualToString:@"自提"]) {
        self.viewYellow.hidden = NO;
        self.labelTelephoneNoRecive.hidden = YES;
        self.labelTelephone.text = [NSString stringWithFormat:@"联系电话：%@",self.modelDelivery.contact];
        self.labelAddress.text = self.modelDelivery.address;
        self.labelTimeRecive.text = @"请您于7个工作日内领取";
        CGFloat height = [self.modelDelivery.address getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 60 - 102, MAXFLOAT) WithFont:[UIFont systemFontOfSize:20.0f]].height + [@"联系电话:" getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 60 - 102, MAXFLOAT) WithFont:[UIFont systemFontOfSize:20.0f]].height + 30;
        [self.viewYellow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }else {
        self.viewYellow.hidden = YES;
        self.labelTelephoneNoRecive.hidden = NO;
        self.labelTimeRecive.text = @"您的商品将于7个工作日之内发出，请耐心等待！";
    }
}

- (void)setModelDelivery:(XZDeliveryOwnModel *)modelDelivery {
    _modelDelivery = modelDelivery;
    
}

@end
