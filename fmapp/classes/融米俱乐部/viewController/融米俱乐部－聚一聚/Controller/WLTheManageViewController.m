//
//  WLManageViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLTheManageViewController.h"

#import "WLFollowingViewController.h"
#import "WLInfoViewController.h"
//#import "WLInfoShowView.h"
#import "WLRequestViewController.h"
#import "WLExchangeViewController.h"
#import "FMRTWellStoreViewController.h"

#import "HTTPClient+Interaction.h"
#import "FMMessageAlterView.h"
#import "YSMyPartyModel.h"
#import "YSMyPartyViewCell.h"
#import "YSMyPartyInCell.h"
#import "WLPublishSuccessViewController.h"
#import "XZRongMiFamilyViewController.h"
#import "WLOrganizationViewController.h" // 发布
#import "XZActivityModel.h"
#import "XZActivityViewController.h" //查看跳转 活动详情页
#import "XZGetTogetherViewController.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 146
#define KTabelViewTag 10000
#define theButtonTag 100000
@interface WLTheManageViewController ()<UITableViewDelegate,UITableViewDataSource,FMMessageAlterViewDelegate>
@property(nonatomic,strong)UIButton *signBtn;
/** 我的足迹  */
@property (nonatomic, strong)UIButton *footprintBtn;
/** 报名凭证底下横线  */
@property (nonatomic, strong)UIView *signLineV;
/** 我的足迹底部横线  */
@property (nonatomic, strong)UIView *footprintLineV;
@property (nonatomic, strong)UIView *bjView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;


@property (nonatomic, weak)NSArray *titleArr;
@property (nonatomic,strong)NSArray *detailberArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *myTableView;


//左侧的tableView
@property (nonatomic, strong)UITableView *tableView;
/**
 *  活动总数
 */
@property (nonatomic, strong)UILabel *countAll;
/**
 *  左部label
 */
@property (nonatomic, strong)UILabel *countAllLabel3;

@property (nonatomic, strong)NSString *tag;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) XZActivityModel *modelActivity;
@property (nonatomic, strong) NSMutableArray *arrActivity;
@end

@implementation WLTheManageViewController

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_signBtn setTitle:@"我的发布" forState:(UIControlStateNormal)];
        [_signBtn setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
        [_signBtn setTitleColor:[HXColor colorWithHexString:@"#003399"] forState:(UIControlStateSelected)];
        _signBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _signBtn;
}

- (NSMutableArray *)arrActivity {
    if (!_arrActivity) {
        _arrActivity = [NSMutableArray array];
    }
    return _arrActivity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self settingNavTitle:@"我的发布"];
    
    [self createTheContentView];
    __weak typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^() {
        
        NSArray *arrController = weakSelf.navigationController.viewControllers;
        NSInteger VcCount = arrController.count;
        UIViewController *lastVC = arrController[VcCount - 2];

        if ([lastVC isKindOfClass:[XZGetTogetherViewController class]]) {
           [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
        
           [weakSelf.navigationController popToViewController:arrController[VcCount - 3] animated:YES];

        }
        
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _currentPage = 1;

    [self.dataSource removeAllObjects];
    [self.dataArr removeAllObjects];
    // 我的发布
    [self getDataSourceFromNetWork];
    // 管理报名
    [self getDataFromNetWork];
}

-(void)createTheContentView{

    [self setTopSelectTitleView];

}

- (UIButton *)footprintBtn {
    if (!_footprintBtn) {
        _footprintBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_footprintBtn setTitle:@"管理报名" forState:(UIControlStateNormal)];
        [_footprintBtn setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
        [_footprintBtn setTitleColor:[HXColor colorWithHexString:@"#003399"] forState:(UIControlStateSelected)];
        _footprintBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_footprintBtn addTarget:self action:@selector(footprintAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _footprintBtn;
}


- (void)setTopSelectTitleView{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    self.signBtn.selected = YES;
    self.footprintBtn.selected = NO;
    [topView addSubview:self.signBtn];
    
    [topView addSubview:self.footprintBtn];
    [self.signBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(topView);
        make.right.equalTo(topView.mas_centerX);
    }];
    
    [self.footprintBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.left.equalTo(topView.mas_centerX);
    }];
    
    UIView *signLineV = [[UIView alloc]init];
    self.signLineV = signLineV;
    self.signLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    
    UIView *footprintLineV = [[UIView alloc]init];
    self.footprintLineV = footprintLineV;
    self.footprintLineV.backgroundColor = KDefaultOrBackgroundColor;
    [self.view addSubview:self.signLineV];
    [self.signLineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.signBtn);
        make.height.equalTo(2);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [self.view addSubview:self.footprintLineV];
    [self.footprintLineV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.and.right.equalTo(self.footprintBtn);
        make.height.equalTo(2);
    }];
    [self createLetfView];
}

- (void)signAction:(UIButton *)sender {
    self.currentPage = 1;

    [self.dataArr removeAllObjects];
    [self.dataSource removeAllObjects];
    self.footprintBtn.selected = NO;
    self.footprintLineV.backgroundColor = KDefaultOrBackgroundColor;
    self.signLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    sender.selected = YES;
    
    [self createLetfView];
    [self getDataSourceFromNetWork];
}

- (void)footprintAction:(UIButton *)sender {

    self.currentPage = 1;
    [self.dataArr removeAllObjects];
    [self.dataSource removeAllObjects];

    self.signBtn.selected = NO;
    self.signLineV.backgroundColor = KDefaultOrBackgroundColor;
    self.footprintLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    sender.selected = YES;
    
    [self createRightView];
    [self getDataFromNetWork];

}

//创建左侧视图
-(void)createLetfView{

    if (self.bjView) {
        [self.bjView removeFromSuperview];
    }
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 51, KProjectScreenWidth, KProjectScreenHeight-117)];
    [bjView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:bjView];
    self.bjView = bjView;
    
    self.bjView.backgroundColor =KDefaultOrBackgroundColor;
    [self createContentView];
    [self createTableView];
    self.tag = @"1";
//    [self getDataSourceFromNetWork];
}

//创建右侧视图
-(void)createRightView{

    if (self.bjView) {
        [self.bjView removeFromSuperview];
    }
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 51, KProjectScreenWidth, KProjectScreenHeight-117)];
    [bjView setBackgroundColor:[UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1]];
    [self.view addSubview:bjView];
    self.bjView = bjView;
    
    [self createTheTabelView];
//    [self getDataFromNetWork];

}

-(NSArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"", nil];
    }
    return _titleArr;
}

- (NSArray *)detailberArr {
    if (!_detailberArr) {
        _detailberArr = [NSArray arrayWithObjects:@"", nil];
    }
    return _detailberArr;
}

-(void)createTheTabelView{
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.bjView.bounds.size.height) style:UITableViewStylePlain];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tag = KTabelViewTag;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [self.dataArr removeAllObjects];
        [self getDataFromNetWork];
    }];
    self.myTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        [self getDataFromNetWork];
    }];
    
    [self.bjView addSubview:self.myTableView];
}


- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath{
    FMRTWellStoreViewController * rootViewController;
    for (UIViewController * viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
            rootViewController = (FMRTWellStoreViewController *)viewController;
        }
    }
    if (rootViewController) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popToViewController:rootViewController animated:NO];
    }
    
}


/**
 *https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/userpartyjoinlist
 */

-(void)getDataFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/userpartyjoinlist?from=rongtuoapp&appid=huiyuan&token=%@&shijian=%d&user_id=%@&page=%d&page_size=%d",tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId,self.currentPage,10];
    
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {

                NSArray * oldArray = response.responseObject[@"data"];


                if ([oldArray isMemberOfClass:[NSNull class]]) {
                }else{
                    if (oldArray.count != 0) {
                        
                        for(NSDictionary * dict in oldArray) {
                            
                            [self.dataArr addObject:dict];
                            
                        }
                        
                    }
                    [self.myTableView reloadData];

                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
            
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        });
    }];
    
}

#pragma mark ---- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == KTabelViewTag){
        return 1;
    }else{
    
        if (self.dataSource.count) {
            return self.dataSource.count;
        }else{
            return 0;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == KTabelViewTag) {
        return self.dataArr.count;
    }else{
    
       return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == KTabelViewTag) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
        
        //    白色底部
        UIView *whightView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, KProjectScreenWidth-30, 126)];
        [whightView setBackgroundColor:[UIColor whiteColor]];
        [whightView.layer setCornerRadius:3.0f];
        [whightView.layer setMasksToBounds:YES];
        [whightView setAlpha:1.0f ];
        [whightView setUserInteractionEnabled:YES];
        [cell.contentView addSubview:whightView];
        
        NSString *text = [self.dataArr[indexPath.row] objectForKey:@"name"];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(79, 20, whightView.frame.size.width/2, 20)];
        titleLabel.text = [NSString stringWithFormat:@"%@",text];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
        [whightView addSubview:titleLabel];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 54, 54)];
        imageV.layer.cornerRadius = 27;
        [imageV sd_setImageWithURL:[self.dataArr[indexPath.row] objectForKey:@"avatar"]];
        [whightView addSubview:imageV];
        
        NSString *text2 = [self.dataArr[indexPath.row] objectForKey:@"times"];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(79, 48, whightView.frame.size.width/2, 15)];
        detailLabel.text = [NSString stringWithFormat:@"第%@次参加我的活动",text2];
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        detailLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
        [whightView addSubview:detailLabel];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 80, whightView.frame.size.width-20, 2)];
        lineView1.backgroundColor = KDefaultOrBackgroundColor;
        [whightView addSubview:lineView1];
        
        //    第二波
        //    时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 82, 130, 40)];
        timeLabel.text = [self.dataArr[indexPath.row] objectForKey:@"commentime"];
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
        timeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
        [whightView addSubview:timeLabel];
        //    融米汇
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 82, KProjectScreenWidth-190, 40)];
        nameLabel.numberOfLines = 0;
        nameLabel.text = [self.dataArr[indexPath.row] objectForKey:@"party_theme"];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        if (self.view.frame.size.width<380) {
            if (self.view.frame.size.width>320) {
                nameLabel.font = [UIFont systemFontOfSize:14.0f];
            }else{
            
                nameLabel.font = [UIFont systemFontOfSize:13.0f];
            }
            
        }
        nameLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
        [whightView addSubview:nameLabel];
        
        UILabel *isPublishedLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-30-100-10, 20, 100, 20)];
        isPublishedLabel.text = [NSString stringWithFormat:@"%@",[self.dataArr[indexPath.row] objectForKey:@"joinname"]];
        isPublishedLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        isPublishedLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
        [isPublishedLabel setTextAlignment:NSTextAlignmentRight];
        [whightView addSubview:isPublishedLabel];
        
        UILabel *isFreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-30-100-10, 48, 100, 15)];
        isFreeLabel.text = [self.dataArr[indexPath.row] objectForKey:@"joinlable"];
        isFreeLabel.font = [UIFont systemFontOfSize:14.0f];
        isFreeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
        [isFreeLabel setTextAlignment:NSTextAlignmentRight];
        [whightView addSubview:isFreeLabel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
    
        static NSString *ID1 = @"YSMyPartyViewCell";
        static NSString *ID2 = @"YSMyPartyInCell";
        
        if ([self.tag integerValue] == 1) {
            YSMyPartyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
            if (cell == nil) {
                cell = [[YSMyPartyViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
            }
            //设置cell圆角
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (self.dataSource.count) {
                cell.dataSource = self.dataSource[indexPath.section];

            }
            
            return cell;
            
        }else{
            YSMyPartyInCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
            if (cell == nil) {
                cell = [[YSMyPartyInCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
            }
            //设置cell圆角
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (self.dataSource.count) {
                cell.dataSource = self.dataSource[indexPath.section];

            }
            cell.blockBtn = ^(UIButton *button){
            
                if (button.tag == theButtonTag) {
                //查看
                    XZActivityViewController *acV = [[XZActivityViewController alloc]init];
                    acV.pid = [self.dataSource[indexPath.section] pid];
                    [self.navigationController pushViewController:acV animated:YES];
                }
                if (button.tag == theButtonTag+1) {
                    if (![[self.dataSource[indexPath.section] states] isEqualToString:@"0"]) {
                        
                        XZActivityModel *modelActivity = self.arrActivity[indexPath.section];
                        //分享
                        WLPublishSuccessViewController *VC = [[WLPublishSuccessViewController alloc]init];
                        VC.modelActivity = modelActivity;
                        [self.navigationController pushViewController:VC animated:YES];
                    }else{
                    
                        ShowAutoHideMBProgressHUD(self.view, @"您的活动未通过审核,不可分享");
                        
                    }
                }
                if (button.tag == theButtonTag+2) {
                    if (![[self.dataSource[indexPath.section] states] isEqualToString:@"1"]) {
                        //修改
                        WLOrganizationViewController *organization = [[WLOrganizationViewController alloc]init];
                        organization.pid = [self.dataSource[indexPath.section] pid];
                        [self.navigationController pushViewController:organization animated:YES];
                        
                    }else {
                    
                        ShowAutoHideMBProgressHUD(self.view, @"您的活动已通过审核,不可修改");
                    }
                
                }
            };
            return cell;
        }
    }
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == KTabelViewTag){
    
        return 0;
    }else{
    
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView.tag == KTabelViewTag){
        
        return 0;
    }else{
        
        return 1;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == KTabelViewTag) {
      
        return KCellHeghtFloat;
    }else{
    
        if ([self.tag integerValue]== 1) {
            return 120;
        }else{
            return 160;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == KTabelViewTag) {
        
        WLExchangeViewController *vc = [[WLExchangeViewController alloc]init];
        vc.name = [self.dataArr[indexPath.row] objectForKey:@"name"];
        vc.phoneNumber = [self.dataArr[indexPath.row] objectForKey:@"phone"];
        vc.pid = [self.dataArr[indexPath.row] objectForKey:@"pid"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if ([[self.dataSource[indexPath.section] jieshu] isEqualToString:@"0"]) {
            XZRongMiFamilyViewController *vc = [[XZRongMiFamilyViewController alloc]init];
            vc.pid = [self.dataSource[indexPath.section] pid];
            vc.party_theme = [self.dataSource[indexPath.section] party_theme];
//            YSMyPartyModel *model = self.dataSource[indexPath.section];
//            vc.state = model.state;
            
            vc.state = [self.dataSource[indexPath.section] states];
            [self.navigationController pushViewController:vc animated:YES];

        }else{
        }
        
    }
}



/***********letf*************/

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *  网络请求
 */
- (void)getDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/partyreleaseapp";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"leibie":self.tag,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
                id newArr = dic[@"listAll"];
                self.countAll.text = [NSString stringWithFormat:@"%@", dic[@"countAll"]];
                
                if ([dic[@"countAll"] integerValue] == 0) {
                    ShowAutoHideMBProgressHUD(self.view, @"没有相应活动");
                }
                
                if (![newArr isMemberOfClass:[NSNull class]]) {
                    
                    if ([newArr isKindOfClass:[NSArray class]]) {
                        
                        NSArray *newArray = [NSArray arrayWithArray:newArr];
                        
                        if (newArray.count) {
                            if (![newArray isKindOfClass:[NSNull class]]) {
                                
                                for(NSDictionary *dict in newArray){
                                    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                    XZActivityModel *modelActivity = [[XZActivityModel alloc]init];
                                    self.modelActivity = modelActivity;
                                    [modelActivity setValuesForKeysWithDictionary:dict];
                                    [self.arrActivity addObject:modelActivity];
                                    YSMyPartyModel *model = [[YSMyPartyModel alloc]initWithDict:infoDict];
                                    [self.dataSource addObject:model];
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  创建tabelView
 */
- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 48, KProjectScreenWidth - 25, KProjectScreenHeight - 48 - 117) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KDefaultOrBackgroundColor;
    self.tableView.dataSource = self;
    [self.bjView addSubview:self.tableView];
    __weak typeof (self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getDataSourceFromNetWork];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
            _currentPage = _currentPage+1;
            [weakSelf getDataSourceFromNetWork];
        }
    ];
    
}

- (void)createContentView{
    
    /**
     *  头部试图
     */
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = KDefaultOrBackgroundColor;
    [self.bjView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView.mas_top);
        make.left.equalTo(self.bjView.mas_left).offset(15);
        make.right.equalTo(self.bjView.mas_right).offset(-10);
        make.height.equalTo(48);
    }];
    
    //左部label
    UILabel *countAllLabel1 = [[UILabel alloc]init];
    countAllLabel1.text = @"共";
    countAllLabel1.font = [UIFont systemFontOfSize:14];
    countAllLabel1.backgroundColor = self.bjView.backgroundColor;
    [headerView addSubview:countAllLabel1];
    [countAllLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    UILabel *countAllLabel2 = [[UILabel alloc]init];
    //    countAllLabel2.text = @"2";
    self.countAll = countAllLabel2;
    countAllLabel2.textAlignment = NSTextAlignmentCenter;
    countAllLabel2.textColor = [UIColor blackColor];
    countAllLabel2.font = [UIFont systemFontOfSize:22];
    countAllLabel2.backgroundColor = self.bjView.backgroundColor;
    [headerView addSubview:countAllLabel2];
    [countAllLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countAllLabel1.mas_right);
        make.bottom.equalTo(headerView.mas_bottom).offset(2);
    }];
    UILabel *countAllLabel3 = [[UILabel alloc]init];
    countAllLabel3.text = @"个活动";
    countAllLabel3.font = [UIFont systemFontOfSize:14];
    countAllLabel3.backgroundColor = self.bjView.backgroundColor;
    self.countAllLabel3 = countAllLabel3;
    [headerView addSubview:countAllLabel3];
    [countAllLabel3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countAllLabel2.mas_right);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    //右部button
    UIButton *doingBtn = [[UIButton alloc]init];
    doingBtn.backgroundColor = [UIColor colorWith8BitRed:9 green:64 blue:143 alpha:1];
    [doingBtn setTitle:@"只看进行中的活动" forState:UIControlStateNormal];
    [doingBtn setTitle:@"查看全部活动" forState:UIControlStateSelected];
    [doingBtn.layer setCornerRadius:2];
    [doingBtn setContentEdgeInsets:UIEdgeInsetsMake(9, 10, 8, 10)];
    doingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [doingBtn addTarget:self action:@selector(doingAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doingBtn];
    [doingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
}
- (void)doingAction:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected == YES){  //按钮名字 "查看全部活动"
        
        self.tag = @"2";
        self.countAllLabel3.text = @"个进行中的活动";
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
        [self getDataSourceFromNetWork];
        
    }else{    //按钮名字 "只看进行中的活动"
        self.tag = @"1";
        self.countAllLabel3.text = @"个活动";
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
        [self getDataSourceFromNetWork];
        
    }
}



@end
