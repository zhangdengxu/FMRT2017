//
//  FMJoinInNotesViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMJoinInNotesViewController.h"
#import "FMShopDetailDuobaoViewController.h"
#import "FMJoinInNoteTableViewCell.h"
#import "FMDuobaoClass.h"

@interface FMJoinInNotesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FMJoinInNotesViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (!self.showNavigationBar) {
//        self.navigationController.navigationBarHidden = NO;
//    }
//}
-(void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor =  [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];;
    [self createContentView];
    
    [self getDataSourceFromNetWork];
    
    [self createUICollectionView];
    // Do any additional setup after loading the view.
}

-(void)refreshDataSource;
{
    [self getDataSourceFromNetWork];
}

-(void)getDataSourceFromNetWork
{

    
    NSString * detailUrl = [NSString stringWithFormat:@"%@/public/newon/show/getWonParticipationList",kXZTestEnvironment];
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSDictionary * parameter ;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                     @"appid":@"huiyuan",
                                     @"shijian":[NSNumber numberWithInt:timestamp],
                                     @"token":tokenlow,
                                     @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                     @"won_id":self.won_id};
        

    }else
    {
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":@"0",
                                     @"appid":@"huiyuan",
                                     @"shijian":[NSNumber numberWithInt:timestamp],
                                     @"token":tokenlow,
                                     @"won_id":self.won_id};

    }
    
    
    [FMHTTPClient postPath:detailUrl parameters:parameter completion:^(WebAPIResponse *response) {
       
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSArray * dictArray = response.responseObject[@"data"];
            
            if (dictArray && ![dictArray isMemberOfClass:[NSNull class]]) {
                
                for (NSDictionary * dict in dictArray) {
                    FMDuobaoClassNotes * notes = [[FMDuobaoClassNotes alloc]init];
                    [notes setValuesForKeysWithDictionary:dict];
                    
                    [self.dataSource addObject:notes];
                }
                [self.tableView reloadData];
            }
        }
        
    }];
}

- (void)createContentView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20 - 41) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.tableView registerClass:[FMJoinInNoteTableViewCell class] forCellReuseIdentifier:@"FMJoinInNoteTableViewCellRegister"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];


    
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMJoinInNoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FMJoinInNoteTableViewCellRegister" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FMJoinInNoteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FMJoinInNoteTableViewCellRegister"];
    }
    FMDuobaoClassNotes * notes = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.duobaoNotes = notes;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMDuobaoClassNotes * notes = self.dataSource[indexPath.row];
    
    if ([notes.way_type integerValue] == 1) {
        return 90;
    }else
    {
        return 70;
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
            if ([self.delegate respondsToSelector:@selector(FMJoinInNotesViewController:withTableView:withFloatY:)]) {
                
                [self.delegate FMJoinInNotesViewController:self withTableView:self.tableView withFloatY:scrollView.contentOffset.y];
                
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
