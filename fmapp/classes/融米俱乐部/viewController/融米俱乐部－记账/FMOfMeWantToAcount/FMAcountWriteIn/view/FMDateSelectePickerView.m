//
//  FMDateSelectePickerView.m
//  fmapp
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDateSelectePickerView.h"


@interface FMDateSelectePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSCalendar *calendar;
    UIButton   *cancelButton;
    UIButton   *chooseButton;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy)   NSString     *string;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIView       *upView;

@end
@implementation FMDateSelectePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {

    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 25, KProjectScreenWidth, 200)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    [self addSubview:self.pickerView];

    UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, KProjectScreenWidth+4, 40)];
    self.upView = upVeiw;
    [self addSubview:upVeiw];
     self.upView.backgroundColor = [UIColor grayColor];
    
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12, 0, 40, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    UIColor *titleColor = [UIColor whiteColor];
    [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];

    [cancelButton addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
    [upVeiw addSubview:cancelButton];
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(KProjectScreenWidth - 50, 0, 40, 40);
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.backgroundColor = [UIColor clearColor];
    UIColor *tiColor = [UIColor whiteColor];
    [chooseButton setTitleColor:tiColor forState:UIControlStateNormal];

    [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
    [upVeiw addSubview:chooseButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel = titleLabel;
    self.titleLabel.textColor = [UIColor whiteColor];

    [upVeiw addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(upVeiw.mas_centerY);
        make.centerX.equalTo(upVeiw.mas_centerX);
    }];

    startYear = 1970;
    yearRange = 2000;
    selectedYear = 0;
    selectedMonth = 1;
    selectedDay = 1;
    selectedHour = 0;
    selectedMinute = 0;
    dayRange=[self isAllDay:startYear andMonth:1];
//    [self hiddenPickerView];
     self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
}


- (void)setSureButtonTintColor:(UIColor *)sureButtonTintColor{
    _sureButtonTintColor = sureButtonTintColor;
    UIColor *titleColor = self.sureButtonTintColor?self.sureButtonTintColor:[UIColor whiteColor];
    [chooseButton setTitleColor:titleColor forState:UIControlStateNormal];
    
}

- (void)setCancelButtonTintColor:(UIColor *)cancelButtonTintColor{
    _cancelButtonTintColor = cancelButtonTintColor;
    UIColor *titleColor = self.cancelButtonTintColor;
    [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
   
}

- (void)setDateBackgroundColor:(UIColor *)dateBackgroundColor{
    _dateBackgroundColor = dateBackgroundColor;
    self.pickerView.backgroundColor = self.dateBackgroundColor;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = self.title ;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    
    self.titleLabel.textColor = self.titleColor;
}

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor{
    _titleBackgroundColor = titleBackgroundColor;
     self.upView.backgroundColor = self.titleBackgroundColor;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return dayRange;
        }
            break;
        case 3:
        {
            return 24;
        }
            break;
        case 4:
        {
            return 60;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)setCurDate:(NSDate *)curDate{
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    comps = [calendar0 components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    [self.pickerView selectRow:year-startYear inComponent:0 animated:true];
    [self.pickerView selectRow:month-1 inComponent:1 animated:true];
    [self.pickerView selectRow:day-1 inComponent:2 animated:true];
    [self.pickerView selectRow:hour inComponent:3 animated:true];
    [self.pickerView selectRow:minute inComponent:4 animated:true];
    
    [self.pickerView reloadAllComponents];
    
     _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute];
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth*component/6.0, 0,KProjectScreenWidth/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,KProjectScreenWidth/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(KProjectScreenWidth/4.0, 0, KProjectScreenWidth/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
        case 2:
        {
            label.frame=CGRectMake(KProjectScreenWidth*3/8, 0, KProjectScreenWidth/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
        }
            break;
        case 3:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld时",(long)row];
        }
            break;
        case 4:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld分",(long)row];
        }
            break;
        case 5:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.frame=CGRectMake(KProjectScreenWidth*component/6.0, 0, KProjectScreenWidth/6.0-5, 30);
            label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
        }
            break;
            
        default:
            break;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        {
            selectedYear=startYear + row;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            selectedDay=row+1;
        }
            break;
        case 3:
        {
            selectedHour=row;
        }
            break;
        case 4:
        {
            selectedMinute=row;
        }
            break;
            
        default:
            break;
    }
    
    _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute];
    
}

- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200);
    } completion:^(BOOL finished) {
    }];
}


- (void)hiddenPickerView{
    
    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
    }];
}

-(void)hiddenPickerViewRight{
    
    [UIView animateWithDuration:0.7f animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
    }];
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        [self.delegate didFinishPickView:_string];
    }
}

-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month{
    
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0)){
                day=29;
                break;
            }else{
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


@end
