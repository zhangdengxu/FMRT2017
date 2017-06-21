//
//  XZUseRedEnvelopeController.m
//  fmapp
//
//  Created by admin on 17/2/18.
//  Copyright © 2017年 yk. All rights reserved.
//  使用红包券

#import "XZUseRedEnvelopeController.h"
#import "XZRedEnvelopeHeader.h" //  红包券的头视图
#import "XZRedEnvelopeModel.h" // moedl
#import "XZRedEnvelopeCell.h" // cell
#import "XZNoRedEnvelopeView.h" // 暂无数据时
#import "YYInstructionsController.h" // 使用说明
#import "Fm_Tools.h"

@interface XZUseRedEnvelopeController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableUseRedEnvelope;
@property (nonatomic, strong) XZRedEnvelopeHeader *headerRedEnvelope;
@property (nonatomic, strong) XZRedEnvelopeModel *modelRedEnv;
@property (nonatomic, strong) XZNoRedEnvelopeView *noRedEnvelope;
// 可用和不可用红包券数量
@property (nonatomic, strong) NSMutableArray *arrRedRnveUse;
// 不可用红包券数量
@property (nonatomic, strong) NSMutableArray *arrRedRnveNotUse;

// 确定
@property (nonatomic, strong) UIButton *sureButton;
// button背景图
@property (nonatomic, strong) UIView *backgroundView;
// 红包状态:可用、不可用
@property (nonatomic, strong) NSString *statusRedEnvelope;
// 当前页数
@property (nonatomic, assign) NSInteger currentPage;

/** 红包券和加息券可用/不可用 */
@property (nonatomic, assign) BOOL isUseful;

// 回调的model
@property (nonatomic, strong) XZRedEnvelopeModel *modelSendBack;
@end

@implementation XZUseRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    if (self.isRedEnvelopeView) {
       [self settingNavTitle:@"使用红包券"];
    }else {
        [self settingNavTitle:@"使用加息券"];
    }
    
    self.view.backgroundColor = XZBackGroundColor;
    self.currentPage = 1;
    self.isUseful = YES;
    
    // 控制是显示可用还是不可用
    self.modelRedEnv.isUseful = YES;
    
    // 判断当前是加息券还是红包券
    self.modelRedEnv.isRedEnvelope = self.isRedEnvelopeView;
    self.statusRedEnvelope = @"4";
    
    //
    [self.view addSubview:self.tableUseRedEnvelope];
    [self.view addSubview:self.headerRedEnvelope];
    //
    UIButton *btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(0, 0, 65, 44);
    [btnAboutUs setTitle:@"使用说明" forState:UIControlStateNormal];
    [btnAboutUs.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnAboutUs setTitleColor:KContentTextColor forState:UIControlStateNormal];
    btnAboutUs.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnAboutUs addTarget:self action:@selector(didClickUseinstructions) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAboutUs];
    
    // 获取数据
    [self getChooseTicketDataFromNetWork];
}

#pragma mark ------ 请求当前页面数据
- (void)getChooseTicketDataFromNetWork {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"Status":self.statusRedEnvelope,
                                @"BidAmt":[NSString stringWithFormat:@"%@",self.useBidAmt],
                                @"ProjId":[NSString stringWithFormat:@"%@",self.ProjId],
                                @"PageNum":[NSString stringWithFormat:@"%zi",self.currentPage],
                                @"PageSize":@10
                                };
    NSString *CmdId = @"GetInterestCoupon"; // 加息券
    if (self.isRedEnvelopeView) { // 是红包券
        CmdId = @"GetRedPacket";
    }
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(CmdId) parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (weakSelf.currentPage == 1) {
            if (weakSelf.isUseful) { // 可用
                [weakSelf.arrRedRnveUse removeAllObjects];
            }else { // 不可用
                [weakSelf.arrRedRnveNotUse removeAllObjects];
            }
        }
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dataDcit = response.responseObject[@"data"];
                if (![dataDcit isKindOfClass:[NSNull class]]) {
                    NSArray *dictArr = dataDcit[@"Detail"];
                    
                    if (weakSelf.modelRedEnv.isUseful) {
                        weakSelf.modelRedEnv.countRedEnveUse = [dataDcit[@"Num"] integerValue];
                    }else {
                       weakSelf.modelRedEnv.countRedEnveNotUse = [dataDcit[@"Num"] integerValue];
                    }
                    
                    if (dictArr.count > 0) {
                        for (NSDictionary *dcit in dictArr) {
                            XZRedEnvelopeModel *redRnvelope = [[XZRedEnvelopeModel alloc] init];
                            [redRnvelope setValuesForKeysWithDictionary:dcit];

                            NSString *amt = [NSString stringWithFormat:@"%@",redRnvelope.Amt];
                            CGFloat width = [amt getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) WithFont:[UIFont systemFontOfSize:24.0f]].width;
                            
                            redRnvelope.contentH = [redRnvelope.Desc getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 40 - width - 30, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height + 50;
                            if (weakSelf.isRedEnvelopeView) { // 红包券
                                redRnvelope.isRedEnvelope = YES;
                            }else {
                                redRnvelope.isRedEnvelope = NO;
                            }
                            if (weakSelf.isUseful) { // 可用
                                redRnvelope.isUseful = YES;
                                    [weakSelf.arrRedRnveUse addObject:redRnvelope];
                            }else { // 不可用
                                redRnvelope.isUseful = NO;
                                    [weakSelf.arrRedRnveNotUse addObject:redRnvelope];
                            }
                        }
                    }
                }
            }
        }
        
        // 添加”暂无数据“页面
        if (weakSelf.isUseful) { // 可用
            if (weakSelf.arrRedRnveUse.count == 0) {
                weakSelf.noRedEnvelope.modelRedEnv = weakSelf.modelRedEnv;
                weakSelf.noRedEnvelope.hidden = NO;
                [weakSelf createSureButton:NO];
            }else {
                [weakSelf createSureButton:YES];
                weakSelf.noRedEnvelope.hidden = YES;
            }
        }else { // 不可用
            [weakSelf createSureButton:NO];
            if (weakSelf.arrRedRnveNotUse.count == 0) {
                weakSelf.noRedEnvelope.modelRedEnv = weakSelf.modelRedEnv;
                weakSelf.noRedEnvelope.hidden = NO;
            }else {
                weakSelf.noRedEnvelope.hidden = YES;
            }
        }
        
        // 如果传过来数据，在这个页面显示出来
        if (self.arrRedRnveUse.count > 0) {
//            NSLog(@"上个页面传入的id:=====%@",self.modelSelected.Id);
            if (self.modelSelected.Id) { // 有值
                for (XZRedEnvelopeModel *model in self.arrRedRnveUse) {
                    if ([model.Id floatValue] == [self.modelSelected.Id floatValue]) {
                        model.isSelected = YES;
                    }
                }
            }
        }
        
        [weakSelf.tableUseRedEnvelope reloadData];
        [weakSelf.tableUseRedEnvelope.mj_header endRefreshing];
        [weakSelf.tableUseRedEnvelope.mj_footer endRefreshing];
        weakSelf.headerRedEnvelope.modelRedEnv = weakSelf.modelRedEnv;
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isUseful) { // 可用
        return self.arrRedRnveUse.count;
    }else { // 不可用
        return self.arrRedRnveNotUse.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UseRedEnvelopeCell"];
    if (!cell) {
        cell = [[XZRedEnvelopeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UseRedEnvelopeCell"];
    }
    
    if (self.isUseful) { // 可用
        if (self.arrRedRnveUse.count > 0) {
            cell.modelRedEnvelope = self.arrRedRnveUse[indexPath.row];
        }
    }else { // 不可用
        if(self.arrRedRnveNotUse.count > 0){
            cell.modelRedEnvelope = self.arrRedRnveNotUse[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    CGFloat height = (KProjectScreenWidth - 20) * 76 / 600.0 + 20;
    if (self.isUseful) { // 可用
        if (self.arrRedRnveUse.count > 0) {
            XZRedEnvelopeModel *model = self.arrRedRnveUse[indexPath.row];
            height += model.contentH;
        }
    }else {
        if(self.arrRedRnveNotUse.count > 0){
            XZRedEnvelopeModel *model = self.arrRedRnveNotUse[indexPath.row];
            height += model.contentH;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isUseful) { // 可用
        if (self.arrRedRnveUse.count > 0) {
            XZRedEnvelopeModel *modelRed = self.arrRedRnveUse[indexPath.row];
            modelRed.isSelected = !modelRed.isSelected;
            NSString *modelRedID = [NSString stringWithFormat:@"%@",modelRed.Id];
            for (XZRedEnvelopeModel *model in self.arrRedRnveUse) {
                NSString *modelID = [NSString stringWithFormat:@"%@",model.Id];
                if (![modelRedID isEqualToString:modelID]) {
                    model.isSelected = NO;
                }
            }
        }
    }
    [tableView reloadData];
}

- (void)setModelSelected:(XZRedEnvelopeModel *)modelSelected {
    _modelSelected = modelSelected;
}

#pragma mark ---- 点击了"确定"按钮
- (void)didClickSureButton {
//    NSLog(@"点击了\"确定\"按钮");
    
    self.modelSendBack = [[XZRedEnvelopeModel alloc] init];
    if (self.isUseful) { // 可用
        for (XZRedEnvelopeModel *model in self.arrRedRnveUse) {
            if (model.isSelected) {
                if (self.modelRedEnv.isRedEnvelope) {// 红包券
                    self.modelSendBack = model;
                }else { // 加息券
                    self.modelSendBack.Id = model.Id;
                    self.modelSendBack.AwardTime = model.AwardTime;
                    self.modelSendBack.PastTime = model.PastTime;
                    self.modelSendBack.GetTrench = model.GetTrench;
                    self.modelSendBack.Status = model.Status;
                    self.modelSendBack.Usable = model.Usable;
                    self.modelSendBack.Title = model.Title;
                    self.modelSendBack.Rate = model.Rate; //
                    self.modelSendBack.Desc = model.Desc;
                    self.modelSendBack.ProjDurationMin = model.ProjDurationMin;//
                    self.modelSendBack.ProjDurationMax = model.ProjDurationMax;//
                    self.modelSendBack.ProjAmtMin = model.ProjAmtMin;//
                    self.modelSendBack.ProjAmtMax = model.ProjAmtMax;//

                }
            }
        }
    }
    
    if (self.modelRedEnv.isRedEnvelope) { // 当前是红包券
        if (self.blockSendModel) {
            self.blockSendModel(self.modelSendBack);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else { // 当前是加息券
        
        self.modelSendBack.Rate = @([self.modelSendBack.Rate floatValue] * 100);

        if (self.lilvyou) { // 存在最大加息数
            // 最大加息数
            CGFloat jiaxiShu = [self.lilvyou floatValue];
            if (jiaxiShu > 0 && [self.modelSendBack.Id floatValue] > 0) {
                // 前个页面传过来最大加息数
                CGFloat currentRate = [self.modelSendBack.Rate floatValue];
                if (currentRate > jiaxiShu) { // 大于最大利息数
                    currentRate = jiaxiShu;
                    // 修改当前model的利率值
                    self.modelSendBack.Rate = @(currentRate);
                    // 提示语
                    NSString *tiShiYu = [NSString stringWithFormat:@"本项目最高可加息%.1f%%,每张加息券只能使用一次,请确认是否使用",[self.lilvyou floatValue]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tiShiYu delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }else { // 不大于直接返回
                    if (self.blockSendModel) {
                        self.blockSendModel(self.modelSendBack);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                if (self.blockSendModel) {
                    self.blockSendModel(self.modelSendBack);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else { // 当前加息券不大于最大利率数
            if (self.blockSendModel) {
                self.blockSendModel(self.modelSendBack);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark ---- 点击alert的确定按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 点击确定
        if (self.blockSendModel) {
            self.blockSendModel(self.modelSendBack);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {

    }
}

#pragma mark ---- 创建确定按钮
- (void)createSureButton:(BOOL)sure {
    if (sure) {
        self.sureButton.hidden = NO;
        self.backgroundView.hidden = NO;
        self.tableUseRedEnvelope.frame = CGRectMake(0, 40, KProjectScreenWidth, KProjectScreenHeight - 64 - 40 - 55);
    }
    else {
        self.sureButton.hidden = YES;
        self.backgroundView.hidden = YES;
        self.tableUseRedEnvelope.frame = CGRectMake(0, 40, KProjectScreenWidth, KProjectScreenHeight - 64 - 40);
    }
}

#pragma mark ---- 使用说明
- (void)didClickUseinstructions {
    if (self.modelRedEnv.isRedEnvelope) { // 是红包券的"使用说明"
        YYInstructionsController *instruction = [[YYInstructionsController alloc] init];
        instruction.navTitle = @"红包券使用说明";
        instruction.state = @"1";
        [self.navigationController pushViewController:instruction animated:YES];
    }else { // 是加息券的"使用说明"
        YYInstructionsController *instruction = [[YYInstructionsController alloc] init];
        instruction.navTitle = @"加息券使用说明";
        instruction.state = @"2";
        [self.navigationController pushViewController:instruction animated:YES];
    }
}

#pragma mark ---- 懒加载
- (UITableView *)tableUseRedEnvelope {
    if (!_tableUseRedEnvelope) {
        _tableUseRedEnvelope = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KProjectScreenWidth, KProjectScreenHeight - 64 - 40 - 55) style:UITableViewStylePlain];
        _tableUseRedEnvelope.delegate = self;
        _tableUseRedEnvelope.dataSource  = self;
        _tableUseRedEnvelope.backgroundColor = XZBackGroundColor;
        _tableUseRedEnvelope.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableUseRedEnvelope.showsVerticalScrollIndicator = NO;
        
        // 头部刷新
        __weak __typeof(&*self)weakSelf = self;
        _tableUseRedEnvelope.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.currentPage = 1;
            [weakSelf getChooseTicketDataFromNetWork];
        }];
        
        // 尾部加载
        _tableUseRedEnvelope.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.currentPage = self.currentPage + 1;
            [weakSelf getChooseTicketDataFromNetWork];
        }];
    }
    return _tableUseRedEnvelope;
}

- (XZRedEnvelopeHeader *)headerRedEnvelope {
    if (!_headerRedEnvelope) {
        _headerRedEnvelope = [[XZRedEnvelopeHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 40)];
        
//        _headerRedEnvelope.modelRedEnv = self.modelRedEnv;
        
        [_headerRedEnvelope setTitleWithModel:self.modelRedEnv];
    
        __weak __typeof(&*self)weakSelf = self;
        _headerRedEnvelope.blockRedEnvelope = ^(UIButton *button) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            // 隐藏暂无数据
            weakSelf.noRedEnvelope.hidden = YES;
            weakSelf.currentPage = 1;
            if (button.tag == 220) { // 可用红包券
                weakSelf.isUseful = YES;
                weakSelf.modelRedEnv.isUseful = YES;
                weakSelf.statusRedEnvelope = @"4";
                // 请求数据
                [weakSelf getChooseTicketDataFromNetWork];
                
                if (weakSelf.arrRedRnveUse.count > 0) { // 当前页面有数据
                    [weakSelf createSureButton:YES];
                }else { // 当前页面没有数据
                    [weakSelf createSureButton:NO];
                }
            }else { // 不可用红包券
                weakSelf.isUseful = NO;
                weakSelf.modelRedEnv.isUseful = NO;
                weakSelf.statusRedEnvelope = @"5";
                [weakSelf createSureButton:NO];
                // 请求数据
                [weakSelf getChooseTicketDataFromNetWork];
            }
            [weakSelf.tableUseRedEnvelope reloadData];
//            weakSelf.headerRedEnvelope.modelRedEnv = weakSelf.modelRedEnv;
        };
    }
    return _headerRedEnvelope;
}

- (XZRedEnvelopeModel *)modelRedEnv {
    if (!_modelRedEnv) {
        _modelRedEnv = [[XZRedEnvelopeModel alloc] init];
    }
    return _modelRedEnv;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundView).offset(-10);
            make.centerX.equalTo(self.backgroundView);
            make.height.equalTo(@40);
            make.width.equalTo(@((150 / 320.0) * KProjectScreenWidth));
        }];
        _sureButton.tag = 502;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 3.0f;
        [_sureButton setBackgroundColor:XZColor(250, 85, 89)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(didClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 55 - 64, KProjectScreenWidth, 55)];
        _backgroundView.backgroundColor = XZBackGroundColor;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (XZNoRedEnvelopeView *)noRedEnvelope {
    if (!_noRedEnvelope) {
        _noRedEnvelope = [[XZNoRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 300)];
        _noRedEnvelope.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenWidth * 0.5);
        [self.tableUseRedEnvelope addSubview:_noRedEnvelope];
        _noRedEnvelope.hidden = YES;
    }
    return _noRedEnvelope;
}

// 可用红包券
- (NSMutableArray *)arrRedRnveUse {
    if (!_arrRedRnveUse) {
        _arrRedRnveUse = [NSMutableArray array];
    }
    return _arrRedRnveUse;
}

// 不可用红包券
- (NSMutableArray *)arrRedRnveNotUse {
    if (!_arrRedRnveNotUse) {
        _arrRedRnveNotUse = [NSMutableArray array];
    }
    return _arrRedRnveNotUse;
}

@end
