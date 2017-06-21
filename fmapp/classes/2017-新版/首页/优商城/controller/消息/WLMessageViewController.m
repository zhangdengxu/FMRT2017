//
//  WLMessageViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLMessageViewController.h"
#import "WLAideViewController.h"
#import "WLInfoViewController.h"
#import "WLChatViewController.h"
#import "ShareViewController.h"
#import "HTTPClient+Interaction.h"

#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 72

@interface WLMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, weak)NSArray *titleArr;
@property (nonatomic,strong)NSArray *dressArr;
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)NSDictionary *dataArray;

@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation WLMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"消息"];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self getDataFromeNetwork];
    [self createTabelView];
}

- (NSDictionary *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSDictionary alloc]init];
    }
    return _dataArray;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSArray arrayWithObjects:@"优商城_信息通告_36",@"优商城_客服聊天_36",@"优商城_物流助手_36", nil];
    }
    return _imageArr;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"信息通告",@"客服聊天",@"物流助手", nil];
    }
    return _titleArr;
}


-(NSArray *)dressArr{
    
    if (!_dressArr) {
        _dressArr = [NSArray arrayWithObjects:@"notice",@"chat",@"wuliu", nil];
    }
    return _dressArr;
}

-(void)getDataFromeNetwork{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-msg_list_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSString *encoded = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:encoded parameters:nil completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                self.dataArray = dic;
                
                [self.tableView reloadData];
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求失败");
                
            }
        });
    }];


}

-(void)createTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, KProjectScreenWidth, KProjectScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    /**
     *标题图片
     */
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 44, 44)];
    if (indexPath.row == 0) {
        [imageV setFrame:CGRectMake(25, 12, 33, 33*64/57)];
    }else if (indexPath.row == 1){
        [imageV setFrame:CGRectMake(25, 14, 38, 34)];
    }else{
        [imageV setFrame:CGRectMake(25, 23, 40, 40*52/75)];
    }
    [imageV setImage:[UIImage imageNamed:self.imageArr[indexPath.row]]];
    [cell.contentView addSubview:imageV];
    /**
     *标题title
     */
    NSString *text = self.titleArr[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(79, 11, KProjectScreenWidth/3, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@",text];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    [cell.contentView addSubview:titleLabel];
    /**
     *时间
     */
    NSString *text1 = [[self.dataArray objectForKey:self.dressArr[indexPath.row]] objectForKey:@"time"];
    UILabel *pjoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-15, 11, KProjectScreenWidth/2, 20)];
    pjoneNumberLabel.textAlignment = NSTextAlignmentRight;
    pjoneNumberLabel.text = [NSString stringWithFormat:@"%@",text1];
    pjoneNumberLabel.font = [UIFont systemFontOfSize:13];
    pjoneNumberLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    [cell.contentView addSubview:pjoneNumberLabel];
    /**
     *内容label
     */
    NSString *text2 = [[self.dataArray objectForKey:self.dressArr[indexPath.row]] objectForKey:@"info"];
    UILabel *dressLabel = [[UILabel alloc]initWithFrame:CGRectMake(79, 32, KProjectScreenWidth-79-15, 20)];
    dressLabel.text = [NSString stringWithFormat:@"%@",text2];
    dressLabel.font = [UIFont systemFontOfSize:13.0f];
    dressLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    [cell.contentView addSubview:dressLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat-6, KProjectScreenWidth, 6)];
    lineView1.backgroundColor = KDefaultOrBackgroundColor;
    [cell.contentView addSubview:lineView1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KCellHeghtFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
            
        case 0:
        {

            WLInfoViewController *infoVC = [[WLInfoViewController alloc]init];
            infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];

            break;
        }
        case 1:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                
                NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:request];
                
                
                
                //WLChatViewController *chatVC = [[WLChatViewController alloc]init];
                //chatVC.hidesBottomBarWhenPushed = YES;
                //[self.navigationController pushViewController:chatVC animated:YES];
            }else{
            
                UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"打开客服提醒" message:@"您尚未安装QQ，请安装QQ后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }

            break;
        }
        case 2:
        {
            WLAideViewController *aideVC = [[WLAideViewController alloc]init];
            aideVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aideVC animated:YES];
            break;
        }
        default:
            break;
    }
    
}
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        _webView.delegate = self;

        [self.view addSubview:_webView];
        _webView.hidden = YES;
    }
    return _webView;
}

@end
