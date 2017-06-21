//
//  FMAccountSelectViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAccountSelectViewController.h"
#import "FMAccountTypeDetailController.h"
#import "FMSelectAccountModel.h"
#import "XMSelectDataPick.h"
#import "NSDate+CategoryPre.h"
#import "FMKeyBoardNumberHeader.h"


@interface FMAccountSelectViewController ()<XMSelectDataPickDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UISearchBar * searchBar;


/**创建UILabel*/


@property (nonatomic, strong) UILabel * selectRangeLabel;//全部
@property (nonatomic, strong) UILabel * dateSelectRangeLabel;//本月／／确认订单页面（箭头）适合下单页面所有有箭头的地方_07

@property (nonatomic, strong) UIButton * threeLeftButton;
@property (nonatomic, strong) UIButton * threeRightButton;

@property (nonatomic, strong) UITextField * fourFirstTextField;
@property (nonatomic, strong) UITextField * fourSecondTextField;


@property (nonatomic, strong) FMSelectAccountEnd * selectModle;

@end

@implementation FMAccountSelectViewController


-(void)setCurrentSelectModel:(FMSelectAccountEnd *)currentSelectModel
{
    _currentSelectModel = currentSelectModel;
    self.selectModle = currentSelectModel;
    if (currentSelectModel.firstTime.length > 7) {
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
    }else
    {
        self.selectModle.firstTime = nil;
    }
    
    if (currentSelectModel.endTime.length > 7) {
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
    }else{
        self.selectModle.endTime = nil;
    }
    
    if ((!self.selectModle.endTime)&&(!self.selectModle.firstTime)) {
        self.selectModle.grade = 100;
    }
    
    self.selectRangeLabel.text = self.selectModle.rangeModel.title;
    self.dateSelectRangeLabel.text = self.selectModle.dateModel.title;
    self.fourFirstTextField.text = self.selectModle.firstMoney;
    self.fourSecondTextField.text = self.selectModle.endMoney;
    self.searchBar.text = self.selectModle.keyString;
    
}

-(FMSelectAccountEnd *)selectModle
{
    
    if (!_selectModle) {
        _selectModle = [[FMSelectAccountEnd alloc]init];
    }
    return _selectModle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"查询条件"];
    [self createUINavigation];
    [self createUISearchBar];
    __weak __typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^(){
        weakSelf.selectModle.grade = 10;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self addMassory];
    
    // Do any additional setup after loading the view.
}
-(void)createUINavigation
{
    UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 18)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"我的账单对号_03"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItem = searchBar;
}

-(void)adsActivitybuttonOnClick:(UIButton *)button
{
    if (self.fourFirstTextField.text.length > 0) {
        self.selectModle.firstMoney = self.fourFirstTextField.text;
    }
    if (self.fourSecondTextField.text.length > 0) {
        self.selectModle.endMoney = self.fourSecondTextField.text;
        
    }
    if ((!self.selectModle.firstTime)&&(!self.selectModle.endTime)&&(!self.selectModle.firstMoney)&&(!self.selectModle.endMoney)&&(!self.selectModle.keyString)&&(!self.selectModle.rangeModel)&&(!(self.searchBar.text.length > 0))) {
        
        self.selectModle.grade = 10;
        if (self.unSelectModelBlock) {
            self.unSelectModelBlock(self.selectModle);
        }
        
    }else
    {
        if (self.searchBar.text.length > 0) {
            self.selectModle.keyString = self.searchBar.text;
        }
        if (self.selectModelBlock) {
            self.selectModelBlock(self.selectModle);
        }
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUISearchBar
{
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 45)];
    self.searchBar = searchBar;
    searchBar.placeholder = @"请输入关键字或拼音";
    searchBar.barStyle = UIBarStyleDefault;
    [self.view addSubview:searchBar];
    
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KProjectScreenWidth, self.view.frame.size.height - self.searchBar.frame.size.height)];
        _scrollView.backgroundColor = XZColor(230,231,234);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 700);
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

/**
 *  添加控件及约束
 */
-(void)addMassory
{
    CGFloat cellHeigh = 44.5;
    
    /**
     第一行
     */
    UIView * contentView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, cellHeigh)];
    [self.scrollView addSubview:contentView1];
    contentView1.backgroundColor = [UIColor whiteColor];
    
    UILabel * firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"查找范围";
    firstLabel.font = [UIFont systemFontOfSize:15];
    [contentView1 addSubview:firstLabel];
    firstLabel.textColor = [UIColor lightGrayColor];
    
    [contentView1 addSubview:self.selectRangeLabel];
    
    
    UIImageView * imageView1 = [[UIImageView alloc]init];
    [contentView1 addSubview:imageView1];
    imageView1.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
    
    UIButton * firstButton = [[UIButton alloc]init];
    firstButton.tag = 500;
    [contentView1 addSubview:firstButton];
    [firstButton addTarget:self action:@selector(selectbuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [firstLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView1.mas_top);
        make.bottom.equalTo(contentView1.mas_bottom);
        make.left.equalTo(contentView1.mas_left).offset(8);
    }];
    
    [imageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@9);
        make.height.equalTo(@16);
        make.right.equalTo(contentView1.mas_right).offset(-10);
        make.centerY.equalTo(contentView1.mas_centerY);
        
    }];
    [self.selectRangeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView1.mas_top);
        make.bottom.equalTo(contentView1.mas_bottom);
        make.right.equalTo(imageView1.mas_left).offset(-12);
        make.left.equalTo(firstLabel.mas_right).offset(12);
    }];
    
    [firstButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView1.mas_top);
        make.bottom.equalTo(contentView1.mas_bottom);
        make.right.equalTo(contentView1.mas_right);
        make.left.equalTo(contentView1.mas_left);
    }];
    [contentView1 bringSubviewToFront:firstButton];
    
    /**
     第二行
     */
    
    UIView * contentView2 = [[UIView alloc]initWithFrame:CGRectMake(0, cellHeigh + 0.5, KProjectScreenWidth, cellHeigh)];
    [self.scrollView addSubview:contentView2];
    contentView2.backgroundColor = [UIColor whiteColor];
    
    UILabel * secondLabel = [[UILabel alloc]init];
    secondLabel.text = @"日期范围";
    secondLabel.font = [UIFont systemFontOfSize:15];
    [contentView2 addSubview:secondLabel];
    secondLabel.textColor = [UIColor lightGrayColor];
    
    [contentView2 addSubview:self.dateSelectRangeLabel];
    
    
    UIImageView * imageView2 = [[UIImageView alloc]init];
    [contentView2 addSubview:imageView2];
    imageView2.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
    
    UIButton * secondButton = [[UIButton alloc]init];
    secondButton.tag = 501;
    [contentView2 addSubview:secondButton];
    [secondButton addTarget:self action:@selector(selectbuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [secondLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView2.mas_top);
        make.bottom.equalTo(contentView2.mas_bottom);
        make.left.equalTo(contentView2.mas_left).offset(8);
    }];
    
    [imageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@9);
        make.height.equalTo(@16);
        make.right.equalTo(contentView2.mas_right).offset(-10);
        make.centerY.equalTo(contentView2.mas_centerY);
        
    }];
    [self.dateSelectRangeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView2.mas_top);
        make.bottom.equalTo(contentView2.mas_bottom);
        make.right.equalTo(imageView2.mas_left).offset(-12);
        make.left.equalTo(secondLabel.mas_right).offset(12);
    }];
    
    [secondButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView2.mas_top);
        make.bottom.equalTo(contentView2.mas_bottom);
        make.right.equalTo(contentView2.mas_right);
        make.left.equalTo(contentView2.mas_left);
    }];
    [contentView2 bringSubviewToFront:secondButton];
    
    
    /**
     *  第三行
     */
    
    
    UIView * contentView3 = [[UIView alloc]initWithFrame:CGRectMake(0, (cellHeigh + 0.5) * 2, KProjectScreenWidth, cellHeigh)];
    [self.scrollView addSubview:contentView3];
    contentView3.backgroundColor = [UIColor whiteColor];
    
    [contentView3 addSubview:self.threeLeftButton];
    [contentView3 addSubview:self.threeRightButton];
    
    UILabel * threeLabel = [[UILabel alloc]init];
    threeLabel.text = @"至";
    threeLabel.font = [UIFont systemFontOfSize:15];
    [contentView3 addSubview:threeLabel];
    threeLabel.textColor = [UIColor lightGrayColor];
    
    [self.threeLeftButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView3.mas_top);
        make.bottom.equalTo(contentView3.mas_bottom);
        make.left.equalTo(contentView3.mas_left).offset(8);
        make.right.equalTo(threeLabel.mas_left).offset(-8);
    }];
    
    [threeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView3.mas_top);
        make.bottom.equalTo(contentView3.mas_bottom);
        make.centerX.equalTo(contentView3.mas_centerX);
        make.centerY.equalTo(contentView3.mas_centerY);
    }];
    
    [self.threeRightButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView3.mas_top);
        make.bottom.equalTo(contentView3.mas_bottom);
        make.left.equalTo(threeLabel.mas_right).offset(8);
        make.right.equalTo(contentView3.mas_right).offset(-8);
    }];
    
    
    /**
     *  第四行
     */
    UIView * contentView4 = [[UIView alloc]initWithFrame:CGRectMake(0, (cellHeigh + 0.5) * 3 + 25, KProjectScreenWidth, cellHeigh)];
    [self.scrollView addSubview:contentView4];
    contentView4.backgroundColor = [UIColor whiteColor];
    
    UILabel * fourMoneyLabel1 = [[UILabel alloc]init];
    fourMoneyLabel1.text = @"¥";
    fourMoneyLabel1.textAlignment = NSTextAlignmentCenter;
    fourMoneyLabel1.font = [UIFont systemFontOfSize:15];
    [contentView4 addSubview:fourMoneyLabel1];
    fourMoneyLabel1.textColor = [UIColor blackColor];
    
    [contentView4 addSubview:self.fourFirstTextField];
    
    UILabel * fourLabel = [[UILabel alloc]init];
    fourLabel.text = @"至";
    fourLabel.font = [UIFont systemFontOfSize:15];
    [contentView4 addSubview:fourLabel];
    fourLabel.textColor = [UIColor lightGrayColor];
    
    
    UILabel * fourMoneyLabel2 = [[UILabel alloc]init];
    fourMoneyLabel2.text = @"¥";
    fourMoneyLabel2.textAlignment = NSTextAlignmentCenter;
    fourMoneyLabel2.font = [UIFont systemFontOfSize:15];
    [contentView4 addSubview:fourMoneyLabel2];
    fourMoneyLabel2.textColor = [UIColor blackColor];
    
    [contentView4 addSubview:self.fourSecondTextField];
    
    [fourMoneyLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView4.mas_top);
        make.bottom.equalTo(contentView4.mas_bottom);
        make.left.equalTo(contentView4.mas_left).offset(8);
        make.width.equalTo(@14);
    }];
    
    [self.fourFirstTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView4.mas_top).offset(5);
        make.bottom.equalTo(contentView4.mas_bottom).offset(-5);
        make.left.equalTo(fourMoneyLabel1.mas_right).offset(8);
        make.right.equalTo(fourLabel.mas_left).offset(-8);
    }];
    
    [fourLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView4.mas_top);
        make.bottom.equalTo(contentView4.mas_bottom);
        make.centerX.equalTo(contentView4.mas_centerX);
        make.centerY.equalTo(contentView4.mas_centerY);
    }];
    
    [fourMoneyLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView4.mas_top);
        make.bottom.equalTo(contentView4.mas_bottom);
        make.left.equalTo(fourLabel.mas_right).offset(8);
        make.width.equalTo(@14);
    }];
    
    [self.fourSecondTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView4.mas_top).offset(5);
        make.bottom.equalTo(contentView4.mas_bottom).offset(-5);
        make.left.equalTo(fourMoneyLabel2.mas_right).offset(8);
        make.right.equalTo(contentView4.mas_right).offset(-8);
    }];
    
    
}

-(void)selectbuttonOnClick:(UIButton  *)button
{
    switch (button.tag) {
        case 500:
        {
            FMAccountTypeDetailController * selectCtr = [[FMAccountTypeDetailController alloc]init];
            selectCtr.accountType = FMAccountTypeDetailControllerTypeRange;
            __weak __typeof(&*self)weakSelf = self;
            selectCtr.selectModel = ^(FMSelectAccountModel * typeDetail){
                weakSelf.selectModle.rangeModel = typeDetail;
                weakSelf.selectRangeLabel.text = typeDetail.title;
            };
            selectCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:selectCtr animated:YES];
        }
            break;
        case 501:
        {
            FMAccountTypeDetailController * selectCtr = [[FMAccountTypeDetailController alloc]init];
            selectCtr.accountType = FMAccountTypeDetailControllerTypeDate;
            __weak __typeof(&*self)weakSelf = self;
            selectCtr.selectModel = ^(FMSelectAccountModel * typeDetail){
                weakSelf.selectModle.dateModel = typeDetail;
                weakSelf.dateSelectRangeLabel.text = typeDetail.title;
                
                [weakSelf changeCurrentDateWithDateModel];
                
                
            };
            selectCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:selectCtr animated:YES];
            
        }
            break;
        case 502:
        {
            XMSelectDataPick * dataPick = [[XMSelectDataPick alloc]init];
            dataPick.typeStyle = XMSelectDataPickStyleStart;
            dataPick.delegate = self;
            [dataPick showTimeWithCurrentTime:[NSDate date]];
            
            
        }
            break;
        case 503:
        {
            XMSelectDataPick * dataPick = [[XMSelectDataPick alloc]init];
            dataPick.typeStyle = XMSelectDataPickStyleend;
            dataPick.delegate = self;
            [dataPick showTimeWithCurrentTime:[NSDate date]];
        }
            break;
            
        default:
            break;
    }
}
-(void)XMSelectDataPickDidSelectTime:(XMSelectDataPick *)dataPick withTurnTime:(NSString *)time;
{
    if (dataPick.typeStyle == XMSelectDataPickStyleStart) {
        
        if (![self.selectModle.firstTime isEqualToString:time]) {
            self.selectModle.grade = 8;
        }
        self.selectModle.firstTime = time;
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
    }else
    {
        if (![self.selectModle.endTime isEqualToString:time]) {
            self.selectModle.grade = 8;
        }
        self.selectModle.endTime = time;
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
    }
    
}

-(void)changeCurrentDateWithDateModel
{
    NSDate *dateOut = [NSDate date];
    
    NSString * currentYearMonthDay = [dateOut retCurrentdateWithYYYY_MM_DD];
    
    FMSelectAccountModel * model = self.selectModle.dateModel;
    if ([model.title_id isEqualToString:@"0200"]) {
        //今日
        self.selectModle.firstTime = currentYearMonthDay;
        self.selectModle.endTime = self.selectModle.firstTime;
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 0;
        
    }else if ([model.title_id isEqualToString:@"0201"])
    {
        //昨日
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:dateOut];//前一天
        self.selectModle.firstTime = [lastDay retCurrentdateWithYYYY_MM_DD];
        self.selectModle.endTime = self.selectModle.firstTime;
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 0;
        
    }else if ([model.title_id isEqualToString:@"0202"])
    {
        //本周
        NSArray * dateArray = [dateOut retWeekFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 1;
        
    }else if ([model.title_id isEqualToString:@"0203"])
    {
        //上周
        NSDate *lastWeek = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 7 sinceDate:dateOut];//前一周
        NSArray * dateArray = [lastWeek retWeekFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 1;
        
    }else if ([model.title_id isEqualToString:@"0204"])
    {
        //本月
        NSArray * dateArray = [dateOut retMonthFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 2;
        
    }else if ([model.title_id isEqualToString:@"0205"])
    {
        //上月
        NSArray * dateArray = [[dateOut lastMonth] retMonthFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 2;
        
        
    }else if ([model.title_id isEqualToString:@"0206"])
    {
        //最近三个月
        NSArray * dateArray = [[dateOut nearByThreeMonth] retMonthFirstDayAndEndDay];
        NSArray * currentMonthArray = [dateOut retMonthFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = currentMonthArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 3;
        
    }else if ([model.title_id isEqualToString:@"0207"])
    {
        //本季
        NSArray * dateArray = [dateOut retQuarterFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 4;
        
        
    }else if ([model.title_id isEqualToString:@"0208"])
    {
        //上季
        NSArray * dateArray = [dateOut retlastQuarterFirstDayAndEndDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 4;
        
        
    }else if ([model.title_id isEqualToString:@"0209"])
    {
        
        //今年
        NSArray * dateArray = [dateOut retYearFirstDayAndEndDayWithStringDate:currentYearMonthDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 5;
        
    }else if ([model.title_id isEqualToString:@"0210"])
    {
        //去年
        NSArray * dateArray = [dateOut retlastYearFirstDayAndEndDayWithStringDate:currentYearMonthDay];
        
        self.selectModle.firstTime = dateArray[0];
        self.selectModle.endTime = dateArray[1];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 5;
        
        
    }else if ([model.title_id isEqualToString:@"0211"])
    {
        //最近7天
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 6 sinceDate:dateOut];//前一天
        self.selectModle.firstTime = [lastDay retCurrentdateWithYYYY_MM_DD];
        self.selectModle.endTime = [dateOut retCurrentdateWithYYYY_MM_DD];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 6;
        
    }else if ([model.title_id isEqualToString:@"0212"])
    {
        //最近30天
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 * 29 sinceDate:dateOut];//前一天
        self.selectModle.firstTime = [lastDay retCurrentdateWithYYYY_MM_DD];
        self.selectModle.endTime = [dateOut retCurrentdateWithYYYY_MM_DD];
        [self.threeLeftButton setTitle:self.selectModle.firstTime forState:UIControlStateNormal];
        [self.threeRightButton setTitle:self.selectModle.endTime forState:UIControlStateNormal];
        self.selectModle.grade = 7;
        
        
    }else
    {
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)selectRangeLabel
{
    if (!_selectRangeLabel) {
        _selectRangeLabel = [[UILabel alloc]init];
        _selectRangeLabel.font = [UIFont systemFontOfSize:15];
        _selectRangeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _selectRangeLabel;
}

-(UILabel *)dateSelectRangeLabel
{
    if (!_dateSelectRangeLabel) {
        _dateSelectRangeLabel = [[UILabel alloc]init];
        _dateSelectRangeLabel.font = [UIFont systemFontOfSize:15];
        _dateSelectRangeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateSelectRangeLabel;
}
-(UIButton *)threeLeftButton
{
    if (!_threeLeftButton) {
        _threeLeftButton = [[UIButton alloc]init];
        _threeLeftButton.tag = 502;
        [_threeLeftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_threeLeftButton addTarget:self action:@selector(selectbuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threeLeftButton;
}
-(UIButton *)threeRightButton
{
    if (!_threeRightButton) {
        _threeRightButton = [[UIButton alloc]init];
        _threeRightButton.tag = 503;
        [_threeRightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_threeRightButton addTarget:self action:@selector(selectbuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threeRightButton;
}


-(UITextField *)fourFirstTextField
{
    if (!_fourFirstTextField) {
        _fourFirstTextField = [[UITextField alloc]init];
        _fourFirstTextField.borderStyle = UITextBorderStyleRoundedRect;
        _fourFirstTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        __weak __typeof(&*self)weakSelf = self;
       _fourFirstTextField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
            [weakSelf keyBoardDown];
        }];
        
        _fourFirstTextField.font = [UIFont systemFontOfSize:15];
    }
    return _fourFirstTextField;
}
-(void)keyBoardDown
{
    [self.view endEditing:YES];
}

-(UITextField *)fourSecondTextField
{
    if (!_fourSecondTextField) {
        _fourSecondTextField = [[UITextField alloc]init];
        _fourSecondTextField.borderStyle = UITextBorderStyleRoundedRect;
        _fourSecondTextField.keyboardType = UIKeyboardTypeDecimalPad;
        __weak __typeof(&*self)weakSelf = self;
        _fourSecondTextField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
            [weakSelf keyBoardDown];
        }];
        _fourSecondTextField.font = [UIFont systemFontOfSize:15];
    }
    return _fourSecondTextField;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 我要记账中，单条记账修改接口
 
 */

@end
