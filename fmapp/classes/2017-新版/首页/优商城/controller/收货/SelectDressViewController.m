
//
//  SelectDressViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "SelectDressViewController.h"
#import "WLManageViewController.h"
#import "AddNewDressViewController.h"
#import "HTTPClient+Interaction.h"
#import "FMGoodShopURL.h"
#import "SignOnDeleteView.h"
#import "XZShoppingOrderAddressModel.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KReuseCellIdNew @"SetUpNewTableVControllerCell"

#define KCellHeghtFloat 105
#define KCellHeghtFloatNew 145
#define KEditBtnTag 1000
#define KDeleteBtnTag 10000
@interface SelectDressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *titleArr;//姓名
@property (nonatomic,strong)NSMutableArray *dressArr;
@property (nonatomic,strong)NSMutableArray *addr_idArr;
@property (nonatomic,strong)NSMutableArray *addrArr;
@property (nonatomic,strong)NSMutableArray *mobileArr;
@property (nonatomic,strong)NSMutableArray *member_idArr;
@property (nonatomic,strong)NSMutableArray *phoneNumberArr;
@property (nonatomic,strong)NSMutableArray *def_addrArr;
@property (nonatomic,strong)NSMutableArray *areaArr;
@property (nonatomic,strong)NSMutableArray *area_idArr;
@property (nonatomic,strong)NSMutableArray *zipArr;

@property (nonatomic, weak)NSString *clearCacheSize ;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger numberOfRow;
@property (nonatomic,assign)BOOL isEdit;

@end

@implementation SelectDressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEdit = NO;
    [self settingNavTitle:self.naviTitleName];
    [self getDataFromNetWork];
    [self createRightBtn];
    [self createTabelView];
    [self createBottomAddButton];
    __weak __typeof(&*self)weakSelf = self;
    
    // 选择收货地址
    self.navBackButtonRespondBlock = ^(){
        [weakSelf huidiao:nil];
    };
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice) name:@"deleteAddress" object:nil];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(notice) name:@"Address" object:nil];
}


-(void)notice{

    [self getDataFromNetWork];
}

-(void)getDataFromNetWork{
/**
 
 addr = 1;
 "addr_id" = 1793;
 area = "mainland:\U4e0a\U6d77/\U4e0a\U6d77\U5e02/\U9759\U5b89\U533a:27";
 day = "\U4efb\U610f\U65e5\U671f";
 "def_addr" = 0;
 firstname = "<null>";
 lastname = "<null>";
 "member_id" = 2325;
 mobile = 1;
 name = 1;
 tel = r;
 time = "\U4efb\U610f\U65f6\U95f4\U6bb5";
 zip = 1;
 **/
//    测试接口 这里需要修改 写入新参数
//    NSString *url=@"https://www.rongtuojinrong.com/qdy/wap/member-receiver_client.html?from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191";
    
    if (self.titleArr.count>0) {
        [self.titleArr removeAllObjects];
        [self.dressArr removeAllObjects];
        [self.addr_idArr removeAllObjects];
        [self.mobileArr removeAllObjects];
        [self.member_idArr removeAllObjects];
        [self.phoneNumberArr removeAllObjects];
        [self.def_addrArr removeAllObjects];
        [self.areaArr removeAllObjects];
        [self.area_idArr removeAllObjects];
        [self.zipArr removeAllObjects];
        [self.addrArr removeAllObjects];
    }

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    NSString *urlStr = [NSString  stringWithFormat:KGoodShop_ManageDress@"?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    Log(@"*********%@",urlStr);
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient  getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code == WebAPIResponseCodeSuccess)
            {
                NSDictionary * dict = response.responseObject;
                if (dict) {
                    NSArray *arr = [dict objectForKey:@"data"];
                    Log(@"arr:%@",arr);
                    Log(@"arr:%@",arr);
                    for (NSDictionary *dic in arr) {
                        NSString *name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                        [self.titleArr addObject:name];
                        NSString *area = [NSString stringWithFormat:@"%@",[dic objectForKey:@"area"]];
                        [self.dressArr addObject:area];
                        NSString *tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
                        [self.phoneNumberArr addObject:tel];
                        NSString *addr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]];
                        [self.addrArr addObject:addr];
                        NSString *addr_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addr_id"]];
                        [self.addr_idArr addObject:addr_id];
                        NSString *zip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zip"]];
                        [self.zipArr addObject:zip];
                        NSString *mobile = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
                        [self.mobileArr addObject:mobile];
                        NSString *def_addr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"def_addr"]];
                        [self.def_addrArr addObject:def_addr];
                        
                        NSString *areaArr = [dic objectForKey:@"area"];
                        [self.areaArr addObject:areaArr];
                        
                        NSString *area_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"area_id"]];
                        [self.area_idArr addObject:area_id];
                    }
                    [self.tableView reloadData];
                
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
                }
                
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求数据失败");
            }
        });
    }];
}

-(void)callModalList{
    [self settingNavTitle:@"管理收货地址"];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    self.isEdit = YES;
    [self.tableView reloadData];
    [self createNewRightBtn];
    
}


//截取字符串
-(NSString *)replacingString:(NSString *)string{
    NSString * contentString;

    if ([string length]>0) {
        NSArray * addressArray = [string componentsSeparatedByString:@":"];
        
        if (addressArray) {
            if (addressArray.count == 2) {
                contentString = addressArray[1];
            }else if(addressArray.count == 3){
                contentString = addressArray [1];
            }else if(addressArray.count == 1)
            {
                contentString = addressArray [0];
            }
        }
    }
    contentString = [contentString stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    contentString = [contentString stringByReplacingOccurrencesOfString:@":" withString:@""];
    return contentString;
    
}

//创建底部添加地址按钮
-(void)createBottomAddButton{

    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight-64-60, KProjectScreenWidth, 60)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];

    UIButton *addDressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addDressBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1])
                         forState:UIControlStateNormal];
    [addDressBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1])
                         forState:UIControlStateHighlighted];
    [addDressBtn setTitle:@"添加新地址"
               forState:UIControlStateNormal];
    [addDressBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [addDressBtn setFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
    addDressBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [addDressBtn setBackgroundColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [addDressBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [addDressBtn addTarget:self action:@selector(addDress:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addDressBtn];

}


-(void)addDress:(UIButton *)button{

    AddNewDressViewController *dressVC = [[AddNewDressViewController alloc]init];
    dressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dressVC animated:YES];
    dressVC.isNewDress = YES;

}

#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isEdit) {
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
        
        NSString *text1 = self.mobileArr[indexPath.row];
        UILabel *pjoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-10, 20, KProjectScreenWidth/2, 20)];
        pjoneNumberLabel.textAlignment = NSTextAlignmentRight;
        pjoneNumberLabel.text = [NSString stringWithFormat:@"%@",text1];
        pjoneNumberLabel.font = [UIFont systemFontOfSize:16];
        pjoneNumberLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
        [cell.contentView addSubview:pjoneNumberLabel];
        
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.def_addrArr[indexPath.row] isEqualToString:@"1"]) {
            NSString *city = self.areaArr[indexPath.row];
            NSString *area_id = self.area_idArr[indexPath.row];
            NSString *realArea = self.addrArr[indexPath.row];
            NSString *dress = [NSString stringWithFormat:@"%@%@%@",@"默认地址：",[self replacingString:city],realArea];
            CGSize size = CGSizeMake(KProjectScreenWidth-20,50);
            CGSize labelsize = [dress sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *morenDressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [morenDressLabel setFont:[UIFont systemFontOfSize:14]];
            [morenDressLabel setFrame:CGRectMake(10, 50, KProjectScreenWidth-20, labelsize.height)];
            [morenDressLabel setNumberOfLines:0];
            morenDressLabel.lineBreakMode = NSLineBreakByWordWrapping;

            [morenDressLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9]];

            [morenDressLabel setText:dress];
            
            NSString *sStr = morenDressLabel.text;
            NSString *sDstr = @"默认地址：";
            NSRange range = [sStr rangeOfString:sDstr];
            NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:morenDressLabel.text];
            [mstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:51/255.0f alpha:1] range:range];
            
            morenDressLabel.attributedText=mstr;
            [cell.contentView addSubview:morenDressLabel];
        }else{
            NSString *city = self.areaArr[indexPath.row];
            NSString *area_id = self.area_idArr[indexPath.row];
            NSString *realArea = self.addrArr[indexPath.row];
            NSString *text2 = [NSString stringWithFormat:@"%@%@",[self replacingString:city],realArea];
            CGSize size = CGSizeMake(KProjectScreenWidth-20,50);
            CGSize labelsize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *dressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            dressLabel.text = [NSString stringWithFormat:@"%@",text2];
            dressLabel.font = [UIFont systemFontOfSize:14.0f];
            dressLabel.frame=CGRectMake(10, 50, KProjectScreenWidth-20, labelsize.height);
            dressLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
            [dressLabel setNumberOfLines:0];
            dressLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:dressLabel];
            
                }
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat-1, KProjectScreenWidth, 1)];
        lineView.backgroundColor = KDefaultOrBackgroundColor;
        [cell.contentView addSubview:lineView];

        return cell;
   
    }else{
    
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
        
        NSString *text1 = self.mobileArr[indexPath.row];
        UILabel *pjoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/2-10, 20, KProjectScreenWidth/2, 20)];
        pjoneNumberLabel.textAlignment = NSTextAlignmentRight;
        pjoneNumberLabel.text = [NSString stringWithFormat:@"%@",text1];
        pjoneNumberLabel.font = [UIFont systemFontOfSize:16];
        pjoneNumberLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
        [cell.contentView addSubview:pjoneNumberLabel];
        
        
        if ([self.def_addrArr[indexPath.row] isEqualToString:@"1"]) {
            
            NSString *dress = [NSString stringWithFormat:@"%@%@%@",@"默认地址：",[self replacingString:self.areaArr[indexPath.row]],self.addrArr[indexPath.row]];
            CGSize size = CGSizeMake(KProjectScreenWidth-20,50);
            CGSize labelsize = [dress sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *morenDressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [morenDressLabel setFont:[UIFont systemFontOfSize:14]];
            [morenDressLabel setFrame:CGRectMake(10, 50, KProjectScreenWidth-20, labelsize.height)];
            [morenDressLabel setNumberOfLines:0];
            morenDressLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            [morenDressLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9]];
            
            [morenDressLabel setText:dress];
            
            NSString *sStr = morenDressLabel.text;
            NSString *sDstr = @"默认地址：";
            NSRange range = [sStr rangeOfString:sDstr];
            NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:morenDressLabel.text];
            [mstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:51/255.0f alpha:1] range:range];
            
            morenDressLabel.attributedText=mstr;
            [cell.contentView addSubview:morenDressLabel];
        }else{
            
            NSString *text2 = [NSString stringWithFormat:@"%@%@",[self replacingString:self.areaArr[indexPath.row]],self.addrArr[indexPath.row]];
            CGSize size = CGSizeMake(KProjectScreenWidth-20,50);
            CGSize labelsize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *dressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            dressLabel.text = [NSString stringWithFormat:@"%@",text2];
            dressLabel.font = [UIFont systemFontOfSize:14.0f];
            dressLabel.frame=CGRectMake(10, 50, KProjectScreenWidth-20, labelsize.height);
            dressLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
            [dressLabel setNumberOfLines:0];
            dressLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:dressLabel];
            
        }
;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloatNew-41, KProjectScreenWidth, 1)];
        lineView.backgroundColor = KDefaultOrBackgroundColor;
        [cell.contentView addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloatNew-7, KProjectScreenWidth, 7)];
        lineView1.backgroundColor = KDefaultOrBackgroundColor;
        [cell.contentView addSubview:lineView1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [slectCtn setFrame:CGRectMake(0, KCellHeghtFloatNew-45, 40, 40)];
        [slectCtn setTag:indexPath.row];
        [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮灰）_03.png"] forState:UIControlStateNormal];
        [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮橙）_03.png"] forState:UIControlStateSelected];
        [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.def_addrArr[indexPath.row] intValue] == 1) {
            self.numberOfRow = indexPath.row;
            [slectCtn setSelected:YES];
        }else{
            [slectCtn setSelected:NO];
        }
        [cell.contentView addSubview:slectCtn];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, KCellHeghtFloatNew-35, 70, 20)];
        if ([self.def_addrArr[indexPath.row] intValue] == 1) {
            
            leftLabel.text = @"默认地址";
            leftLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:51/255.0f alpha:1];
        }else{
            
            leftLabel.text = @"设为默认";
            leftLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
        }
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:leftLabel];
        
        UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-115, KCellHeghtFloatNew-33, 16, 16)];
        [leftImageV setImage:[UIImage imageNamed:@"管理收货地址（编辑）_03.png"]];
        [cell.contentView addSubview:leftImageV];
        
        UILabel *editLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-97, KCellHeghtFloatNew-35, 35, 20)];
        [editLabel setText:@"编辑"];
        editLabel.font = [UIFont systemFontOfSize:14];
        [editLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.7]];
        [cell addSubview:editLabel];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setTag:KEditBtnTag+indexPath.row];
        [editBtn setFrame:CGRectMake(KProjectScreenWidth-115, 105, 50, 35)];
        editBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:editBtn];
        
        UIImageView *deleteImageV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-62, KCellHeghtFloatNew-33, 16, 16)];
        [deleteImageV setImage:[UIImage imageNamed:@"管理收货地址（删除）_03.png"]];
        [cell.contentView addSubview:deleteImageV];
        
        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-44, KCellHeghtFloatNew-35, 35, 20)];
        [deleteLabel setText:@"删除"];
        deleteLabel.font = [UIFont systemFontOfSize:14];
        [deleteLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.7]];
        [cell addSubview:deleteLabel];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(KProjectScreenWidth-65, KCellHeghtFloatNew-35, 65, 35)];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn setTag:KDeleteBtnTag+indexPath.row];
        [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
        
        return cell;

    
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEdit) {
        return KCellHeghtFloatNew;
    }else{
        return KCellHeghtFloat;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.isSelectDress) {
        XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
        model.addr = self.addrArr[indexPath.row];
        model.area = self.dressArr[indexPath.row];
        model.addr_id = self.addr_idArr[indexPath.row];
        model.def_addr = [self.def_addrArr[indexPath.row] integerValue];
        model.mobile = self.mobileArr[indexPath.row];
        model.name = self.titleArr[indexPath.row];
        model.area_id = self.area_idArr[indexPath.row];
//        model.isConfirmOrder = YES;
        
        [self huidiao:model];
       
    }

    
}

-(void)huidiao:(XZShoppingOrderAddressModel *)model
{
    if (model) { // 点击每一行地址回调
        if (self.blockAgainBtn) {
            self.blockAgainBtn(model);
        }
    }else { // 点返回键
        if (self.areaArr.count == 0) {// 将所有地址删除
            // 删除部分地址或者直接点击返回键
            XZShoppingOrderAddressModel *modelNodata = [[XZShoppingOrderAddressModel alloc] init];
            if (self.blockAgainBtn) {
                self.blockAgainBtn(modelNodata);
            }
        }else {// 修改了地址或者直接返回
            int index = 0;
            for (int i = 0; i < self.addr_idArr.count; i++) {
                NSString *addr_id = [NSString stringWithFormat:@"%@",self.addr_idArr[i]];
                if ([self.addr_id_address isEqualToString:addr_id]) { // 返回当前传递的地址
                    index = i;
                    // 用户直接点击返回，没有切换地址
                    XZShoppingOrderAddressModel *modelNodata = [[XZShoppingOrderAddressModel alloc] init];
                    modelNodata.addr_id = self.addr_idArr[index];
                    modelNodata.addr = self.addrArr[index];
                    modelNodata.area = self.dressArr[index];
                    modelNodata.def_addr = [self.def_addrArr[index] integerValue];
                    modelNodata.mobile = self.mobileArr[index];
                    modelNodata.name = self.titleArr[index];
                    modelNodata.area_id = self.area_idArr[index];
                    if (self.blockAgainBtn) {
                        self.blockAgainBtn(modelNodata);
                    }
//                   Log(@"返回时的area_id ====== %@,当前model的modelNodata.area_id ==== %@",modelNodata.area_id,self.area_idArr[index]);
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }else {// 前一个页面传递的地址被删除,确认订单显示“请选择地址”
                    XZShoppingOrderAddressModel *modelNodata = [[XZShoppingOrderAddressModel alloc] init];
                    if (self.blockAgainBtn) {
                        self.blockAgainBtn(modelNodata);
                    }
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑
-(void)edit:(UIButton *)button{
    //tag 1000
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:button];
    [self performSelector:@selector(todoSomething:) withObject:button afterDelay:0.2f];

}

- (void)todoSomething:(UIButton *)button
{
    //在这里做按钮的想做的事情。
    AddNewDressViewController *dressVC = [[AddNewDressViewController alloc]init];
    dressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dressVC animated:YES];
    dressVC.isNewDress = NO;
    dressVC.name = self.titleArr[button.tag-KEditBtnTag];
    dressVC.userPhoneNumber = self.mobileArr[button.tag-KEditBtnTag];
    dressVC.dress = self.dressArr[button.tag-KEditBtnTag];
    dressVC.addr_id = self.addr_idArr[button.tag-KEditBtnTag];
    dressVC.zip = self.zipArr[button.tag-KEditBtnTag];
    dressVC.addr = self.addrArr[button.tag-KEditBtnTag];
    if (self.numberOfRow == button.tag-KEditBtnTag) {
        dressVC.isMoren = YES;
    }
}

//删除
-(void)delete:(UIButton *)button{
    //tag 10000
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingElse:) object:button];
    [self performSelector:@selector(todoSomethingElse:) withObject:button afterDelay:0.2f];
    

}

-(void)todoSomethingElse:(UIButton *)button{

    SignOnDeleteView *signView = [[SignOnDeleteView alloc]init];
    [signView showSignViewWithTitle:@"确认删除该地址么？" detail:@"删除地址后就无法恢复该地址了"];
    signView.deleteBlock = ^(UIButton *asbutton) {
        
        
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        
        Log(@"00000    %ld",(long)button.tag);
        NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-del_rec_client.html?addr_id=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",self.addr_idArr[button.tag-KDeleteBtnTag],[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
        
        __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    NSString *msg = [response.responseObject objectForKey:@"msg"];
                    NSString *data = [response.responseObject objectForKey:@"data"];
                    
                    Log(@"******msg:%@",msg);
                    Log(@"******msg:%@",data);
                    [self getDataFromNetWork];
                    
                }
                else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                    
                }
            });
        }];
    };

}


//设为默认
-(void)bottomSelectAction:(UIButton *)button{
    

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-save_rec_client.html?&tel=%@&appid=huiyuan&from=rongtuoapp&shijian=%d&token=%@&user_id=%@&tel=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,timestamp,tokenlow,[CurrentUserInformation sharedCurrentUserInfo].userId,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    Log(@"***%@",string);

//    post
    NSDictionary * parameter = @{@"phone":@"",@"zip":@"",@"addr":self.addrArr[button.tag],@"addr_id":self.addr_idArr[button.tag],@"area":self.areaArr[button.tag],@"def_addr":@"1",@"name":self.titleArr[button.tag],@"mobile":self.mobileArr[button.tag]};
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
         
                [self getDataFromNetWork];
                ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
            }
        }else {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
        }
    }];

}


- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

- (NSArray *)phoneNumberArr {
    if (!_phoneNumberArr) {
        _phoneNumberArr = [[NSMutableArray alloc]init];;
    }
    return _phoneNumberArr;
}

-(NSArray *)areaArr{
    
    if (!_areaArr) {
        _areaArr = [[NSMutableArray alloc]init];
    }
    return _areaArr;
    
}

- (NSMutableArray *)area_idArr {
    if (!_area_idArr) {
        _area_idArr = [[NSMutableArray alloc]init];
    }
    return _area_idArr;
}

-(NSArray *)addrArr{
    
    if (!_addrArr) {
        _addrArr = [[NSMutableArray alloc]init];
    }
    return _addrArr;
}


-(NSArray *)dressArr{
    
    if (!_dressArr) {
        _dressArr = [[NSMutableArray alloc]init];
    }
    return _dressArr;
}

-(NSArray *)addr_idArr{
    
    if (!_addr_idArr) {
        _addr_idArr = [[NSMutableArray alloc]init];
    }
    return _addr_idArr;
}

- (NSArray *)mobileArr {
    if (!_mobileArr) {
        _mobileArr = [[NSMutableArray alloc]init];
    }
    return _mobileArr;
}



- (NSArray *)def_addrArr {
    if (!_def_addrArr) {
        _def_addrArr = [[NSMutableArray alloc]init];
    }
    return _def_addrArr;
}

-(void)createTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-104) style:UITableViewStylePlain];
    // 设置背景色
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)createRightBtn{
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"管理"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(callModalList)];
    
    rightButton.tintColor=[HXColor colorWithHexString:@"#333333"];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void)createNewRightBtn{
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    
    rightButton.tintColor=[HXColor colorWithHexString:@"#333333"];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}


@end
