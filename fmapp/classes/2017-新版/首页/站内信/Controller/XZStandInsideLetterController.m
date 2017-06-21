//
//  XZStandInsideLetterController.m
//  fmapp
//
//  Created by admin on 16/11/22.
//  Copyright © 2016年 yk. All rights reserved.
//  站内信

#import "XZStandInsideLetterController.h"
#import "XZStandInsideLetterCell.h"
#import "XZStandInsideLetterModel.h"
#import "NSString+Extension.h"
#import "ShareViewController.h"

#define XZStandInsideLetterURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixin"
// 已读数据
#define XZStandInsideLetterReadURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixinshow"

@interface XZStandInsideLetterController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableInsideLetter;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *arrInsideLetter;
// 当前选中index
@property (nonatomic, strong) NSString *currentIndex;
// 暂无数据
@property (nonatomic, strong) UIImageView *labelNoData;
@end

@implementation XZStandInsideLetterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self createNavSegmentControl];
    self.currentIndex = @"1";
    // 请求站内信“全部”的数据
    [self requestInsideLetterDataFromNetWork:self.currentIndex];
}

- (void)didClickSegmentedControl:(UISegmentedControl *)segmentSelected {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSInteger index = segmentSelected.selectedSegmentIndex;
    switch (index) {
        case 0:{ // 全部
            self.currentIndex = @"1";
            self.currentPage = 1;
            [self requestInsideLetterDataFromNetWork:@"1"];
//            NSLog(@"全部");
            break;
        }
        case 1:{ // 未读
            self.currentIndex = @"2";
            self.currentPage = 1;
            [self requestInsideLetterDataFromNetWork:@"2"];
//            NSLog(@"未读");
            break;
        }
        case 2:{ // 已读
            self.currentIndex = @"3";
            self.currentPage = 1;
            [self requestInsideLetterDataFromNetWork:@"3"];
//            NSLog(@"已读");
            break;
        }
        default:
            break;
    }
}

// 请求站内信数据
- (void)requestInsideLetterDataFromNetWork:(NSString *)zhuangtai {
    NSDictionary *parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"page_size":@10,
                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.currentPage],
                                 @"zhuangtai":zhuangtai,
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:XZStandInsideLetterURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        NSLog(@"站内信======%@",response.responseObject);
        if (!response.responseObject) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"当前网络不佳！");
        }else {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (weakSelf.currentPage == 1) {
                    [weakSelf.arrInsideLetter removeAllObjects];
                }
                if (!response.responseObject[@"data"]) { // 返回值中没有data数据
                    if (weakSelf.currentPage == 1) {
                        [weakSelf.tableInsideLetter addSubview:weakSelf.labelNoData];
                    }
                }else { // 有数据
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        [weakSelf.labelNoData removeFromSuperview];
                        NSArray *dataArray = response.responseObject[@"data"];
                        if (dataArray.count > 0) { // data中有值
                            for (NSDictionary *dict in dataArray) {
                                XZStandInsideLetterModel *modelInsideLetter = [[XZStandInsideLetterModel alloc]init];
                                [modelInsideLetter setValuesForKeysWithDictionary:dict];
                                modelInsideLetter.cellHeight = [modelInsideLetter.neirong getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 57, MAXFLOAT) WithFont:[UIFont systemFontOfSize:14]].height;
                                [self.arrInsideLetter addObject:modelInsideLetter];
                            }
                        }
                        else {
                            if (weakSelf.currentPage > 1) {
                                ShowAutoHideMBProgressHUD(weakSelf.view,@"暂无更多数据");
                            }
                        }
                    }
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }
        }
        [weakSelf.tableInsideLetter.mj_header endRefreshing];
        [weakSelf.tableInsideLetter.mj_footer endRefreshing];
        [weakSelf.tableInsideLetter reloadData];
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrInsideLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZStandInsideLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandInsideLetterCell"];
    if (!cell) {
        cell = [[XZStandInsideLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StandInsideLetterCell"];
    }
    XZStandInsideLetterModel *modelInsideLet = self.arrInsideLetter[indexPath.row];
    cell.modelInsideLetter = modelInsideLet;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     XZStandInsideLetterModel *modelInsideLet = self.arrInsideLetter[indexPath.row];
    return modelInsideLet.cellHeight + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZStandInsideLetterModel *modelInsideLetter = self.arrInsideLetter[indexPath.row];
    if ([modelInsideLetter.zhuangtai isEqualToString:@"2"]) { // 未读
        // 请求数据
        [self postReadDataToNetWork:modelInsideLetter];
    }
    NSString *url = [NSString stringWithFormat:@"%@?mess_id=%@",XZStandInsideLetterReadURL,modelInsideLetter.mess_id];
    ShareViewController *viewController=[[ShareViewController alloc] initWithTitle:@"" AndWithShareUrl:url];
    viewController.JumpWay = @"MyRecommand";
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 点击未读数据每一行请求数据
- (void)postReadDataToNetWork:(XZStandInsideLetterModel *)modelInside {
    NSDictionary *parameter = @{
                                @"mess_id":modelInside.mess_id,
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getPath:XZStandInsideLetterReadURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        NSLog(@"站内信已读----%@",response.responseObject);
        modelInside.zhuangtai = @"3";
        [weakSelf.tableInsideLetter reloadData];
    }];
}

- (void)createNavSegmentControl {
    [self.view addSubview:self.tableInsideLetter];
    NSArray *segmentArr = @[@"全部",@"未读",@"已读"];
    //
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArr];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = XZColor(14, 93, 210);
    segmentControl.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.6, 30);
    [segmentControl addTarget:self action:@selector(didClickSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
}

#pragma mark ---- 懒加载
- (UITableView *)tableInsideLetter {
    if (!_tableInsideLetter) {
        _tableInsideLetter = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableInsideLetter.delegate = self;
        _tableInsideLetter.dataSource  = self;
        _tableInsideLetter.backgroundColor = KDefaultOrBackgroundColor;
        _tableInsideLetter.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableInsideLetter.showsVerticalScrollIndicator = NO;
        __weak __typeof(&*self)weakSelf = self;
        // 刷新
        _tableInsideLetter.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            // 请求数据
            [weakSelf requestInsideLetterDataFromNetWork:self.currentIndex];
        }];
        _tableInsideLetter.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage = weakSelf.currentPage+1;
            // 请求数据
            [weakSelf requestInsideLetterDataFromNetWork:self.currentIndex];
        }];

    }
    return _tableInsideLetter;
}

- (NSMutableArray *)arrInsideLetter {
    if (!_arrInsideLetter) {
        _arrInsideLetter = [NSMutableArray array];
    }
    return _arrInsideLetter;
}

- (UIImageView *)labelNoData {
    if (!_labelNoData) {
        _labelNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenWidth * 822 / 486.0)];
        _labelNoData.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _labelNoData;
}

@end
