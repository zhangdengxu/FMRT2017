//
//  WLFollowingViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLFollowingViewController.h"
#import "HTTPClient+Interaction.h"
#import "FMMessageAlterView.h"
#import "FMRTWellStoreViewController.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 96
@interface WLFollowingViewController ()<UITableViewDelegate,UITableViewDataSource,FMMessageAlterViewDelegate>

@property (nonatomic, weak)NSArray *phoneArr;
@property (nonatomic,strong)NSArray *dressArr;
@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) UIImageView  * backGroundImage;
@end

@implementation WLFollowingViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"物流助手"];
    if ([self.isFromDuobao isEqualToString:@"yes"]) {
        [self settingNavTitle:@"物流信息"];
    }
    if (self.isFromDuobao.length>3) {
        [self settingNavTitle:[NSString stringWithFormat:@"%@",self.isFromDuobao]];
    }
    [self getDataFromNetWork];
    [self createTabelView];
    NSString *tag = [NSString stringWithFormat:@"%@",self.tag];
    if (![tag isEqualToString:@"1"]) {
       [self setNavItemWithButton];
    }
     
}

-(void)getDataFromNetWork{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-msg_detail_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
     NSDictionary *parameter = @{@"com":self.com,@"nu":self.nu};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess){
            
            NSDictionary *dic = response.responseObject[@"data"];
            if ([dic isMemberOfClass:[NSNull class]]) {
                
                [self contueNullDataSource];
                
            }else{

                if (dic[@"data"]) {
                    self.dataSource = [dic objectForKey:@"data"];
                    if ([self.dataSource isMemberOfClass:[NSNull class]]){
                        [self contueNullDataSource];
                        
                    }else
                    {
                        if ([self.dataSource count] == 0) {
                            [self contueNullDataSource];
                        }else{
                            [self.tableView reloadData];
                        }
                    }
                }
            }
        }else{
            
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求失败");

        }
    }];
}

-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]init];
        NSString *strIf = [NSString stringWithFormat:@"%@",self.isFromDuobao];
        NSString *imageName = [strIf isEqualToString:@"yes"]?@"摩托物流车_03":@"暂无数据";
        _backGroundImage.image=[UIImage imageNamed:imageName];
        [_backGroundImage setFrame:[strIf isEqualToString:@"yes"]?CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*801/513):CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [self.view addSubview:_backGroundImage];
    }
    return _backGroundImage;
}

-(void)contueNullDataSource
{
    self.tableView.hidden = YES;
    self.backGroundImage.hidden = NO;
    
}

-(void)createTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, KProjectScreenHeight - 74) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)createHeaderView{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 135)];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 43, 42.5)];
    [imageV setImage:[UIImage imageNamed:@"x5.png"]];
    [headerView addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 14, KProjectScreenWidth-69, 20)];
    nameLabel.text = @"派送员：某某";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [headerView addSubview:nameLabel];
    
    UILabel *deliverLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 37, KProjectScreenWidth-69, 20)];
    deliverLabel.text = @"顺丰快递：580270912745";
    deliverLabel.font = [UIFont systemFontOfSize:12];
    deliverLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [headerView addSubview:deliverLabel];
    
    UILabel *phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 54, KProjectScreenWidth/3, 20)];
    phoneNumberLabel.text = @"手机：18854111301";
    phoneNumberLabel.font = [UIFont systemFontOfSize:12];
    phoneNumberLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [headerView addSubview:phoneNumberLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, KProjectScreenWidth, 5)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [headerView addSubview:lineView];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, KProjectScreenWidth-15, 32)];
    bottomLabel.text = @"物流跟踪";
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.font = [UIFont boldSystemFontOfSize:16];
    bottomLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    [headerView addSubview:bottomLabel];

    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 122, KProjectScreenWidth-30, 1)];
    [lineView1 setBackgroundColor:KDefaultOrBackgroundColor];
    [headerView addSubview:lineView1];
    
    self.tableView.tableHeaderView = headerView;
    
}
- (void)setNavItemWithButton {
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightMAction:) forControlEvents: UIControlEventTouchUpInside];
    
    messageButton.frame =CGRectMake(KProjectScreenWidth - 50, 10, 30, 30);
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:navItem,nil] animated:YES];
}

- (void)rightMAction:(UIButton *)sender {
    
    FMMessageModel *two = [[FMMessageModel alloc] initWithTitle:@"首页" imageName:@"优商城消息-消息03"  isShowRed:NO];
    NSArray * dataArr = @[two];
    
    __block  FMMessageAlterView * messageAlter = [[FMMessageAlterView alloc] initWithDataArray:dataArr origin:CGPointMake(KProjectScreenWidth - 15, 64) width:100 height:44 direction:kFMMessageAlterViewDirectionRight];
    messageAlter.delegate = self;
    messageAlter.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        messageAlter = nil;
    };
    [messageAlter pop];
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


//- (void)setNavItemsWithButton {
//    
//    UIButton *messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22.5*3/2, 25*3/2)];
//    [messageButton setBackgroundImage:[UIImage imageNamed:@"7７.png"] forState:UIControlStateNormal];
//    [messageButton setBackgroundImage:[UIImage imageNamed:@"6６６.png"] forState:UIControlStateSelected];
//    [messageButton addTarget:self action:@selector(rightAction:) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
//    [self.navigationItem setRightBarButtonItem:navItem animated:YES];
//}
//
//- (void)rightAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    
//}

#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *text2 = [self.dataSource[indexPath.row] objectForKey:@"context"];
    CGSize size = CGSizeMake(KProjectScreenWidth-48-25,54);
    CGSize labelsize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailLabel.text = [NSString stringWithFormat:@"%@",text2];
    detailLabel.font = [UIFont systemFontOfSize:13.0f];
    [detailLabel setNumberOfLines:0];
    detailLabel.frame=CGRectMake(48, 2, KProjectScreenWidth-48-25, labelsize.height);
    if (indexPath.row == 0) {
        detailLabel.textColor = [UIColor colorWithRed:0 green:153/255.0 blue:102/255.0 alpha:1];

    }else{
    
        detailLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    }
    [detailLabel setNumberOfLines:0];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:detailLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, labelsize.height+2+5, KProjectScreenWidth-48, 20)];
    
    NSString *UU = [NSString stringWithFormat:@"%lld", [[self.dataSource[indexPath.row] objectForKey:@"time"] longLongValue]];
    NSTimeInterval time=[UU doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];

    timeLabel.text = currentDateStr;
    
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    if (indexPath.row == 0) {
        timeLabel.textColor = [UIColor colorWithRed:0 green:153/255.0 blue:102/255.0 alpha:1];

    }else{
        timeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    }
    [cell.contentView addSubview:timeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(48, labelsize.height+2+35, KProjectScreenWidth-48-15,1)];
    lineView.backgroundColor = KDefaultOrBackgroundColor;
    [cell.contentView addSubview:lineView];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(26.5, 0, 1, labelsize.height+2+5+20+30)];
    [lineImageView setImage:[UIImage imageNamed:@"x8.png"]];
    [cell.contentView addSubview:lineImageView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 44, 44)];
    if (indexPath.row == 0) {
        [imageV setFrame:CGRectMake(20, 0, 13, 13)];
        [imageV setImage:[UIImage imageNamed:@"x6.png"]];
        
    }else{
        [imageV setFrame:CGRectMake(22, 0, 9, 9)];
        [imageV setImage:[UIImage imageNamed:@"x7.png"]];
        
    }
    [cell.contentView addSubview:imageV];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text2 = [self.dataSource[indexPath.row] objectForKey:@"context"];
    CGSize size = CGSizeMake(KProjectScreenWidth-48-25,54);
    CGSize labelsize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailLabel.text = [NSString stringWithFormat:@"%@",text2];
    detailLabel.font = [UIFont systemFontOfSize:13.0f];
    [detailLabel setNumberOfLines:0];
    detailLabel.frame=CGRectMake(48, 2, KProjectScreenWidth-48-25, labelsize.height);
    [detailLabel setNumberOfLines:0];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;

    return labelsize.height+2+50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
            
            
        case 0:
        {
            break;
        }
        case 1:
        {
            
            break;
        }
        case 2:
        {
           
            break;
        }
        default:
            break;
    }
    
}




@end
