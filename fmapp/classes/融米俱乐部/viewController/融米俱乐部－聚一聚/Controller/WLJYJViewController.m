//
//  WLJYJViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#define urlBankList @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/getbankinfo"

#import "WLJYJViewController.h"
#import "XZBankListModel.h"
#import "WLJYJTableViewCell.h"
//#import "XZApplyUnwrapProfmptView.h" // 解绑提示
#import "XZTextCommentView.h" // 评论框

#define THEBUTTONTAG 10000
@interface WLJYJViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)UILabel *pinglunLabel;
@property(nonatomic,strong)UILabel *zanLabel;
@property(nonatomic,strong)UIButton *joinButton;
@property (nonatomic, strong) UITableView *tableChooseBank;
@property (nonatomic, strong) NSMutableArray *arrayBankList;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, strong) XZTextCommentView *commentView;
@end

@implementation WLJYJViewController
- (XZTextCommentView *)commentView {
    if (!_commentView) {
        //
        _commentView = [[XZTextCommentView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 49, KProjectScreenWidth, 49)];
        _commentView.backgroundColor = [UIColor whiteColor];
        [_commentView setPlaceholderText:@"评论："];
        // 添加监听，当键盘出现时收到消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        // 添加监听，当键盘退出时收到消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification  object:nil];
        __weak __typeof(&*self)weakSelf = self;
        _commentView.blockDidClickSendBtn = ^(NSString *text){
            weakSelf.commentView.frame = CGRectMake(0, KProjectScreenHeight - 49, KProjectScreenWidth, 49);
        //这里发送评论请求
            [weakSelf requestForJYJPL:text];
        };
    }
    return _commentView;
}

-(void)requestForJYJPL:(NSString *)text{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    __weak __typeof(&*self)weakSelf = self;
    
    
    NSString *url = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partycommentapp";
    NSDictionary * parameter = @{
                                 @"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSString stringWithFormat:@"%d",timestamp],
                                 @"token":tokenlow,
                                 @"comment":text,
                                 @"pid":self.pid
                                 };
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess)
        {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,@"评论成功");
            [self requestBankListData];
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            
        }
   }];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)arrayBankList {
    if (!_arrayBankList) {
        _arrayBankList = [NSMutableArray array];
    }
    return _arrayBankList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self settingNavTitle:@"评论"];
    [self createBottomView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableChooseBank.tableHeaderView = [self tableViewHeaderView];
    __weak typeof(&*self)weakSelf = self;
    // 返回
    self.navBackButtonRespondBlock = ^() {
        [weakSelf.commentView.textView resignFirstResponder];
        [weakSelf.commentView removeFromSuperview];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 请求数据
    [self requestBankListData];
}


- (UITableView *)tableChooseBank {
    if (!_tableChooseBank) {
        _tableChooseBank = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth-20, KProjectScreenHeight - 113) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableChooseBank];
        _tableChooseBank.delegate = self;
        _tableChooseBank.dataSource = self;
        UILabel *tableHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 8)];
        _tableChooseBank.backgroundColor = [UIColor whiteColor];
        tableHeaderView.backgroundColor = KDefaultOrBackgroundColor;
        _tableChooseBank.tableHeaderView =  tableHeaderView;
        
        _tableChooseBank.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.arrayBankList removeAllObjects];
            _currentPage = 1;
            _isAddData = NO;
            [self requestBankListData];
        }];

        _tableChooseBank.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            _currentPage = _currentPage + 1;
            _isAddData = YES;
            [self requestBankListData];
        }];

    }
    return _tableChooseBank;
}

//创建底部视图
-(void)createBottomView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.commentView];
}

#pragma mark ----- 请求数据
- (void)requestBankListData {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    __weak __typeof(&*self)weakSelf = self;
    

    NSString *url = @"https://www.rongtuojinrong.com/rongtuoxinsoc/juyijuparty/partycommentlistapp";

    NSDictionary * parameter = @{
                                 @"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSString stringWithFormat:@"%d",timestamp],
                                 @"token":tokenlow,
                                 @"pid":self.pid,
                                 @"c_page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":@"10"};
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess)
        {
            
            if (_isAddData) {
                
                _isAddData = NO;
            }else
            {
                [self.arrayBankList removeAllObjects];
            }

            NSDictionary *dataArray = response.responseObject[@"data"];
            NSArray *listArray = [dataArray objectForKey:@"list"];
            [self.headerLabel setText:[NSString stringWithFormat:@"%@条评论",[NSString stringWithFormat:@"%@",[dataArray objectForKey:@"count"]]]];
            self.dataArray = listArray;
            if (self.dataArray.count != 0) { // data中有值
                for (NSDictionary *dict in listArray) {
                    XZBankListModel *modelBank = [[XZBankListModel alloc]init];
                    [modelBank setValuesForKeysWithDictionary:dict];
                    [self.arrayBankList addObject:modelBank];
                }
            }
          
            [weakSelf.tableChooseBank reloadData];

        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            
        }
        
        [weakSelf.tableChooseBank.mj_header endRefreshing];
        [weakSelf.tableChooseBank.mj_footer endRefreshing];
    
    }];

}

#pragma mark ----- Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayBankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"chooseBank";
    WLJYJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[WLJYJTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if (self.arrayBankList.count != 0) {
        XZBankListModel *modelBank = self.arrayBankList[indexPath.row];
        cell.bankModel = modelBank;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

#pragma mark ---- tabelViewHeaderView


-(UIView *)tableViewHeaderView{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth-20, 70)];
    [header setBackgroundColor:[UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 15)];
    [header addSubview:label];
    label.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth-30, 70)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [headerLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    return header;
    
}


#pragma mark ---- 键盘

// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.commentView.textView.text.length == 0) { // 键盘弹出
        self.commentView.frame = CGRectMake(0, KProjectScreenHeight-height-49, KProjectScreenWidth, 49);
    }else{
        CGRect rect = CGRectMake(0, KProjectScreenHeight - self.commentView.frame.size.height-height, KProjectScreenWidth, self.commentView.frame.size.height);
        self.commentView.frame = rect;
    }
}

// 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.commentView.textView.text.length == 0) {
        self.commentView.frame = CGRectMake(0, KProjectScreenHeight-49, KProjectScreenWidth, 49);
    }else{
        CGRect rect = CGRectMake(0, KProjectScreenHeight - self.commentView.frame.size.height, KProjectScreenWidth, self.commentView.frame.size.height);
        self.commentView.frame = rect;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.commentView.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.commentView.textView resignFirstResponder];
}

@end
