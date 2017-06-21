//
//  YYRechargeRecordViewController.m
//  fmapp
//
//  Created by yushibo on 2016/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//  充值记录

#import "YYRechargeRecordViewController.h"

#import "YYRechargeRecordCell.h"
#import "YYRechargeRecordModel.h"
@interface YYRechargeRecordViewController () <UITableViewDelegate, UITableViewDataSource>
/** 夺宝币  */
@property (nonatomic, strong) UILabel *goldBiLabel;
/** 头像  */
@property (nonatomic, strong) UIImageView * photoImage;
/** ID  */
@property (nonatomic, strong) UILabel *idName;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int currentPage;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation YYRechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"充值记录"];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    self.currentPage = 1;
    [self createHeaderView];
    [self createTableView];
    [self getShareDataSourceFromNetWork];
    [self getRechargeRecordFromNetWork];

}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;

}

- (UILabel *)alertLabel{
    
    if (!_alertLabel) {
        
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无记录";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
        
    }
    return _alertLabel;
}
#pragma mark --- 用户头像网络请求

- (void)getShareDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/coin/getUserWonAccount",kXZTestEnvironment];

    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 };
    
    __weak typeof (self)weakSelf = self;

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            
            return ;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
            if (![dict isMemberOfClass:[NSNull class]]) {
                
                if (dict.count) {
                    if(![dict[@"nickname"] isKindOfClass:[NSNull class]]){
                        if (![[NSString stringWithFormat:@"%@", dict[@"nickname"]] isEqualToString:@""]) {
                            weakSelf.idName.text = [NSString stringWithFormat:@"ID:%@", dict[@"nickname"]] ;
                        }else{
                            weakSelf.idName.text = [NSString stringWithFormat:@"ID:%@", dict[@"phone"]] ;
                        }
                    }else{
                        weakSelf.idName.text = [NSString stringWithFormat:@"ID:%@", dict[@"phone"]] ;
                    }
                    weakSelf.goldBiLabel.text = [NSString stringWithFormat:@"%@", dict[@"coin"]];
                    [weakSelf.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict[@"head_img"]]] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
        }
    }];
    
}
#pragma mark --- 用户充值记录网络请求

- (void)getRechargeRecordFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/coin/getWonCoinRecord",kXZTestEnvironment];

    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 @"type":@"1"
                                 };
    __weak __typeof(self)weakSelf = self;

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    for(NSDictionary *dict in newArray){
                        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                        YYRechargeRecordModel *model = [[YYRechargeRecordModel alloc]initWithDict:infoDict];
//                        [model setValuesForKeysWithDictionary:infoDict];
                        [weakSelf.dataSource addObject:model];
                        
                    }
                }
            }
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
        }else{
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        
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

- (void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 125, KProjectScreenWidth, KProjectScreenHeight - 125 - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getRechargeRecordFromNetWork];
        
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage = _currentPage+1;
        [weakSelf getRechargeRecordFromNetWork];
    }];

    [self.view addSubview:self.tableView];
    
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

#pragma mark --- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID1 = @"YYRechargeRecordCell";
    YYRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YYRechargeRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
    }
    if (self.dataSource.count) {
        cell.status = self.dataSource[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)createHeaderView{

    /*
     **  头部头像栏
    */
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, KProjectScreenWidth, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    /** 头像  */
    UIImageView * photoImage = [[UIImageView alloc]init];
//    photoImage.image = [UIImage imageNamed:@"commtouxiang110"];
    photoImage.backgroundColor = [UIColor darkGrayColor];
    photoImage.layer.masksToBounds = YES;
    photoImage.layer.cornerRadius = 23;
    photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoImage = photoImage;
    [headerView addSubview:photoImage];
    [photoImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(7);
        make.left.equalTo(headerView.mas_left).offset(10);
        make.height.equalTo(@46);
        make.width.equalTo(@46);
    }];

    /** ID  */
    UILabel *idName = [[UILabel alloc]init];
    idName.font = [UIFont systemFontOfSize:17];
    idName.textColor = [UIColor colorWithHexString:@"#333333"];
//    idName.text = @"ID:18483483722";
//    idName.backgroundColor = [UIColor redColor];
//    idName.translatesAutoresizingMaskIntoConstraints = NO;
    self.idName = idName;
    [headerView addSubview:idName];
    [idName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoImage.mas_right).offset(15);
        make.centerY.equalTo(headerView.mas_centerY);
//        
        if (KProjectScreenWidth > 320) {
            make.width.equalTo(160);
        }else {
            
            make.width.equalTo(135);
        }
        
    }];
    
    
    /** 夺宝币个数  */
    UILabel *goldBiLabel = [[UILabel alloc]init];
    self.goldBiLabel = goldBiLabel;
//    goldBiLabel.text = @"111263";
    goldBiLabel.font = [UIFont systemFontOfSize:17];
    goldBiLabel.textColor = [UIColor colorWithHexString:@"#ff6633"];
    [headerView addSubview:goldBiLabel];
    [goldBiLabel makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(walletView.mas_top);
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-10);
    }];
    
    /** 夺宝币图标  */
    UIImageView *walletView = [[UIImageView alloc]init];
    walletView.image = [UIImage imageNamed:@"全新夺宝币-改版"];
    walletView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:walletView];
    [walletView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(goldBiLabel.mas_left).offset(-3);
    }];


    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, KProjectScreenWidth, 50)];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondView];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"获得数量";
    numberLabel.font =[UIFont systemFontOfSize:16];
//    numberLabel.backgroundColor = [UIColor redColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [secondView addSubview:numberLabel];
    [numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(secondView.mas_centerX).offset(15);
        make.centerY.equalTo(secondView.mas_centerY);
        make.width.equalTo((KProjectScreenWidth-30) / 10 * 3);
    }];

    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [secondView addSubview:leftLine];
    [leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(numberLabel.mas_left);
        make.centerY.equalTo(secondView.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(30);
    }];
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [secondView addSubview:rightLine];
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right);
        make.centerY.equalTo(secondView.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(30);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"获得时间";
    timeLabel.font =[UIFont systemFontOfSize:16];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView.mas_left).offset(15);
        make.right.equalTo(leftLine.mas_left);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
    UILabel *wayLabel = [[UILabel alloc]init];
    wayLabel.text = @"获得方式";
    wayLabel.font =[UIFont systemFontOfSize:16];
    wayLabel.textAlignment = NSTextAlignmentCenter;
    wayLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:wayLabel];
    [wayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondView.mas_right);
        make.left.equalTo(rightLine.mas_right);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
    

}

@end
