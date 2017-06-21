//
//  WLGBJLViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLGBJLViewController.h"
#import "HTTPClient+Interaction.h"
#import "WLRegularViewController.h"
#import "HTTPClient+Interaction.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "FMShopSpecModel.h"
#import "Fm_Tools.h"

#define KReuseCellId @"GBJLTableVControllerCell"
@interface WLGBJLViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIView *bjView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)XZActivityModel *model;
@property (nonatomic,strong)UILabel *labelHeaderView;

@end

@implementation WLGBJLViewController

-(NSArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UIView *)bjView{
    
    if (!_bjView) {
        _bjView = [[UIView alloc]initWithFrame:self.view.frame];;
    }
    return _bjView;
}

-(XZActivityModel *)model{
    
    if (!_model) {
        _model = [[XZActivityModel alloc]init];;
    }
    return _model;
}

- (UILabel *)labelHeaderView {
    if (!_labelHeaderView) {
        _labelHeaderView = [[UILabel alloc] initWithFrame:CGRectMake((KProjectScreenWidth - 100) * 0.5, KProjectScreenWidth * 0.5, 100, 50)];
        _labelHeaderView.text = @"暂无数据";
        _labelHeaderView.textColor = [UIColor darkGrayColor];
        _labelHeaderView.font = [UIFont boldSystemFontOfSize:16.0f];
        _labelHeaderView.textAlignment = NSTextAlignmentCenter;
    }
    return _labelHeaderView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataFromNetWork];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 1;
    [self settingNavTitle:@"充值记录"];
    [self.view setBackgroundColor:[UIColor colorWithRed:218/255.0f green:45/255.0f blue:64/255.0f alpha:1]];
    [self createContentView];
    [self refreshForFirst];
}

-(void)refreshForFirst{

    _currentPage = 1;
    _isAddData = NO;
    [self getDataFromNetWork];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.myTableView reloadData];
}

-(void)createContentView{
    
    UIImageView *headView = [[UIImageView alloc]init];
    headView.image = [UIImage imageNamed:@"photo"];
    //    headView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headView];
    [headView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    UIView *bjView = [[UIView alloc]init];
    [bjView setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1]];
    [self.view addSubview:bjView];
    [bjView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-10);
        make.left.equalTo(headView.mas_left).offset(10);
        make.top.equalTo(headView.mas_bottom);

        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
        
    }];
    
    
    self.myTableView = [[UITableView alloc]init];
    self.myTableView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _isAddData = NO;
        [self getDataFromNetWork];
    }];
    self.myTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        _isAddData = YES;
        [self getDataFromNetWork];
    }];
    [bjView addSubview:self.myTableView];
    [self.myTableView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bjView.mas_right).offset(-15);
        make.left.equalTo(bjView.mas_left).offset(15);
        make.top.equalTo(bjView.mas_top).offset(25);
        make.bottom.equalTo(bjView.mas_bottom).offset(-50);
        
    }];
    
      
}


-(void)getDataFromNetWork{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *string =[NSString stringWithFormat:@"%@/public/won/coin/getCoinRecord",kXZTestEnvironment];
    
    //NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/java/public/won/coin/getCoinRecord"];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,@"page":[NSString stringWithFormat:@"%d",self.currentPage],@"type":@"1",@"trench":@""};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            Log(@"***********%@",response.responseObject);
            
            NSArray * oldArray = response.responseObject[@"data"];
            
            if (_isAddData) {
                
                _isAddData = NO;
            }else{
                [self.dataArr removeAllObjects];
            }
            if (oldArray.count != 0) {
                
                if (self.currentPage == 1) {
                    [[self labelHeaderView] removeFromSuperview];
                }
                for(NSDictionary * dict in oldArray) {
                    
                    [self.dataArr addObject:dict];
                    
                }
            }else{
                if (self.currentPage == 1) {

                    [self.view addSubview:[self labelHeaderView]];
                }
            }
                        
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [weakSelf.myTableView reloadData];
    }];
}


#pragma mark ---- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 40)];
    [bjView setBackgroundColor:[UIColor whiteColor]];
    bjView.layer.borderWidth = .5;
    bjView.layer.borderColor = [KDefaultOrBackgroundColor CGColor];
    [cell.contentView addSubview:bjView];

    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 40)];
    [leftLabel setText:[NSString stringWithFormat:@"购币数量：%@个",[dic objectForKey:@"coin"]]];
    [leftLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
    
    if (KProjectScreenWidth<330) {
       [leftLabel setFont:[UIFont boldSystemFontOfSize:11]];
    }else if (KProjectScreenWidth<380){
        [leftLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }else{
        [leftLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    [cell.contentView addSubview:leftLabel];
    
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deal_time"]];
    NSString *showTime = [Fm_Tools getTimeFromString:str];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-300-10, 2, 300, 20)];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",showTime];
    [timeLabel setText:timeStr];
    [timeLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    
    if (KProjectScreenWidth<330) {
        [timeLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }else if (KProjectScreenWidth<380){
        [timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }else{
        [timeLabel setFont:[UIFont boldSystemFontOfSize:14]];    }
    [cell.contentView addSubview:timeLabel];
    
    NSString *str1 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deal_time"]];
    UILabel *timeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-300-10, 20, 300, 20)];
    NSString *timeStr1 = [NSString stringWithFormat:@"%@",[Fm_Tools getTheTotalTimeWithSecondsFromString:str1]];
    [timeLabel2 setText:timeStr1];
    timeLabel2.text = timeStr1;
    [timeLabel2 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [timeLabel2 setTextAlignment:NSTextAlignmentRight];
    
    if (KProjectScreenWidth<330) {
        [timeLabel2 setFont:[UIFont boldSystemFontOfSize:12]];
    }else if (KProjectScreenWidth<380){
        [timeLabel2 setFont:[UIFont boldSystemFontOfSize:13]];
    }else{
        [timeLabel2 setFont:[UIFont boldSystemFontOfSize:14]];    }
    [cell.contentView addSubview:timeLabel2];

    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
