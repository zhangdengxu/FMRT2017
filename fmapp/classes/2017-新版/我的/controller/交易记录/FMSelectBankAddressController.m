//
//  FMSelectBankAddressController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectBankAddressController.h"
#import "FMBankAddressModel.h"
#import "FMBankAddressHeaderView.h"

@interface FMSelectBankAddressController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FMSelectBankAddressController
static NSString * headerFlagBankAddress = @"FMBankAddressHeaderViewReuse";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"开户行属地"];
    
    [self getDataSourceFromNetWork];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FMBankAddressModel * bankModel = self.dataSource[section];
    if (bankModel.isShowDetail) {
        return bankModel.subs.count;
    }else
    {
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * flag = @"FMSelectBankAddressControllerCellFlag";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:flag];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        cell.textLabel.layoutMargins = UIEdgeInsetsMake(0, 60, 0, 0);
        cell.backgroundColor = [HXColor colorWithHexString:@"e5e9f2"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [HXColor colorWithHexString:@"363738"];
        
    }
    FMBankAddressModel * bankModel = self.dataSource[indexPath.section];
    FMBankAddressModelContent * bankContent = bankModel.subs[indexPath.row];
    cell.textLabel.text = bankContent.region_name;
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMBankAddressModel * bankModel = self.dataSource[indexPath.section];
    FMBankAddressModelContent * bankContent = bankModel.subs[indexPath.row];
//    NSLog(@"region_name:%@",bankContent.region_name);
    
    FMBankAddressModelEnd * endModel = [[FMBankAddressModelEnd alloc]init];
    endModel.region_id = bankContent.region_id;
    endModel.region_name = [NSString stringWithFormat:@"%@ %@",bankModel.region_name,bankContent.region_name];
    
    if (self.bankAddress) {
        self.bankAddress(endModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FMBankAddressHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFlagBankAddress];
    if (!header) {
        header = [[FMBankAddressHeaderView alloc]initWithReuseIdentifier:headerFlagBankAddress];
    }
    FMBankAddressModel * bankModel = self.dataSource[section];
    bankModel.section = section;
    header.bankModel = bankModel;
     __weak __typeof(&*self)weakSelf = self;
    header.bankAddressBlock = ^(FMBankAddressModel * bankModel){
        [weakSelf ctrItemOnClick:bankModel];
    };
    return header;

}
-(void)ctrItemOnClick:(FMBankAddressModel *)bankModel
{
//    if (!bankModel.isShowDetail) {
//        [self.tableView reloadData];
//    }else{
        NSIndexSet * indexSet = [[NSIndexSet alloc]initWithIndex:bankModel.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    
}
/** 开户行所属地 */
-(void)getDataSourceFromNetWork
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *html=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@",bankAddressURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:html parameters:nil completion:^(WebAPIResponse *response) {
        [hud hide:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * dataArray = response.responseObject[@"data"];
            for (NSDictionary * dict in dataArray) {
                FMBankAddressModel * model = [[FMBankAddressModel alloc]init];
                NSArray * subsArray = dict[@"sub"];
                model.region_id = dict[@"region_id"];
                model.region_name = dict[@"region_name"];
                NSMutableArray * subsMuarray = [NSMutableArray array];
                for (NSDictionary * subsDict in subsArray) {
                    FMBankAddressModelContent * modelContent = [[FMBankAddressModelContent alloc]init];
                    [modelContent setValuesForKeysWithDictionary:subsDict];
                    [subsMuarray addObject:modelContent];
                    
                }
                model.subs = subsMuarray;
                [self.dataSource addObject:model];
                
            }
            [self.tableView reloadData];
            
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [HXColor colorWithHexString:@"e5e9f2"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[FMBankAddressHeaderView class] forHeaderFooterViewReuseIdentifier:headerFlagBankAddress];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


@end
