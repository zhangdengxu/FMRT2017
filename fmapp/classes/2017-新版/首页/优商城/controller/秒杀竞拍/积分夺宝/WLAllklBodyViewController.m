//
//  WLAllklBodyViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KdefauleMargion 30

#import "WLAllklBodyViewController.h"
#import "FMTimeKillShopController.h"
#import "FMTimeKillShopDetailController.h"

#import "WLAllBodyShopHeaderView.h"
#import "FMTimeKillTableViewFooterView.h"
#import "NSDate+CategoryPre.h"
#import "FMTimeKillShopModel.h"
#import "FMTimeKillCommentCell.h"
#import "FMKillTimeComment.h"
#import "FMRTAucTool.h"
#import "FMButtonStyleModel.h"

#import "FMShopSpecModel.h"
#import "XZConfirmOrderKillViewController.h"
#import "YSSpikeRuleViewController.h"
#import "WLDuobaoTableViewCell.h"
#import "WLAllPelpleModel.h"
#import "FMShopDetailDuobaoViewController.h"
#import "XZMySnatchController.h" // 我的夺宝
#import "YYAnnounceResultsNewViewController.h"
#import "XZCommonProblemsController.h"
#import "XZBaskOrderNewController.h"
#import "Fm_Tools.h"
#import "WLFirstPageHeaderViewController.h"

@interface WLAllklBodyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * headerDataSource;
@property (nonatomic, strong) WLAllBodyShopHeaderView * tableViewHeaderView;
@property (nonatomic, strong) UIView * tableViewFooterView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * FooderViewDataSource;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray * time_bucket;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@property (nonatomic, strong) FMSelectShopInfoModel * shopDetailModel;
@property (nonatomic,strong) UIButton *leftrintBtn;
@property (nonatomic,strong) UIButton *rightprintBtn;
@property (nonatomic, strong) NSString * isXiala;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
/**
 *1为最新商品 2为精品推荐
 */
@property (nonatomic, strong)NSString *currentStyle;

@end
//WLAllBodyShopHeaderView
@implementation WLAllklBodyViewController

static NSString * FMDuobaoTableViewRegister = @"FMDuobaoTableViewRegister" ;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSourceWithHeaderFromNetWork];
}

//头部视图
-(WLAllBodyShopHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[WLAllBodyShopHeaderView alloc]init];
        
        __weak __typeof(&*self)weakSelf = self;
        
        _tableViewHeaderView.headButtonOnClick = ^(NSInteger index){
            
            [weakSelf continuWithItem:index];
            
        };
        _tableViewHeaderView.moreBlock = ^(){
        
            [weakSelf turnToMorePage];
        };
    }
    return _tableViewHeaderView;
}
/**
 *点击头部更多
 */
-(void)turnToMorePage{

    YYAnnounceResultsNewViewController *YYVc = [[YYAnnounceResultsNewViewController alloc]init];
    [self.navigationController pushViewController:YYVc animated:YES];

}
/**
 *点击头部滚动视图
 */
-(void)continuWithItem:(NSInteger)index
{
    WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];
    viewController.shareURL = @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/duobaoguize";
    viewController.navTitle = @"夺宝规则";
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
/**
 *尾部视图
 */
-(UIView *)tableViewFooterView
{

    NSInteger number = self.FooderViewDataSource.count;
    if (number>=2) {
        number = 2;
    }
    number = 0;
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 75)];
        [_tableViewFooterView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-7.5, 10.5, 15, 9)];
        [imgV setImage:[UIImage imageNamed:@"向下展开"]];
        [_tableViewFooterView addSubview:imgV];
        UIButton *loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loadButton setFrame:CGRectMake(0, 0, KProjectScreenWidth, 30)];
        [loadButton addTarget:self action:@selector(loadMoreAndShowMassege) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooterView addSubview:loadButton];
        
        if (number > 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, KProjectScreenWidth, 5)];
            [lineView setBackgroundColor:KDefaultOrBackgroundColor];
            [_tableViewFooterView addSubview:lineView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 40)];
            [titleLabel setText:@"晒单专区"];
            [titleLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
            [_tableViewFooterView addSubview:titleLabel];
            
            UILabel *moreLabel = [[UILabel alloc]init];
            [moreLabel setText:@"更多"];
            [moreLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
            [moreLabel setFont:[UIFont boldSystemFontOfSize:12]];
            [_tableViewFooterView addSubview:moreLabel];
            [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_tableViewFooterView.mas_right).offset(-25);
                make.top.equalTo(_tableViewFooterView.mas_top).offset(35);
                make.height.equalTo(40);
            }];
            UIImageView *arrowImagV = [[UIImageView alloc]init];
            [arrowImagV setImage:[UIImage imageNamed:@"箭头_103"]];
            [_tableViewFooterView addSubview:arrowImagV];
            [arrowImagV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(moreLabel.mas_right).offset(3);
                make.top.equalTo(moreLabel.mas_top).offset(15.5);
                make.width.equalTo(5);
                make.height.equalTo(9);
            }];
            UIButton *chooseMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseMoreButton addTarget:self action:@selector(chosseAction:) forControlEvents:UIControlEventTouchUpInside];
            [_tableViewFooterView addSubview:chooseMoreButton];
            [chooseMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(moreLabel.mas_left);
                make.top.equalTo(moreLabel.mas_top);
                make.right.equalTo(_tableViewFooterView.mas_right);
                make.height.equalTo(40);
            }];
        }
        
        /**
         *尾部视图两个cell
         */
        CGFloat height = 0;
        CGFloat height2 = 0;
        for (int i = 0; i<number; i++) {
            UIView *bjView = [[UIView alloc]init];
            UIImageView *imgView = [[UIImageView alloc]init];
            NSString *head_url = [self.FooderViewDataSource[i] objectForKey:@"head_url"];
            [imgView sd_setImageWithURL:[NSURL URLWithString:head_url]];
            imgView.layer.cornerRadius = 17.5;
            [imgView.layer setMasksToBounds:YES];
            [bjView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bjView.mas_left).offset(10);
                make.top.equalTo(bjView.mas_top).offset(15);
                make.width.equalTo(35);
                make.height.equalTo(35);
            }];
            [bjView setFrame:CGRectMake(0, 75+height, KProjectScreenWidth, 200)];
            [_tableViewFooterView addSubview:bjView];
            
            UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, .5)];
            topLineView.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1];
            [bjView addSubview:topLineView];
            
            UILabel *title = [[UILabel alloc]init];
            NSString *nickName = [NSString stringWithFormat:@"%@",[self.FooderViewDataSource[i] objectForKey:@"nickname"]];
            if ([[self.FooderViewDataSource[i] objectForKey:@"nickname"] isKindOfClass:[NSNull class]] || nickName.length == 0) {
                NSString *phoneNuber = [NSString stringWithFormat:@"%@",[self.FooderViewDataSource[i] objectForKey:@"phone"]];
                [title setText:[NSString stringWithFormat:@"ID:%@",[self phoneNumberWithStar:phoneNuber]]];
            }else{
                [title setText:[NSString stringWithFormat:@"ID:%@",nickName]];

            }
            [title setTextColor:[HXColor colorWithHexString:@"#0099FF"]];
            [title setFont:[UIFont systemFontOfSize:16]];
            [bjView addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(25);
                make.top.equalTo(imgView.mas_top);
                make.height.equalTo(30);
            }];
            /**
             *时间
             */
            UILabel *labelTime = [[UILabel alloc] init];
            [bjView addSubview:labelTime];
            [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bjView).offset(-10);
                make.centerY.equalTo(title.mas_centerY);
            }];
            labelTime.textColor = XZColor(153, 153, 153);
            labelTime.font = [UIFont systemFontOfSize:14];
            labelTime.textAlignment = NSTextAlignmentRight;
            NSString *timeStr = [NSString stringWithFormat:@"%@",[Fm_Tools getTotalTimeFromString:[self.FooderViewDataSource[i] objectForKey:@"comment_time"]]];
            [labelTime setText:timeStr];
            
            UILabel *title1 = [[UILabel alloc]init];
            [title1 setText:[self.FooderViewDataSource[i] objectForKey:@"comment_title"]];
            [title1 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9]];
            [title1 setFont:[UIFont systemFontOfSize:16]];
            [bjView addSubview:title1];
            [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_left);
                make.right.equalTo(bjView.mas_right).offset(-15);
                make.top.equalTo(title.mas_bottom).offset(5);
                make.height.equalTo(30);
            }];
            
            UILabel *content = [[UILabel alloc]init];
            [content setText:[self.FooderViewDataSource[i] objectForKey:@"comment_content"]];
            [content setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
            [content setFont:[UIFont systemFontOfSize:13]];
            content.numberOfLines = 0;
            [bjView addSubview:content];
            [content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_left);
                make.right.equalTo(bjView.mas_right).offset(-15);
                make.top.equalTo(title1.mas_bottom);
            }];
            if (i == 0) {
                height = 80+[self heitForLabel:[self.FooderViewDataSource[0] objectForKey:@"comment_content"]]+100;
                [bjView setFrame:CGRectMake(0, 75, KProjectScreenWidth, height)];
            }else{
                height2 = 80+[self heitForLabel:[self.FooderViewDataSource[1] objectForKey:@"comment_content"]]+100;
                [bjView setFrame:CGRectMake(0, 75+height, KProjectScreenWidth, height2)];
            }
            UIView *imageBjView = [[UIView alloc]init];
            [bjView addSubview:imageBjView];
            [imageBjView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_left);
                make.right.equalTo(bjView.mas_right).offset(-15);
                make.top.equalTo(content.mas_bottom).offset(15);
                make.height.equalTo(65);
            }];
            NSArray *img_list = [self.FooderViewDataSource[i] objectForKey:@"img_list"];
            for (int j = 0; j<img_list.count; j++) {
                UIImageView *showImages = [[UIImageView alloc]initWithFrame:CGRectMake((65+10)*j, 0, 65, 65)];
                [showImages sd_setImageWithURL:[NSURL URLWithString:img_list[j]] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
                [imageBjView addSubview:showImages];
            }
        }
        if (number == 0) {
           [_tableViewFooterView setFrame:CGRectMake(0, 0, KProjectScreenWidth, 30)];
        }else{
        
        [_tableViewFooterView setFrame:CGRectMake(0, 0, KProjectScreenWidth, height+height2+75)];
        }
    }
    return _tableViewFooterView;
}
/**
 *打马赛克的手机号
 */
-(NSString *)phoneNumberWithStar:(NSString *)phoneNuber{

    NSString *a = [phoneNuber substringToIndex:3];
    NSString *b = [phoneNuber substringFromIndex:7];
    NSString *phone = [NSString stringWithFormat:@"%@****%@",a,b];
    return phone;
}
/**
 *加载更多
 */
-(void)loadMore{
    
    _currentPage = _currentPage + 1;
    _isAddData = YES;
    [self getDataSourceFromNetWorkWithString:self.currentStyle];
}

/**
 *下拉刷新
 */
-(void)loadMoreXiala{
    [self.dataSource removeAllObjects];
    _currentPage = 1;
    _isAddData = NO;
    [self getDataSourceFromNetWorkWithString:self.currentStyle];
}


/**
 *加载更多1
 */
-(void)loadMoreAndShowMassege{

    self.isXiala = @"yes";
    [self loadMore];
}

//计算label高度
-(CGFloat)heitForLabel:(NSString *)content{
    
    CGFloat chengweiW = KProjectScreenWidth - 85;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGFloat chengweiH = [content boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
    return chengweiH;
}
/**
 *跳转晒单专区
 */
-(void)chosseAction:(UIButton *)sender{

    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        XZBaskOrderNewController *XZSVc = [[XZBaskOrderNewController alloc]init];
        [self.navigationController pushViewController:XZSVc animated:YES];
    }
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(NSMutableArray *)FooderViewDataSource
{
    if (!_FooderViewDataSource) {
        
        _FooderViewDataSource = [NSMutableArray array];
        
    }
    return _FooderViewDataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self createHeaderView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 刷新
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf requestGetTotherData];
        }];

        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
/**
 *下啦刷新方法
 */
-(void)requestGetTotherData{

    [self getDataSourceWithHeaderFromNetWork];
    [self loadMoreXiala];
    [self getFooterViewDataSourceFromNetWork];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

-(UIView *)createHeaderView{

    CGFloat height = self.tableViewHeaderView.frame.size.height;
    UIView *headerBjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, height+50)];
    [headerBjView addSubview:self.tableViewHeaderView];
    [headerBjView setBackgroundColor:[UIColor whiteColor]];
    
    [self.leftrintBtn setFrame:CGRectMake(0, height, KProjectScreenWidth/2, 50)];
    self.leftrintBtn.selected = YES;
    [headerBjView addSubview:self.leftrintBtn];
    
    [self.rightprintBtn setFrame:CGRectMake(KProjectScreenWidth/2, height, KProjectScreenWidth/2, 50)];
    self.rightprintBtn.selected = NO;
    [headerBjView addSubview:self.rightprintBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height+49.5, KProjectScreenWidth, .5)];
    lineView.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1];
    [headerBjView addSubview:lineView];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2, height+10, 1, 30)];
    lineView1.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1];
    [headerBjView addSubview:lineView1];
    return headerBjView;
}

- (UIButton *)leftrintBtn {
    if (!_leftrintBtn) {
        _leftrintBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftrintBtn setTitle:@"最新商品" forState:(UIControlStateNormal)];
        [_leftrintBtn setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
        [_leftrintBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateSelected)];
        _leftrintBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_leftrintBtn addTarget:self action:@selector(footprintAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _leftrintBtn;
}

- (UIButton *)rightprintBtn {
    if (!_rightprintBtn) {
        _rightprintBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightprintBtn setTitle:@"精品推荐" forState:(UIControlStateNormal)];
        [_rightprintBtn setTitleColor:KContentTextColor forState:(UIControlStateNormal)];
        [_rightprintBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateSelected)];
        _rightprintBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_rightprintBtn addTarget:self action:@selector(rightPrintAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _rightprintBtn;
}

- (void)footprintAction:(UIButton *)sender {
    
    self.rightprintBtn.selected = NO;
    sender.selected = YES;
    
    _currentPage = 1;
    _isAddData = NO;
    self.currentStyle = @"1";
    [self getDataSourceFromNetWorkWithString:self.currentStyle];
}
-(void)rightPrintAction:(UIButton *)sender{

    self.leftrintBtn.selected = NO;
    sender.selected = YES;
    
    _currentPage = 1;
    _isAddData = NO;
    self.currentStyle = @"2";
    [self getDataSourceFromNetWorkWithString:self.currentStyle];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.currentStyle = @"1";
    [self settingNavTitle:@"全民夺宝"];
    //添加tableview
    [self.view addSubview: self.tableView];
    [self setRightButtonItemWithTitleImage:@"新版-我的夺宝"];
    [self creatBackToTopButton];
    [self getDataSourceWithHeaderFromNetWork];
    [self getDataSourceFromNetWorkWithString:@"1"];
    [self getFooterViewDataSourceFromNetWork];
}

/**
 *创建右上角按钮
 */
- (void)setRightButtonItemWithTitleImage:(NSString *)imageName{
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
/**
 *创建返回顶部和消息漂浮按钮
 */
-(void)creatBackToTopButton{

    //联系客服-改版
    CGFloat returTopView_width = 35;
    UIButton * returTopView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5 , self.view.frame.size.height - 64 - returTopView_width - KdefauleMargion - 10 - returTopView_width, returTopView_width, returTopView_width)];
    [returTopView setBackgroundImage:[UIImage imageNamed:@"联系客服-改版"] forState:UIControlStateNormal];
    [returTopView addTarget:self action:@selector(controlCallTelephoneButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returTopView];
    [self.view bringSubviewToFront:returTopView];
    
    //返回顶部
    UIButton * callTelephoneView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height - 64 - returTopView_width - KdefauleMargion, returTopView_width, returTopView_width)];
    [callTelephoneView setBackgroundImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [callTelephoneView addTarget:self action:@selector(controlScrollViewLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callTelephoneView];
    [self.view bringSubviewToFront:callTelephoneView];
}

- (void)controlScrollViewLocationButtonOnClick:(UIButton *)button
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

}
/**
 *右下角消息点击事件
 */
-(void)controlCallTelephoneButtonOnClick:(UIButton *)button{

    XZCommonProblemsController *XZVc = [[XZCommonProblemsController alloc]init];
    [self.navigationController pushViewController:XZVc animated:YES];
}
/**
 *右上角我的
 */
-(void)rightButton
{
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        [self requestForReadNews];
        XZMySnatchController *mySnatch = [[XZMySnatchController alloc] init];
        [self.navigationController pushViewController:mySnatch animated:YES];
    }
}
/**
 *消息已读请求
 */
-(void)requestForReadNews{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSDictionary * paras = @{@"appid":@"huiyuan",
              @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
              @"shijian":[NSNumber numberWithInt:timestamp],
              @"token":[token lowercaseString]
              };
    [FMHTTPClient postPath:[NSString stringWithFormat:@"%@/public/newon/show/readLotteryInfo",kXZTestEnvironment] parameters:paras completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
           
        }
    }];
}

/**
 *请求头部视图数据
 */
-(void)getDataSourceWithHeaderFromNetWork
{
    NSString *token;
    NSDictionary * paras;
    int timestamp = [[NSDate date]timeIntervalSince1970];
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
         paras = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":[token lowercaseString]
                                 };

    }else{
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString]
                  };
    }
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:[NSString stringWithFormat:@"%@/public/newon/show/getFontPageInfo",kXZTestEnvironment] parameters:paras completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dataAll = response.responseObject[@"data"];
            [weakSelf changeTableViewHeaderData:dataAll[@"banner"] Withscrolling_message:dataAll[@"scrolling_message"]];
            if ([dataAll[@"is_unread_record"] isEqualToString:@"1"]) {
                [weakSelf setRightButtonItemWithTitleImage:@"新版-我的夺宝-灰色点"];
            }else{
                [weakSelf setRightButtonItemWithTitleImage:@"新版-我的夺宝"];
            }
        }
    }];
}
/**
 *请求tableView数据
 */
-(void)getDataSourceFromNetWorkWithString:(NSString *)type
{
    NSString *token;
    NSDictionary * paras;
    int timestamp = [[NSDate date]timeIntervalSince1970];
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState){
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                  @"page_num":@"6",
                  @"rank_type":type};

    }else{
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                  @"page_num":@"6",
                  @"rank_type":type};

    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:[NSString stringWithFormat:@"%@/public/newon/show/getActiveWonList",kXZTestEnvironment] parameters:paras completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSArray * oldArray = response.responseObject[@"data"];
            if (_isAddData) {
                _isAddData = NO;
            }else
            {
                [weakSelf.dataSource removeAllObjects];
            }
            if (oldArray.count != 0) {
                
                for(NSDictionary * dict in oldArray) {
                    //model
                    WLAllPelpleModel *model = [[WLAllPelpleModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [weakSelf.dataSource addObject:model];
                }
            }else{
                NSString *str = [NSString stringWithFormat:@"%@",weakSelf.isXiala];
                if ([str isEqualToString:@"yes"]) {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"暂无更多数据");
                    weakSelf.isXiala = @"";
                }
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *请求尾部视图数据
 */
-(void)getFooterViewDataSourceFromNetWork
{
    NSString *token;
    NSDictionary * paras;
    int timestamp = [[NSDate date]timeIntervalSince1970];
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState){
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"page":@"1",
                  @"page_num":@"5"};
    }else{
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"page":@"1",
                  @"page_num":@"5"};
    }

    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:[NSString stringWithFormat:@"%@/public/newon/comment/getComments",kXZTestEnvironment] parameters:paras completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSArray * oldArray = response.responseObject[@"data"];
          
            if (oldArray.count != 0) {
                
                for(NSDictionary * dict in oldArray) {
                    
                    [weakSelf.FooderViewDataSource addObject:dict];
                }
            }
            if (_tableViewFooterView){
                [_tableViewFooterView removeFromSuperview];
                _tableViewFooterView = nil;
            }
            weakSelf.tableView.tableFooterView = weakSelf.tableViewFooterView;
        }
    }];
}

/**
 *头部数据赋值
 */
-(void)changeTableViewHeaderData:(NSArray *)banner Withscrolling_message:(NSArray *)message
{
    [self.tableViewHeaderView changeTableViewHeaderData:banner Withscrolling_message:message];
}

#pragma mark- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?self.dataSource.count:0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    WLAllPelpleModel * model = self.dataSource[indexPath.row];
    FMShopDetailDuobaoViewController * duobao = [[FMShopDetailDuobaoViewController alloc]init];
    duobao.product_id = model.product_id;
    duobao.won_id = model.won_id;
    [self.navigationController pushViewController:duobao animated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLDuobaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMDuobaoTableViewRegister];
    if (!cell) {
        cell = [[WLDuobaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FMDuobaoTableViewRegister];
    }
    if (self.dataSource.count) {
        WLAllPelpleModel *modelALL = self.dataSource[indexPath.row];
        cell.model = modelALL;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
    
}


@end
