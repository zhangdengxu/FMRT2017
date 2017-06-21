//
//  WLDJQTABViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLDJQTABViewController.h"
#import "HTTPClient+Interaction.h"
#import "WLRegularViewController.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "FMShopSpecModel.h"
#import "FMRTWellStoreViewController.h"

#define KReuseCellId @"JPJLTableVControllerCell"

@interface WLDJQTABViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIView *bjView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)XZActivityModel *model;
@property (nonatomic,strong)UILabel *labelHeaderView;
@end

@implementation WLDJQTABViewController

-(NSArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UIView *)bjView{
    
    if (!_bjView) {
        _bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [_bjView setBackgroundColor:[UIColor colorWithRed:228/255.0f green:235/255.0f blue:241/255.0f alpha:1]];
    }
    return _bjView;
}

-(XZActivityModel *)model{
    
    if (!_model) {
        _model = [[XZActivityModel alloc]init];;
    }
    return _model;
}

- (UILabel *)labelHeaderView {
    if (!_labelHeaderView) {
        _labelHeaderView = [[UILabel alloc] initWithFrame:CGRectMake((KProjectScreenWidth - 100) * 0.5, KProjectScreenWidth * 0.5, 100, 50)];
        _labelHeaderView.text = @"暂无数据";
        _labelHeaderView.textColor = [UIColor darkGrayColor];
        _labelHeaderView.font = [UIFont boldSystemFontOfSize:16.0f];
        _labelHeaderView.textAlignment = NSTextAlignmentCenter;
    }
    return _labelHeaderView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_myTableView) {
        [self createTableView];
    }
    [self getDataFromNetWork];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self settingNavTitle:@"抵价券"];
    
    if ([[NSString stringWithFormat:@"%@",self.state] isEqualToString:@"1"]) {
        [self createBottomBtn];
    }
    

}

-(void)createBottomBtn{

    CGFloat height = [[NSString stringWithFormat:@"%@",self.state] isEqualToString:@"1"]?self.view.bounds.size.height-88:self.view.bounds.size.height-45;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, 45)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    [self.view addSubview:bottomView];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    [bottomLabel setText:@"暂不使用抵价券"];
    [bottomLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:bottomLabel];
    
    UIButton *regularBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regularBtn setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [regularBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [regularBtn addTarget:self action:@selector(giveUpAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:regularBtn];
    
}

-(void)giveUpAction{

    if (self.blockBottomButton) {
        self.blockBottomButton();
    }
    [self.navigationController popViewControllerAnimated:YES];

}

-(UIView *)createHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 40)];
    [headerView setBackgroundColor:KDefaultOrBackgroundColor];
    
    UIButton *regularBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regularBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [regularBtn setTitle:@"抵价券规则" forState:UIControlStateNormal];
    [regularBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [regularBtn addTarget:self action:@selector(regularAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:regularBtn];
    [regularBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(5);
        make.right.equalTo(headerView.mas_right).offset(-10);
    }];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"活动规则--问号_08.png"]];
    [headerView addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(regularBtn.mas_centerY);
        make.right.equalTo(regularBtn.mas_left).offset(-2);
        make.height.equalTo(13);
        make.width.equalTo(13);
    }];
    
    return headerView;
}

-(void)createTableView{

    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [[NSString stringWithFormat:@"%@",self.state] isEqualToString:@"1"]?self.view.bounds.size.height-85:self.view.bounds.size.height-45) style:UITableViewStylePlain];
    _myTableView.backgroundColor = KDefaultOrBackgroundColor;
    _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableHeaderView = [self createHeaderView];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _isAddData = NO;
        [self getDataFromNetWork];
    }];
    _myTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        _isAddData = YES;
        [self getDataFromNetWork];
    }];
    [self.view addSubview:_myTableView];

}


-(void)getDataFromNetWork{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *string =[NSString stringWithFormat:@"%@/public/ticket/getUserTicketList",kXZTestEnvironment];
    

    
    
   // NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/java/public/ticket/getUserTicketList"];
    
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"state":self.state,@"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
//            NSLog(@"***********%@",response.responseObject);
            self.dataArr = [response.responseObject objectForKey:@"data"];
            [self.myTableView reloadData];
            
            if (self.dataArr.count == 0) {
                if (!_labelHeaderView) {
                  [self.view addSubview:[self labelHeaderView]];
                }
                
                if (!_bjView) {
                   [self createWDJQView];
                }
                
                [self getShareInfo];
            }else{
                [self.labelHeaderView removeFromSuperview];
                [self.bjView removeFromSuperview];
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

-(void)getShareInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    
    NSString *string =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    

    
    //NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,@"flag":self.flag,@"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
            NSString *flagStr = [NSString stringWithFormat:@""];
            if ([self.flag isEqualToString:@"kill"]) {
                flagStr = @"1";
            }else if ([self.flag isEqualToString:@"auction"]){
                flagStr = @"2";
            }
            self.model.shareurl = [NSString stringWithFormat:@"%@?flag=%@",[dic objectForKey:@"link"],flagStr];
            self.model.sharetitle = [dic objectForKey:@"title"];
            self.model.sharepic = [dic objectForKey:@"img"];
            self.model.sharecontent = [dic objectForKey:@"content"];
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"读取失败");
        }

    }];

}

-(void)userAction:(UIButton *)button{
    //立即使用
    /*
     data =     (
     {
     amount = 4;
     "begin_date" = 1471276800;
     "consume_time" = "<null>";
     "end_date" = 1472572800;
     "receive_time" = 1471321585;
     "receive_type" = first;
     state = 1;
     "ticket_id" = 192;
     }
     );
     */
    if ([self.tag isEqualToString:@"grzx"]) {
        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        
        [self.navigationController popToViewController:viewCtl animated:YES];

    }else{
    
        NSDictionary *dic = self.dataArr[button.tag];
        
        if ([[dic objectForKey:@"state"] isEqualToString:@"1"]){
            
            FMSelectShopInfoModel *modelShopInfo = [[FMSelectShopInfoModel alloc] init];
            modelShopInfo.ticket_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_id"]];
            modelShopInfo.amount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"amount"]];
            modelShopInfo.unUseCoupon = NO; // 不选择优惠券
            //        这里调用block 给需要用到的视图控制器传值
            if (self.blockSupportTicket) {
                self.blockSupportTicket(modelShopInfo);
            }
            
            if ([self.flag isEqualToString:@"kill"] || [self.flag isEqualToString:@"auction"] || [self.flag isEqualToString:@"won"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                FMRTWellStoreViewController *vc = [[FMRTWellStoreViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }

    }
    
    
}

-(void)createWDJQView{
    
    [self.view addSubview:self.bjView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"很遗憾"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:24]];
    [self.bjView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView.mas_top).offset(100);
        make.left.equalTo(self.bjView.mas_left).offset(10);
        make.right.equalTo(self.bjView.mas_right).offset(-10);
        make.height.equalTo(30);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    [titleLabel1 setText:@"您还没有获得抵价券！"];
    [titleLabel1 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel1 setTextColor:[UIColor redColor]];
    [titleLabel1 setFont:[UIFont systemFontOfSize:24]];
    [self.bjView addSubview:titleLabel1];
    [titleLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bjView.mas_left).offset(10);
        make.right.equalTo(self.bjView.mas_right).offset(-10);
        make.height.equalTo(30);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundColor:[UIColor redColor]];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.cornerRadius = 25;
    [self.bjView addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView.mas_bottom).offset(-250);
        make.left.equalTo(self.bjView.mas_left).offset(KProjectScreenWidth/4);
        make.right.equalTo(self.bjView.mas_right).offset(-KProjectScreenWidth/4);
        make.height.equalTo(50);
    }];
    
    UILabel *btnLabel = [[UILabel alloc]init];
    [btnLabel setText:@"分享领取折价券"];
    [btnLabel setTextColor:[UIColor whiteColor]];
    [btnLabel setTextAlignment:NSTextAlignmentCenter];
    [btnLabel setFont:[UIFont boldSystemFontOfSize:18]];
    if (KProjectScreenWidth>350) {
        [btnLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    [self.bjView addSubview:btnLabel];
    [btnLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(shareBtn.mas_centerX);
        make.centerY.equalTo(shareBtn.mas_centerY);
    }];
    
    UIButton *regularBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regularBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [regularBtn setTitle:@"抵价券规则" forState:UIControlStateNormal];
    [regularBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [regularBtn addTarget:self action:@selector(regularAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bjView addSubview:regularBtn];
    [regularBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.bjView.mas_centerX).offset(7);
    }];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"活动规则--问号_08.png"]];
    [self.bjView addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(regularBtn.mas_centerY);
        make.right.equalTo(regularBtn.mas_left).offset(-2);
        make.height.equalTo(13);
        make.width.equalTo(13);
    }];
    
}


//分享领取折价券
-(void)shareAction{
    if (self.model.shareurl) {
        WLPublishSuccessViewController *vc = [[WLPublishSuccessViewController alloc]init];
        vc.modelActivity = self.model;
        vc.tag = @"kill";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    
        ShowAutoHideMBProgressHUD(self.view,@"读取失败");
    }
   
}

//规则
-(void)regularAction{
    
    WLRegularViewController *vc = [[WLRegularViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = KDefaultOrBackgroundColor;
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth-20, (KProjectScreenWidth-20)*138/605)];
    if ([[dic objectForKey:@"state"] isEqualToString:@"1"]) {
        [imgV setImage:[UIImage imageNamed:@"优惠券_03"]];
    }else{
        [imgV setImage:[UIImage imageNamed:@"灰背景_07"]];
    }
    
    imgV.userInteractionEnabled = YES;
    [cell.contentView addSubview:imgV];
    
    //        NSString *text = [self.dataArr[indexPath.row] objectForKey:@"name"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (KProjectScreenWidth-20)*4/7, (KProjectScreenWidth-20)*138/605)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    //        titleLabel.text = [NSString stringWithFormat:@"%@",text];
    [titleLabel setText:[NSString stringWithFormat:@"￥%@.00抵价券",[dic objectForKey:@"amount"]]];
    titleLabel.font = [UIFont systemFontOfSize:21];
    if (KProjectScreenWidth<350) {
        titleLabel.font = [UIFont systemFontOfSize:18];
    }
    if ([[dic objectForKey:@"state"] isEqualToString:@"1"]) {
        titleLabel.textColor = [UIColor redColor];
    }else{
        titleLabel.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1];
    }
    
    NSString *vStr = titleLabel.text;
    NSString *Str=[vStr substringFromIndex:1];
    NSString *vDStr = [Str substringToIndex:1];
    NSRange range=[vStr rangeOfString:vDStr];
    NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:vStr];
    [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:range];
    if (KProjectScreenWidth<350) {
        [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:range];
    }
    titleLabel.attributedText=mstr;
    
    [cell.contentView addSubview:titleLabel];
    
    
    //    时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-20)*4/7+15, 10, KProjectScreenWidth*4/7, 15)];
    //        timeLabel.text = [self.dataArr[indexPath.row] objectForKey:@"commentime"];
    [timeLabel setText:@"仅限优商城限时秒杀、"];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    if (self.view.frame.size.width>320) {
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
    }else{
        
        timeLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    timeLabel.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1];
    [imgV addSubview:timeLabel];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-20)*4/7+15, 30, KProjectScreenWidth*4/7, 15)];
    if (KProjectScreenWidth<330) {
        [nameLabel setFrame:CGRectMake((KProjectScreenWidth-20)*4/7+15, 27, KProjectScreenWidth*4/7, 15)];
    }
    nameLabel.numberOfLines = 0;
    //        nameLabel.text = [self.dataArr[indexPath.row] objectForKey:@"party_theme"];
    [nameLabel setText:@"竞拍活动使用"];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    if (self.view.frame.size.width<380) {
        if (self.view.frame.size.width>320) {
            nameLabel.font = [UIFont systemFontOfSize:14.0f];
        }else{
            
            nameLabel.font = [UIFont systemFontOfSize:11.0f];
        }
        
    }
    nameLabel.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1];
    [imgV addSubview:nameLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[dic objectForKey:@"state"] isEqualToString:@"1"]){
        [button setBackgroundImage:[UIImage imageNamed:@"立即使用_03"] forState:UIControlStateNormal];
    }else if ([[dic objectForKey:@"state"] isEqualToString:@"0"]){
        //未开始
        [button setBackgroundImage:[UIImage imageNamed:@"已过期_03"] forState:UIControlStateNormal];
    }else if ([[dic objectForKey:@"state"] isEqualToString:@"2"]){
        [button setBackgroundImage:[UIImage imageNamed:@"已使用_03"] forState:UIControlStateNormal];
        
    }else if ([[dic objectForKey:@"state"] isEqualToString:@"3"]){
        [button setBackgroundImage:[UIImage imageNamed:@"已过期_03"] forState:UIControlStateNormal];
        
    }else if ([[dic objectForKey:@"state"] isEqualToString:@"4"]){
        //已作废
        [button setBackgroundImage:[UIImage imageNamed:@"已过期_03"] forState:UIControlStateNormal];
    }
    
    [imgV addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        if (KProjectScreenWidth>400) {
          make.bottom.equalTo(imgV.mas_bottom).offset(-12);
        }else if (KProjectScreenWidth>330){
          make.bottom.equalTo(imgV.mas_bottom).offset(-9);
        }else{
          make.bottom.equalTo(imgV.mas_bottom).offset(-7);
        }
        make.height.equalTo((80*9/34)*KProjectScreenWidth/414);
        make.width.equalTo(80*KProjectScreenWidth/414);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KProjectScreenWidth*138/605+12;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tag isEqualToString:@"grzx"]) {
        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }else{
        
        NSDictionary *dic = self.dataArr[indexPath.row];
        
        if ([[dic objectForKey:@"state"] isEqualToString:@"1"]){
        
            FMSelectShopInfoModel *modelShopInfo = [[FMSelectShopInfoModel alloc] init];
            modelShopInfo.ticket_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_id"]];
            modelShopInfo.amount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"amount"]];
            //        这里调用block 给需要用到的视图控制器传值
            if (self.blockSupportTicket) {
                self.blockSupportTicket(modelShopInfo);
            }
            
            if ([self.flag isEqualToString:@"kill"] || [self.flag isEqualToString:@"auction"] || [self.flag isEqualToString:@"won"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                FMRTWellStoreViewController *vc = [[FMRTWellStoreViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
      
    }
}


@end
