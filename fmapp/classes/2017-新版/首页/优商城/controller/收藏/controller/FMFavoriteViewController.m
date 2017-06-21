//
//  FMFavoriteViewController.m
//  fmapp
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMFavoriteViewController.h"
#import "FMFavoriteTableViewCell.h"
#import "FMFavoriteModel.h"
#import "FMShoppigListBottomEditView.h"
#import "FMShoppingListShareView.h"
#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "FMShoppingListScanView.h"
#import "Fm_Tools.h"
#import "FMFavoriteBottomView.h"
#import "SignOnDeleteView.h"
#import "FMPlaceOrderViewController.h"
#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"


@interface FMFavoriteViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,FMMessageAlterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr, *shareImageData;
@property (nonatomic, assign) float  totalNumber;
@property (nonatomic, strong) FMShoppingListShareView *shareView;
@property (nonatomic, assign) BOOL isOver,isAddData;
@property (nonatomic, strong) FMFavoriteBottomView *fmBottomView;

@end

@implementation FMFavoriteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self settingNavTitle:@"我的收藏"];
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self setNavItemsWithButton];
    [self createTableView];
    [self setUpBottomView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataForTableView];

}

- (void)requestDataForTableView {

    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    NSString *urlStr = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMFavoriteListUrl,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FMWeakSelf;
    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求网络数据失败！");
        }

        if (response.code == WebAPIResponseCodeSuccess) {

            NSArray *array = response.responseObject[@"data"];
            
            [weakSelf.dataArr removeAllObjects];
            if (![array isMemberOfClass:[NSNull class]]) {
                
                if (array.count < 10) {
                    weakSelf.isOver = YES;
                }
                
                if (_isAddData) {
                    _isAddData = NO;
                }else{
                    [weakSelf.dataArr removeAllObjects];
                }
                if (array.count != 0) {

                    for (NSDictionary *dic in array) {

                        FMFavoriteModel *model = [[FMFavoriteModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        [weakSelf.dataArr addObject:model];
                    }

                }else{
                    
                }
                
                [weakSelf.tableView reloadData];
            }else{
                
                UILabel * detalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, 400)];
                detalLabel.textAlignment = NSTextAlignmentCenter;
                detalLabel.textColor = KDefaultOrNightTextColor;
                detalLabel.text = @"暂无收藏记录";
                weakSelf.tableView.tableHeaderView = detalLabel;
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView reloadData];
        }else{
            
            if ([response.responseObject objectForKey:@"msg"]) {
                
                NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                
                ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
            }
            
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)setUpBottomView{
    
    self.fmBottomView.hidden = YES;
    
    __weak typeof (self)weakSelf = self;
    self.fmBottomView.shareBlcok = ^(UIButton *sender){
        [weakSelf clickBottomShareButton:sender];
    };
    
    self.fmBottomView.deleteBlcok = ^(UIButton *sender){
        [weakSelf clickDeleteButton:sender];
    };

    self.fmBottomView.allSelectBlcok = ^(UIButton *sender){
        [weakSelf clickAllSelectButton:sender];
    };
    
    [self.view addSubview:self.fmBottomView];
    [self.fmBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

- (void)clickBottomShareButton:(UIButton *)sender {
    
    if (self.totalNumber == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"您还没有选择要分享的宝贝哦");
    }else{
        self.shareView = [[FMShoppingListShareView alloc]init];
        [self.view addSubview:self.shareView];
        __weak typeof (self)weakSelf = self;
        
        NSMutableString *string = [NSMutableString string];
        for (int index =0; index < self.shareImageData.count; index++) {
            NSInteger jnde= [self.shareImageData[index] integerValue];
            FMFavoriteModel *model = self.dataArr[jnde];
            
            [string appendString:[NSString stringWithFormat:@"%@,",model.product_id]];
        }
        NSString *prodidURL = [string substringWithRange:NSMakeRange(0, string.length - 1)];
        NSString *shareURL = [NSString stringWithFormat:@"http://www.qdygo.com/wap/product/share/%@.html",prodidURL];
        
        NSInteger jnde= [self.shareImageData[0] integerValue];
        FMFavoriteModel *model = self.dataArr[jnde];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.image]];
        
        self.shareView.block = ^(UIButton *sender){
            [weakSelf clickShareButton:sender with:shareURL withTitle:model.name withData:data];
        };
        [self.shareView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)clickShareButton:(UIButton *)sender with:(NSString *)shareUrl withTitle:(NSString *)title withData:(NSData *)data{
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareUrl,@"weixin"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareUrl,@"wxcircle"];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareUrl,@"qq"];
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@?plattype=%@",shareUrl,@"sina"];
    
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    switch (sender.tag) {
        case 2110:
        {
            //x
            self.shareView.hidden = YES;
            break;
        }
        case 2111:
        {
            //复制链接
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            board.string = shareUrl;
            ShowAutoHideMBProgressHUD(self.view, @"已将连接复制到粘贴板");
            self.shareView.hidden = YES;
            break;
        }
        case 2112:
        {
            //二维码
            self.shareView.hidden = YES;
            [self clickShareQRImageWith:shareUrl];
            break;
        }
        case 2113:
        {
            //微博
            [UMSocialData defaultData].title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareUrl] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2114:
        {
            //QQ
           [UMSocialData defaultData].extConfig.qqData.title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareUrl] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

            break;
        }
        case 2115:
        {
            //微信");
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareUrl] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2116:
        {
            //朋友圈
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareUrl] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        default:
            break;
    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess){
        ShowAutoHideMBProgressHUD(self.view,@"分享成功");
        
    }else{
        ShowAutoHideMBProgressHUD(self.view,@"分享失败");
    }
}


- (void)clickShareQRImageWith:(NSString *)qrUrl {

    self.shareView.hidden = YES;
    UIImage *QRImage = [Fm_Tools QRcodeWithUrlString:qrUrl];
    UIImage *plaxImage = [Fm_Tools addIconToQRCodeImage:QRImage withIcon:[UIImage imageNamed:@"二维码小图片"] withScale:6];
    NSMutableArray *array = [NSMutableArray array];
    for (int index =0; index < self.shareImageData.count; index++) {
        NSInteger jnde= [self.shareImageData[index] integerValue];
        FMFavoriteModel *model = self.dataArr[jnde];
        [array addObject:model.image];
    }
    
    FMShoppingListScanView *scanView = [[FMShoppingListScanView alloc]initWithData:[NSMutableArray arrayWithArray:array]count:self.totalNumber withQRImage:plaxImage];
    __weak typeof (self)weakSelf = self;
    scanView.block = ^(NSError *error){
        if(error != NULL){
            ShowAutoHideMBProgressHUD(weakSelf.view, @"二维码图片保存失败");
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"二维码图片已保存至相册");
        }
    };
    [self.view addSubview:scanView];
    [scanView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)clickDeleteButton:(UIButton *)sender {
    
    if (self.totalNumber == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"您还没有选择要删除的商品");
    }else{
        
        SignOnDeleteView *deleteView = [[SignOnDeleteView alloc]init];
        [deleteView showSignViewWithTitle:@"确认删除商品么？" detail:@"删除商品后就无法恢复商品了"];
        __weak typeof (self)weakSelf = self;
        deleteView.sureBlock = ^(UIButton *sender){
            [weakSelf deleteProductClickBottomAction:sender];
        };
    }
}

- (void)deleteProductClickBottomAction:(UIButton *)sender {
    
    NSMutableString *string = [NSMutableString string];
    for (int index =0; index < self.shareImageData.count; index++) {
        NSInteger jnde= [self.shareImageData[index] integerValue];
        FMFavoriteModel *model = self.dataArr[jnde];

        NSString *str = [NSString stringWithFormat:@"%ld,",(long)model.gid];
        [string appendString:str];
    }
    NSString *gidStr = [string substringWithRange:NSMakeRange(0, string.length - 1)];

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *nav = [NSString stringWithFormat:@"%@?gid=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMFavoriteListDeleteUrl,gidStr,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [FMHTTPClient postPath:nav parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];

        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        
        if ([status integerValue] == 0) {
            
            NSMutableArray *arrPath = [NSMutableArray array];
            NSMutableArray *arrData = [NSMutableArray array];
            
            for (NSNumber *number in self.shareImageData) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[number integerValue] inSection:0];
                [arrPath addObject:indexPath];
                [arrData addObject:self.dataArr[indexPath.row]];
            }
            [self.shareImageData removeAllObjects];
            self.totalNumber = 0;
            self.fmBottomView.allSelectButton.selected = NO;
            [self.dataArr removeObjectsInArray:arrData];
            [self.tableView deleteRowsAtIndexPaths:arrPath  withRowAnimation:(UITableViewRowAnimationFade)];
            
            [self.tableView reloadData];
            
            ShowAutoHideMBProgressHUD(self.view, @"已经将商品从收藏中移除");
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"暂时未能商品从收藏中移除");
        }
    } ];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.backgroundColor = KDefaultOrBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isOver = NO;
        _isAddData = NO;
        [self requestDataForTableView];
    }];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom);
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FMFavoriteTableViewCell";
    FMFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMFavoriteTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    __weak typeof (self)weakSelf = self;
    
    cell.selectBlock = ^(UIButton *sender){
        [weakSelf clickSelectButton:sender withIndexPath:indexPath];
    };
    
    FMFavoriteModel *model = self.dataArr[indexPath.row];
    [cell sendeDataWithModel:model];
    
    return cell;
}

- (void)clickSelectButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath{
    
    FMFavoriteModel *model = self.dataArr[indexPath.row];
    model.selectState = sender.selected;
    
    if (model.selectState) {
        self.totalNumber ++;
        [self.shareImageData addObject:[NSNumber numberWithInteger:indexPath.row]];

    }else {
        self.fmBottomView.allSelectButton.selected = NO;
        self.totalNumber --;
        [self.shareImageData removeObject:[NSNumber numberWithInteger:indexPath.row]];

    }
    if (self.totalNumber == self.dataArr.count) {
        self.fmBottomView.allSelectButton.selected = YES;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMFavoriteModel *model = self.dataArr[indexPath.row];
   
    
    FMPlaceOrderViewController *detailVC = [[FMPlaceOrderViewController alloc]init];
    detailVC.product_id = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (void)setNavItemsWithButton {
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightAction:) forControlEvents: UIControlEventTouchUpInside];
    messageButton.frame =CGRectMake(KProjectScreenWidth - 50, 10, 30, 30);
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    editButton.frame =CGRectMake(KProjectScreenWidth - 100, 10, 50, 30);
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:navItem,titleItem,nil] animated:YES];
}

- (void)rightAction:(UIButton *)sender {
    
    FMMessageModel *one = [[FMMessageModel alloc] initWithTitle:@"消息" imageName:@"优商城消息-消息04" isShowRed:NO];
    FMMessageModel *two = [[FMMessageModel alloc] initWithTitle:@"首页" imageName:@"优商城消息-消息03"  isShowRed:NO];
    NSArray * dataArr = @[one,two];
    
    __block  FMMessageAlterView * messageAlter = [[FMMessageAlterView alloc] initWithDataArray:dataArr origin:CGPointMake(KProjectScreenWidth - 15, 64) width:100 height:44 direction:kFMMessageAlterViewDirectionRight];
    messageAlter.delegate = self;
    messageAlter.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        messageAlter = nil;
    };
    [messageAlter pop];
}

- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            WLMessageViewController *wlVc = [[WLMessageViewController alloc]init];
            wlVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wlVc animated:YES];
        }else {
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)editButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (FMFavoriteModel *model in self.dataArr) {
        model.navSelectState = sender.selected;
    }
    
    [self.tableView reloadData];

    if (!sender.selected) {

        self.fmBottomView.hidden = YES;
        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }else {

        self.fmBottomView.hidden = NO;
        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
    }
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)shareImageData {
    if (!_shareImageData) {
        _shareImageData = [NSMutableArray array];
    }
    return _shareImageData;
}

- (FMFavoriteBottomView *)fmBottomView {
    if (!_fmBottomView) {
        _fmBottomView = [[FMFavoriteBottomView alloc]init];
    }
    return _fmBottomView;
}

- (void)clickAllSelectButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (FMFavoriteModel *model in self.dataArr) {
        model.selectState = sender.selected;
    }
    
    [self.tableView reloadData];
    
    if (sender.selected) {
        
        self.totalNumber = self.dataArr.count;
        [self.shareImageData removeAllObjects];
        
        for (int i = 0; i < self.dataArr.count; i++) {
            FMFavoriteModel *model = [self.dataArr objectAtIndex:i];
            if (model.selectState){
                [self.shareImageData addObject:[NSNumber numberWithInteger:i]];
            }
        }
    }else{
        self.totalNumber = 0;
        [self.shareImageData removeAllObjects];
    }
}

@end
