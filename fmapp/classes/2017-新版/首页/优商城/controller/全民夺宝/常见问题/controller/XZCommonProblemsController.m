//
//  XZCommonProblemsController.m
//  fmapp
//
//  Created by admin on 16/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//  常见问题

#import "XZCommonProblemsController.h"
#import "XZContactServicesSection.h" // section
#import "XZContactServicesModel.h" // model
#import "XZContactSerContentModel.h"
#import "XZContactServicesCell.h" // cell
#import "XZContactServicesFooter.h" // footer
//#import "XZMySnatchController.h" // 我的夺宝

@interface XZCommonProblemsController ()<UITableViewDelegate,UITableViewDataSource,XZContactServicesSectionDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableContact;
/** 内容数组 */
@property (nonatomic, strong) NSArray *contentArr;
/** cell的model */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation XZCommonProblemsController
- (UITableView *)tableContact {
    if (!_tableContact) {
        _tableContact = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, KProjectScreenHeight - 74) style:UITableViewStylePlain];
        // XZColor(217, 45, 64)
        _tableContact.backgroundColor = [UIColor whiteColor];
        _tableContact.delegate = self;
        _tableContact.dataSource  = self;
        _tableContact.showsVerticalScrollIndicator = NO;
        _tableContact.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableContact;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"常见问题"];
    self.view.backgroundColor = XZColor(229, 233, 242);
    [self.view addSubview:self.tableContact];
//    [self createRightButtonAndOtherButton];
    // 添加头和尾
    [self crateHeaderAndFooter];
    // 获取数据
    [self getSectionAndCellData];
}

// 添加头和尾
- (void)crateHeaderAndFooter {
    // 添加尾
    XZContactServicesFooter *footer = [[XZContactServicesFooter alloc] init];
    footer.isCommonProblem = YES;
    [self.view addSubview:footer];
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(KProjectScreenWidth - 40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo((50 * KProjectScreenWidth / 320));
    }];
    
    
    __weak __typeof(&*self)weakSelf = self;
    footer.blockContactServices = ^(UIButton *button) {
        if (button.tag == 300) { // QQ客服
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                webView.delegate = weakSelf;
                [webView loadRequest:request];
                [weakSelf.view addSubview:webView];
                
            }else{
                UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"打开客服提醒" message:@"您尚未安装QQ，请安装QQ后重试！" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
                
            }
        }else { // 拨打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-878-8686"]];
        }
    };
}

//- (void)didClickRightItemButton {
//    XZMySnatchController *mySnatch = [[XZMySnatchController alloc] init];
//    [self.navigationController pushViewController:mySnatch animated:YES];
//}

// 获取数据
- (void)getSectionAndCellData {
    for (NSDictionary *dictionary in self.contentArr) {
        XZContactServicesModel *modelContactSer = [[XZContactServicesModel alloc] init];
        modelContactSer.isCommonProblems = YES;
        [modelContactSer setContactServicesWithDic:dictionary];
        [self.dataSourceArr addObject:modelContactSer];
    }
    [self.tableContact reloadData];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XZContactServicesModel *modelContactSer = self.dataSourceArr[section];
    return modelContactSer.isOpened ? modelContactSer.detail.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZContactServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactServices"];
    if (!cell) {
        cell = [[XZContactServicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactServices"];
    }
    XZContactServicesModel *modelService = self.dataSourceArr[indexPath.section];
    cell.modelContact = modelService.detail[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XZContactServicesSection *sectionHeader = [[XZContactServicesSection alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 44)];
    sectionHeader.tag = section + 200;
    sectionHeader.delegate = self;
    XZContactServicesModel *modelContactSer = self.dataSourceArr[section];
    sectionHeader.modelContactSer = modelContactSer;
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZContactServicesModel *modelContactSer = self.dataSourceArr[indexPath.section];
    XZContactSerContentModel *modelSer = modelContactSer.detail[indexPath.row];
//    NSLog(@"%f",modelSer.contentH);
    return modelSer.contentH;
}

#pragma ---- XZContactServicesSectionDelegate
- (void)touchAction:(XZContactServicesSection *)section {
    NSInteger index = section.tag - 200;
    XZContactServicesModel *modelContactSer = [self.dataSourceArr objectAtIndex:index];
    modelContactSer.isOpened = !modelContactSer.isOpened;
    //    [self.tableContact reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    for (int i = 0; i < self.dataSourceArr.count; i++) {
        XZContactServicesModel *model = [self.dataSourceArr objectAtIndex:i];
        if (i != index) {
            model.isOpened = NO;
        }
    }
    [self.tableContact reloadData];
    if (modelContactSer.isOpened) {
        [self.tableContact scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

//// 创建右侧按钮和返回顶部、联系客服
//- (void)createRightButtonAndOtherButton {
//    //
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"全新我的夺宝"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickRightItemButton)];
//}

#pragma mark ---- 懒加载
- (NSArray *)contentArr {
    if (!_contentArr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CommonProblems" ofType:@"plist"];
        _contentArr = [NSArray arrayWithContentsOfFile:plistPath];
    }
    return _contentArr;
}

- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

@end
