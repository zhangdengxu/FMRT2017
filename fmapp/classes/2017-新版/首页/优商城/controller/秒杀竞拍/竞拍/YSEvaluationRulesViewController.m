//
//  YSEvaluationRulesViewController.m
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSEvaluationRulesViewController.h"

@interface YSEvaluationRulesViewController ()

@end

@implementation YSEvaluationRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"评价规则"];
    [self setHeaderView];
    [self setBottomView];
    [self setUpContent];
}

- (void)setUpContent{

    NSString *textcontent = @"在评论区留言，如果您对此活动感兴趣，可以发表你的参与体验、购物感想。留言成功随机可获1-5元抵价券1张，重复留言不累加。评论不少于20字，不超过140字，请勿发布与活动无关、违法、反动等内容。经我们客服人员审核通过后，予以发送抵价券。";
   
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, KProjectScreenWidth - 20, 300)];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = textcontent;
    /**
     *  设置自动行高
     */
    CGFloat textW = KProjectScreenWidth - 30;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat textH = [textcontent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    
    label.frame = CGRectMake(15, 131, textW, textH);
    
    [self.view addSubview:label];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
