//
//  XZScrollAdsViewController.m
//  fmapp
//
//  Created by admin on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//  广告轮播页

#import "XZScrollAdsViewController.h"
#import "XZScrollAdsCell.h"
#import "XZMultiFunctionScrollAdsCell.h"
#import "XZScrollAdsModel.h"
#import "AppDelegate.h"
#import "XZScrollAdsButtonModel.h"// button点击的model
#import "ShareViewController.h" // web页
#import "FMRTRegisterAppController.h"// 注册

@interface XZScrollAdsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) XZScrollAdsModel *modelScroll;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
// 跑秒
@property (nonatomic, assign) dispatch_source_t timerX;
@end

static NSString *const reuseID = @"ScrollAdsItem";
static NSString *const reuseIDMulti = @"MultiFunctionScrollAdsCell";
@implementation XZScrollAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(KProjectScreenWidth, KProjectScreenHeight);
    flowLayout.minimumInteritemSpacing = 0.001f;
    flowLayout.minimumLineSpacing = 0.001f;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, KProjectScreenWidth, KProjectScreenHeight + 20) collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.bounces = NO;
    [collectionView registerClass:[XZScrollAdsCell class] forCellWithReuseIdentifier:reuseID];
    [collectionView registerClass:[XZMultiFunctionScrollAdsCell class] forCellWithReuseIdentifier:reuseIDMulti];
    self.collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = NO;

    // 一张图的时候，下面没有点
    if (self.modelScroll.pic.count > 1) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.pageControl];
    }
   
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    self.pageControl.hidden = NO;
    // 只有一张广告的时候跑秒
    if (self.modelScroll.pic.count == 1) {
        [self buttonTimeReduce:5];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
    self.pageControl.hidden = YES;
}

- (void)AnalyticalDataWithDict:(NSDictionary *)dict {
    XZScrollAdsModel *modelScroll = [[XZScrollAdsModel alloc] init];
    [modelScroll setScrollAdsModelWithDic:dict];
    self.modelScroll = modelScroll;
    [self.collectionView reloadData];
}

#pragma mark ----- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.modelScroll.pic.count;
    _pageControl.numberOfPages = count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(&*self)weakSelf = self;
    
    // 停止跑秒
    void(^blockStopTimer)() = ^{
        if (weakSelf.timerX) {  // 停止跑秒
            dispatch_source_cancel(weakSelf.timerX);
            weakSelf.timerX = 0;
        }
    };
    
    if (indexPath.item == (self.modelScroll.pic.count - 1)) {
        XZMultiFunctionScrollAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIDMulti forIndexPath:indexPath];
//        // 只有一张广告的时候跑秒
//        if (self.modelScroll.pic.count > 1) {
//            cell.noSeconds = YES;
//        }else {
//            cell.noSeconds = NO;
//        }
        if (self.modelScroll.pic) {
            cell.modelPicUrl = self.modelScroll.pic[indexPath.item];
        }
        
        // 跳过按钮
        cell.blockJumpButton = ^(UIButton *button) {
            blockStopTimer();
            // 点击跳过按钮，替换跟控制器
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
            // 判断登录
            [ShareAppDelegate initWithUserAutoLogin];
        };
        
        // 点击操作
        void(^blockOperation)(int) = ^(int i) {
            XZScrollAdsButtonModel *modelButton;
            if (self.modelScroll.btn) {
                modelButton = self.modelScroll.btn[i];
            }
            NSString *type = [NSString stringWithFormat:@"%@",modelButton.type];
//            NSLog(@"type  ================= %@",type);
            if ([type isEqualToString:@"0"]) {
                
            }else if ([type isEqualToString:@"1"]) {
                blockStopTimer();
                // web页
                ShareViewController *shareVC = [[ShareViewController alloc] initWithTitle:modelButton.title AndWithShareUrl:modelButton.lianjie];
                [weakSelf.navigationController pushViewController:shareVC animated:YES];
            }else if([type isEqualToString:@"2"]){
               blockStopTimer();
                // 注册
                FMRTRegisterAppController *registerVc = [[FMRTRegisterAppController alloc]init];
//                registerVc.isGoBackLogin = YES;
                [weakSelf.navigationController pushViewController:registerVc animated:YES];
            }else if ([type isEqualToString:@"3"]){
                // 首页
                blockStopTimer();
                // 点击跳过按钮，替换跟控制器
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                // 判断登录
                [ShareAppDelegate initWithUserAutoLogin];
            }
        };
    
        // 页面的四个按钮 0：不能点击，1：web，2：原生--注册，3：原生--进入app
        cell.blockCellButton = ^(UIButton *button) {
            if (button.tag == 500) { // 第一个
                blockOperation(0);
            }else if (button.tag == 501) { // 第二个
                blockOperation(1);
            }else if (button.tag == 502) { // 第三个
                blockOperation(2);
            }else { // 第四个
                blockOperation(3);
            }
        };
        
        return cell;
    }else {
        XZScrollAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
        if (self.modelScroll.pic) {
           cell.modelPicUrl = self.modelScroll.pic[indexPath.item];
        }
        // 第一页和最后一页显示“跳过”按钮
        if (indexPath.row == 0) {
            cell.isHiddenJumpBtn = NO; // 不隐藏"跳过"按钮
            // 跳过按钮
            cell.blockJumpButton = ^(UIButton *button) {
                blockStopTimer();
                // 点击跳过按钮，替换跟控制器
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                // 判断登录
                [ShareAppDelegate initWithUserAutoLogin];
            };
        }else {
            cell.isHiddenJumpBtn = YES; // 隐藏"跳过"按钮
        }
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    __weak __typeof(&*self)weakSelf = self;
    if (scrollView.contentOffset.x >= ((self.modelScroll.pic.count - 1) * KProjectScreenWidth + 30)) { //  + 30
        // 停止跑秒
        void(^blockStopTimer)() = ^{
            if (weakSelf.timerX) {  // 停止跑秒
                dispatch_source_cancel(weakSelf.timerX);
                weakSelf.timerX = 0;
            }
        };
        // 进入首页
        blockStopTimer();
        [self dismissViewControllerAnimated:NO completion:nil];
        // 判断登录
        [ShareAppDelegate initWithUserAutoLogin];
    }
}

/** 让button读秒 */
- (void)buttonTimeReduce:(int)seconds {
//    NSLog(@"button跑秒");
    __block int timeout = seconds;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self.timerX = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(&*self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 跑秒结束
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                // 判断登录
                [ShareAppDelegate initWithUserAutoLogin];
            });
        }else{
            int seconds = timeout % 5;
            __block NSString *strTime = [NSString stringWithFormat:@"%.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (seconds == 0) {
                    strTime = @"5";
                }
//                NSLog(@"strTime**********跳过%@",strTime);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ----- scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 获取当前显示的cell的下标
    int page = floor((scrollView.contentOffset.x - KProjectScreenWidth / 2) / KProjectScreenWidth) + 1;
    
    // 赋值给记录当前坐标的变量
    self.pageControl.currentPage = page;
}

#pragma mark --- 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((KProjectScreenWidth - 100) / 2.0, KProjectScreenHeight - 50, 100, 30)];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (void)dealloc
{
    Log(@"开机广告页*******&&&&&&&&dealloc");
}
@end
