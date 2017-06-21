//
//  FMShopStandardController.m
//  fmapp
//
//  Created by runzhiqiu on 2016/12/10.
//  Copyright © 2016年 yk. All rights reserved.
//



#import "FMShopStandardController.h"
#import "FMPlaceOrderViewController.h"
#import "FMShopOtherModel.h"
#import "FMShopStandardTableViewCell.h"


@interface FMShopStandardController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation FMShopStandardController


static NSString * shopStandardTableViewCellRegister = @"shopStandardTableViewCellRegister";

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20 - 35 - 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FMShopStandardTableViewCell class] forCellReuseIdentifier:shopStandardTableViewCellRegister];
        
        [self.view addSubview:_tableView];
        
        
    }
    return _tableView;
}
-(void)disTroyVideo;
{
    _delegate = nil;
    
}
-(void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
//    NSLog(@"delloc ===== FMShopStandardController");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];

    
    
    if (self.dataSource.count > 0) {
        [self.tableView reloadData];
    }
    
    [self contentShowTitleView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FMShopStandardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:shopStandardTableViewCellRegister forIndexPath:indexPath];
    cell.shopOtherModel = self.dataSource[indexPath.row];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 50;
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
            if ([self.delegate respondsToSelector:@selector(FMShopStandardController:withTableView:withFloatY:)]) {
                [self.delegate FMShopStandardController:self withTableView:self.tableView withFloatY:scrollView.contentOffset.y];
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
