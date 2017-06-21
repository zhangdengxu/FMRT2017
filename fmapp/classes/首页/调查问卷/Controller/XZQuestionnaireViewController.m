//
//  XZQuestionnaireViewController.m
//  XZProject
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//  调查问卷

#import "XZQuestionnaireViewController.h"
#import "XZQuestionnaireHeaderView.h"
#import "XZQuestionnaireCell.h"
#import "XZQuestionnaireModel.h"
#import "YSQuestionnaireFootViewController.h" // 结果展示页

#define kXZQuestionnaireUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/wenjuansave"

@interface XZQuestionnaireViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableQuestionnaire;
/** model数组 */
@property (nonatomic, strong) NSMutableArray *arrQuestionnaire;
/** 所有需要上传的数据 */
@property (nonatomic, strong) NSMutableArray *arrPostData;
/** "下一步"按钮 */
@property (nonatomic, strong) UIButton *btnNext;
/** 问题的下标 */
@property (nonatomic, assign) int index;
// 单选，当前选中的行
//@property (nonatomic, strong) UIButton *currentButton;
/** 最终得分 */
@property (nonatomic, assign) CGFloat totalScore;
/** 调查问卷的JSon数据 */
@property (nonatomic, strong) NSArray *questionnaireArr;
@end

@implementation XZQuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self createNextButton];
    [self settingNavTitle:@"调查问卷"];
    self.index = 0;
    self.totalScore = 0;
    [self.view addSubview:self.tableQuestionnaire];
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Questionnaire" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:dataPath];
    NSError *error;
    NSArray *questionnaireArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self.questionnaireArr = questionnaireArr;
    [self getQuestionnaireData:0];
}

// 获取数据
- (void)getQuestionnaireData:(int)nextIndex {
    [self.arrQuestionnaire removeAllObjects];
//    if (nextIndex < self.questionnaireArr.count) {
        NSArray *array = self.questionnaireArr[nextIndex];
        for (NSDictionary *dict in array) {
            XZQuestionnaireModel *modelQues = [[XZQuestionnaireModel alloc] init];
            [modelQues setValuesForKeysWithDictionary:dict];
            // 计算高度
            modelQues.nameHeight = [self getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT)  WithFont:15.0f andString:modelQues.name];
            modelQues.typeHeight = [self getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 50, MAXFLOAT)  WithFont:15.0f andString:modelQues.type];
            [self.arrQuestionnaire addObject:modelQues];
        }
        [self.tableQuestionnaire reloadData];
        // 203, 204, 205
        [self.btnNext setBackgroundColor:XZColor(203, 204, 205)];
        self.btnNext.userInteractionEnabled = NO;
//    }else {
    
//    }
}

// 将用户的选择提交到服务器
- (void)putUserChooseToNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // zhuangtai:(问卷是否完成1表示未完成,2表示完成)
    NSDictionary *parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"Zhuangtai":@"2",
                                 @"Questionone":[NSString stringWithFormat:@"%@",self.arrPostData[0][@"type"]],
                                 @"Questiontwo":[NSString stringWithFormat:@"%@",self.arrPostData[1][@"type"]],
                                 @"Questionthree":[NSString stringWithFormat:@"%@",self.arrPostData[2][@"type"]],
                                 @"Questionfour":[NSString stringWithFormat:@"%@",self.arrPostData[3][@"type"]],
                                 @"Questionfive":[NSString stringWithFormat:@"%@",self.arrPostData[4][@"type"]],
                                 @"Questionsix":[NSString stringWithFormat:@"%@",self.arrPostData[5][@"type"]],
                                 @"Questionseven":[NSString stringWithFormat:@"%@",self.arrPostData[6][@"type"]],
                                 @"Questioneight":[NSString stringWithFormat:@"%@",self.arrPostData[7][@"type"]],
                                 @"Questionnine":[NSString stringWithFormat:@"%@",self.arrPostData[8][@"type"]],
                                 @"Questionten":[NSString stringWithFormat:@"%@",self.arrPostData[9][@"type"]]
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"parameter ===== %@",parameter);
    [FMHTTPClient postPath:kXZQuestionnaireUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        NSLog(@"问卷调查response.responseObject = %@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
        if (![response.responseObject isKindOfClass:[NSNull class]]) {
        // 数据请求成功 score
        NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status isEqualToString:@"0"]) {
                YSQuestionnaireFootViewController *vc = [[YSQuestionnaireFootViewController alloc]init];
                vc.view.backgroundColor = [UIColor whiteColor];
                vc.totalNumber = [NSString stringWithFormat:@"%.2f",self.totalScore];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"提交失败,请重新提交");
        }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"提交失败,请重新提交");
        }
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrQuestionnaire.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZQuestionnaireCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionnaireCell"];
    if (!cell) {
        cell = [[XZQuestionnaireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionnaireCell"];
    }
    
    XZQuestionnaireModel *modelQues = self.arrQuestionnaire[indexPath.row];
    cell.modelQues = modelQues;
    __weak __typeof(&*self)weakSelf = self;
    void(^blockBlueColor)() = ^{ // “下一步”蓝色
        [weakSelf.btnNext setBackgroundColor:XZColor(14, 93, 211)];
        weakSelf.btnNext.userInteractionEnabled = YES;
    };
    void(^blockGrayColor)() = ^{ // “下一步”灰色
        [weakSelf.btnNext setBackgroundColor:XZColor(203, 204, 205)];
        weakSelf.btnNext.userInteractionEnabled = NO;
    };
    cell.blockQuestionnaire = ^(UIButton *button,UIButton *btnSelected) {
        if (!modelQues.isMultiple) {//单选
            // 分数只能有一个被选中
            for (XZQuestionnaireModel *temp in weakSelf.arrQuestionnaire) {
                // 不是当前行
                if (![temp.name isEqualToString:modelQues.name]) {
                    temp.isSelected = NO;
                }else { // 点击了当前行
                    temp.isSelected = !temp.isSelected;
                }
            }
           [tableView reloadData];
        }else { // 多选
            // 最后一个和其他的互斥
            XZQuestionnaireModel *modelLast = weakSelf.arrQuestionnaire[self.arrQuestionnaire.count - 1];
            if ([modelQues.name isEqualToString:modelLast.name]) { // 当前点击的是'无'
                modelLast.isSelected = !modelLast.isSelected;
                for (int i = 1; i <= weakSelf.arrQuestionnaire.count - 2; i++) {
                    XZQuestionnaireModel *model = weakSelf.arrQuestionnaire[i];
                    model.isSelected = NO;
                }
            }else { // 当前点击的是上面四个
                if (modelLast.isSelected) {
                    modelLast.isSelected = NO;
                }
                modelQues.isSelected = !modelQues.isSelected;
            }
            
            [tableView reloadData];
        }
        // “下一步”按钮变蓝色
        for (XZQuestionnaireModel *model in weakSelf.arrQuestionnaire) {
            if (model.isSelected) {
                blockBlueColor(); // 蓝色
                return;
            }
        }
        blockGrayColor();// 灰色
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZQuestionnaireModel *modelQues = self.arrQuestionnaire[indexPath.row];
    if (indexPath.row == 0) {
        return modelQues.nameHeight;
    }else {
        return modelQues.typeHeight;
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
    [btnNext setBackgroundColor:XZColor(203, 204, 205)];
    btnNext.userInteractionEnabled = NO;
}

// 点击了下一步按钮
- (void)didClickNextButton {
    /**
     获取用户的选择
     */
    NSMutableString *typeStr = @"".mutableCopy;
    XZQuestionnaireModel *modelQuesTitle = self.arrQuestionnaire[0];
//    NSLog(@"self.arrQuestionnaire.count = %lu",(unsigned long)self.arrQuestionnaire.count);
    for (int i = 0; i < self.arrQuestionnaire.count; i++) {
        XZQuestionnaireModel *modelQues = self.arrQuestionnaire[i];
        if (modelQues.isSelected) {
            if (!modelQues.isMultiple) { // 单选
                NSDictionary *dict = @{@"name":modelQuesTitle.name,@"type":modelQues.type};
                [self.arrPostData addObject:dict];
            }else { // 多选
                [typeStr appendFormat:@",%@",modelQues.type];
            }
        }
    }
    // 多选数据加入到数组中
    if (modelQuesTitle.isMultiple) {
        NSString *finalType = [typeStr substringFromIndex:1];
        NSDictionary *dict = @{@"name":modelQuesTitle.name,@"type":finalType};
        [self.arrPostData addObject:dict];
    }
//    NSLog(@"用户选中数据self.arrPostData ==== %@ \n typeStr = %@",self.arrPostData,typeStr);

    /**
     计算用户的分数
     */
    CGFloat temp = 0;
    int count = 1;
    for (XZQuestionnaireModel *modelQues in self.arrQuestionnaire) {
        if (modelQues.score > 0) {
            if (modelQues.isSelected ) {
                if (modelQues.isMultiple) { // 多选
                    count++;
                }
                temp += modelQues.score;
            }
        }
    }
    if (count > 1) { // 多选的第一个不是选项
        count -= 1;
    }
    self.totalScore = self.totalScore + (temp / count);
    self.index++;
    if (self.index < self.questionnaireArr.count) {
       [self getQuestionnaireData:self.index];
    }else {
//        NSLog(@"答题完毕");
//        NSLog(@"self.totalScore = %f",self.totalScore);
        // 请求数据
        [self putUserChooseToNetWork];
    }
}

#pragma mark ---- 计算高度
- (CGFloat)getStringCGSizeWithMaxSize:(CGSize)maxSize WithFont:(CGFloat)font andString:(NSString *)string
{
    NSDictionary * attres = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attres context:nil].size.height + 30;
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
        headerView.imageName = @"内容页-banner_02";
        _tableQuestionnaire.tableHeaderView = headerView;
    }
    return _tableQuestionnaire;
}

- (NSMutableArray *)arrQuestionnaire {
    if (!_arrQuestionnaire) {
        _arrQuestionnaire = [NSMutableArray array];
    }
    return _arrQuestionnaire;
}

- (NSMutableArray *)arrPostData {
    if (!_arrPostData) {
        _arrPostData = [NSMutableArray array];
    }
    return _arrPostData;
}

/**
 XZQuestionnaireModel *modelLast = self.arrQuestionnaire[self.arrQuestionnaire.count - 1];
 if ([modelLast.name isEqualToString:modelQues.name]) { //indexPath.row == self.questionnaireArr.count - 1
 if (weakSelf.currentButton != btnSelected) {
 weakSelf.currentButton.selected = NO;
 weakSelf.currentButton = btnSelected;
 btnSelected.selected = YES;
 blockBlueColor();
 // 分数只能有一个被选中
 for (XZQuestionnaireModel *temp in self.arrQuestionnaire) {
 if (![temp.name isEqualToString:modelQues.name]) {
 temp.isSelected = NO;
 }else {
 temp.isSelected = YES;
 }
 }
 }
 }else {
 btnSelected.selected = !btnSelected.selected;
 weakModel.isSelected = !weakModel.isSelected;
 }

 */
@end
