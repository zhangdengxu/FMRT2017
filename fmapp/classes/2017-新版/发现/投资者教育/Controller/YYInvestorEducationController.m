//
//  YYInvestorEducationController.m
//  fmapp
//
//  Created by yushibo on 2017/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//  发现 -- 投资者教育界面 

#import "YYInvestorEducationController.h"
#import "YYLatestInformationModel.h"
#import "YYInvestorEducationCell.h"
#import "YYRongMiCell.h"
#import "ShareViewController.h"
#import "XZRongMiSchoolController.h"  // 融米学堂

@interface YYInvestorEducationController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UILabel *titleLabel;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) NSURLSessionDataTask * dataTask;

@end

@implementation YYInvestorEducationController
#pragma mark --- 懒加载
- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无数据";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self createNavTitle];
    [self createTableView];
    [self getDataSourceFromNetWork];
    
    
}
-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = [self CreateTableHeaderView];
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            _currentPage = 1;
            [weakSelf.dataSource removeAllObjects];
            [weakSelf getDataSourceFromNetWork];
            
        }else{
            
            [weakSelf.dataSource removeAllObjects];
            [weakSelf getSchoolDataSourceFromNetWork];
        }

        
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            _currentPage = _currentPage+1;
            [weakSelf getDataSourceFromNetWork];
            
        }else{
            
            [self.dataSource removeAllObjects];
            [weakSelf getSchoolDataSourceFromNetWork];
        }
        
    }];
    
    [self.view addSubview:self.tableView];
    
}
- (UIView *)CreateTableHeaderView{
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth * 290) / 640)];
    imageV.userInteractionEnabled = YES;
    self.imageV = imageV;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {

    }else{
    
        UIImageView *centerView = [[UIImageView alloc]init];
        centerView.image = [UIImage imageNamed:@"融米学堂_播放-icon_1702"];
        centerView.contentMode = UIViewContentModeScaleAspectFit;
        [imageV addSubview:centerView];
        [centerView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageV);
        }];
    }
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [imageV addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(imageV);
        make.height.equalTo(40);
        
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];

    self.titleLabel = titleLabel;
    [bottomView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.right.equalTo(bottomView.mas_right);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(clickBtnJump:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(imageV);
    }];
    
    return imageV;

}
- (void)clickBtnJump:(UIButton *)button{

    YYLatestInformationModel *model = self.dataSource[0];
    
    NSString *title = @"理财讲堂";
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        title = @"融米学堂";
        XZRongMiSchoolController *miVc = [[XZRongMiSchoolController alloc]init];
        miVc.articleId = model.news_id;
        [self.navigationController pushViewController:miVc animated:YES];
    }else{
        
        ShareViewController *webViewController=[[ShareViewController alloc]initWithTitle:title AndWithShareUrl:[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zixunshow?news_id=%@",model.news_id]];
        webViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }

    
    
}
#pragma mark --- 理财讲堂 -- 网络请求
- (void)getDataSourceFromNetWork{
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }

    NSString *urlStr = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/indexapp/zixunmore";
    NSDictionary * parameter = @{
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 @"leixing":@"2"
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (self.currentPage == 1) {
                
                [self.dataSource removeAllObjects];
            }

            
            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    
                    for(NSDictionary *dict in newArray){
                        
                        YYLatestInformationModel *model = [[YYLatestInformationModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        [weakSelf.dataSource addObject:model];
                    }
                    weakSelf.tableView.tableHeaderView = [weakSelf CreateTableHeaderView];
                    YYLatestInformationModel *model = weakSelf.dataSource[0];
                    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]] placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"]];
                    self.titleLabel.text = model.title;;

                }
                /** 暂无数据提示 */
                if (weakSelf.dataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
            }
        }else{
            
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark --- 融米学堂 -- 网络请求
-(void)getSchoolDataSourceFromNetWork{
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }

    NSString *string = kRongmiClub_RongmiSchoolClass;
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            [self.dataSource removeAllObjects];

            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    
                    for(NSDictionary *dict in newArray){
                        
                        YYLatestInformationModel *model = [[YYLatestInformationModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        [weakSelf.dataSource addObject:model];
                    }
                    
                    weakSelf.tableView.tableHeaderView = [weakSelf CreateTableHeaderView];

                    YYLatestInformationModel *model = weakSelf.dataSource[0];
                    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.rongtuojinrong.com%@", model.videoThumb]] placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"]];
                    self.titleLabel.text = model.title;;
                }
                /** 暂无数据提示 */
                if (weakSelf.dataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
            }
        }else{
            
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark ---   UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count) {
        
        return self.dataSource.count - 1;
    }else{
        
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID1 = @"YYInvestorEducationCell";
    static NSString *ID2 = @"YYRongMiCell";

    if (self.segmentedControl.selectedSegmentIndex == 0) {

        YYInvestorEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            cell = [[YYInvestorEducationCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
        }
        if (self.dataSource.count) {
            cell.status = self.dataSource[indexPath.row + 1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
        YYRongMiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell == nil) {
            cell = [[YYRongMiCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
        }
        if (self.dataSource.count) {
            cell.status = self.dataSource[indexPath.row + 1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 200;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYLatestInformationModel *model = self.dataSource[indexPath.row + 1];
    
    NSString *title = @"理财讲堂";
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        title = @"融米学堂";
        
        XZRongMiSchoolController *miVc = [[XZRongMiSchoolController alloc]init];
        miVc.articleId = model.news_id;
        [self.navigationController pushViewController:miVc animated:YES];
    }else{
    
        ShareViewController *webViewController=[[ShareViewController alloc]initWithTitle:title AndWithShareUrl:[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zixunshow?news_id=%@",model.news_id]];
        webViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


- (void)createNavTitle{
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"理财讲堂", @"融米学堂", nil]];
    segmentedControl.tintColor = [UIColor colorWithHexString:@"#0159d5"];
    //    [segmentedControl setFrame:CGRectMake((KProjectScreenWidth-240)/2, 7, 240, 30)];
    CGRect frame = segmentedControl.frame;
    frame.size.width = 220;
    segmentedControl.frame = frame;
    [segmentedControl addTarget:self action:@selector(segmentedControlChange) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    
    self.segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;
}

- (void)segmentedControlChange{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        self.currentPage = 1;
        
        [self getDataSourceFromNetWork];
        
    }else{
        
//        self.currentPage = 1;
        
        [self getSchoolDataSourceFromNetWork];
        
    }
    
}

@end
