//
//  YYInstructionsController.m
//  fmapp
//
//  Created by yushibo on 2016/12/15.
//  Copyright © 2016年 yk. All rights reserved.
//  优惠券使用说明

#import "YYInstructionsController.h"
#import "YYinstructionsCell.h"
#import "YYInstructionsModel.h"

@interface YYInstructionsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, strong)NSMutableArray *listArra1;
@property (nonatomic, strong)NSMutableArray *listArra2;
@property (nonatomic, strong)NSMutableArray *listArra3;
@property (nonatomic, strong)NSMutableArray *listArra4;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation YYInstructionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:self.navTitle];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [self createTableView];
}

#pragma mark --- 创建TabeView
- (void)createTableView{
    
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)style:(UITableViewStylePlain)];
        tableview.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    tableview.backgroundColor = [UIColor redColor];
    
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView = tableview;
    tableview.tableHeaderView = [self setUpTableHeaderView];
    [self.view addSubview:self.tableView];
    
}
- (UIView *)setUpTableHeaderView{

    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 7)];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#E5E9F2"];
    return lineV;
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID1 = @"YYCouponCell";
    YYinstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YYinstructionsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
    }
    
    if (self.dataSource.count) {
        
        cell.status = self.dataSource[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.state integerValue] == 4) {
        return ([YYinstructionsCell heightForCellWith:self.dataSource[indexPath.row]] - 15);

    }else{
    return [YYinstructionsCell heightForCellWith:self.dataSource[indexPath.row]];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark --  数据
-(NSMutableArray *)listArra1{
    if(!_listArra1){
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];

        [dict1 setObject:@"Q: 如何选择红包券？" forKey:@"title"];
        [dict1 setObject:@"用户投资时，可选择需要使用的红包，选择红包后，可自动抵减投资本金。（如未选择使用红包，则此次投资不享受红包抵扣）\n普通标默认用户使用红包券，若用户不想使用可自行选择不使用。" forKey:@"content"];
        
        [dict2 setObject:@"Q: 每次投资可以使用几个红包券？" forKey:@"title"];
        [dict2 setObject:@"每次投资只能使用一个红包券，且不能和加息券同时使用。" forKey:@"content"];
        
        [dict3 setObject:@"Q: 各类红包券的使用条件是什么？" forKey:@"title"];
        [dict3 setObject:@"各类红包的具体使用条件请参阅该红包券的介绍页面。" forKey:@"content"];
        
        [dict4 setObject:@"Q: 使用了红包券投资如何计算收益？" forKey:@"title"];
        [dict4 setObject:@"使用了红包券，按照您的投资本金正常计算收益。比如：您投标了1000元，用了5元的红包券，实际支付995元，系统会按照1000元正常计算收益。" forKey:@"content"];
        
        [dict5 setObject:@"Q: 系统在选择默认红包时按照什么规则？" forKey:@"title"];
        [dict5 setObject:@"优先按照红包券到期时间由早到晚进行排序；\n当红包券到期时间相同时，按照红包券金额由大到小进行排序；\n当红包券金额相同时，按照红包券发放时间由早到晚进行排序；" forKey:@"content"];
        
        NSMutableArray *listArray1 = [[NSMutableArray alloc]init];
        [listArray1 addObject:dict1];
        [listArray1 addObject:dict2];
        [listArray1 addObject:dict3];
        [listArray1 addObject:dict4];
        [listArray1 addObject:dict5];

        
        _listArra1 = listArray1;
    }
    return _listArra1;
}
-(NSMutableArray *)listArra2{
    
    if(!_listArra2){
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]init];
        [dict1 setObject:@"Q: 如何选择加息券？" forKey:@"title"];
        [dict1 setObject:@"用户投资时，可选择需要使用的加息券，投资完成后，即可按约定获得额外收益。（如未选择使用加息券，则此次投资不享受福利）\n带有加息标志的活动标，系统默认您使用符合条件的加息券；用户不想使用时可自行选择不使用。" forKey:@"content"];
        
        [dict2 setObject:@"Q: 加息券可以叠加使用吗？" forKey:@"title"];
        [dict2 setObject:@"不可以，每次投资只能使用一张加息券，且加息券和红包券不能同时使用；" forKey:@"content"];
        
        [dict3 setObject:@"Q: 何时能够获得加息券收益？" forKey:@"title"];
        [dict3 setObject:@"投标成功后，使用了加息券的用户，会按照加息后的利息计算每月收益，到期还本。" forKey:@"content"];
        
        [dict4 setObject:@"Q: 加息券的种类？" forKey:@"title"];
        [dict4 setObject:@"加息券分为活动加息券和通用加息券；活动加息券只能在活动期间使用，且只能用于活动标，普通标不能使用；通用加息券可以用于活动标，也可以用于普通标。" forKey:@"content"];
        
        [dict5 setObject:@"Q: 活动标默认优先使用加息券，在默认选择加息券时按照哪些规则？" forKey:@"title"];
        [dict5 setObject:@"优先按照加息券到期时间由早到晚进行排序；\n当加息券到期时间相同时，按照加息利率由大到小进行排序；\n当加息利率相同时，按照加息券发放时间由早到晚进行排序；" forKey:@"content"];
        
        [dict6 setObject:@"Q: 当发生提前还款时，如何计算加息券收益？" forKey:@"title"];
        [dict6 setObject:@"若在投资期间发生提前还款，则按照实际期限计算加息收益，未到期部分不再计算。" forKey:@"content"];
        
        [dict7 setObject:@"Q: 加息期限与加息券有效期有何区别？" forKey:@"title"];
        [dict7 setObject:@"加息期限指获得加息收益的期限，比如加息券1%投标了2个月的标，那么加息期限就是2个月；加息券有效期指加息券需在该期间内使用，比如加息券有效期是10天，需要在10天内使用该加息券。" forKey:@"content"];
        
        NSMutableArray *listArray2 = [[NSMutableArray alloc]init];
        [listArray2 addObject:dict1];
        [listArray2 addObject:dict2];
        [listArray2 addObject:dict3];
        [listArray2 addObject:dict4];
        [listArray2 addObject:dict5];
        [listArray2 addObject:dict6];
        [listArray2 addObject:dict7];
        _listArra2 = listArray2;
    }
    return _listArra2;
}
-(NSMutableArray *)listArra3{
    
    if(!_listArra3){
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        
        [dict1 setObject:@"Q: 什么是抵价券？" forKey:@"title"];
        [dict1 setObject:@"抵用券是融托金融优商城活动专用的一种抵扣券， 可用于抵用部分商品价格，具体以产品可抵用额度为准。抵用券可通过多种方式获得，需在有效期内使用。抵价券面额将根据活动测算的实际情况，设置相应面额。常规一般会设置为1-10元等。具体面额设置将根据当期促销活动决定启用何等面额。" forKey:@"content"];
        
        [dict2 setObject:@"Q: 如何使用抵价券？" forKey:@"title"];
        [dict2 setObject:@"1、必须在抵价券有效期内使用，抵价有效期将根据活动测算的实际情况，设置期限。常规期限一般为30天。\n2、必须在指定活动使用区内使用抵价券\n3、抵价券不得拆分使用，不得累加，一笔交易只能使用一张抵价券\n4、抵价券必须使用于支持相应面额抵价券的商品上，消费额度满10元，方能使用抵价券\n5、抵价券不能与其他优惠同时享使用\n6、抵价券不能抵扣邮费，只能抵扣最终成交的商品价格\n7、当交易关闭时，如果买家使用了抵价券，系统会自动退还抵价券给买家，但如果抵价券已经过期，将无法继续使用；其他情况下，抵价券一经使用将不得退还。" forKey:@"content"];
        
        NSMutableArray *listArray3 = [[NSMutableArray alloc]init];
        [listArray3 addObject:dict1];
        [listArray3 addObject:dict2];
        
        _listArra3 = listArray3;
    }
    return _listArra3;
}
-(NSMutableArray *)listArra4{
    
    if(!_listArra4){
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
        
        [dict1 setObject:@"1、体验金是融托金融用平台自有资金设立的一个专门用于提供给平台客户进行平台项目投资体验的基金，是一种投资体验项目的虚拟资金。" forKey:@"title"];
        
        [dict2 setObject:@"2、获得体验金后，可以投资体验金专享标。" forKey:@"title"];
        
        [dict3 setObject:@"3、体验金专享标是由融托金融设立的一个专门提供给平台客户使用体验金进行投资体验的虚拟项目。" forKey:@"title"];
        
        [dict4 setObject:@"4、投资体验标也需要完成实名认证，方便后续投资、取现等操作。" forKey:@"title"];
        
        [dict5 setObject:@"5、客户使用体验金投资项目到期后，所得的收益归客户所有(可提现或续投融托金融平台的任意项目)，本金部分由平台收回。" forKey:@"title"];
        
        
        NSMutableArray *listArray4 = [[NSMutableArray alloc]init];
        [listArray4 addObject:dict1];
        [listArray4 addObject:dict2];
        [listArray4 addObject:dict3];
        [listArray4 addObject:dict4];
        [listArray4 addObject:dict5];
        
        _listArra4 = listArray4;
    }
    return _listArra4;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        if ([self.state integerValue] == 1) {
            self.listArray = self.listArra1;
        }else if ([self.state integerValue] == 2){
            self.listArray = self.listArra2;
        }else if ([self.state integerValue] == 3){
            self.listArray = self.listArra3;
        }else if ([self.state integerValue] == 4){
            self.listArray = self.listArra4;
        }

        for(NSDictionary *dict in self.listArray){
            NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            //封装数据模型
            YYInstructionsModel *model = [[YYInstructionsModel alloc]init];
            [model setValuesForKeysWithDictionary:infoDict];
            //将数据模型放入数组中
            [self.dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
