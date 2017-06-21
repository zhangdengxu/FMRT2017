//
//  WLAideViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLAideViewController.h"
#import "WLFollowingViewController.h"
#import "WLInfoViewController.h"
//#import "WLInfoShowView.h" ====XZ
#import "WLRequestViewController.h"
#import "FMRTWellStoreViewController.h"
#import "HTTPClient+Interaction.h"
#import "FMMessageAlterView.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 156

@interface WLAideViewController ()<UITableViewDelegate,UITableViewDataSource,FMMessageAlterViewDelegate>

@property (nonatomic, weak)NSArray *titleArr;
@property (nonatomic,strong)NSArray *detailberArr;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)UIImageView  * backGroundImage;
@end

@implementation WLAideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"物流助手"];
    [self getDataFromNetWork];
    [self createTabelView];
    [self setNavItemWithButton];
}

-(NSArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [_backGroundImage setImage:[UIImage imageNamed:@"暂无数据"]];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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


-(void)getDataFromNetWork{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-msg_list_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@&cateid=3",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];

    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                NSArray *data = [response.responseObject objectForKey:@"data"];
                if ([data isMemberOfClass:[NSNull class]]) {
                    [self contueNullDataSource];
                }else if (data.count == 0){
                    [self contueNullDataSource];
                }else{
                    [self.backGroundImage removeFromSuperview];
                    self.tableView.hidden = NO;
                    self.dataArr = data;
                    [self.tableView reloadData];
                }
                
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
        });
    }];

}


#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = [self.dataArr[indexPath.row] objectForKey:@"time"];;
    timeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
    [cell.contentView addSubview:timeLabel];
    
//    白色底部
    UIView *whightView = [[UIView alloc]initWithFrame:CGRectMake(15, 30, KProjectScreenWidth-30, 126)];
    [whightView setBackgroundColor:[UIColor whiteColor]];
    [whightView.layer setCornerRadius:3.0f];
    [whightView.layer setMasksToBounds:YES];
    [whightView setAlpha:1.0f ];
    [whightView setUserInteractionEnabled:YES];
    [cell.contentView addSubview:whightView];
    
    NSString *text = [self.dataArr[indexPath.row] objectForKey:@"title"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, whightView.frame.size.width-20, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@",text];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [whightView addSubview:titleLabel];

    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 54, 54)];
    [imageV sd_setImageWithURL:[self.dataArr[indexPath.row] objectForKey:@"img"]];
    [whightView addSubview:imageV];
    
    NSString *text2 = [self.dataArr[indexPath.row] objectForKey:@"info"];
    CGSize size = CGSizeMake(whightView.frame.size.width-89,54);
    CGSize labelsize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailLabel.text = [NSString stringWithFormat:@"%@",text2];
    detailLabel.font = [UIFont systemFontOfSize:12.0f];
    [detailLabel setNumberOfLines:0];
    detailLabel.frame=CGRectMake(79, 30, whightView.frame.size.width-89, labelsize.height);
    detailLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    [detailLabel setNumberOfLines:0];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [whightView addSubview:detailLabel];

    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 90, whightView.frame.size.width-20, 1)];
    lineView1.backgroundColor = KDefaultOrBackgroundColor;
    [whightView addSubview:lineView1];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 91, KProjectScreenWidth-20-30-5, 35)];
    bottomLabel.text = @"查看详情";
    bottomLabel.font = [UIFont systemFontOfSize:14.0f];
    bottomLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [whightView addSubview:bottomLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-20-30, 102, 7, 12)];
    [imageV1 setImage:[UIImage imageNamed:@"箭头_103"]];
    [whightView addSubview:imageV1];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KCellHeghtFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WLFollowingViewController *followingVC = [[WLFollowingViewController alloc]init];
    followingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:followingVC animated:YES];
    followingVC.com = [self.dataArr[indexPath.row] objectForKey:@"com"];
    followingVC.nu = [self.dataArr[indexPath.row] objectForKey:@"nu"];

    
    
}


@end
