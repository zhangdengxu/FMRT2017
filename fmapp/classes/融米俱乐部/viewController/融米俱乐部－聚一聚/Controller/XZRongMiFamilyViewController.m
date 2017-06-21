//
//  XZRongMiFamilyViewController.m
//  fmapp
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//  融米一家亲

#import "XZRongMiFamilyViewController.h"
#import "XZRongMiFamilyItem.h"
#import "XZRongMiFamilyReusableView.h"
#import "WLMMYPViewController.h" // 验票
#import "XZActivityViewController.h" // 活动
// 数据请求

#import "XZActivityModel.h" // model
#import "WLPublishSuccessViewController.h" // 分享页
#import "WLOrganizationViewController.h" // 发布页

/** 融米一家亲 */
#define kRongMiFamilyURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/manapartyinfo"

@interface XZRongMiFamilyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionFamily;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
///** 背景图 */
//@property (nonatomic, strong) UIView *viewBackGround;
/** model */
@property (nonatomic, strong) XZActivityModel *modelRongMi;
/** 头视图 */
@property (nonatomic, strong) XZRongMiFamilyReusableView *headerView;

@end


@implementation XZRongMiFamilyViewController
static NSString *reuseID = @"rongMiFamily";
static NSString *headerReuseID = @"rongMiFamily_header";
static NSString *footerReuseID = @"rongMiFamily_footer";


- (UICollectionView *)collectionFamily {
    if (!_collectionFamily) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat size =  (KProjectScreenWidth - 2) / 3.0;
        flowLayout.itemSize = CGSizeMake( size, size);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置section的头标题大小
        flowLayout.headerReferenceSize = CGSizeMake(KProjectScreenWidth, size + 220);
        flowLayout.footerReferenceSize = CGSizeMake(KProjectScreenWidth, 100);
        _collectionFamily = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) collectionViewLayout:flowLayout];
        _collectionFamily.backgroundColor = XZColor(230, 235, 240);
        _collectionFamily.showsVerticalScrollIndicator = NO;
        _collectionFamily.dataSource = self;
        _collectionFamily.delegate = self;
        [_collectionFamily registerClass:[XZRongMiFamilyItem class] forCellWithReuseIdentifier:reuseID];
        [_collectionFamily registerClass:[XZRongMiFamilyReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID];
        [_collectionFamily registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseID];

        [self.view addSubview:_collectionFamily];

    }
    return _collectionFamily;
}

- (NSArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSArray arrayWithObjects:@"融米一家亲_分享",@"融米一家亲_再发一个",@"融米一家亲_查看", nil];
    }
    return _imgArr;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"分享",@"再发一个",@"查看", nil];
    }
    return _titleArr;
}

- (XZActivityModel *)modelRongMi {
    if (!_modelRongMi) {
        _modelRongMi = [[XZActivityModel alloc]init];
    }
    return _modelRongMi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = self.party_theme ? self.party_theme : @"融米一家亲";
    [self settingNavTitle:title]; // @"融米一家亲"
    self.modelRongMi.party_theme = title;

    // 注册cell
 
    // 验票
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"验票" style:UIBarButtonItemStyleDone target:self action:@selector(didClickCheckTicketBtn:)];
    // 注册UICollectionReusableView的headerView

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestRongMiFamilyData];
}

#pragma mark ----- 请求数据
- (void)requestRongMiFamilyData {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
//    NSString *urlPath = [NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%@&token=%@&pid=%@",kRongMiFamilyURL,[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,self.pid];
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"pid":self.pid
                                 };
    [FMHTTPClient postPath:kRongMiFamilyURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//=======
//
//    [FMHTTPClient postPath:urlPath parameters:nil completion:^(WebAPIResponse *response) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//>>>>>>> 851e882ef1425ca006dffdb52bdcbe7433a8cbce
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                [self.modelRongMi setValuesForKeysWithDictionary:dataDict];
                self.headerView.modelRongMi = self.modelRongMi;
               }else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }

            [self.collectionFamily reloadData];
        }else{
        }
    }];
}

// 点击验票按钮
- (void)didClickCheckTicketBtn:(UIBarButtonItem *)item {
    WLMMYPViewController *registerCertification = [[WLMMYPViewController alloc]init];
    registerCertification.count = self.modelRongMi.checkticketdone;
    [self.navigationController pushViewController:registerCertification animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZRongMiFamilyItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
        item.backgroundColor = [UIColor whiteColor];
    item.imgPhoto.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
    item.labelTitle.text = [NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];

    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
        case 0: // 分享
        {
            if ([self.state isEqualToString:@"0"]) { // 不能分享
                ShowAutoHideMBProgressHUD(self.view,@"未通过审核不能分享！");
            }else {
                WLPublishSuccessViewController *share = [[WLPublishSuccessViewController alloc]init];
                share.modelActivity = self.modelRongMi;
                share.hasManage = NO;
                [self.navigationController pushViewController:share animated:YES];
            }
        }
            break;
        case 1: // 再发一个
        {
            // 发布
            WLOrganizationViewController *publish = [[WLOrganizationViewController alloc]init];
            [self.navigationController pushViewController:publish animated:YES];
        }
            break;
        case 2: // 查看
        {
            XZActivityViewController *activity = [[XZActivityViewController alloc]init];
            activity.pid = self.pid;
            [self.navigationController pushViewController:activity animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
 //设置section的头标题
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView = nil;
    // 如果是section的头
    if (kind == UICollectionElementKindSectionHeader) {
        XZRongMiFamilyReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID forIndexPath:indexPath];
        self.headerView = headerView;
        self.headerView.modelRongMi = self.modelRongMi;

//         点击修改按钮
        __weak typeof (self)weakSelf = self;
        headerView.blockAlter = ^(UIButton *button){
            if ([weakSelf.state isEqualToString:@"0"]) {
                WLOrganizationViewController *organization = [[WLOrganizationViewController alloc]init];
                organization.pid = weakSelf.pid;
                [weakSelf.navigationController pushViewController:organization animated:YES];
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"当前活动已不能修改");
            }
            
        };
        reuseableView = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseID forIndexPath:indexPath];
        reuseableView = footerView;
    }

    return reuseableView;
}


@end
