//
//  XZRiskQuestionnaireViewController.m
//  XZProject
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//  风险评估问卷

#import "XZRiskQuestionnaireViewController.h"
#import "XZQuestionnaireHeaderView.h"
#import "XZRiskQuestionnaireCell.h"
#import "XZRiskQuestionnaireModel.h" // 最外层数据
#import "XZRiskQuestionListModel.h" // 问卷调查列表数据
#import "XZRiskQuestionAnswerModel.h" // 问卷调查试题数据
#import "WLNewBesureViewController.h"// 结果页面
#import "XZRiskQuestionnaireSection.h" // section头部
#import "XZRiskFirstPageView.h" // 第一个页面
#import "XZRiskQueSubmitAnswerModel.h" // 提交的model
#import "WLNewEvaluateViewController.h" // 调查问卷结果页


//#define kXZQuestionnaireUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/wenjuansave"

@interface XZRiskQuestionnaireViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableQuestionnaire;
/** "下一步"按钮 */
@property (nonatomic, strong) UIButton *btnNext;
/** 问题的下标 */
@property (nonatomic, assign) int index;
/** 记录当前是第一页 */
@property (nonatomic, assign) int indexFirstPage;

/** 调查问卷的JSon数据 */
@property (nonatomic, strong) NSArray *questionnaireArr;

// 第一个页面的model
@property (nonatomic, strong) XZRiskQuestionnaireModel *modelRiskQues;
// 问卷的列表
@property (nonatomic, strong) NSMutableArray *arrQuestionList;

// section头部
@property (nonatomic, strong) XZRiskQuestionnaireSection *sectionQues;

// 第一页数据
@property (nonatomic, strong) XZRiskFirstPageView *viewFirstPage;

/** 用户最终的选择 */
@property (nonatomic, strong) NSMutableString *finalChooseStr;

/** 用户的最终得分 */
@property (nonatomic, assign) CGFloat totalScore;

// 提交问卷的返回数据
@property (nonatomic, strong) XZRiskQueSubmitAnswerModel *modelSubmit;
@end

@implementation XZRiskQuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self createNextButton];
    [self settingNavTitle:@"风险评估问卷"];
    self.indexFirstPage = 0;
    self.totalScore = 0.0;
    [self.view addSubview:self.viewFirstPage];
    
    // 从网络上获取调查问卷的数据
    [self getQuestionnaireDataFromNetwork];
}

#pragma mark ---- 获取问卷调查的数据
- (void)getQuestionnaireDataFromNetwork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,                               @"TestCode":@"RiskAssessmentQuestionnaire"
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *CmdId = @"GetTest";
    [FMHTTPClient postPath:kXZUniversalTestUrl(CmdId) parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        NSLog(@"问卷调查的返回数据 ========= %@",response.responseObject);
        if (response.responseObject) {
            [weakSelf.arrQuestionList removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    weakSelf.modelRiskQues = [[XZRiskQuestionnaireModel alloc] init];
                    [weakSelf.modelRiskQues setValuesForKeysWithDictionary:data];
                    // 计算高度
                    weakSelf.modelRiskQues.DescHeight = [weakSelf getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:15.0f andString:[NSString stringWithFormat:@"%@\n\t%@",_modelRiskQues.Subtitle,_modelRiskQues.Desc]];
                    // 试题列表
                    for (NSDictionary *dictList in weakSelf.modelRiskQues.Qu) {
                        XZRiskQuestionListModel *modelList = [[XZRiskQuestionListModel alloc] init];
                        [modelList setQuestionListModeWithDic:dictList];
                        [weakSelf.arrQuestionList addObject:modelList];
                        modelList.contentHeight = [weakSelf getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:15.0f andString:modelList.Content] + 20;
                    }
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
        else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"加载数据失败");
        }
        weakSelf.viewFirstPage.modelRiskQues = weakSelf.modelRiskQues;
        // 计算第一页描述页的高度
        int height = KProjectScreenWidth * 216 / 640.0;
        weakSelf.viewFirstPage.frame = CGRectMake(0, 0, KProjectScreenWidth, weakSelf.modelRiskQues.DescHeight + height + 40 + 40 + 20);
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index <= (self.arrQuestionList.count - 1)) {
        XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
        return [modelList.Opt count];
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrQuestionList.count > 0) {
        XZRiskQuestionnaireCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZRiskQuestionnaireCell"];
        if (!cell) {
            cell = [[XZRiskQuestionnaireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZRiskQuestionnaireCell"];
        }
        XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
        XZRiskQuestionAnswerModel *modelAnswer = modelList.Opt[indexPath.row];
        cell.modelQuesAnswer = modelAnswer;
        
        
        __weak __typeof(&*self)weakSelf = self;
        void(^blockBlueColor)() = ^{ // “下一步”蓝色
            [weakSelf.btnNext setBackgroundColor:XZColor(14, 93, 211)];
            weakSelf.btnNext.userInteractionEnabled = YES;
        };
        void(^blockGrayColor)() = ^{ // “下一步”灰色
            [weakSelf.btnNext setBackgroundColor:XZColor(203, 204, 205)];
            weakSelf.btnNext.userInteractionEnabled = NO;
        };
        
        cell.blockQuestionnaire = ^(UIButton *button,UIButton *btnSelected) { // 单选
            for (XZRiskQuestionAnswerModel *temp in modelList.Opt) {
                // 不是当前行
                if (![temp.Code isEqualToString:modelAnswer.Code]) {
                    temp.isSelected = NO;
                }else { // 点击了当前行
                    temp.isSelected = !temp.isSelected;
                }
            }
            
            if (self.index <= (self.arrQuestionList.count - 1)) {
                [tableView reloadData];
                // 如果是必答的，当用户点击的时候修改“下一步”颜色
                if ([modelList.Must intValue] == 1) {
                    // “下一步”按钮变蓝色
                    for (XZRiskQuestionAnswerModel *model in modelList.Opt) {
                        if (model.isSelected) {
                            blockBlueColor(); // 蓝色
                            return;
                        }
                    }
                    blockGrayColor();// 灰色
                }else { // 非必选
                    blockBlueColor(); // 蓝色
                }

            }
            
        };
        return cell;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index <= (self.arrQuestionList.count - 1)) {
        XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
        XZRiskQuestionAnswerModel *modelAnswer = modelList.Opt[indexPath.row];
        return modelAnswer.ContentHeight;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.index <= (self.arrQuestionList.count - 1)) {
        XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
        self.sectionQues.modelQuesList = modelList;
        return self.sectionQues;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.index <= (self.arrQuestionList.count - 1)) {
        XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
        return modelList.contentHeight;
    }else {
        return 0;
    }
    
}

// 创建"下一步"按钮
- (void)createNextButton {
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnNext];
    [btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.equalTo(@45);
        make.width.equalTo(@(KProjectScreenWidth - 20)); // KProjectScreenWidth *
    }];
    self.btnNext = btnNext;
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    btnNext.layer.masksToBounds = YES;
    btnNext.layer.cornerRadius = 5.0f;
    [btnNext addTarget:self action:@selector(didClickNextButton) forControlEvents:UIControlEventTouchUpInside];
    // 14,93,211
    [btnNext setBackgroundColor:XZColor(14, 93, 211)];
    btnNext.userInteractionEnabled = YES;
}

#pragma mark ----- 点击了下一步按钮
- (void)didClickNextButton {
    if (!self.arrQuestionList.count) {
        ShowAutoHideMBProgressHUD(self.view, @"加载数据失败");
        return;
    }
    if (self.index < (self.arrQuestionList.count - 1)) {
        if (self.indexFirstPage == 0) {// 第一页
            [self.viewFirstPage removeFromSuperview];
            [self.view addSubview:self.tableQuestionnaire];
            self.indexFirstPage += 1;
            self.index = 0;
            [self.tableQuestionnaire reloadData];
            XZRiskQuestionListModel *modelList = self.arrQuestionList[self.index];
            // 0：非必答  1：必答
            if ([modelList.Must intValue] == 0) { // 非必选  蓝色
                [self.btnNext setBackgroundColor:XZColor(14, 93, 211)];
                self.btnNext.userInteractionEnabled = YES;
            }else { // 必选 灰色
                [self.btnNext setBackgroundColor:XZColor(203, 204, 205)];
                self.btnNext.userInteractionEnabled = NO;
            }
            
        }else { // 第一页除外
            self.index = self.index + 1;
            [self.tableQuestionnaire reloadData];
            XZRiskQuestionListModel *modelListQ = self.arrQuestionList[self.index];
            // 0：非必答  1：必答
            if ([modelListQ.Must intValue] == 0) { // 非必选  蓝色
                [self.btnNext setBackgroundColor:XZColor(14, 93, 211)];
                self.btnNext.userInteractionEnabled = YES;
            }else { // 必选 灰色
                [self.btnNext setBackgroundColor:XZColor(203, 204, 205)];
                self.btnNext.userInteractionEnabled = NO;
            }
        }
        
    }
    else if (self.index == (self.arrQuestionList.count - 1)) {
        // 获取用户的结果和分数
        for (int i = 0; i < self.arrQuestionList.count; i++) {
            XZRiskQuestionListModel *modelList = self.arrQuestionList[i];
            for (XZRiskQuestionAnswerModel *modelAnswer in modelList.Opt) {
                if (modelAnswer.isSelected) {
                    [self.finalChooseStr appendFormat:@"%@:%@|",modelList.Id,modelAnswer.Id];
                    _totalScore = _totalScore + [modelAnswer.Score floatValue];
                }
            }
        }
        self.index += 1;
        
        if (self.index == self.arrQuestionList.count) { // 提交答案
            NSString *finalChoose = [self.finalChooseStr substringToIndex:[self.finalChooseStr length] - 1];
            if (finalChoose.length > 0) {
                // 请求数据
                [self putUserChooseToNetWork:finalChoose];
            }
        }
    }else { // 提交答案
        NSString *finalChoose = [self.finalChooseStr substringToIndex:[self.finalChooseStr length] - 1];
        if (finalChoose.length > 0) {
            // 请求数据
            [self putUserChooseToNetWork:finalChoose];
        }
    }
    
}

#pragma mark ---- 计算高度
- (CGFloat)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(CGFloat)font andString:(NSString *)string
{
    NSDictionary * attres = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attres context:nil].size.height; //  + 30
}

#pragma mark ---- 懒加载
- (UITableView *)tableQuestionnaire {
    if (!_tableQuestionnaire) {
        _tableQuestionnaire = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 65 - 64) style:UITableViewStylePlain];
        _tableQuestionnaire.delegate = self;
        _tableQuestionnaire.dataSource  = self;
        _tableQuestionnaire.backgroundColor = [UIColor whiteColor];
        _tableQuestionnaire.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableQuestionnaire.showsVerticalScrollIndicator = NO;
        XZQuestionnaireHeaderView *headerView = [[XZQuestionnaireHeaderView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 216 / 640.0)];
        headerView.imageName = @"调查问卷_海报_1702";
        _tableQuestionnaire.tableHeaderView = headerView;
    }
    return _tableQuestionnaire;
}

#pragma mark ----- 懒加载
- (NSMutableArray *)arrQuestionList {
    if (!_arrQuestionList) {
        _arrQuestionList = [NSMutableArray array];
    }
    return _arrQuestionList;
}

- (XZRiskQuestionnaireSection *)sectionQues {
    if (!_sectionQues) {
        _sectionQues = [[XZRiskQuestionnaireSection alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
    }
    return _sectionQues;
}

- (XZRiskFirstPageView *)viewFirstPage {
    if (!_viewFirstPage) {
        _viewFirstPage = [[XZRiskFirstPageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 300)];
    }
    return _viewFirstPage;
}

- (NSMutableString *)finalChooseStr {
    if (!_finalChooseStr) {
        _finalChooseStr = [NSMutableString string];
    }
    return _finalChooseStr;
}

- (XZRiskQueSubmitAnswerModel *)modelSubmit {
    if (!_modelSubmit) {
        _modelSubmit = [[XZRiskQueSubmitAnswerModel alloc] init];
    }
    return _modelSubmit;
}

// 将用户的选择提交到服务器
- (void)putUserChooseToNetWork:(NSString *)finalStr {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"TestCode":@"RiskAssessmentQuestionnaire",
                                @"Answers":finalStr,
                                };
    NSString *CmdId = @"HandInTest";
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(CmdId) parameters:parameter completion:^(WebAPIResponse *response) {
//        NSLog(@"parameter：%@ ====== 提交问卷答案response.responseObject ========= %@",parameter,response.responseObject);
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dataDcit = response.responseObject[@"data"];
                if (![dataDcit isKindOfClass:[NSNull class]]) {
                    [weakSelf.modelSubmit setValuesForKeysWithDictionary:dataDcit];
                    // 跳转结果页
                    WLNewEvaluateViewController *evaluateVc = [[WLNewEvaluateViewController alloc] init];
                    evaluateVc.isComeFromYY = NO;
                    evaluateVc.modelRiskSubmit = weakSelf.modelSubmit;
                    [weakSelf.navigationController pushViewController:evaluateVc animated:YES];
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"提交问卷答案失败");
        }
    }];
                
}


@end
