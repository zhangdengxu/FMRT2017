//
//  FMShopJoinInViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShopJoinInViewController.h"
#import "FMDuobaoShopCellHeaderView.h"
#import "FMDuobaoSHopCellFooter.h"
#import "FMPlaceOrderViewController.h"
#import "FMDuobaoStyleTableViewCell.h"
#import "FMShopDetailDuobaoViewController.h"

#import "FMDuobaoClass.h"

@interface FMShopJoinInViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@end

@implementation FMShopJoinInViewController

static NSString * flagFMShopJoinInViewController = @"FMShopJoinInViewControllerCell";
static NSString * duobaoShopCellHeaderViewRegister = @"FMDuobaoShopCellHeaderViewRegister";
static NSString * duobaoSHopCellFooterRegister = @"FMDuobaoSHopCellFooterRegister";

-(void)dealloc
{
    self.navigationController.navigationBarHidden = NO;

}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20 - 41) style:UITableViewStyleGrouped];
        [_tableView registerClass:[FMDuobaoStyleTableViewCell class] forCellReuseIdentifier:flagFMShopJoinInViewController];
        [_tableView registerClass:[FMDuobaoSHopCellFooter class] forHeaderFooterViewReuseIdentifier:duobaoSHopCellFooterRegister];
        [_tableView registerClass:[FMDuobaoShopCellHeaderView class] forHeaderFooterViewReuseIdentifier:duobaoShopCellHeaderViewRegister];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    [self reloadViewWithDataSource];
   
    
    [self createUICollectionView];
    // Do any additional setup after loading the view.
}

-(void)reloadViewWithDataSource
{
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FMDuobaoClassStyle * duobao = self.dataSource[section];
    //duobao.isSpread = NO 为不展开，duobao.isSpread = YES 为展开
    if (!duobao.isSpread) {
        return 0;
    }else
    {
        return 1;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMDuobaoStyleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:flagFMShopJoinInViewController forIndexPath:indexPath];
    if (!cell) {
        cell = [[FMDuobaoStyleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:flagFMShopJoinInViewController];
        
    }
    
    FMDuobaoClassStyle * duobao = self.dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentString = duobao.explain;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMDuobaoClassStyle * duobao = self.dataSource[indexPath.section];
    NSString * str = duobao.explain;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(KProjectScreenWidth - 60,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    CGFloat heigh = rect.size.height + 10;
    heigh = heigh > 44? heigh:44;
    return heigh;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    FMDuobaoClassStyle * duobao = self.dataSource[section];

    //duobao.isSpread = NO 为不展开，duobao.isSpread = YES 为展开
    if (!duobao.isSpread) {
        return nil;
    }else
    {
        FMDuobaoSHopCellFooter * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:duobaoSHopCellFooterRegister];
        if (!footer) {
            footer = [[FMDuobaoSHopCellFooter alloc]initWithReuseIdentifier:duobaoSHopCellFooterRegister];
            
        }
        __weak __typeof(&*self)weakSelf = self;
        footer.section = section;
        footer.buttonBlock = ^(NSInteger  sectionS){
            
            [weakSelf buttonBlockOnClickWithInSection:sectionS];
            
        };
        
        return footer;
    }
}

-(void)buttonBlockOnClickWithInSection:(NSInteger)section
{
    FMDuobaoClassStyle * duobao = self.dataSource[section];

    duobao.isSpread = NO;
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FMDuobaoShopCellHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:duobaoShopCellHeaderViewRegister];
    if (!header) {
        header = [[FMDuobaoShopCellHeaderView alloc]initWithReuseIdentifier:duobaoShopCellHeaderViewRegister];
        
    }
    FMDuobaoClassStyle * duobao = self.dataSource[section];
    duobao.spreadNumber = section;
    header.duobaoStyle = duobao;
     __weak __typeof(&*self)weakSelf = self;
    header.buttonBlock = ^(FMDuobaoClassStyle * buobaoStyle)
    {
        [weakSelf buyButtonOnClick:buobaoStyle];
    };
    
    header.buttonSpread = ^(FMDuobaoClassStyle * buobaoStyle){
        [weakSelf spreadButtonOnClick:buobaoStyle];
    };
    return header;
}
-(void)spreadButtonOnClick:(FMDuobaoClassStyle *)buttonStyle
{
    buttonStyle.isSpread = YES;
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:buttonStyle.spreadNumber];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}


-(void)buyButtonOnClick:(FMDuobaoClassStyle *)buttonStyle
{
  
    if (self.buttonBlock) {
        self.buttonBlock(buttonStyle);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    FMDuobaoClassStyle * duobao = self.dataSource[section];
    //stauts = 1 为没有进度条，status = 2为存在进度条
    if ([duobao.status integerValue] == 1) {
        //duobao.isSpread = NO 为不展开，duobao.isSpread = YES 为展开
        if (!duobao.isSpread) {
            
            if ([duobao.type integerValue] == 1) {
                //抽奖有下部展开条
                //没有进度条，不展开
                return KFirstViewHeigh + KThirdViewHeigh + KFourViewHeigh + KDefaultMargion * 4;
            }else
            {
                //老友价没有下部展开条
                //没有进度条，不展开
                return KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }
            
            

        }else
        {
            if ([duobao.type integerValue] == 1) {
                //抽奖有下部展开条
                //没有进度条，展开
                return KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }else
            {
                //老友价没有下部展开条
                //没有进度条，展开
                return KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }
            
        }
        
       
    }else
    {
        
        //duobao.isSpread = NO 为不展开，duobao.isSpread = YES 为展开
        if (!duobao.isSpread) {
            if ([duobao.type integerValue] == 1) {
            
                //有进度条，不展开
                return KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KFourViewHeigh + KDefaultMargion * 4;
            }else
            {
                //老友价没有下部展开条
                //有进度条，不展开
                return KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }
           
            
        }else
        {
            if ([duobao.type integerValue] == 1) {
                //有进度条，展开
                return KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }else
            {
                //老友价没有下部展开条
                //有进度条，展开
                return KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KDefaultMargion * 3;
            }
            
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    FMDuobaoClassStyle * duobao = self.dataSource[section];
    
    //duobao.isSpread = NO 为不展开，duobao.isSpread = YES 为展开
    if (!duobao.isSpread) {
        return 0.5;
    }else
    {
        return KFourViewHeigh;
    }
    
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
            if ([self.delegate respondsToSelector:@selector(FMShopJoinInViewController:withTableView:withFloatY:)]) {
                
                [self.delegate FMShopJoinInViewController:self withTableView:self.tableView withFloatY:scrollView.contentOffset.y];
                
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
