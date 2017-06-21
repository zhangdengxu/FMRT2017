//
//  WLManageViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLManageViewController.h"
#import "AddNewDressViewController.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 120
#define KEditBtnTag 1000
#define KDeleteBtnTag 10000
@interface WLManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)NSArray *titleArr;
@property (nonatomic,strong)NSArray *dressArr;
@property (nonatomic,strong)NSArray *phoneNumberArr;

@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger numberOfRow;
@end

@implementation WLManageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"管理收货地址"];
    [self createTabelView];

}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"融小融",@"赵国强",@"赵燕", nil];
    }
    return _titleArr;
}

- (NSArray *)phoneNumberArr {
    if (!_phoneNumberArr) {
        _phoneNumberArr = [NSArray arrayWithObjects:@"18764083738",@"18764083738",@"18764083738", nil];
    }
    return _phoneNumberArr;
}


-(NSArray *)dressArr{
    
    if (!_dressArr) {
        _dressArr = [NSArray arrayWithObjects:@"山东省济南市　林允儿（Yoona），1990年出生于韩国首尔，集歌手、演员、主持人于一身，亚洲超人气女团少女时代成员之一。",@"山东省济南市　林允儿（Yoona），1990年出生于韩国首尔，集歌手、演员、主持人于一身，亚洲超人气女团少女时代成员之一。",@"山东省济南市　林允儿（Yoona），1990年出生于韩国首尔，集歌手、演员、主持人于一身，亚洲超人气女团少女时代成员之一。", nil];
    }
    return _dressArr;
}


-(void)createTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    // 设置背景色
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

//设为默认
-(void)bottomSelectAction:(UIButton *)button{
    
    button.selected=!button.selected;
    if (button.selected) {
        self.numberOfRow = button.tag;
        [self.tableView reloadData];
    }
    if (!button.selected) {
        self.numberOfRow = 1000;
        [self.tableView reloadData];
    }
}


#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSString *text = self.titleArr[indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, KProjectScreenWidth/3, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@",text];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [cell.contentView addSubview:titleLabel];
    
    NSString *text1 = self.phoneNumberArr[indexPath.row];
    UILabel *pjoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-10, 20, KProjectScreenWidth/2, 20)];
    pjoneNumberLabel.textAlignment = NSTextAlignmentRight;
    pjoneNumberLabel.text = [NSString stringWithFormat:@"%@",text1];
    pjoneNumberLabel.font = [UIFont systemFontOfSize:16];
    pjoneNumberLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    [cell.contentView addSubview:pjoneNumberLabel];
    
    
    NSString *text2 = self.dressArr[indexPath.row];
    UILabel *dressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KProjectScreenWidth-20, 20)];
    dressLabel.text = [NSString stringWithFormat:@"%@",text2];
    dressLabel.font = [UIFont systemFontOfSize:14.0f];
    dressLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    [cell.contentView addSubview:dressLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat-41, KProjectScreenWidth, 1)];
    lineView.backgroundColor = KDefaultOrBackgroundColor;
    [cell.contentView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat-7, KProjectScreenWidth, 7)];
    lineView1.backgroundColor = KDefaultOrBackgroundColor;
    [cell.contentView addSubview:lineView1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slectCtn setFrame:CGRectMake(10, KCellHeghtFloat-35, 20, 20)];
    [slectCtn setTag:indexPath.row];
    [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮灰）_03.png"] forState:UIControlStateNormal];
    [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮橙）_03.png"] forState:UIControlStateSelected];
    [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.numberOfRow == indexPath.row) {
        [slectCtn setSelected:YES];
    }else{
    
        [slectCtn setSelected:NO];
    }
    [cell.contentView addSubview:slectCtn];
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, KCellHeghtFloat-35, 70, 20)];
    if (self.numberOfRow == indexPath.row) {
        
        leftLabel.text = @"默认地址";
        leftLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:51/255.0f alpha:1];
    }else{
    
        leftLabel.text = @"设为默认";
        leftLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    }
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:14.0f];
    [cell.contentView addSubview:leftLabel];

    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-115, KCellHeghtFloat-33, 16, 16)];
    [leftImageV setImage:[UIImage imageNamed:@"管理收货地址（编辑）_03.png"]];
    [cell.contentView addSubview:leftImageV];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTag:KEditBtnTag+indexPath.row];
    [editBtn setFrame:CGRectMake(KProjectScreenWidth-100, KCellHeghtFloat-35, 35, 20)];
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn setTitleColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.7] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [cell.contentView addSubview:editBtn];
    
    UIImageView *deleteImageV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-62, KCellHeghtFloat-33, 16, 16)];
    [deleteImageV setImage:[UIImage imageNamed:@"管理收货地址（删除）_03.png"]];
    [cell.contentView addSubview:deleteImageV];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setFrame:CGRectMake(KProjectScreenWidth-47, KCellHeghtFloat-35, 35, 20)];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn setTag:KDeleteBtnTag+indexPath.row];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.7] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteBtn];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KCellHeghtFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
            
            
        case 2:
        {
            break;
        }
        case 3:
        {
            
            break;
        }
        case 5:
        {
            
            break;
        }
        default:
            break;
    }
    
}
//编辑
-(void)edit:(UIButton *)button{
//tag 1000
    AddNewDressViewController *dressVC = [[AddNewDressViewController alloc]init];
    dressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dressVC animated:YES];
    dressVC.isNewDress = YES;

}
//删除
-(void)delete:(UIButton *)button{
//tag 10000
    AddNewDressViewController *dressVC = [[AddNewDressViewController alloc]init];
    dressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dressVC animated:YES];
    dressVC.isNewDress = NO;

}


@end
