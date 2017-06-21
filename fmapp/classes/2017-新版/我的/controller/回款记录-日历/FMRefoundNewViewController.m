//
//  FMRefoundNewViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/4/25.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRefoundNewViewController.h"
#import "FSCalendar.h"
#import "Fm_Tools.h"
#import "HooDatePicker.h"

@interface FMRefoundNewViewController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,UIGestureRecognizerDelegate,HooDatePickerDelegate>
{
    void * _KVOContext;
}


@property (nonatomic, weak)   FSCalendar *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic, strong) HooDatePicker *datePicker;


@end

@implementation FMRefoundNewViewController
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(HooDatePicker *)datePicker
{
    if (!_datePicker) {
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        _datePicker = [[HooDatePicker alloc] initWithSuperView:keyWindow];
        _datePicker.delegate = self;
        _datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
        NSDate *minDate = [dateFormatter dateFromString:@"1990-01-01"];
        
        
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
    }
    return _datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self settingNavTitle:@"回款记录"];
    [self createContentView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeMonth;
    self.calendar.accessibilityIdentifier = @"calendar";
    
    // Do any additional setup after loading the view.
}


- (void)createContentView{
    
    FSCalendar *calendar = [[FSCalendar alloc]init];
    [self.view addSubview:calendar];
    [calendar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(KProjectScreenWidth);
        make.top.equalTo(self.view.top);
    }];
    calendar.delegate = self;
    calendar.dataSource = self;
    
    //    calendar.appearance.titleSelectionColor = [UIColor redColor];
    calendar.calendarWeekdayView.backgroundColor = [UIColor whiteColor];
    calendar.calendarHeaderView.backgroundColor = [UIColor whiteColor];
    calendar.backgroundColor = XZColor(249, 249, 249);
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.todayColor = [UIColor lightGrayColor];
    calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"#333"];
    calendar.appearance.weekdayTextColor = [UIColor colorWithHexString:@"#333"];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.titlePlaceholderColor = [UIColor clearColor];
    
    self.calendar = calendar;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(calendar.bottom);
        make.bottom.equalTo(self.view.bottom);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
