//
//  FMOfMeWantToAcountViewController.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KMainTableViewTag 9090
#define KSecTableViewTag 9091

#import "FMOfMeWantToAcountViewController.h"
#import "FMOfMeWantAcountTableViewCell.h"
#import "FMAcountModel.h"
#import "FMAcountFootView.h"
#import "FMAcountAddSubViewController.h"

@interface FMOfMeWantToAcountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView, *secTableView;
@property (nonatomic, strong) NSMutableArray *secDataArr, *dataSource;
@property (nonatomic, assign) int ID;

@end

@implementation FMOfMeWantToAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"支出类别"];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataSource removeAllObjects];
    [self.secDataArr removeAllObjects];
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
    
    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/allleibie?leibie=1";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        if (response.responseObject!=nil) {
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status integerValue] == 0) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    
                    NSDictionary * dic = [response.responseObject objectForKey:@"data"];
                    
                    NSArray *lendArr = [dic objectForKey:@"lendArr"];
                    
                    if (lendArr.count) {
                        
                        for (NSDictionary *dict in lendArr) {
                            FMAcountModel *model = [FMAcountModel objectWithKeyValues:dict];
                            
                            [self.dataSource addObject:model];
                        }
                    }
                    
                    FMAcountModel *model = self.dataSource[0];
                    if (model.typeDetailArr.count) {
                        self.secDataArr = [NSMutableArray arrayWithArray:model.typeDetailArr];
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
        }

        [weakSelf.mainTableView reloadData];
        [weakSelf.secTableView reloadData];
        [_mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    }];
}

- (void)createTableView{
    
    _mainTableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth / 4 + 1, KProjectScreenHeight - 64) style:(UITableViewStylePlain)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.tag = KMainTableViewTag;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;

        tableview;
    });
    [self.view addSubview:_mainTableView];
    
    _secTableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(KProjectScreenWidth / 4, 0, KProjectScreenWidth / 4 *3, KProjectScreenHeight - 64) style:(UITableViewStylePlain)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.tag = KSecTableViewTag;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview;
    });
    [self.view addSubview:_secTableView];
    
    __weak typeof (self)weakSelf = self;
    FMAcountFootView *footView = [[FMAcountFootView alloc]init];
    footView.addBlock = ^(){
      
        [weakSelf addSubAcountContent];
    };
    _secTableView.tableFooterView = footView;
    
}

- (void)addSubAcountContent{
    
    FMAcountAddSubViewController *addVC = [[FMAcountAddSubViewController alloc]init];
    addVC.ID = self.ID;
    addVC.type = 1;
    addVC.titleType = @"新增支出子类";
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == KMainTableViewTag) {
        
        return self.dataSource.count;
        
    }else{
        
        return self.secDataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == KMainTableViewTag) {
        
        static NSString *identifier = @"maintableview";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor clearColor];

        FMAcountModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text =model.typeTotalName;
        cell.textLabel.textColor = KContentTextColor;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        
        static NSString *identifier = @"FMOfMeWantAcountTableViewCell";
        FMOfMeWantAcountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FMOfMeWantAcountTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        }
    
        NSDictionary *dic = self.secDataArr[indexPath.row];
        FMAcountLendModel *model = [FMAcountLendModel mj_objectWithKeyValues:dic];
        [cell sendDataWithModel:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == KMainTableViewTag) {
        
        if (self.dataSource.count) {
            
            FMAcountModel *model  = self.dataSource[indexPath.row];
            
            if (model.typeDetailArr.count > 0) {
                [self.secDataArr removeAllObjects];
            }
            self.ID = [model.DID intValue];
            [self.secDataArr addObjectsFromArray:model.typeDetailArr];
            [self.secTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            // [self.secTableView setContentOffset:CGPointMake(0,0) animated:NO];
            [self.secTableView reloadData];
        }
    }else{
        
        if (self.secDataArr.count > 0) {
            
            NSDictionary *dic = self.secDataArr[indexPath.row];
            FMAcountLendModel *model = [FMAcountLendModel objectWithKeyValues:dic];
            
            if (self.typeBlock) {
                self.typeBlock(model.title);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)secDataArr{
    
    if (!_secDataArr) {
        _secDataArr = [NSMutableArray array];
    }
    return _secDataArr;
}

@end
