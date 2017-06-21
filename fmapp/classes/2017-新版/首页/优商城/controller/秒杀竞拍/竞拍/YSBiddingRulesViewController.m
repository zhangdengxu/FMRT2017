//
//  YSBiddingRulesViewController.m
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//  竞拍规则

#import "YSBiddingRulesViewController.h"
#import "YSBiddingRulesModel.h"
#import "YSBiddingRulesViewCell.h"
#import "XZActivityModel.h"
#import "WLPublishSuccessViewController.h"


@interface YSBiddingRulesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) XZActivityModel *modelActivity;
@end

@implementation YSBiddingRulesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"活动规则"];
    [self setHeaderView];
    [self setBottomView];
    [self setUpTableView];
//    [self setRightShareButton];
    
}

#pragma mark --  创建右侧分享按钮
- (XZActivityModel *)modelActivity{
    
    if (!_modelActivity) {
        XZActivityModel *modelActivity = [[XZActivityModel alloc]init];
        _modelActivity = modelActivity;
    }
    return _modelActivity;
}
- (void)setRightShareButton{
    
    [self getShareDataSourceFromNetWork];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"分享按钮_07"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickShareBtn:)];
    
    
    
}
- (void)didClickShareBtn:(UIBarButtonItem *)item {
    WLPublishSuccessViewController *share = [[WLPublishSuccessViewController alloc]init];
    share.modelActivity = self.modelActivity;
    [self.navigationController pushViewController:share animated:YES];
}

- (void)getShareDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    
    
    //NSString *urlStr = @"https://www.rongtuojinrong.com/java/public/other/getShareInfo";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"flag":@"auction"
                                 };
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
                if (![dict isMemberOfClass:[NSNull class]]) {
                    
                    if (dict.count) {
                        XZActivityModel *model = [[XZActivityModel alloc]init];
                        model.sharepic = dict[@"img"];
                        model.sharecontent = dict[@"content"];
                        model.sharetitle = dict[@"title"];
                        model.shareurl = dict[@"link"];
                        self.modelActivity = model;
                    }
                }
            }
        }
    }];
    
}

#pragma mark --  创建UITableView
- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 118, KProjectScreenWidth, KProjectScreenHeight - 180 - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *labele = [[UILabel alloc]init];
    labele.text = [NSString stringWithFormat:@"%@", [[self.listArray objectAtIndex:section] objectForKey:@"title"]];
    labele.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:labele];
    [labele makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(10);
    }];
    /**
     *  右部箭头
     */
    UIImageView *imaV = [[UIImageView alloc]init];
    if ([[[self.listArray objectAtIndex:section] objectForKey:@"mark"] isEqualToString:@"NO"]) {
        
        [imaV setImage:[UIImage imageNamed:@"向右按钮_09"]];
    }else{
        
        [imaV setImage:[UIImage imageNamed:@"向下按钮_05"]];
    }
    
    [view addSubview:imaV];
    [imaV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    view.tag = section;
    if (view.gestureRecognizers == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClickedAction:)];
        [view addGestureRecognizer:tap];
    }
    
    return view;
}

- (void) headerViewClickedAction:(UITapGestureRecognizer *)sender
{
    if ([[[self.listArray objectAtIndex:sender.view.tag] objectForKey:@"mark"] isEqualToString:@"NO"]) {
        for (int i = 0; i < self.listArray.count; i++) {
            [[self.listArray objectAtIndex:i] setObject:@"NO" forKey:@"mark"];
        };
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"YES" forKey:@"mark"];
    } else {
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"NO" forKey:@"mark"];
    }
    
    [self.tableView reloadData];
//    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.view.tag];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[[self.listArray objectAtIndex:section] objectForKey:@"mark"] isEqualToString:@"NO"]) {
        return 0;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID1 = @"YSBiddingRulesViewCell";
    YSBiddingRulesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YSBiddingRulesViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataSource = self.dataSource[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSBiddingRulesModel *status = self.dataSource[indexPath.section];
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 20;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat textH = [status.content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    return textH + 21;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}

#pragma mark --  头视图

-(void)setHeaderView{
    
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 118)];
    [headerView setImage:[UIImage imageNamed:@"活动规则banner_02"]];
    [self.view addSubview:headerView];
    
}

#pragma mark --  底部图

- (void)setBottomView{
    
    UIImageView *headerView = [[UIImageView alloc]init];
    headerView.backgroundColor = [UIColor redColor];
    [headerView setImage:[UIImage imageNamed:@"底部解释权图"]];
    [self.view addSubview:headerView];
    
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(62);
    }];
}

#pragma mark --  数据

- (NSMutableArray *)listArray{
    
    if(!_listArray){
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
        
        [dict1 setObject:@"怎样参加竞拍?" forKey:@"title"];
        [dict1 setObject:@"在融托金融APP上进行注册登录，就可以参加竞拍了。每日16:00开始，18:00结束，最少5款产品参加0元起拍，价高者得。在结束时间，最后一位竞拍用户，可凭竞拍价格获得该商品，每商品竞拍上限为商品原价7折，在规定时间内，如达到竞拍上限，竞拍结束，归价高者得。须填写购货订单完成，视为有效。竞拍完成后，未成功抢购用户，所花费购货款7-14工作日自动原路返回账户。所有商品，每天上午十点更新。" forKey:@"content"];
        [dict1 setObject:@"NO" forKey:@"mark"];
        
        [dict2 setObject:@"抵价券如何获得和使用?" forKey:@"title"];
        [dict2 setObject:@"获得方式——\nA.注册用户登录APP，打开红包即可随机抽取1—5元抵价券1张；\nB.转发活动页面至朋友圈，随机获得1-5元抵价券1张，每日限领一次；\nC.推荐并邀请好友注册成功，并开通汇付，随机可获5-10元抵价券，注册成功后即可获得，每日可无限领取；\nD.在评论区留言，如果您对此活动感兴趣，可以发表你的参与体验、购物感想。留言成功随机可获1-5元抵价券1张。评论不少于20字，不超过140字，请勿发布与活动无关、违反、反动等内容。经我们客服人员审核通过后，予以发送抵价券。\n使用方式——\nA.抵价券仅限本次活动使用。抵价券在促销活动规定的有效期内使用，有效期过后不得使用。 有效期1周。限时秒杀、竞拍活动可通用；\nB. 抵价券不可兑现，无法转借。每商品只限使用一张；\nC.抵价券以电子券形式存放于用户个人中心。抵价券有相应面额显示，面额设置常规为1-10元不等；\nD.竞拍、秒杀活动抵价券账户为同一账户，每券通用，但仅限使用一次。当前活动使用该券后，此券作废，其他活动不得使用；\nE.10元及10元以下商品，不得使用抵价券。" forKey:@"content"];
        [dict2 setObject:@"NO" forKey:@"mark"];
        
        [dict3 setObject:@"怎样查看是否成为幸运用户?如何领取幸运商品?" forKey:@"title"];
        [dict3 setObject:@"点击进入“个人中心”，在竞拍记录里即可查看竞拍成功过的产品，点击对应成功订单即可查看物流信息。\n竞拍商品如正常订单一样，成功竞拍到商品，后台会在24小时内进行发货。" forKey:@"content"];
        [dict3 setObject:@"NO" forKey:@"mark"];
        
        [dict4 setObject:@"商品是正品吗?如何保证?" forKey:@"title"];
        [dict4 setObject:@"所有商品均从正规渠道采购，100%正品，可享受厂家所提供的全国联保服务。" forKey:@"content"];
        [dict4 setObject:@"NO" forKey:@"mark"];
        
        [dict5 setObject:@"收到的商品可以退换货吗?" forKey:@"title"];
        [dict5 setObject:@"本次活动为折扣商品，拍前请您看好款式、尺码、颜色等，一经付款，不给予退换货。" forKey:@"content"];
        [dict5 setObject:@"NO" forKey:@"mark"];
        
        
        NSMutableArray *listArray = [[NSMutableArray alloc]init];
        [listArray addObject:dict1];
        [listArray addObject:dict2];
        [listArray addObject:dict3];
        [listArray addObject:dict4];
        [listArray addObject:dict5];
        
        _listArray = listArray;
    }
    return _listArray;
}
- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        for(NSDictionary *dict in self.listArray){
            NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            //封装数据模型
            YSBiddingRulesModel *model = [[YSBiddingRulesModel alloc]initWithDict:infoDict];
            
            //将数据模型放入数组中
            [self.dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
