//
//  FMJionPrizeHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMJionPrizeHeaderView.h"


@interface FMJionPrizeHeaderView ()

@property (nonatomic, strong) UIButton * titleMidele;
@property (nonatomic, strong) UILabel * middleMAXDetail;
@property (nonatomic, strong) UILabel * leftNumberDetailText;
@property (nonatomic, strong) UILabel * middleNumberDetailText;
@property (nonatomic, strong) UILabel * rightNumberDetailText;
@property (nonatomic, weak) UIView * bottomView;


@end


@implementation FMJionPrizeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIAndMassary];
    }
    return self;
}
-(void)rightImageViewButtonButtonOnClick:(UIButton *)button
{
//
    //点击头部日历；
    if (self.blockHeaderView) {
        self.blockHeaderView(button.tag - 1000);
    }
    
}
-(void)setCalenderString:(NSString *)calenderString
{
    _calenderString = calenderString;
    [self.titleMidele setTitle:calenderString forState:UIControlStateNormal];
}

-(void)createUIAndMassary
{
    CGFloat bottomHeigh = 10;
    CGFloat header1 = 23;
    CGFloat header2 = 38;
    CGFloat header3 = 5;
    
    if (KProjectScreenWidth > 400)
    {
    
    }else if (KProjectScreenWidth > 350)
    {
        bottomHeigh = 5;
        header1 = 17;
        header2 = 34;
        header3 = 3;

    }else
    {
            bottomHeigh = 1;
            header1 = 10;
            header2 = 20;
            header3 = 0;
        
    }

    //添加日期的点击事件
    UIButton * titleMidele = [[UIButton alloc]init];
    [titleMidele setBackgroundColor:[UIColor yellowColor]];
    titleMidele.tag = 1000;
    self.titleMidele = titleMidele;
    [titleMidele addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleMidele];
    [titleMidele makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(bottomHeigh);
    }];
    
    
    
    
    //创建背景
    UIImageView * imageViewHeaderBG = [[UIImageView alloc]init];
    imageViewHeaderBG.image = [UIImage imageNamed:@"我的推荐_首页-top背景_1702"];
    //imageViewHeaderBG.backgroundColor = [UIColor redColor];
    [self addSubview:imageViewHeaderBG];
    [imageViewHeaderBG makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_height).multipliedBy(0.65);
        
    }];
    
    
    //创建累积奖励（元）
    UILabel * middleDetail = [[UILabel alloc]init];
    middleDetail.textAlignment = NSTextAlignmentCenter;
    middleDetail.textColor = [UIColor whiteColor];
    middleDetail.text = @"累积奖励（元）";
    middleDetail.font = [UIFont systemFontOfSize:15];
    middleDetail.backgroundColor = [UIColor clearColor];
    [self addSubview:middleDetail];
    
    [middleDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleMidele.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    
    //创建累积奖励（元）向右箭头
    UIImageView * rightImageView1 = [[UIImageView alloc]init];
    rightImageView1.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self addSubview:rightImageView1];
    [rightImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleDetail.mas_right);
        make.centerY.equalTo(middleDetail.mas_centerY);
        
    }];
    
    //添加累积奖励（元）向右箭头的点击事件
    UIButton * rightImageViewButton2 = [[UIButton alloc]init];
    [rightImageViewButton2 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton2.tag = 1001;
    [rightImageViewButton2 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightImageViewButton2];
    [rightImageViewButton2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleDetail.mas_left);
        make.top.equalTo(middleDetail.mas_top);
        make.right.equalTo(rightImageView1.mas_right);
        make.bottom.equalTo(middleDetail.mas_bottom);
    }];

    
    //创建中间大数字
    UILabel * middleMAXDetail = [[UILabel alloc]init];
    middleMAXDetail.textAlignment = NSTextAlignmentCenter;
    middleMAXDetail.textColor = [UIColor whiteColor];
    middleMAXDetail.text = @"0";
    middleMAXDetail.backgroundColor = [UIColor clearColor];
    middleMAXDetail.font = [UIFont systemFontOfSize:38];
    [self addSubview:middleMAXDetail];
    self.middleMAXDetail = middleMAXDetail;
    [middleMAXDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(middleDetail.mas_bottom).offset(header1);
        make.right.equalTo(self.mas_right);
    }];
    
   
    
    UIView * lineWhiteView1 = [[UIView alloc]init];
    lineWhiteView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineWhiteView1];
    [lineWhiteView1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(middleMAXDetail.mas_bottom).offset(header2);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    

    
    
    UIView * lineWhiteView2 = [[UIView alloc]init];
    lineWhiteView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineWhiteView2];
    [lineWhiteView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineWhiteView1.mas_bottom).offset(8);
        make.bottom.equalTo(imageViewHeaderBG.mas_bottom).offset(-8);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(self.mas_left).offset(KProjectScreenWidth * 0.333);
    }];
    

    
    
    UIView * lineWhiteView3 = [[UIView alloc]init];
    lineWhiteView3.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineWhiteView3];
    [lineWhiteView3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineWhiteView1.mas_bottom).offset(8);
        make.bottom.equalTo(imageViewHeaderBG.mas_bottom).offset(-8);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(self.mas_right).offset( -KProjectScreenWidth * 0.333);
    }];
    
    
    //现金奖励（元）
    UILabel * leftNumberDetail = [[UILabel alloc]init];
    leftNumberDetail.textAlignment = NSTextAlignmentCenter;
    leftNumberDetail.textColor = [UIColor whiteColor];
    leftNumberDetail.text = @"现金奖励(元)";
    leftNumberDetail.font = [UIFont systemFontOfSize:12];
    [self addSubview:leftNumberDetail];
    [leftNumberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineWhiteView2.top).offset(header3);
        make.centerX.equalTo(self.mas_left).offset(KProjectScreenWidth * 0.1666);
        make.height.equalTo(16);

    }];
    
    //创建左下角向右箭头
    UIImageView * leftImageView2 = [[UIImageView alloc]init];
    leftImageView2.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self addSubview:leftImageView2];
    [leftImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftNumberDetail.mas_right).offset(4);
        make.centerY.equalTo(leftNumberDetail.mas_centerY);
        
    }];

    
    //创建左下角数字Label
    UILabel * leftNumberDetailText = [[UILabel alloc]init];
    leftNumberDetailText.textAlignment = NSTextAlignmentCenter;
    leftNumberDetailText.textColor = [UIColor whiteColor];
    leftNumberDetailText.text = @"0";
    leftNumberDetailText.font = [UIFont systemFontOfSize:17];
    self.leftNumberDetailText = leftNumberDetailText;
    [self addSubview:leftNumberDetailText];
    [leftNumberDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(leftNumberDetail.mas_bottom).offset(5);
        make.right.equalTo(lineWhiteView2.mas_left);

    }];
    
    
    
    //添加左下角区域的点击事件
    UIButton * leftImageViewButton3 = [[UIButton alloc]init];
    [leftImageViewButton3 setBackgroundColor:[UIColor clearColor]];
    leftImageViewButton3.tag = 1003;
    [leftImageViewButton3 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftImageViewButton3];
    [leftImageViewButton3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(leftNumberDetail.mas_top);
        make.right.equalTo(leftNumberDetailText.mas_right);
        make.bottom.equalTo(leftNumberDetailText.mas_bottom);
    }];
    
    
    
    //红包奖励（元）
    UILabel * middleNumberDetail = [[UILabel alloc]init];
    middleNumberDetail.textAlignment = NSTextAlignmentCenter;
    middleNumberDetail.textColor = [UIColor whiteColor];
    middleNumberDetail.text = @"红包奖励(元)";
    middleNumberDetail.font = [UIFont systemFontOfSize:12];

    [self addSubview:middleNumberDetail];
    [middleNumberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftNumberDetail.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(16);
    }];
    
    //创建中间向右箭头
    UIImageView * middleImageView2 = [[UIImageView alloc]init];
    middleImageView2.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self addSubview:middleImageView2];
    [middleImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleNumberDetail.mas_right).offset(4);
        make.centerY.equalTo(middleNumberDetail.mas_centerY);
        
    }];
    
    
    //创建中间数字Label
    UILabel * middleNumberDetailText = [[UILabel alloc]init];
    middleNumberDetailText.textAlignment = NSTextAlignmentCenter;
    middleNumberDetailText.textColor = [UIColor whiteColor];
    middleNumberDetailText.text = @"0";
    middleNumberDetailText.font = [UIFont systemFontOfSize:17];
    self.middleNumberDetailText = middleNumberDetailText;
    [self addSubview:middleNumberDetailText];
    [middleNumberDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineWhiteView2.mas_right);
        make.top.equalTo(middleNumberDetail.mas_bottom).offset(5);
        make.right.equalTo(lineWhiteView3.mas_left);
        
    }];
    
    
    
    //添加中间区域的点击事件
    UIButton * middleImageViewButton3 = [[UIButton alloc]init];
    [middleImageViewButton3 setBackgroundColor:[UIColor clearColor]];
    middleImageViewButton3.tag = 1004;
    [middleImageViewButton3 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:middleImageViewButton3];
    [middleImageViewButton3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineWhiteView2.mas_right);
        make.top.equalTo(middleNumberDetail.mas_top);
        make.right.equalTo(lineWhiteView3.mas_left);
        make.bottom.equalTo(middleNumberDetailText.mas_bottom);
    }];
    
    
    
    //有效好友（人）
    UILabel * rightNumberDetail = [[UILabel alloc]init];
    rightNumberDetail.textAlignment = NSTextAlignmentCenter;
    rightNumberDetail.textColor = [UIColor whiteColor];
    rightNumberDetail.text = @"邀请好友(人)";
    rightNumberDetail.font = [UIFont systemFontOfSize:12];
    [self addSubview:rightNumberDetail];
    [rightNumberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftNumberDetail.mas_top);
        make.centerX.equalTo(self.mas_right).offset(-KProjectScreenWidth * 0.1666);
        make.height.equalTo(16);

    }];
    
    //创建右下角向右箭头
    UIImageView * rightImageView2 = [[UIImageView alloc]init];
    rightImageView2.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self addSubview:rightImageView2];
    [rightImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightNumberDetail.mas_right).offset(4);
        make.centerY.equalTo(rightNumberDetail.mas_centerY);
        
    }];
    
    
    //创建右下角数字Label
    UILabel * rightNumberDetailText = [[UILabel alloc]init];
    rightNumberDetailText.textAlignment = NSTextAlignmentCenter;
    rightNumberDetailText.textColor = [UIColor whiteColor];
    rightNumberDetailText.text = @"0";
    rightNumberDetailText.font = [UIFont systemFontOfSize:17];
    self.rightNumberDetailText = rightNumberDetailText;
    [self addSubview:rightNumberDetailText];
    [rightNumberDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineWhiteView3.mas_right);
        make.top.equalTo(rightNumberDetail.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right);
        
    }];
    
    
    
    //添加右下角区域的点击事件
    UIButton * rightImageViewButton3 = [[UIButton alloc]init];
    [rightImageViewButton3 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton3.tag = 1005;
    [rightImageViewButton3 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightImageViewButton3];
    [rightImageViewButton3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineWhiteView3.mas_right);
        make.top.equalTo(rightNumberDetail.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(rightNumberDetailText.mas_bottom);
    }];
    

    
    
    
    //创建长条的图片
    UIImageView * rectangleImageView2 = [[UIImageView alloc]init];
    rectangleImageView2.image = [UIImage imageNamed:@"积分明细签到icon线"];
    [self addSubview:rectangleImageView2];
    
    //创建实心圆的图片
    UIImageView * circleImageView2 = [[UIImageView alloc]init];
    circleImageView2.backgroundColor = [UIColor whiteColor];
    circleImageView2.image = [UIImage imageNamed:@"积分明细_03.png"];
    [self addSubview:circleImageView2];
    

    UIView * lineWhiteView4 = [[UIView alloc]init];
    lineWhiteView4.backgroundColor = [HXColor colorWithHexString:@"#cccccc"];
    [self addSubview:lineWhiteView4];
    
    
    //创建中间文字
    UILabel * middleDescribeDetailText = [[UILabel alloc]init];
    middleDescribeDetailText.textAlignment = NSTextAlignmentCenter;
    middleDescribeDetailText.textColor = [HXColor colorWithHexString:@"#666666"];
    middleDescribeDetailText.numberOfLines = 0;
    middleDescribeDetailText.attributedText = [self setUpLabelLineSpaceWithText:@"每成功邀请一位好友首次投资成功后，邀请人可获得20元红包奖励；还可享受好友自首次投资开始日起30天内，好友每笔投资金额年化2‰的现金奖励；"];
    
    
    
    
    if (KProjectScreenWidth > 400) {
        middleDescribeDetailText.font = [UIFont systemFontOfSize:13];
    }else if (KProjectScreenWidth > 350)
    {
        middleDescribeDetailText.font = [UIFont systemFontOfSize:11];

    }else
    {
        middleDescribeDetailText.font = [UIFont systemFontOfSize:9];

    }
    [self addSubview:middleDescribeDetailText];
    [middleDescribeDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(imageViewHeaderBG.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-12);
        make.bottom.equalTo(lineWhiteView4.mas_top).offset(-10);
    
        
    }];
    
    
  
    [lineWhiteView4 makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(circleImageView2.mas_top).offset(-10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [circleImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14.5);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.width.height.equalTo(@16);
        
    }];
    
    //创建中间数字Label
    UILabel * bottomDescribeDetailText = [[UILabel alloc]init];
    bottomDescribeDetailText.textAlignment = NSTextAlignmentCenter;
    bottomDescribeDetailText.textColor = [HXColor colorWithHexString:@"#333333"];
    bottomDescribeDetailText.text = @"奖励明细";
    bottomDescribeDetailText.font = [UIFont systemFontOfSize:14];
    [self addSubview:bottomDescribeDetailText];
    [bottomDescribeDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleImageView2.mas_right).offset(8);
        make.centerY.equalTo(circleImageView2.mas_centerY);
    }];
    

    [rectangleImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleImageView2.mas_centerX);
        make.top.equalTo(circleImageView2.mas_centerY);
        make.height.equalTo(@25);
        
    }];

    
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(middleDescribeDetailText.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(20);

    }];
    bottomView.hidden = NO;
    
    [self bringSubviewToFront:circleImageView2];
    [self haveNoAnyDate];
    

}



// 设置label的行间距
- (NSMutableAttributedString *)setUpLabelLineSpaceWithText:(NSString *)text{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    //设置行距
    if (KProjectScreenWidth == 320) {
        [style setLineSpacing:3.0f];
    }else
    {
        [style setLineSpacing:5.0f];
    }
   
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    return attStr;
}

-(void)haveALLdataSource
{
    self.bottomView.hidden = YES;
}

-(void)haveNoAnyDate
{
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.hidden = NO;
    [self bringSubviewToFront:self.bottomView];
}


-(void)setHeaderModel:(FMJionPrizeHeaderViewModel *)headerModel
{
    _headerModel = headerModel;
    
    CGFloat totalMoney = headerModel.awardCashAmt + headerModel.awardRedPacketAmt;
    self.middleMAXDetail.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.2f",totalMoney]];
    self.leftNumberDetailText.text = [NSString stringWithFormat:@"%.2f",headerModel.awardCashAmt];
    self.middleNumberDetailText.text = [NSString stringWithFormat:@"%.2f",headerModel.awardRedPacketAmt];
    self.rightNumberDetailText.text = [NSString stringWithFormat:@"%zi",headerModel.inviteSum];
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation FMJionPrizeHeaderViewModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

