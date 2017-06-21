//
//  WLRegularViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLRegularViewController.h"

@interface WLRegularViewController ()

@end

@implementation WLRegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"抵价券规则"];
    [self createHeader];

}

-(void)createHeader{

    [self.view setBackgroundColor:[UIColor colorWithRed:227/255.0f green:234/255.0f blue:242/255.0f alpha:1]];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    if (KProjectScreenWidth>375) {
        mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,950);

    }else if (KProjectScreenWidth<330){
        mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,900);

    }else{
        mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,960);

    }
    [self.view addSubview:mainScrollView];

    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*5/16)];
    [imgV setImage:[UIImage imageNamed:@"活动规则banner_02.png"]];
    [mainScrollView addSubview:imgV];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"抵价券如何获得和使用？"];
    [titleLabel setTextColor:[UIColor colorWithRed:245/255.0f green:15/255.0f blue:29/255.0f alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [mainScrollView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(30);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    [titleLabel1 setText:@"获得方式——"];
    [titleLabel1 setTextColor:[UIColor colorWithRed:245/255.0f green:15/255.0f blue:29/255.0f alpha:1]];
    [titleLabel1 setFont:[UIFont systemFontOfSize:18]];
    [mainScrollView addSubview:titleLabel1];
    [titleLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(30);
    }];

    UILabel *contentLabel1 = [[UILabel alloc]init];
    contentLabel1.numberOfLines = 0;
    [contentLabel1 setText:@"A.注册用户登录APP，打开红包即可随机抽取1—5元抵价券1张；\nB.转发活动页面至朋友圈，随机获得1-5元抵价券1张，每日限领一次；\nC.推荐并邀请好友注册成功，并开通汇付，随机可获5-10元抵价券，注册成功后即可获得，每日可无限领取；\nD.在评论区留言，如果您对此活动感兴趣，可以发表你的参与体验、购物感想。留言成功随机可获1-5元抵价券1张。评论不少于20字，不超过140字，请勿发布与活动无关、违反、反动等内容。经我们客服人员审核通过后，予以发送抵价券。"];
    [contentLabel1 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
    [contentLabel1 setFont:[UIFont systemFontOfSize:18]];
    if (KProjectScreenWidth<350) {
     [contentLabel1 setFont:[UIFont systemFontOfSize:16]];
    }
    [mainScrollView addSubview:contentLabel1];
    [contentLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        
    }];
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    [titleLabel2 setText:@"使用方式——"];
    [titleLabel2 setTextColor:[UIColor colorWithRed:245/255.0f green:15/255.0f blue:29/255.0f alpha:1]];
    [titleLabel2 setFont:[UIFont systemFontOfSize:18]];
    [mainScrollView addSubview:titleLabel2];
    [titleLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel1.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(30);
    }];

    UILabel *contentLabel2 = [[UILabel alloc]init];
    contentLabel2.numberOfLines = 0;
    [contentLabel2 setText:@"A.抵价券仅限本次活动使用。抵价券在促销活动规定的有效期内使用，有效期过后不得使用。 有效期1周。限时秒杀、竞拍活动可通用；\nB. 抵价券不可兑现，无法转借。每商品只限使用一张；\nC. .抵价券以电子券形式存放于用户个人中心。抵价券有相应面额显示，面额设置常规为1-10元不等。\nD.竞拍、秒杀活动抵价券账户为同一账户，每券通用，但仅限使用一次。当前活动使用该券后，此券作废，其它活动不得使用。\nE.10元及10元以下商品，不得使用抵价券。"];
    [contentLabel2 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
    [contentLabel2 setFont:[UIFont systemFontOfSize:18]];
    if (KProjectScreenWidth<350) {
        [contentLabel2 setFont:[UIFont systemFontOfSize:16]];
    }
    [mainScrollView addSubview:contentLabel2];
    [contentLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel2.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        
    }];

    UIImageView *bottomImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-43-KProjectScreenWidth*105/640, KProjectScreenWidth, KProjectScreenWidth*105/640)];
    [bottomImgV setImage:[UIImage imageNamed:@"竞拍秒杀底部视图"]];
    [self.view addSubview:bottomImgV];
    
}



@end
