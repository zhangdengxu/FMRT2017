//
//  FMGatherViewController.m
//  fmapp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMGatherViewController.h"
#import "WJSegmentMenuVc.h"
#import "FMGatherDetailViewController.h"
#import "FMGatherModel.h"
#import "MJExtension.h"
#import "WLMessageViewController.h"

@interface FMGatherViewController ()<WJSegmentMenuVcDelegate>

@property (nonatomic, strong) WJSegmentMenuVc *segmentMenuVc;
@property (nonatomic, strong) FMGatherDetailViewController *currentShopCtr;
@property (nonatomic, strong) NSMutableArray  *titleDataSource;

@end

@implementation FMGatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"凑单"];
//    [self setUpTitlLabel];
    [self createShopCollectionView];
    [self requestDataToCollectionView];
    [self setNavItemsWithButton];

}

- (void)setNavItemsWithButton {
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"优商城_已读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightAction) forControlEvents: UIControlEventTouchUpInside];
    
    messageButton.frame =CGRectMake(KProjectScreenWidth - 50, 10, 30, 30);
    
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:navItem,nil] animated:YES];
}

- (void)rightAction{
    WLMessageViewController *messageVC = [[WLMessageViewController alloc]init];
    
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)setUpTitlLabel {
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KProjectScreenWidth, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = kColorTextColorClay;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *price = @"50";
    NSString *allPrice = @"200";
    NSString *titleAll = [NSString stringWithFormat:@"再买%@元，可享受“满%@元享包邮“优惠",price,allPrice];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
    NSRange range = [titleAll rangeOfString:price];
    NSRange range1 = [titleAll rangeOfString:allPrice];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KMoneyColor range:range1];

    titleLabel.attributedText = attrStr;

    [self.view addSubview:titleLabel];
    
    
}

-(void)createShopCollectionView{

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 10)];
    titleView.backgroundColor = KDefaultOrBackgroundColor;
    [self.view addSubview:titleView];

    WJSegmentMenuVc *segmentMenuVc = [[WJSegmentMenuVc alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 35)];
    self.segmentMenuVc = segmentMenuVc;
    [self.view addSubview:segmentMenuVc];

    segmentMenuVc.backgroundColor = [UIColor whiteColor];
    segmentMenuVc.titleFont = [UIFont systemFontOfSize:16.0];
    segmentMenuVc.selectTitleFont = [UIFont systemFontOfSize:17.0];
    segmentMenuVc.unlSelectedColor = [UIColor colorWithWhite:0.2 alpha:1];
    segmentMenuVc.selectedColor = KMoneyColor;
    
    segmentMenuVc.MenuVcSlideType = WJSegmentMenuVcSlideTypeSlide;
    segmentMenuVc.SlideColor = [UIColor colorWithRed:(255/255.0) green:(103/255.0) blue:(51/255.0) alpha:1];
    segmentMenuVc.delegate = self;
    segmentMenuVc.advanceLoadNextVc = NO;
}

- (void)requestDataToCollectionView {

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/cart-fororder_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        
        NSDictionary *dicData = [NSDictionary dictionaryWithDictionary:response.responseObject];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            [self.titleDataSource removeAllObjects];
            NSArray *arr =[FMGatherStyleModel mj_objectArrayWithKeyValuesArray:dicData[@"fororder_tab"]];
            for (FMGatherStyleModel *model in arr) {
                [self.titleDataSource addObject:model.tab_name];
            }
            
            NSMutableArray * muarray = [NSMutableArray array];
            for (int i = 0; i< self.titleDataSource.count; i++) {
                FMGatherDetailViewController * vc = [[FMGatherDetailViewController alloc]init];
                vc.tab_filter = [arr[i] tab_filter];
                [muarray addObject:vc];
            }
            [self.segmentMenuVc addSubVc:muarray subTitles:self.titleDataSource];
        }
    }];
}

- (NSMutableArray *)titleDataSource {
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray array];
    }
    return _titleDataSource;
}

@end
