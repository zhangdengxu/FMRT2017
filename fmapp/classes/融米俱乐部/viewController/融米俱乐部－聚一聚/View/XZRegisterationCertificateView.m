//
//  XZRegisterationCertificateView.m
//  fmapp
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZRegisterationCertificateView.h"
#import "XZRegistrationCertificateModel.h"
#import "Fm_Tools.h"
// 判断是否为iOS8.2
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)

@interface XZRegisterationCertificateView ()
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBottom;
/** 活动时间 */
@property (nonatomic, strong) UILabel *labelActivityTime;
/** 活动地点 */
@property (nonatomic, strong) UILabel *labelActivityAddress;
/** 主办方 */
@property (nonatomic, strong) UILabel *labelHost;
/** 报名人 */
@property (nonatomic, strong) UILabel *labelPersonName;
/** 活动标签(免费) */
@property (nonatomic, strong) UILabel *labelFree;
/** 融米一家亲 */
@property (nonatomic, strong) UILabel *labelTitle;
/** 二维码 */
@property (nonatomic, strong) UIImageView *imgIcon;
/** 即将开始 */
@property (nonatomic, strong) UIImageView *imgPic;
@end

@implementation XZRegisterationCertificateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRegisterationCertificateView];
    }
    return self;
}

- (void)setUpRegisterationCertificateView {
    self.backgroundColor = XZColor(230, 235, 240);
    UILabel *topLine = [[UILabel alloc]init];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@15);
    }];
    topLine.backgroundColor = XZColor(230, 235, 240);
    
    /** 蓝色背景 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
    [self addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLine.mas_left);
        make.right.equalTo(topLine.mas_right);
        make.top.equalTo(topLine.mas_bottom);
        make.height.equalTo(@(KProjectScreenWidth * 15 / 32.0));
    }];
    imgPhoto.image = [UIImage imageNamed:@"报名凭证_背景图"];
    
    /** 融米一家亲 */
    UILabel *labelTitle = [[UILabel alloc]init];
    [imgPhoto addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.top.equalTo(imgPhoto.mas_top).offset(5);
        make.width.equalTo(KProjectScreenWidth - 20);
    }];
    self.labelTitle = labelTitle;
    if (iOS8) {
        labelTitle.font = [UIFont systemFontOfSize:15 weight:2];
    }else {
        labelTitle.font = [UIFont systemFontOfSize:15];
    }
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.numberOfLines = 2;
    
    /** 二维码 */
    UIImageView *imgIcon = [[UIImageView alloc]init];
    [imgPhoto addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.top.equalTo(labelTitle.mas_bottom).offset(8);
        make.height.and.width.equalTo(@(KProjectScreenWidth * 7/32));
    }];
    self.imgIcon = imgIcon;
    self.imgIcon.backgroundColor = [UIColor whiteColor];
    imgIcon.image = [UIImage imageNamed:@"财经新闻new_03"];
    
    /** 免费 */
    UILabel *labelFree = [[UILabel alloc]init];
    [imgPhoto addSubview:labelFree];
    [labelFree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.bottom.equalTo(imgPhoto.mas_bottom).offset(-8);
    }];
    self.labelFree = labelFree;
    if (iOS8) {
        labelFree.font = [UIFont systemFontOfSize:16 weight:2];
    }else {
         labelFree.font = [UIFont systemFontOfSize:16];
    }
    labelFree.textColor = [UIColor whiteColor];
    labelFree.textAlignment = NSTextAlignmentCenter;
    
    /** 即将开始 */
    UIImageView *imgPic = [[UIImageView alloc]init];
    [imgPhoto addSubview:imgPic];
    [imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
        make.bottom.equalTo(imgPhoto.mas_bottom).offset(-10);
        make.width.and.height.equalTo(@50);
    }];
    self.imgPic = imgPic;
    imgPic.contentMode = UIViewContentModeScaleAspectFill;
    
    /** 白色背景 */
    UIView *viewBottom = [[UIView alloc]init];
    [self addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLine.mas_left);
        make.right.equalTo(topLine.mas_right);
        make.top.equalTo(imgPhoto.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.viewBottom = viewBottom;
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    /** 活动时间 */
    UILabel *labelTime = [self createLeftLabel:0];
    labelTime.text = @"活动时间：";
    UILabel *labelActivityTime = [self createLabelWithOffSet:0];
    self.labelActivityTime = labelActivityTime;
    
    /** 活动地点 */
    UILabel *labelActivity = [self createLeftLabel:36.5];
    labelActivity.text = @"活动地点：";
    UILabel *labelActivityAddress = [self createLabelWithOffSet:36.5];
    self.labelActivityAddress = labelActivityAddress;
    
    /** 主办方 */
    UILabel *labelHostLeft = [self createLeftLabel:73];
    labelHostLeft.text = @"主办方：";
    UILabel *labelHost = [self createLabelWithOffSet:73];
    self.labelHost = labelHost;
    
    /** 报名人 */
    UILabel *labelPerson = [self createLeftLabel:108.5];
    labelPerson.text = @"报名人：";
    UILabel *labelPersonName = [self createLabelWithOffSet:108.5];
    self.labelPersonName = labelPersonName;
    
    /** 线 */
    [self createLineWithTopView:labelActivityTime];
    [self createLineWithTopView:labelActivityAddress];
    [self createLineWithTopView:labelHost];
}

// 线
- (void)createLineWithTopView:(UIView *)topView {
    UILabel *line = [[UILabel alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBottom.mas_left).offset(10);
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(self.viewBottom.mas_right).offset(-10);
        make.height.equalTo(0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
}

// 左边的label
- (UILabel *)createLeftLabel:(CGFloat)offSet{
    UILabel *labelTime = [[UILabel alloc]init];
    [self.viewBottom addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBottom.mas_left).offset(10);
        make.top.equalTo(self.viewBottom.mas_top).offset(offSet);
        make.height.equalTo(@36);
//        make.width.equalTo(80);
    }];
    labelTime.textColor = [UIColor lightGrayColor];
    labelTime.font = [UIFont systemFontOfSize:16];
    return labelTime;
}

// 每一行
- (UILabel *)createLabelWithOffSet:(CGFloat)offSet{
    UILabel *labelActivityTime = [[UILabel alloc]init];
    [self.viewBottom addSubview:labelActivityTime];
    [labelActivityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBottom.mas_left).offset(90);
        make.top.equalTo(self.viewBottom.mas_top).offset(offSet);
        make.height.equalTo(@36);
    }];
    labelActivityTime.font = [UIFont systemFontOfSize:16];
    return labelActivityTime;
}

// 给label赋值
- (void)setModelCertificate:(XZRegistrationCertificateModel *)modelCertificate {
    _modelCertificate = modelCertificate;

    // 赋值
    self.labelActivityTime.text = [NSString stringWithFormat:@"%@",modelCertificate.party_timelist];
    self.labelActivityAddress.text = [NSString  stringWithFormat:@"%@",modelCertificate.party_address];    self.labelHost.text = [NSString  stringWithFormat:@"%@",modelCertificate.party_initiator];
    self.labelPersonName.text = [NSString  stringWithFormat:@"%@",modelCertificate.name];
    
    self.labelTitle.text = [NSString stringWithFormat:@"%@",modelCertificate.party_theme];
    self.labelFree.text = [NSString stringWithFormat:@"%@",modelCertificate.party_labletitle];
    UIImage *img= [Fm_Tools QRcodeWithUrlString:modelCertificate.shuzima];
    self.imgIcon.image = [Fm_Tools addIconToQRCodeImage:img withIcon:[UIImage imageNamed:@"二维码小图片"] withScale:6];
    NSString *party_joinstatus = [NSString stringWithFormat:@"%@",modelCertificate.party_joinstatus];
    // 1即将开始 2已验票 3已结束 4已拒绝
    if ([party_joinstatus isEqualToString:@"1"]) { // 1即将开始
        self.imgPic.image = [UIImage imageNamed:@"报名凭证_即将开始"];
    }else if ([party_joinstatus isEqualToString:@"2"]) { // 2已验票
        self.imgPic.image = [UIImage imageNamed:@"我的参与_报名凭证_已验票"];
    }else if ([party_joinstatus isEqualToString:@"3"]) { // 3已结束
        self.imgPic.image = [UIImage imageNamed:@"我的参与_报名凭证_已结束"];
    }else { //4已拒绝
        self.imgPic.image = [UIImage imageNamed:@"我的参与_报名凭证_已拒绝"];
    }
    
}

@end
