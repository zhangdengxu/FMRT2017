//
//  FMAccountTypeDetailController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAccountTypeDetailController.h"
#import "FMSelectAccountModel.h"

@interface FMAccountTypeDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;



@end

@implementation FMAccountTypeDetailController

static NSString *FMAccountTypeDetailControllerTableRegister = @"FMAccountTypeDetailControllerTableViewCell";

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        if (self.accountType == FMAccountTypeDetailControllerTypeRange) {
            
            _dataSource = [self createRangeModel];
        }else
        {
            _dataSource = [self createDateTypeModel];
        }
        
        
    }
    return _dataSource;
}

-(NSMutableArray *)createDateTypeModel
{
    NSArray * dateTypeArray = @[@{@"title":@"今日",@"title_id":@"0200"},
                                 @{@"title":@"昨日",@"title_id":@"0201"},
                                 @{@"title":@"本周",@"title_id":@"0202"},
                                 @{@"title":@"上周",@"title_id":@"0203"},
                                @{@"title":@"本月",@"title_id":@"0204"},
                                @{@"title":@"上月",@"title_id":@"0205"},
                                @{@"title":@"最近三个月",@"title_id":@"0206"},
                                @{@"title":@"本季",@"title_id":@"0207"},
                                @{@"title":@"上季",@"title_id":@"0208"},
                                @{@"title":@"今年",@"title_id":@"0209"},
                                @{@"title":@"去年",@"title_id":@"0210"},
                                 @{@"title":@"最近7天",@"title_id":@"0211"},
                                 @{@"title":@"最近30天",@"title_id":@"0212"}
                                ];
    NSMutableArray * rangeMUArray = [NSMutableArray array];
    for (NSDictionary * dict in dateTypeArray) {
        FMSelectAccountModel * model = [[FMSelectAccountModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [rangeMUArray addObject:model];
    }
    return rangeMUArray;
    
    
}
-(NSMutableArray *)createRangeModel
{
    NSArray * rangeDataArray = @[@{@"title":@"全部",@"title_id":@"01"},
                                 @{@"title":@"支出",@"title_id":@"02"},
                                 @{@"title":@"收入",@"title_id":@"03"},
                                 @{@"title":@"借贷",@"title_id":@"04"}];
    NSMutableArray * rangeMUArray = [NSMutableArray array];
    for (NSDictionary * dict in rangeDataArray) {
        FMSelectAccountModel * model = [[FMSelectAccountModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [rangeMUArray addObject:model];
    }
    return rangeMUArray;
    
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FMAccountTypeDetailControllerTableRegister];
        //初步预测cell高度
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FMAccountTypeDetailControllerTableRegister forIndexPath:indexPath];
    FMSelectAccountModel * model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMSelectAccountModel * model = self.dataSource[indexPath.row];
    if (self.selectModel) {
        self.selectModel(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.accountType == FMAccountTypeDetailControllerTypeRange) {
        [self settingNavTitle:@"查找范围"];
    }else
    {
        [self settingNavTitle:@"选择日期类型"];
    }
    
    [self tableView];
    
    // Do any additional setup after loading the view.
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

@end
