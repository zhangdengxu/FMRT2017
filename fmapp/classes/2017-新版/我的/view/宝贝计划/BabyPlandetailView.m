//
//  BabyPlandetailView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultTitleTextColor [UIColor colorWithRed:(1.0/255) green:(59.0/255) blue:(143.0/255) alpha:1]
#define KDefaultTextColor [UIColor colorWithRed:(170.0/255) green:(170.0/255) blue:(170.0/255) alpha:1]
#import "BabyPlandetailView.h"
#import "BabyPlanModel.h"

@interface BabyPlandetailView ()

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *tradeTime;
@property (weak, nonatomic) IBOutlet UILabel *becomedueTime;
@property (weak, nonatomic) IBOutlet UILabel *profitYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockupTime;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyInMonth;
@property (weak, nonatomic) IBOutlet UILabel *moneyInDay;
@property (weak, nonatomic) IBOutlet UILabel *saveAlreadyMoney;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *shouShouldSaveMoney;

@property (weak, nonatomic) IBOutlet UIView *babyPlayStateView;
@property (weak, nonatomic) IBOutlet UIView *babyPlayStateViewDetailView;
@property (weak, nonatomic) IBOutlet UILabel *cunkuanriLabel;

@end

@implementation BabyPlandetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BabyPlandetailView" owner:self options:nil] firstObject];
        
        CGRect rect = self.frame;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        self.frame = rect;
    }
    return self;
}

- (IBAction)babyPlanButtonOnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(BabyPlandetailView:WithJieid:)]) {
        [self.delegate BabyPlandetailView:self WithJieid:self.babyPlan];
    }
    
}

- (IBAction)addBabyPlayButtonOnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BabyPlandetailView:WithAddBabyPlan:)]) {
        [self.delegate BabyPlandetailView:self WithAddBabyPlan:self.babyPlan];
    }

    
}
-(void)setBabyPlan:(BabyPlanModel *)babyPlan
{
    _babyPlan = babyPlan;

    CGSize sizeString = [NSString getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, self.titleView.frame.size.height) WithFont:[UIFont systemFontOfSize:20] WithString:babyPlan.title];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = KDefaultTitleTextColor;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = babyPlan.title;
    [self.titleView addSubview:titleLabel];
    UIImage * image = nil;
    if([babyPlan.zhuangtai isEqualToString:@"4"]){
        image = [UIImage imageNamed:@"持有中icon@2x_03"];
    }else
    {
        image = [UIImage imageNamed:@"已到期"];
    }
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((titleLabel.center.x + sizeString.width * 0.5) + 10, 0, image.size.width, image.size.height)];
    rightImage.image = image;
    rightImage.center = CGPointMake(rightImage.center.x, titleLabel.center.y);
    [self.titleView addSubview:rightImage];
    
    self.tradeTime.text = [NSString stringWithFormat:@"交易时间：%@",babyPlan.jiaoyishijian];
    
    
    self.becomedueTime.text = babyPlan.daoqishijian;
    self.profitYearLabel.text = [NSString stringWithFormat:@"%@%%",babyPlan.lilv];
    
    self.lockupTime.text = [NSString stringWithFormat:@"%@个月",babyPlan.qixian];
    self.moneyTypeLabel.text = [NSString stringWithFormat:@"%@",babyPlan.huankuanfangshi];
    self.saveAlreadyMoney.text = [NSString stringWithFormat:@"%@元",babyPlan.yicun];
    self.moneyInDay.text = [NSString stringWithFormat:@"%@日",babyPlan.mytouziri];
    self.moneyInMonth.text = [NSString stringWithFormat:@"%@元",babyPlan.jiner == nil ? @"未取到" : babyPlan.jiner];
    self.getMoneyLabel.text = [NSString stringWithFormat:@"%@元",babyPlan.yizhuan];
    self.cunkuanriLabel.text = [NSString stringWithFormat:@"本次存款日:%@",babyPlan.bencishijian];

    
    if (![babyPlan.benyueyicun boolValue]) {
        /**
         *  未存宝贝计划
         */
        self.babyPlayStateView.hidden = NO;
        
    }else
    {
        /**
         *  已存宝贝计划
         */
        self.babyPlayStateView.hidden = YES;
       
        
    }
    
}



-(NSString *)timemarkToNSStringTime:(NSString *)str
{

    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate: detaildate];
}
-(NSString *)timeToTimeMark:(NSDate *)dateNew
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNew timeIntervalSince1970]];
    return timeSp;
}
///**
// *  计算两个时间的时间差
// */
//- (NSInteger *)intervalFromLastDate: (NSDate *) date1  toTheDate:(NSDate *) date2
//{
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour ;
//    
//    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
//    NSInteger retDay = [d day];
//    return retDay;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
