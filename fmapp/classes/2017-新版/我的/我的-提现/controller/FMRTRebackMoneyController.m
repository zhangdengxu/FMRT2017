//
//  FMRTRebackMoneyController.m
//  fmapp
//
//  Created by apple on 2017/5/31.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRebackMoneyController.h"
#import "FMRTRebackMoneyCell.h"
#import "FMRTRebackHeaderView.h"
#import "IQKeyboardManager.h"
#import "FMRTBankListSelectedController.h"
#import "ShareViewController.h"
#import "FMRTRebackMoneyModel.h"
#import "MJExtension.h"
#import "Fm_Tools.h"
#import "WLFirstPageHeaderViewController.h"

static NSString *FMRTRebackMoneyCellID = @"FMRTRebackMoneyCellID";
@interface FMRTRebackMoneyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FMRTRebackHeaderView *headerView;
@property (nonatomic, strong)FMRTRebackMoneyModel *dataModel;
@property (nonatomic, assign)NSInteger txtType;
@property (nonatomic, copy)  NSString *bankSelectedName;

@end

@implementation FMRTRebackMoneyController

- (void)setBankName:(NSString *)bankName{
    _bankName = bankName;
    self.dataModel.brabankName = bankName;

    [self.tableView reloadData];
}

- (void)setPrcptcd:(NSString *)prcptcd{
    _prcptcd = prcptcd;
}

- (FMRTRebackMoneyModel *)dataModel{
    if (!_dataModel) {
        _dataModel  =[[FMRTRebackMoneyModel alloc]init];
    }
    return _dataModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"提现"];
    
    [self createTableView];
    [self requestTableData];

}

- (void)requestTableData{
        
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@",kXZUniversalTestUrl(@"LLCashQuery"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];

    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        if (response.responseObject) {
            NSLog(@"取现列表===%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess){

                if ([response.responseObject objectForKey:@"data"]) {
                    id dicData = [response.responseObject objectForKey:@"data"];
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *data = (NSDictionary *)dicData;
                        weakSelf.dataModel = [FMRTRebackMoneyModel mj_objectWithKeyValues:data];
                    }
                }
//                weakSelf.headerView.model = weakSelf.dataModel;

                [weakSelf.tableView reloadData];
            }else{
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


- (void)createTableView{
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight-64) style:(UITableViewStylePlain)];
        tableview.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        FMWeakSelf;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestTableData];
        }];
        tableview;
    });
    
    [self.view addSubview:_tableView];

    
//    self.tableView.tableHeaderView = self.headerView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide{
    [self.view endEditing:YES];
}

- (FMRTRebackHeaderView *)headerView{
    if (!_headerView) {//        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 290);

        _headerView = [[FMRTRebackHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 360)];
        FMWeakSelf;
        _headerView.sureBlcok = ^(NSInteger txType, NSString *money) {
            [weakSelf sureActionRequestDataWith:txType money:money];
        };
        _headerView.bankBlcok = ^{
            [weakSelf clickBankSelectedBtn];
        };

    }
    return _headerView;
}

#pragma mark - 选择开户支行
- (void)clickBankSelectedBtn{
    
    FMRTBankListSelectedController *listVC = [[FMRTBankListSelectedController alloc]init];
    listVC.signBankCard = self.dataModel.signBankCard;
    [self.navigationController pushViewController:listVC animated:YES];
}


#pragma mark - 取现
- (void)sureActionRequestDataWith:(NSInteger)txtype money:(NSString *)money{
    
    self.txtType = txtype;
    
    if (self.dataModel.isWorkDay == 1) {

        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请在工作日取现！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alter show];
        
        return;
    }
    
    NSDate *beginTime = [Fm_Tools dateFromDateString:[Fm_Tools getTotalTimeWithSecondsFromString:self.dataModel.beginTime] ];
    
    NSDate *endTime = [Fm_Tools dateFromDateString:[Fm_Tools getTotalTimeWithSecondsFromString:self.dataModel.endTime]];
    
    NSString *beginHour = [Fm_Tools hourMinuteStringFromDate:beginTime];
    NSString *endHour = [Fm_Tools hourMinuteStringFromDate:endTime];
    
    if (txtype == 1) {

        NSString *alertString = [NSString stringWithFormat:@"大额提现只能在工作日%@-%@使用，请知悉！",beginHour,endHour];
        
        NSComparisonResult result = [[NSDate date] compare:beginTime];
        NSComparisonResult backResult = [[NSDate date] compare:endTime];
        
        if (!(result == NSOrderedDescending&& backResult == NSOrderedAscending) ) {
            
            UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertString delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alter show];
            
            return;
        }
    }
    
    if ([money doubleValue] >self.dataModel.acctAmt) {
//        ShowAutoHideMBProgressHUD(self.view, @"提现金额不能超出剩余额度！");
        
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"提现金额不能超出剩余额度！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    NSString *brankName = @"";
    NSString *prcptcd = @"";

    if (txtype == 0) {
        
        if ([money doubleValue] >self.dataModel.transLimit) {
            NSString *alertString = [NSString stringWithFormat:@"您的单笔提现金额超限，请于工作日%@-%@使用大额提现！",beginHour,endHour];
            
//            NSComparisonResult result = [[NSDate date] compare:beginTime];
//            NSComparisonResult backResult = [[NSDate date] compare:endTime];
//            
//            if (!(result == NSOrderedDescending&& backResult == NSOrderedAscending) ) {
//                
//
//            }
            
            UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertString delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alter show];
            
            return;
        }
    }else{
        
        brankName = self.dataModel.brabankName;
        prcptcd = self.prcptcd;

        if (IsStringEmptyOrNull(brankName)) {
            UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择开户支行！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@&TransAmt=%@&TransType=%@&BankCnaps=%@&BrabankName=%@",kXZUniversalTestUrl(@"LLCash"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1",money,@(txtype),prcptcd,brankName];
    NSString *encodedString=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    WLFirstPageHeaderViewController *webVC  = [[WLFirstPageHeaderViewController alloc]init];
    webVC.shareURL = encodedString;
    webVC.navTitle = @"取现";
    
    FMWeakSelf;
    webVC.refreshBackBlock = ^{
        [weakSelf refreshTableHeaderData];
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)refreshTableHeaderData{
    
    [self requestTableData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.dataModel.desc.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        FMRTRebackMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMRTRebackMoneyCellFist"];
        if (cell == nil) {
            cell = [[FMRTRebackMoneyCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"FMRTRebackMoneyCellFist"];
        }
        
        if (self.bankName.length) {
            self.dataModel.brabankName = self.bankName;
        }
        
        cell.model = self.dataModel;
//        cell.bankName = self.bankSelectedName;
        cell.txtType = self.txtType;

        FMWeakSelf;
        cell.sureBlcok = ^(NSInteger txType, NSString *money) {
            [weakSelf sureActionRequestDataWith:txType money:money];
        };
        cell.bankBlcok = ^{
            [weakSelf clickBankSelectedBtn];
        };
        cell.timeBlcok = ^(NSInteger type) {
            weakSelf.txtType = type;
            [weakSelf.tableView reloadData];
        };

        cell.bigBlcok = ^(NSInteger type) {
            weakSelf.txtType = type;

            [weakSelf.tableView reloadData];
        };
        return cell;
        
    }else if(indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTRebackMoneyCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTRebackMoneyCellID];
        }
        FMRTDetailModel *model = self.dataModel.desc[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",model.ID,model.content];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333"];
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.txtType == 0) {
            return 300;
        }else{
            return 375;
        }
    }else{
       return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        
        UILabel *alertLabel = [[UILabel alloc]init];
        alertLabel.text = @"温馨提示:";
        alertLabel.textColor = [HXColor colorWithHexString:@"#FF6633"];
        alertLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:alertLabel];
        [alertLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left).offset(15);
            make.centerY.equalTo(view.centerY);
        }];
        return view;
    }else{
        return nil;
    }
 
}

@end
