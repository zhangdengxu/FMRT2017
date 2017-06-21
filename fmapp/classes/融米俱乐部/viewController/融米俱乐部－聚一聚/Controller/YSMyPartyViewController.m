//
//  YSMyPartyViewController.m
//  fmapp
//
//  Created by yushibo on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSMyPartyViewController.h"
#import "YSMyPartyModel.h"
#import "YSMyPartyViewCell.h"
#import "YSMyPartyInCell.h"
@interface YSMyPartyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 *  活动总数
 */
@property (nonatomic, strong)UILabel *countAll;
/**
 *  左部label
 */
@property (nonatomic, strong)UILabel *countAllLabel3;

@property (nonatomic, strong)NSString *tag;

@property (nonatomic, strong)NSMutableArray *dataSource;
@end


@implementation YSMyPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"我的聚会"];
    self.view.backgroundColor =KDefaultOrBackgroundColor;
    [self createContentView];
    [self createTableView];
    self.tag = @"1";
    [self getDataSourceFromNetWork];

}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *  网络请求
 */
- (void)getDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partyreleaseapp";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"leibie":self.tag
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
    
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
                id newArr = dic[@"listAll"];
                
                self.countAll.text = [NSString stringWithFormat:@"%@", dic[@"countAll"]];
                
                if ([dic[@"countAll"] integerValue] == 0) {
                    ShowAutoHideMBProgressHUD(self.view, @"没有相应活动");
                }
                
                if (![newArr isMemberOfClass:[NSNull class]]) {
                    
                    if ([newArr isKindOfClass:[NSArray class]]) {
                        
                        NSArray *newArray = [NSArray arrayWithArray:newArr];
                        
                        if (newArray.count) {
                            if (![newArray isKindOfClass:[NSNull class]]) {
                                
                                for(NSDictionary *dict in newArray){
                                    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                    YSMyPartyModel *model = [[YSMyPartyModel alloc]initWithDict:infoDict];
                                    [self.dataSource addObject:model];
                                }
                                
                                [self.tableView reloadData];
                            }
                        }
                    }

                }
             }
        }else{
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
    }];
}

/**
 *  创建tabelView
 */
- (void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 48, KProjectScreenWidth - 25, KProjectScreenHeight - 48) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KDefaultOrBackgroundColor;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark ---- UITableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID1 = @"YSMyPartyViewCell";
    static NSString *ID2 = @"YSMyPartyInCell";
    
    if ([self.tag integerValue] == 1) {
        
        YSMyPartyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
        
            cell = [[YSMyPartyViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
      
        }
        //设置cell圆角
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        cell.dataSource = self.dataSource[indexPath.section];

        return cell;
    }else{
        
        YSMyPartyInCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        if (cell == nil) {
            
            cell = [[YSMyPartyInCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
        }
        //设置cell圆角
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        cell.dataSource = self.dataSource[indexPath.section];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([self.tag integerValue]== 1) {
        return 120;
    }else{
        return 160;
    }
}
- (void)createContentView{

    /**
     *  头部试图
     */
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = KDefaultOrBackgroundColor;
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(48);
    }];
    
//左部label
    UILabel *countAllLabel1 = [[UILabel alloc]init];
    countAllLabel1.text = @"共";
    countAllLabel1.font = [UIFont systemFontOfSize:14];
    countAllLabel1.backgroundColor = self.view.backgroundColor;
    [headerView addSubview:countAllLabel1];
    [countAllLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    UILabel *countAllLabel2 = [[UILabel alloc]init];
//    countAllLabel2.text = @"2";
    self.countAll = countAllLabel2;
    countAllLabel2.textAlignment = NSTextAlignmentCenter;
    countAllLabel2.textColor = [UIColor blackColor];
    countAllLabel2.font = [UIFont systemFontOfSize:22];
    countAllLabel2.backgroundColor = self.view.backgroundColor;
    [headerView addSubview:countAllLabel2];
    [countAllLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countAllLabel1.mas_right);
        make.bottom.equalTo(headerView.mas_bottom).offset(2);
    }];
    UILabel *countAllLabel3 = [[UILabel alloc]init];
    countAllLabel3.text = @"个活动";
    countAllLabel3.font = [UIFont systemFontOfSize:14];
    countAllLabel3.backgroundColor = self.view.backgroundColor;
    self.countAllLabel3 = countAllLabel3;
    [headerView addSubview:countAllLabel3];
    [countAllLabel3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countAllLabel2.mas_right);
        make.bottom.equalTo(headerView.mas_bottom);
    }];

//右部button
    UIButton *doingBtn = [[UIButton alloc]init];
    doingBtn.backgroundColor = [UIColor colorWith8BitRed:9 green:64 blue:143 alpha:1];
    [doingBtn setTitle:@"只看进行中的活动" forState:UIControlStateNormal];
    [doingBtn setTitle:@"查看全部活动" forState:UIControlStateSelected];
    [doingBtn.layer setCornerRadius:2];
    [doingBtn setContentEdgeInsets:UIEdgeInsetsMake(9, 10, 8, 10)];
    doingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [doingBtn addTarget:self action:@selector(doingAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doingBtn];
    [doingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
}
- (void)doingAction:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected == YES){  //按钮名字 "查看全部活动"
    
        self.tag = @"2";
        self.countAllLabel3.text = @"个进行中的活动";
        [self.dataSource removeAllObjects];
        [self getDataSourceFromNetWork];
        
    }else{    //按钮名字 "只看进行中的活动"
        
        self.tag = @"1";
        self.countAllLabel3.text = @"个活动";
        [self.dataSource removeAllObjects];
        [self getDataSourceFromNetWork];
        
    }
}



@end
