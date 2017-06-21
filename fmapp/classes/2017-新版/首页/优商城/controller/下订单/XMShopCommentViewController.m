//
//  XMShopCommentViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMShopCommentViewController.h"
#import "FMGoodShopURL.h"

#import "LWImageBrowser.h"
#import "FMShopCommentTableViewCell.h"
#import "LWDefine.h"
#import "LWAlchemy.h"
#import "FMShopCommentModel.h"
#import "FMCommentLayout.h"
#import "FMCommentHeaderViewTagMark.h"
#import "FMPlaceOrderViewController.h"

@interface XMShopCommentViewController ()<UITableViewDataSource,UITableViewDelegate,FMShopCommentTableViewCellDelegate,UIScrollViewDelegate,FMCommentHeaderViewTagMarkDelegate>


@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray * titleDataSource;
@property (nonatomic, strong) FMCommentHeaderViewTagMark * headerView;

@property (nonatomic, assign) NSInteger currengPage;

@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation XMShopCommentViewController

-(NSMutableArray *)titleDataSource
{
    if (!_titleDataSource) {

        _titleDataSource = [[NSMutableArray alloc] init];
        
    }
    return _titleDataSource;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(FMCommentHeaderViewTagMark *)headerView
{
    if (!_headerView) {
        _headerView = [[FMCommentHeaderViewTagMark alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, 0)];
        _headerView.delegate = self;
        [_headerView setTagMarkWithTagArray:self.titleDataSource];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20 - 35 - 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.decelerationRate = 1.0f;
        
    
        [_tableView addSubview:[self contentShowTitleView]];
        _tableView.mj_footer =  [MJRefreshBackFooter footerWithRefreshingBlock:^{
            _currengPage = _currengPage + 1;
            [self judgeGetNetWork:self.currentIndex];
        }];

        
    }
    return _tableView;
}
-(void)disTroyVideo;
{
    _delegate = nil;
    _headerView.delegate = nil;
    [_headerView removeFromSuperview];
    _headerView = nil;
}
- (void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"delloc ===== XMShopCommentViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    self.currengPage = 1;
    
    
    [self getTitleDataSourceFromNetWork];
    
   
    
    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    FMShopCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[FMShopCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (self.dataSource.count >= indexPath.row) {
        FMCommentLayout* cellLayout = self.dataSource[indexPath.row];
        cell.cellLayout = cellLayout;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count >= indexPath.row) {
        FMCommentLayout* layout = self.dataSource[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/****************************************************************************/
/**
 *  在这里生成LWAsyncDisplayView的模型。
 */
/****************************************************************************/

- (FMCommentLayout *)layoutWithStatusModel:(FMShopCommentModel *)statusModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    FMCommentLayout* layout = [[FMCommentLayout alloc] initWithContainer:container
                                                   statusModel:statusModel
                                                         index:index];
    return layout;
}

//点击图片
- (void)tableViewCell:(FMShopCommentTableViewCell *)cell didClickedImageWithCellLayout:(FMCommentLayout *)layout
              atIndex:(NSInteger)index;
{
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[layout.statusModel.imgs objectAtIndex:i]]
                                                                                     HDURL:[NSURL URLWithString:[layout.statusModel.imgs objectAtIndex:i]]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

- (void)tableViewCell:(FMShopCommentTableViewCell *)cell didClickedSecondImageWithCellLayout:(FMCommentLayout *)layout
              atIndex:(NSInteger)index;
{
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionSecondArray.count];
    for (NSInteger i = 0; i < layout.imagePostionSecondArray.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[layout.statusModel.secondImgs objectAtIndex:i]]
                                                                                     HDURL:[NSURL URLWithString:[layout.statusModel.secondImgs objectAtIndex:i]]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionSecondArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getTitleDataSourceFromNetWork
{
    NSString * getCommentURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product-goodsDiscuss_client_nums-%@.html", self.goods_id];
    
    [FMHTTPClient postPath:getCommentURL parameters:nil completion:^(WebAPIResponse *response) {
        [self.titleDataSource removeAllObjects];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * titleArray = @[@"count_all",@"count_img",@"count_zhuiping"];
            NSDictionary * data = response.responseObject[@"data"];
            for (NSInteger i = 0; i < titleArray.count; i ++) {
                
                NSString * titleString = data[titleArray[i]];
                [self.titleDataSource addObject:titleString];
            }
            
            self.view = self.tableView;
            [self createUICollectionView];
            self.tableView.tableHeaderView = self.headerView;
            [self judgeGetNetWork:self.currentIndex];
        }
    }];
}

-(void)FMCommentHeaderViewTagMark:(FMCommentHeaderViewTagMark *)headerView didSelectItem:(NSInteger)index
{
    if (self.currentIndex == index) {
        return;
    }
    
    self.currengPage = 1;
   [self.dataSource removeAllObjects];
    self.currentIndex = index;
    [self judgeGetNetWork:self.currentIndex];
}
-(void)judgeGetNetWork:(NSInteger)index
{
    
    
    if (index == 0) {
        NSString * getCommentURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product-goodsDiscuss_client-%@-%zi.html",self.goods_id,self.currengPage];
        [self getNetWorkFromNetWork:getCommentURL];
        
    }else if (index == 1){
        NSString * getCommentURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product-goodsDiscuss_client-%@-%zi.html?zhuiping=1",self.goods_id,self.currengPage];
        [self getNetWorkFromNetWork:getCommentURL];
    }else if (index == 2){
        NSString * getCommentURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product-goodsDiscuss_client-%@-%zi.html?pic=1",self.goods_id,self.currengPage];
        [self getNetWorkFromNetWork:getCommentURL];

    }else
    {
    
    }
    
    
}

-(void)getNetWorkFromNetWork:(NSString *)html
{
   
    
    [FMHTTPClient postPath:html parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSArray * data = response.responseObject[@"data"];
            for (NSInteger i = 0; i < data.count; i ++) {
                NSDictionary * dict = data[i];
                FMShopCommentModel * shopComment = [FMShopCommentModel createFMShopCommentModelWithShopDetailDictionary:dict];
                
                LWLayout * layout = [self layoutWithStatusModel:shopComment index:i];
                [self.dataSource addObject:layout];
            }
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
}


-(void)createUICollectionView
{
    if (self.fatherController.isLetSonViewScroll) {
        self.tableView.scrollEnabled = YES;
    }else
    {
        self.tableView.scrollEnabled = NO;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
    if (scrollView.contentOffset.y <= 0) {
        if (fabs(scrollView.contentOffset.y) > 20) {
            if ([self.delegate respondsToSelector:@selector(XMShopCommentViewController:withTableView:withFloatY:)]) {
                [self.delegate XMShopCommentViewController:self withTableView:self.tableView withFloatY:scrollView.contentOffset.y];
            }
        }
    }
}



-(UIView *)contentShowTitleView
{
    UIView * contentShow = [[UIView alloc]initWithFrame:CGRectMake(0, -50, KProjectScreenWidth, 50)];
    contentShow.backgroundColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"返回上部";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    [contentShow addSubview:titleLabel];
    titleLabel.center = CGPointMake(KProjectScreenWidth * 0.5, 25);
    return contentShow;
}

@end
