//
//  WLJPJLViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLJPJLViewController.h"
#import "HTTPClient+Interaction.h"
#import "Fm_Tools.h"
#define KReuseCellId @"JPJLTableVControllerCell"

@interface WLJPJLViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation WLJPJLViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getDataFromNetWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self settingNavTitle:@"竞拍记录"];
    [self createHeader];
    [self createTabelView];
}

-(NSArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)createHeader{
    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
    [bjView setBackgroundColor:[UIColor colorWithRed:228/255.0f green:235/255.0f blue:240/255.0f alpha:1]];
    [self.view addSubview:bjView];
    NSArray *array = [NSArray arrayWithObjects:@"用户ID",@"出价金额",@"出价时间", nil];
    for (int i=0; i<3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3*i, 0, KProjectScreenWidth/3, 50)];
        [titleLabel setText:array[i]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        if (KProjectScreenWidth<350) {
            [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        }
        [bjView addSubview:titleLabel];
    }
    
}

-(void)getDataFromNetWork{
    
    NSString *navUrl =[NSString stringWithFormat:@"%@/public/show/getAuctionRecord",kXZTestEnvironment];
    
    
    //NSString *navUrl = @"https://www.rongtuojinrong.com/java/public/show/getAuctionRecord";
    NSDictionary * parameter = @{@"auction_id":self.auction_id,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"only_user":@"false",
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){

        if (response.code == WebAPIResponseCodeSuccess) {

        NSArray * oldArray = response.responseObject[@"data"];
                
        if (_isAddData) {
                        
            _isAddData = NO;
            }else{
            [self.dataArr removeAllObjects];
            }
            if (oldArray.count != 0) {
                        
               for(NSDictionary * dict in oldArray) {
                            
                   [self.dataArr addObject:dict];
                            
                }
            }
            [weakSelf.myTableView reloadData];
            
            }
            [weakSelf.myTableView.mj_header endRefreshing];
            [weakSelf.myTableView.mj_footer endRefreshing];
        });
    }];
    
}

-(void)createTabelView{
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50-45) style:UITableViewStylePlain];
    self.myTableView.backgroundColor = [UIColor clearColor];
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
     
    
    [self.view addSubview:self.myTableView];
    
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
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth/3, 60)];
    //    电话
     NSMutableString *telStr = [[NSMutableString  alloc] initWithString:[dic objectForKey:@"phone"]];
     [telStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [titleLabel setText:telStr];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    if (KProjectScreenWidth<350) {
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    [cell.contentView addSubview:titleLabel];
    
//    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/4, 0, KProjectScreenWidth/4, 60)];
//    [detailLabel setTextAlignment:NSTextAlignmentCenter];
//    [detailLabel setText:[NSString stringWithFormat:@"%@次",[dic objectForKey:@"record_id"]]];
//    detailLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    if (KProjectScreenWidth<350) {
//        detailLabel.font = [UIFont boldSystemFontOfSize:14];
//    }
//    
//    detailLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
//    [cell.contentView addSubview:detailLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 59, cell.contentView.frame.size.width-20, 1)];
    lineView1.backgroundColor = KDefaultOrBackgroundColor;
    [cell.contentView addSubview:lineView1];
    
    
    UILabel *jineLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3, 0, KProjectScreenWidth/3, 60)];
    [jineLabel setTextAlignment:NSTextAlignmentCenter];
    [jineLabel setText:[NSString stringWithFormat:@"%@元",[dic objectForKey:@"price"]]];
    jineLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    if (KProjectScreenWidth<350) {
        jineLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    jineLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    [cell.contentView addSubview:jineLabel];
    
    //    时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3*2, 10, KProjectScreenWidth/3-10, 20)];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    NSString *timeStr = [Fm_Tools getTimeFromString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trans_time"]]];
     NSString *timeStr1 = [Fm_Tools getTheTotalTimeWithSecondsFromString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trans_time"]]];
    [timeLabel setText:timeStr1];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    timeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
    [cell.contentView addSubview:timeLabel];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3*2, 30, KProjectScreenWidth/3-10, 20)];
    [nameLabel setTextAlignment:NSTextAlignmentRight];
    [nameLabel setText:timeStr];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
    [cell.contentView addSubview:nameLabel];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
