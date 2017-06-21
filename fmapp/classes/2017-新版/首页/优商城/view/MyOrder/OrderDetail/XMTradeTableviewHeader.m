//
//  XMTradeTableviewHeader.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/22.
//  Copyright © 2016年 yk. All rights reserved.
//
#define kLightGrayTextColor XZColor(143, 143, 143)
#define kDarkGrayTextColor XZColor(48, 48, 48)

#define KDefaultImageWidth 
#define KDefaultLabelFont 15
#define KDefaultMargion 10
#define KDefaultImageHeigh 90
#import "XMTradeTableviewHeader.h"
#import "XZMyOrderModel.h"
#import "AutoHeightLabel.h"


@interface XMTradeTableviewHeader()

@property (nonatomic, weak) UIImageView * headerImage;

@end


@implementation XMTradeTableviewHeader

- (instancetype)initWithorderModel:(FMOrderDetailLocationModel *)headerModel
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth,300);
        self.backgroundColor = [UIColor whiteColor];
        _headerModel = headerModel;
        
        CGSize sizeGoodsLocation;
        CGFloat origin_y = 0;
        
        UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KDefaultImageHeigh * (KProjectScreenWidth/320))];
        [self addSubview:headerImage];
        self.headerImage = headerImage;
        
        if ((headerModel.orderStatusFM == 21) || (headerModel.orderStatusFM == 31)) { // 交易成功
            [headerImage setImage:[UIImage imageNamed:@"交易成功"]];
        }else if (headerModel.orderStatusFM == 61) // 等待买家付款
        {
            [headerImage setImage:[UIImage imageNamed:@"等待买家付款"]];
        }else if ((headerModel.orderStatusFM == 1) || (headerModel.orderStatusFM == 12)) // 交易关闭
        {
            [headerImage setImage:[UIImage imageNamed:@"交易关闭"]];
        }else if (headerModel.orderStatusFM == 51) // 买家已付款，但还未发货
        {
            [headerImage setImage:[UIImage imageNamed:@"买家已付款"]];
        }else if (headerModel.orderStatusFM == 41)// 卖家发货但用户还未收到货
        {
            [headerImage setImage:[UIImage imageNamed:@"卖家已发货"]];
        }else if (headerModel.orderStatusFM == 11) { // 售后申请中
            [headerImage setImage:[UIImage imageNamed:@"order_detail_return"]];
        }
        
        origin_y = origin_y +  KDefaultImageHeigh * (KProjectScreenWidth/320) + KDefaultMargion;
        
        UIView * currentView;
        if (headerModel.orderAddresss) {
            
            /** 物流地址 */
            UILabel *labelLogistics = [[UILabel alloc]init];
            labelLogistics.numberOfLines = 0;
            labelLogistics.font = [UIFont systemFontOfSize:KDefaultLabelFont];
            [self addSubview:labelLogistics];
            sizeGoodsLocation = [headerModel.orderAddresss.context getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 50 - 30, MAXFLOAT) WithFont:[UIFont systemFontOfSize:KDefaultLabelFont]];
            labelLogistics.text = headerModel.orderAddresss.context;
            labelLogistics.frame = CGRectMake(50, origin_y,KProjectScreenWidth - 50 - 30, sizeGoodsLocation.height);
            labelLogistics.textColor = [HXColor colorWithHexString:@"#2eae7a"];
            origin_y = origin_y +sizeGoodsLocation.height + KDefaultMargion;
            
            
            UIImageView *imgAdressDetail = [[UIImageView alloc]init];
            [self addSubview:imgAdressDetail];
            [imgAdressDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-10);
                make.top.equalTo(headerImage.mas_bottom).offset(15);
                make.height.equalTo(@15);
                make.width.equalTo(@8);
            }];
            imgAdressDetail.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
            //  小汽车图片
            UIImageView *imgLogistics = [[UIImageView alloc]init];
            [self addSubview:imgLogistics];
            [imgLogistics mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.top.equalTo(headerImage.mas_bottom).offset(15);
                make.height.equalTo(@19);
                make.width.equalTo(@30);
            }];
            imgLogistics.image = [UIImage imageNamed:@"卡车"];
            
            
            
            /** 时间 */
            UILabel *labelTime = [[UILabel alloc]init];
            [self addSubview:labelTime];
            [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labelLogistics.mas_left);
                make.top.equalTo(labelLogistics.mas_bottom).offset(KDefaultMargion);
                make.height.equalTo(@20);
            }];
            labelTime.text = headerModel.orderAddresss.ftime;
            labelTime.font = [UIFont systemFontOfSize:13];
            labelTime.textColor = kLightGrayTextColor;
            
            origin_y = origin_y + 20 + KDefaultMargion;
            // 分割线
            UIView *viewLine = [[UIView alloc]init];
            [self addSubview:viewLine];
            [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.top.equalTo(labelTime.mas_bottom).offset(KDefaultMargion);
                make.height.equalTo(@0.5);
            }];
            viewLine.backgroundColor = XZColor(235, 235, 242);
            origin_y = origin_y + 0.5 + KDefaultMargion;
            currentView = viewLine;
            
            
            UIButton * cleanButton = [[UIButton alloc]init];
            [self addSubview:cleanButton];
            [cleanButton addTarget:self action:@selector(addressButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.top.equalTo(labelLogistics.mas_top);
                make.bottom.equalTo(viewLine.mas_bottom);
            }];
        }
        CGSize sizePeopleLocation;
        if (headerModel.locationString) {
            
            if (!currentView) {
                currentView =headerImage;
            }
            origin_y = origin_y + KDefaultMargion;
            sizePeopleLocation = [headerModel.locationString getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 50 - 30, MAXFLOAT) WithFont:[UIFont systemFontOfSize:KDefaultLabelFont]];
            //  图片
            UIImageView *imgAdress = [[UIImageView alloc]init];
            [self addSubview:imgAdress];
            imgAdress.frame = CGRectMake(10, origin_y, 25, 30);
            imgAdress.image = [UIImage imageNamed:@"地图"];
            /** 收货人 */
            UILabel *labelUserName = [[UILabel alloc]init];
            [self addSubview:labelUserName];
            
            [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgAdress.mas_top);
                make.left.equalTo(imgAdress.mas_right).offset(10);
                make.height.equalTo(@20);
            }];
            labelUserName.text = headerModel.peopleGoods;
            labelUserName.textColor = kDarkGrayTextColor;
            labelUserName.font = [UIFont systemFontOfSize:KDefaultLabelFont];
            /** 收货人电话 */
            UILabel *labelPhoneNumber = [[UILabel alloc]init];
            [self addSubview:labelPhoneNumber];
            [labelPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labelUserName.mas_top);
                make.right.equalTo(self.mas_right).offset(-10);
                make.centerY.equalTo(labelUserName.mas_centerY);
            }];
            labelPhoneNumber.text = headerModel.mobile;
            labelPhoneNumber.textColor = kDarkGrayTextColor;
            labelPhoneNumber.textAlignment = NSTextAlignmentRight;
            labelPhoneNumber.font = [UIFont systemFontOfSize:KDefaultLabelFont];
            origin_y = origin_y + 20 + KDefaultMargion;
            
            /** 收货地址 */
            
            UILabel *labelLogistics = [[UILabel alloc]init];
            labelLogistics.numberOfLines = 0;
            [self addSubview:labelLogistics];
            labelLogistics.text = headerModel.locationString;
            labelLogistics.frame = CGRectMake(50, origin_y,KProjectScreenWidth - 50 - 30, sizePeopleLocation.height);
        
            labelLogistics.font = [UIFont systemFontOfSize:KDefaultLabelFont];
            
            UIView *viewLine11 = [[UIView alloc]init];
            viewLine11.backgroundColor = XZColor(235, 235, 242);
            [self addSubview:viewLine11];
            [viewLine11 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.top.equalTo(labelLogistics.mas_bottom).offset(10);
                make.height.equalTo(@0.5);
            }];
            
            currentView = labelLogistics;
            
            origin_y = origin_y + sizePeopleLocation.height + KDefaultMargion;
            

        }
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, origin_y + KDefaultMargion) ;
        
    }
    return self;
}

-(void)addressButtonOnClick
{
    if (self.blockBtn) {
        self.blockBtn();
    }
}

@end
