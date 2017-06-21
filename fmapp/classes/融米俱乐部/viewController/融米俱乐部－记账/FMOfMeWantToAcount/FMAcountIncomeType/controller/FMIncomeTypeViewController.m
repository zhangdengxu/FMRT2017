//
//  FMIncomeTypeViewController.m
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMIncomeTypeViewController.h"
#import "FMAcountAddSubViewController.h"
#import "FMIcomeTypeModel.h"

@interface FMIncomeTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FMIncomeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"收入类别"];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDatatoTabelView];
}

- (void)requestDatatoTabelView {
    
    __weak __typeof(self)weakSelf = self;
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow};

    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/allleibie?leibie=2";
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        if (response.responseObject!=nil) {
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status integerValue] == 0) {
                
                [self.dataSource removeAllObjects];
                
                if ([response.responseObject objectForKey:@"data"]) {
                    
                    NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                    
                    NSArray *dataArr = [dic objectForKey:@"incomeArr"];
                    
                    if (dataArr.count) {
                        if (![dataArr isKindOfClass:[NSNull class]]) {
                            
                            for (NSDictionary *dict in dataArr) {
                                
                                FMIcomeTypeModel *model = [[FMIcomeTypeModel alloc]init];
                                [model setValuesForKeysWithDictionary:dict];
                                [self.dataSource addObject:model];
                            }
                        }
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
        }
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight - 64 - 40) style:(UITableViewStyleGrouped)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview;
    });
    [self.view addSubview:_tableView];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self requestDatatoTabelView];
//    }];
    [self createBottomView];
}

- (void)createBottomView{
    
    UIButton *bottomView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [bottomView addTarget:self action:@selector(addIncomeType) forControlEvents:(UIControlEventTouchUpInside)];
    bottomView.backgroundColor = [HXColor colorWithHexString:@"#333333"];
    [self.view addSubview:bottomView];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    UIImageView *addImage = [[UIImageView alloc]init];
    addImage.contentMode = UIViewContentModeScaleAspectFit;
    addImage.image = [UIImage imageNamed:@"新增子类icon_03"];
    [bottomView addSubview:addImage];
    [addImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.centerX.equalTo(bottomView.mas_centerX).offset(-25);
        make.height.with.equalTo(@30);
    }];
    
    UILabel *addLabel = [[UILabel alloc]init];
    addLabel.text = @"新增子类";
    addLabel.font = [UIFont systemFontOfSize:13];
    addLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:addLabel];
    [addLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addImage.mas_right).offset(3);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
}

- (void)addIncomeType{
    
    FMAcountAddSubViewController *addVC = [[FMAcountAddSubViewController alloc]init];
    addVC.titleType = @"新增收入子类";
    addVC.type = 2;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    FMIcomeTypeModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMIcomeTypeModel *model = self.dataSource[indexPath.row];
    if (self.typeSelectBlock) {
        self.typeSelectBlock(model.title);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
