//
//  DressTableViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "DressTableViewController.h"
#import "HTTPClient+ExploreModules.h"
#import "ShareViewController.h"
#import "FMGoodShopURL.h"
#import "UIButton+Bootstrap.h" //修改右侧button
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 45
@interface DressTableViewController ()

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *clearCacheSize ;
@property (nonatomic, strong) UILabel *cacheLabel;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *parent_id;
@property (nonatomic,strong) NSString *lastParent_id;

@property (nonatomic,strong) NSString *provence;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;

@end

@implementation DressTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"选择地址"];

    self.level = @"1";
    self.parent_id = @"0";
    // 设置背景色
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self createLeftBtn];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    [self getDataFromNetWork];

}

- (void) settingNavTitle:(NSString *)title{
    
    CGRect rcTileView = CGRectMake(90, 0, KProjectScreenWidth - 2*90, 44);
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: rcTileView];
    titleTextLabel.backgroundColor = [UIColor clearColor];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.textColor = [UIColor blackColor];
    [titleTextLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleTextLabel setText:title];
    CGSize sizeTitle = [title sizeWithAttributes:@{NSFontAttributeName:titleTextLabel.font}];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(rcTileView.size.width/2+sizeTitle.width/2+10, 12, 20, 20);
    [indicatorView setHidesWhenStopped:YES];
    [titleTextLabel addSubview:indicatorView];
    self.navigationItem.titleView = titleTextLabel;

}

-(void)createLeftBtn{

    //    左侧button
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(10, 20, 44, 44)];
    navButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton simpleButtonWithImageColor:[UIColor blackColor]];
    [navButton addAwesomeIcon:FMIconLeftArrow beforeTitle:YES];
    
    [navButton addTarget:self  action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    self.navigationItem.leftBarButtonItem = rightItem;
}
/**
 *请求数据
 */
-(void)getDataFromNetWork{

    NSString *string = [NSString stringWithFormat:@"%@?level=%@&parent_id=%@",KGoodShop_ManageDress_MyDress_ChooseArea,self.level,self.parent_id];
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {

                weakSelf.titleArr = [response.responseObject objectForKey:kDataKeyData];
                Log(@"***%@",weakSelf.titleArr);
                
                if (weakSelf.titleArr != nil && ![weakSelf.titleArr isKindOfClass:[NSNull class]] && weakSelf.titleArr.count != 0) {

                    [weakSelf.tableView reloadData];

                }else{
                //  无数据时
                    [self ifTheArrayIsAlive];
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
        });
    }];
}

-(void)leftButtonOnClick{
    if ([self.level intValue]>1) {
        if ([self.level intValue]==2) {
            self.level = @"1";
            self.parent_id = @"0";
            [self getDataFromNetWork];

        }else{
            self.level = [NSString stringWithFormat:@"%d",[self.level intValue]-1];
            self.parent_id = self.lastParent_id;
            [self getDataFromNetWork];
        }
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    // 给Cell加一条横线
    NSDictionary *dic = self.titleArr[indexPath.row];
    NSString *text = [dic objectForKey:@"region_name"];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isLine = YES;
    for (UIView * view in cell.contentView.subviews) {
        if ([view isMemberOfClass:[UIView class]]) {
            isLine = NO;
        }
    }
    if (isLine) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat - 1, KProjectScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(231/255.0) blue:(232/255.0) alpha:1];
        [cell.contentView addSubview:lineView];
        [cell.contentView bringSubviewToFront:lineView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KCellHeghtFloat;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.titleArr[indexPath.row];
    if ([self.level intValue]==1) {
        
        self.provence = [dic objectForKey:@"region_name"];
    }else if ([self.level intValue]==2){
    
        self.city = [dic objectForKey:@"region_name"];
    }else if ([self.level intValue]==3){
    
        self.country = [dic objectForKey:@"region_name"];
    }
    
    self.level = [NSString stringWithFormat:@"%d",[self.level intValue]+1];
    self.lastParent_id = self.parent_id;
    self.parent_id = [dic objectForKey:@"region_id"];
    Log(@"%@  %@",self.level,self.parent_id);
    if ([self.level intValue]<4) {
        
      [self getDataFromNetWork];
    }else{
    
      [self ifTheArrayIsAlive];
    }
}

-(void)ifTheArrayIsAlive{

    NSString *country = @"";
    if (self.country) {
        if (self.country.length > 0) {
            country = self.country;
        }
    }
    if (self.blockWithDress) {
        self.blockWithDress(self.provence,self.city,country,self.parent_id);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
