//
//  FMMonthAccountViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMMonthAccountViewController.h"
#import "FMDefiniteDetailedViewController.h"

#import "FMMonthAccountTableViewCell.h"
#import "NSDate+CategoryPre.h"
#import "FMMonthAddReduceModel.h"
#import "XMAlertTimeView.h"


@interface FMMonthAccountViewController ()<UITableViewDelegate,UITableViewDataSource,XMAlertTimeViewDelegate>

@property (nonatomic, strong) UIView * dataBackGround;
@property (nonatomic, strong) UIButton * timeDateButton;
@property (nonatomic, strong) UIButton * timeDateButtonleft;
@property (nonatomic, strong) UIButton * timeDateButtonright;


@property (nonatomic, strong) UIView * bottomBackGround;
@property (nonatomic, strong) UILabel * allAddPrice;
@property (nonatomic, strong) UILabel * differentPrice;
@property (nonatomic, strong) UILabel * allReducePrice;


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic,copy) NSString * currentYear;

@property (nonatomic, strong) NSArray * startAndEndTime;
@end

@implementation FMMonthAccountViewController
static NSString *monthAccountViewControllerTableRegister = @"MonthAccountViewControllerTableViewCell";
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
     [self settingNavTitle:@"月收支差"];
    
    [self createUIAndMassory];
    
//    [self createUItableView];
    
    [self getDataSourceFromNetWork];
    // Do any additional setup after loading the view.
}



-(void)getDataSourceFromNetWork
{
    //获取网络请求
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jizhang&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString * html = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/yeartotallist";
    NSDictionary * paras;
    if (self.startAndEndTime) {
        paras = @{@"appid":@"jizhang",
                  @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":tokenlow,
                  @"startMonth":self.startAndEndTime[0],
                  @"endMonth":self.startAndEndTime[1]};
    }else
    {
        paras = @{@"appid":@"jizhang",
                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                 @"shijian":[NSNumber numberWithInt:timestamp],
                 @"token":tokenlow,
                 @"year":self.currentYear};
    }
//https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/yeartotallist?appid=jizhang&endMonth=2016-12&shijian=1468034361&startMonth=2016-03&token=4c4992bde57406a04feb40d8b83b5791&user_id=191
   
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:html parameters:paras completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * data = response.responseObject[@"data"];
            FMMonthAddReduceModelBottom * bottomModel = [[FMMonthAddReduceModelBottom alloc]init];
            bottomModel.yearShouru = [NSString stringWithFormat:@"%@",data[@"Yearshouru"]];
            bottomModel.yearShouzhicha = [NSString stringWithFormat:@"%@",data[@"Yearshouzhicha"]];
            bottomModel.yearZhichu = [NSString stringWithFormat:@"%@",data[@"Yearzhichu"]];
            
            
            [self changeBottomView:bottomModel];
            
            if (data[@"monthArray"]) {
                
                NSArray * monthArray = data[@"monthArray"];
                [self.dataSource removeAllObjects];
                for (NSDictionary * dict in monthArray) {
                    FMMonthAddReduceModel * model = [[FMMonthAddReduceModel alloc]init];
                    [model setFMMonthAddReduceModelWithDictionary:dict];
                    [self.dataSource addObject:model];
                }
                if (self.dataSource.count == 0) {
                    ShowAutoHideMBProgressHUD(self.view, @"暂无数据");
                    [self changeBottomViewWithZero];
                }
                [self.tableView reloadData];
            }
        }else if (response.code == WebAPIResponseCodeFailed){
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
            [self changeBottomViewWithZero];
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }else
        {
            [self changeBottomViewWithZero];
            ShowAutoHideMBProgressHUD(self.view, @"网络获取失败");
        }
    }];
}

-(void)changeBottomViewWithZero
{
    self.allAddPrice.text = @"0";
    self.allReducePrice.text = @"0";
    self.differentPrice.text = @"0";
}
-(void)changeBottomView:(FMMonthAddReduceModelBottom *)bottomModel
{
    self.allAddPrice.text = bottomModel.yearShouru;
    self.allReducePrice.text = bottomModel.yearZhichu;
    self.differentPrice.text = bottomModel.yearShouzhicha;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, KProjectScreenWidth - 20, self.view.frame.size.height - 100) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FMMonthAccountTableViewCell class] forCellReuseIdentifier:monthAccountViewControllerTableRegister];
        _tableView.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        //初步预测cell高度
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [self getDataSourceFromNetWork];
//        }];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMMonthAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:monthAccountViewControllerTableRegister forIndexPath:indexPath];
    
    cell.monthModel = self.dataSource[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMMonthAddReduceModel * monthReduce = self.dataSource[indexPath.row];
    FMDefiniteDetailedViewController * defineVC = [[FMDefiniteDetailedViewController alloc]init];
    defineVC.originModel = monthReduce;
    defineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:defineVC animated:YES];
}
-(void)createUIAndMassory
{
    [self.dataBackGround makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@50);
    }];
    
    [self.timeDateButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dataBackGround.mas_centerX);
        make.centerY.equalTo(self.dataBackGround.mas_centerY);
        make.height.equalTo(self.dataBackGround.mas_height);
        
    }];
    
    [self.timeDateButtonleft makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeDateButton.mas_left).offset(-15);
        make.centerY.equalTo(self.timeDateButton.mas_centerY);
        make.width.equalTo(@24);
        make.height.equalTo(@40);
        
    }];
    
    [self.timeDateButtonright makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeDateButton.mas_right).offset(15);
        make.centerY.equalTo(self.timeDateButton.mas_centerY);
        make.width.equalTo(@24);
        make.height.equalTo(@40);
    }];
    
    [self.bottomBackGround makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    UILabel * firstLabel = [[UILabel alloc]init];
    firstLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomBackGround addSubview:firstLabel];
    [firstLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBackGround.mas_left).offset(10);
        make.top.equalTo(self.bottomBackGround.mas_top).offset(5);
    }];
    firstLabel.text = @"总收入:";
    
    
    [self.allAddPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstLabel.mas_right).offset(10);
        make.top.equalTo(firstLabel.mas_top);
    }];
    
    
    UILabel * secondLabel = [[UILabel alloc]init];
    secondLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomBackGround addSubview:secondLabel];
    [secondLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBackGround.mas_centerX).offset(10);
        make.top.equalTo(self.bottomBackGround.mas_top).offset(5);
    }];
    secondLabel.text = @"总收支差:";
    
    
    [self.differentPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondLabel.mas_right).offset(10);
        make.top.equalTo(secondLabel.mas_top);
    }];
    
    
    UILabel * thirdLabel = [[UILabel alloc]init];
    thirdLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomBackGround addSubview:thirdLabel];
    thirdLabel.text = @"总支出:";
    [thirdLabel makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.bottomBackGround.mas_left).offset(10);
        make.bottom.equalTo(self.bottomBackGround.mas_bottom).offset(-5);
        
    }];
    

    [self.allReducePrice makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(thirdLabel.mas_right).offset(10);
        make.top.equalTo(thirdLabel.mas_top);
    }];

    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.dataBackGround.mas_bottom);
        make.bottom.equalTo(self.bottomBackGround.mas_top);
    }];
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

-(void)timeDateButtonrightOnClick
{
    self.startAndEndTime = nil;
    NSInteger  currentYearInt = [self.currentYear integerValue];
    currentYearInt ++;
    
    self.currentYear = [NSString stringWithFormat:@"%zi",currentYearInt];

    NSString * currentTitle = [NSString stringWithFormat:@"%zi-01 至 %zi-12",currentYearInt,currentYearInt];
    [self.timeDateButton setTitle:currentTitle forState:UIControlStateNormal];
    [self getDataSourceFromNetWork];
    
}
-(void)timeDateButtonOnClick
{
    XMAlertTimeView * alterView = [[XMAlertTimeView alloc]init];
    alterView.timeViewType = XMAlertTimeViewTypeyyyyMM;
    alterView.title.text = @"请选择日期";
    alterView.delegate = self;
    
    NSString * cuttentButton = self.timeDateButton.currentTitle;

    [alterView showAlertVeiwWithAllString:[self changduanxianToNianyue:cuttentButton]];

}
-(NSString *)changduanxianToNianyue:(NSString *)time
{
    NSString *strUrl = [time stringByReplacingOccurrencesOfString:@"至" withString:@"－"];
    return strUrl;
    
}
-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;
{
    NSString *strUrl = [time stringByReplacingOccurrencesOfString:@"－" withString:@"至"];
    [self.timeDateButton setTitle:strUrl forState:UIControlStateNormal];
    
    NSString *netString = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *array = [netString componentsSeparatedByString:@"－"];
    if (array.count > 1) {
        self.startAndEndTime = array;
        [self getDataSourceFromNetWork];
    }
}

-(void)timeDateButtonleftOnClick
{
    self.startAndEndTime = nil;
    NSInteger  currentYearInt = [self.currentYear integerValue];
    if (currentYearInt > 0) {
        currentYearInt --;
    }
    self.currentYear = [NSString stringWithFormat:@"%zi",currentYearInt];
    NSString * currentTitle = [NSString stringWithFormat:@"%zi-01 至 %zi-12",currentYearInt,currentYearInt];
    [self.timeDateButton setTitle:currentTitle forState:UIControlStateNormal];
    [self getDataSourceFromNetWork];
}

/**
 *  日期背景
 */
-(UIView *)dataBackGround
{
    if (!_dataBackGround) {
        _dataBackGround = [[UIView alloc]init];
        _dataBackGround.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        [self.view addSubview:_dataBackGround];
    }
    return _dataBackGround;
}
/**
 *  选择时间Button
 */
-(UIButton *)timeDateButton
{
    if (!_timeDateButton) {
        _timeDateButton = [[UIButton alloc]init];
        [_timeDateButton setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_timeDateButton addTarget:self action:@selector(timeDateButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.dataBackGround addSubview:_timeDateButton];
        
        NSString * currentYear = [[NSDate date] turnToThisDateOnlyYearWithFormat];

        self.currentYear = currentYear;
        NSString * currentTitle = [NSString stringWithFormat:@"%@-01 至 %@-12",currentYear,currentYear];
        
        [_timeDateButton setTitle:currentTitle forState:UIControlStateNormal];
    }
    return _timeDateButton;
}
-(UIButton *)timeDateButtonleft
{
    if (!_timeDateButtonleft) {
        _timeDateButtonleft = [[UIButton alloc]init];
        [_timeDateButtonleft addTarget:self action:@selector(timeDateButtonleftOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeDateButtonleft setImage:[UIImage imageNamed:@"记账_红色箭头_03"] forState:UIControlStateNormal];
        _timeDateButtonleft.imageEdgeInsets = UIEdgeInsetsMake(10, 6, 10, 6);
        [self.dataBackGround addSubview:_timeDateButtonleft];
    }
    return _timeDateButtonleft;
}
-(UIButton *)timeDateButtonright
{
    if (!_timeDateButtonright) {
        _timeDateButtonright = [[UIButton alloc]init];
        [_timeDateButtonright addTarget:self action:@selector(timeDateButtonrightOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeDateButtonright setImage:[UIImage imageNamed:@"记账_红色箭头_03"] forState:UIControlStateNormal];
        _timeDateButtonright.transform = CGAffineTransformRotate(_timeDateButtonright.transform, M_PI);
        _timeDateButtonright.imageEdgeInsets = UIEdgeInsetsMake(10, 6, 10, 6);
        [self.dataBackGround addSubview:_timeDateButtonright];
    }
    return _timeDateButtonright;
}

-(UIView *)bottomBackGround
{
    if (!_bottomBackGround) {
        _bottomBackGround = [[UIView alloc]init];
         _bottomBackGround.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        [self.view addSubview:_bottomBackGround];
    }
    return _bottomBackGround;
}

-(UILabel *)allAddPrice
{
    if (!_allAddPrice) {
        _allAddPrice = [[UILabel alloc]init];
        _allAddPrice.font = [UIFont systemFontOfSize:14];
        _allAddPrice.textColor = [UIColor lightGrayColor];
        [self.bottomBackGround addSubview:_allAddPrice];
    }
    return _allAddPrice;
}
-(UILabel *)allReducePrice
{
    if (!_allReducePrice) {
        _allReducePrice = [[UILabel alloc]init];
        _allReducePrice.font = [UIFont systemFontOfSize:14];
        _allReducePrice.textColor = [UIColor lightGrayColor];
        [self.bottomBackGround addSubview:_allReducePrice];
    }
    return _allReducePrice;
}

-(UILabel *)differentPrice
{
    if (!_differentPrice) {
        _differentPrice = [[UILabel alloc]init];
        _differentPrice.font = [UIFont systemFontOfSize:14];
        _differentPrice.textColor = [UIColor lightGrayColor];
        [self.bottomBackGround addSubview:_differentPrice];
    }
    return _differentPrice;
}

/*
 startMonth 表示开始月份  如2013-04
 endMonth   表示结束月份  如2016-07
 这样就表示   2013-04到2016-07之间的所有月收支差
 */

/**
 *
 */

@end
