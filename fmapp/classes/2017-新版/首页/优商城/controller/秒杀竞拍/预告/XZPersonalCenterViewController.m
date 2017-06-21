//
//  XZPersonalCenterViewController.m
//  XZProject
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 admin. All rights reserved.
//  个人中心

#import "XZPersonalCenterViewController.h"
#import "XZPersonalCenterCell.h" // cell
#import "FMRTAuctionRecordViewController.h" // 竞拍参与记录
#import "WLDJQTABViewController.h" // 抵价券
#import "FMTimeKillNoteController.h"
#import "YSSpikeParticipationRecordViewController.h"


@interface XZPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  */
@property (nonatomic, strong) UITableView *tablePersonCenter;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation XZPersonalCenterViewController
- (UITableView *)tablePersonCenter {
    if (!_tablePersonCenter) {
        _tablePersonCenter = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tablePersonCenter.delegate = self;
        _tablePersonCenter.dataSource  = self;
//        _tablePersonCenter.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tablePersonCenter.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tablePersonCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"个人中心"];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tablePersonCenter];
    self.imgArray = @[@"commtouxiang110",@"参与记录icon_03",@"抵价券icon_06",@"联系客服icon_09"].mutableCopy;
    self.titleArray = @[@"",@"参与记录",@"抵价券",@"联系客服：400-878-8686"].mutableCopy;
}

#pragma mark ---- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCenter"];
    if (!cell) {
        cell = [[XZPersonalCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personCenter"];
    }
    if (indexPath.row == 0) {
        cell.imgPhoto.backgroundColor = [UIColor darkGrayColor];
        cell.imgPhoto.contentMode = UIViewContentModeScaleToFill;
        [cell.imgPhoto sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://%@",[CurrentUserInformation sharedCurrentUserInfo].touxiangsde]] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
         cell.labelTitle.text = [NSString stringWithFormat:@"%@",[CurrentUserInformation sharedCurrentUserInfo].mobile];
    }else {
        cell.imgPhoto.contentMode = UIViewContentModeCenter;
        cell.imgPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArray[indexPath.row]]];
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.row]];
    }
    
    if (indexPath.row > 0 && indexPath.row < 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([self.flag isEqualToString:@"kill"]) { // 秒杀
            YSSpikeParticipationRecordViewController * spike = [[YSSpikeParticipationRecordViewController alloc]init];
            spike.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:spike animated:YES];
            

        }else { // 竞拍
 
            FMRTAuctionRecordViewController *auction = [[FMRTAuctionRecordViewController alloc] init];
            [self.navigationController pushViewController:auction animated:YES];
            
        }
    }else if (indexPath.row == 2) {
        WLDJQTABViewController *tab = [[WLDJQTABViewController alloc] init];
        tab.flag = self.flag;
        tab.tag = @"grzx";
        tab.state = @"";
        [self.navigationController pushViewController:tab animated:YES];
    }else if (indexPath.row == 3)  {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-878-8686"]];
    }
}

@end
