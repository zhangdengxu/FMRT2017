//
//  AddNewDressViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "AddNewDressViewController.h"
#import "DressTableViewController.h"
#import "HTTPClient+Interaction.h"
#import "SignOnDeleteView.h"
#import "SelectDressViewController.h"
#import "FMKeyBoardNumberHeader.h"
#define KReuseCellId @"SetUpTableVControllerCell"
#define KCellHeghtFloat 45

@interface AddNewDressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) NSArray *titleArr;
@property (nonatomic, weak) NSString *clearCacheSize ;
@property (nonatomic, weak) UILabel *cacheLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *isSelectBtn;

@property (nonatomic, weak) UITextField *receiver;//收货人
@property (nonatomic, weak) UITextField *phoneNumber;//联系电话
@property (nonatomic,strong) UITextView *detailDress;//详细地址
@property (nonatomic,strong) UILabel *uilabel;
@property (nonatomic,strong) UILabel *cityLabel;//所在地区
@property (nonatomic,strong) UILabel *streetLabel;//街道
@property (nonatomic,strong) NSString *cityName;//街道

@end

@implementation AddNewDressViewController

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"收货人",@"联系电话",@"所在地区",@"",@"", nil];
    }
    return _titleArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightBtn];
    [self createTabelView];
    [self settingNavTitle:@"我的收货地址"];
}

-(void)createRightBtn{

    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"保存"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(callModalList:)];
    
    rightButton.tintColor=[HXColor colorWithHexString:@"#333333"];
    self.navigationItem.rightBarButtonItem = rightButton;

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

#pragma mark ---- UITextView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.uilabel.text = @"详细地址";
    }else{
        self.uilabel.text = @"";
    } 
}

#pragma mark ---- Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseCellId forIndexPath:indexPath];
    NSString *text = self.titleArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",text];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    
    if (2==indexPath.row) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-235, 0, 200, 45)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"请选择";
        label.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
        [cell.contentView addSubview:label];
        self.cityLabel = label;
        if (self.dress) {
            
            [self.cityLabel setText:[self replacingString:self.dress]];
            
        }
    }
    
    if (indexPath.row == 0) {
        UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, KProjectScreenWidth-115, 35)];
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.keyboardType = UIKeyboardTypeDefault;
        textField1.delegate = self;
        [cell.contentView addSubview:textField1];
        self.receiver = textField1;
        self.receiver.text = self.name;
    }
    if (indexPath.row == 1) {
        UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, KProjectScreenWidth-115, 35)];
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.keyboardType = UIKeyboardTypePhonePad;
        [cell.contentView addSubview:textField1];
        textField1.delegate = self;
        self.phoneNumber = textField1;
        self.phoneNumber.text = self.userPhoneNumber;
        __weak __typeof(&*self)weakSelf = self;
        self.phoneNumber.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
            [weakSelf keyBoardDown];
        }];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row<3) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KCellHeghtFloat - 1, KProjectScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(231/255.0) blue:(232/255.0) alpha:1];
        [cell.contentView addSubview:lineView];
        [cell.contentView bringSubviewToFront:lineView];
    }
    
    if (indexPath.row == 3) {
        UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, KProjectScreenWidth-10, 110)];
        textview.backgroundColor=[UIColor whiteColor];
        textview.scrollEnabled = NO;
        textview.editable = YES;
        textview.delegate = self;
        textview.font=[UIFont fontWithName:@"Arial" size:18.0];
        textview.keyboardType = UIKeyboardTypeDefault;
        textview.dataDetectorTypes = UIDataDetectorTypeAll;
        [cell.contentView addSubview:textview];
        self.detailDress = textview;
        if (self.addr) {
            if ([self.addr length]>0) {
                
                self.detailDress.text = self.addr;

            }
        }
        self.uilabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, textview.frame.size.width, 20)];
        self.uilabel.text = @"详细地址";
        self.uilabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
        self.uilabel.enabled = NO;
        self.uilabel.backgroundColor = [UIColor clearColor];
        if (self.detailDress.text.length == 0) {
            self.uilabel.text = @"详细地址";
        }else{
            self.uilabel.text = @"";
        }
        [cell.contentView addSubview:self.uilabel];
    }
    if (indexPath.row == 4) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 5)];
        lineView.backgroundColor = KDefaultOrBackgroundColor;
        [cell.contentView addSubview:lineView];
        if (self.isNewDress) {
            
            cell.textLabel.text = @"设为默认地址";
            UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [slectCtn setFrame:CGRectMake(KProjectScreenWidth-30, 15, 20, 20)];
            [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮灰）_03.png"] forState:UIControlStateNormal];
            [slectCtn setImage:[UIImage imageNamed:@"管理收货地址（默认按钮橙）_03.png"] forState:UIControlStateSelected];
            [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [slectCtn setSelected:NO];
            [cell.contentView addSubview:slectCtn];
            self.isSelectBtn = slectCtn;
        }else{
        
           cell.textLabel.text = @"删除地址";
            cell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1];
            
        }
    }
    return cell;
}

-(void)keyBoardDown{

    [self.phoneNumber resignFirstResponder];
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

-(void)bottomSelectAction:(UIButton *)button{

    button.selected=!button.selected;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        
        return 120;
    }else if (indexPath.row == 4){
    
        return KCellHeghtFloat+5;
    }
    return KCellHeghtFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.receiver resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.detailDress resignFirstResponder];
    
    switch (indexPath.row) {

        case 2:
        {
            /**
             *选择地址
             */
            DressTableViewController *dressV = [[DressTableViewController alloc]initWithStyle:UITableViewStylePlain];
            dressV.blockWithDress = ^(NSString *string1,NSString *string2,NSString *string3,NSString *string4){
            
                self.cityLabel.text = [NSString stringWithFormat:@"%@ %@ %@",string1,string2,string3];
                self.cityName = [NSString stringWithFormat:@"mainland:%@/%@/%@:%@",string1,string2,string3,string4];
            };
            dressV.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dressV animated:YES];
            break;
        }

        case 4:
        {
            if (self.isNewDress) {
                
            }else{
                /**
                 *设为默认
                 */
                SignOnDeleteView *signView = [[SignOnDeleteView alloc]init];
                [signView showSignViewWithTitle:@"确认删除该地址么？" detail:@"删除地址后就无法恢复该地址了"];
                signView.deleteBlock = ^(UIButton *button) {

                    int timestamp = [[NSDate date]timeIntervalSince1970];
                    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
                    NSString *tokenlow=[token lowercaseString];
                    
                    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-del_rec_client.html?addr_id=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",self.addr_id,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
                    
                    __weak __typeof(&*self)weakSelf = self;
                    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            if (response.code==WebAPIResponseCodeSuccess) {
                                
                                ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                NSNotification * notice = [NSNotification notificationWithName:@"deleteAddress" object:nil userInfo:nil];
                                
                                [[NSNotificationCenter defaultCenter]postNotification:notice];
                            }
                            else
                            {
                                ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
                                
                            }
                        });
                    }];

                };

            }
            break;
        }
        default:
            break;
    }

}

/**
 *保存
 */
-(void)callModalList:(UIBarButtonItem *)button{

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:button];
    [self performSelector:@selector(todoSomething:) withObject:button afterDelay:0.2f];
    
}


-(void)todoSomething:(UIBarButtonItem *)button{

    /**
     *
     addr_id
     area
     addr
     name
     zip
     phone
     mobile
     def_addr
     */
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *isSelected = @"";
    if (self.isSelectBtn) {
        
        isSelected = self.isSelectBtn.selected?@"1":@"0";
    }
    if (self.isMoren) {
        isSelected = @"1";
    }
    NSString *dressId = @"";
    if (self.addr_id) {
        dressId = self.addr_id;
    }
    
    NSString *cityName = @"";
    
    if (self.cityName) {
        if ([self.cityName length]>0) {
            cityName = self.cityName;
            
        }
    }else{
        if (self.dress) {
            cityName = self.dress;
        }
    }
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-save_rec_client.html?appid=huiyuan&from=rongtuoapp&shijian=%d&token=%@&user_id=%@&tel=%@",timestamp,tokenlow,[CurrentUserInformation sharedCurrentUserInfo].userId,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    
    NSDictionary * parameter = @{@"zip":@"",@"tel":@"",@"addr":self.detailDress.text,@"addr_id":dressId,@"area":cityName,@"def_addr":isSelected,@"name":self.receiver.text,@"mobile":self.phoneNumber.text};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                
                SelectDressViewController *VC = [[SelectDressViewController alloc]init];
                VC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                NSNotification * theNotice = [NSNotification notificationWithName:@"Address" object:nil userInfo:nil];
                
                [[NSNotificationCenter defaultCenter]postNotification:theNotice];
            }
            ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
        }else {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
        }
    }];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}


@end
