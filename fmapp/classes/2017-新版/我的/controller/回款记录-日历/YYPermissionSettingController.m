//
//  YYPermissionSettingController.m
//  fmapp
//
//  Created by yushibo on 2017/3/1.
//  Copyright © 2017年 yk. All rights reserved.
//  推荐权限设置

#import "YYPermissionSettingController.h"
#import "YYPermissionSettingCell.h"
#import "YYPermissionSettingModel.h"
#import "FMKeyBoardNumberHeader.h"
#import "RegexKitLite.h"
@interface YYPermissionSettingController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
/**  好友手机号 */
@property (nonatomic,strong) UITextField *phoneText;
/**  推荐系数数组 */
@property (nonatomic,strong) NSArray *jurisdictionArray;
/**  所选推荐系数 */
@property (nonatomic, strong) NSString *beTitle;
@end

@implementation YYPermissionSettingController

#pragma mark --  懒加载
-(NSArray *)jurisdictionArray{

    if (!_jurisdictionArray) {
        _jurisdictionArray = [NSArray array];
        
    }
    return _jurisdictionArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self settingNavTitle:@"设置"];
    [self setupTableView];

    [self requestDatatoCollectionView];
    
//    /**  回收键盘  */
//    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.tableView.tableFooterView addGestureRecognizer:singleTap];
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.tableView.tableHeaderView endEditing:YES];
    
}

#pragma mark --  权限系数网络请求
- (void)requestDatatoCollectionView{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow
                                 
                                 };
    
    
    FMWeakSelf;
    //NSString * seleString = kXZUniversalTestUrl(@"MyRecommendationAuthority");
    NSString * seleString = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/mypowfit");
    [FMHTTPClient postPath:seleString parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (!response.responseObject) {
            
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据错误");
        }else{
            
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSArray *dataArr = response.responseObject[@"data"];
                if ([dataArr isKindOfClass:[NSNull class]]){
                   
                }else{

                    self.jurisdictionArray = dataArr;
              //      NSLog(@"%lu", (unsigned long)self.jurisdictionArray.count);
               //     NSLog(@"%@",self.jurisdictionArray);

                    self.beTitle = self.jurisdictionArray[0];
               //     NSLog(@"%@",self.beTitle);
                    
                }
                
            }else{
                
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据错误");
                
            }
            
        }

        [self.tableView reloadData];

    }];
}
#pragma mark --- 创建 UITableView
- (void)setupTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self setupTableHeaderView];
    self.tableView.tableFooterView = [self setupTableFooterView];
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- 创建 tableHeaderView
- (UIView *)setupTableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 54)];
    headerView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    [headerView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(7);
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView.mas_bottom).offset(-1);
    }];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"好友手机号:";
    leftLabel.font = [UIFont systemFontOfSize:17];
    leftLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [backView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(10);

    }];
    
    
    UITextField *phoneText = [[UITextField alloc]init];
    phoneText.textColor = [HXColor colorWithHexString:@"#333333"];
    [phoneText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [phoneText setReturnKeyType:UIReturnKeyNext];
    [phoneText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [phoneText setFont:[UIFont systemFontOfSize:18.0f]];
    [phoneText setBorderStyle:UITextBorderStyleNone];
    [phoneText setPlaceholder:@"请输入好友手机号"];
    [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    [phoneText setDelegate:self];
     __weak __typeof(&*self)weakSelf = self;
    phoneText.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    
    [phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneText=phoneText;
    [backView addSubview:phoneText];
    [phoneText makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(leftLabel.mas_right).offset(8);
    }];
    
    return headerView;
    
}
-(void)keyBoardDown
{
    [self.view endEditing:YES];
}
- (void)textFieldDidChange:(UITextField *)textField
{

    if (textField == self.phoneText) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark --- 创建 tableFooterView 和 确认按钮点击
- (UIView *)setupTableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 130)];
    footerView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    UIButton *commitBtn = [[UIButton alloc]init];
    [commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [commitBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn.layer setMasksToBounds:YES];
    [commitBtn.layer setCornerRadius:2.0f];
    commitBtn.backgroundColor = [HXColor colorWithHexString:@"0159d5"];
    [footerView addSubview:commitBtn];
    
    [commitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(40);
        make.left.equalTo(footerView.mas_left).offset(15);
        make.right.equalTo(footerView.mas_right).offset(-15);
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    
    return footerView;
    
}
- (void)commitBtnClick{

 //   NSLog(@"%s",__func__);

    if ((self.phoneText.text.length == 11) && ([self.phoneText.text isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"])) {
        [self commitDataToServer];
    }else{
    
        ShowAutoHideMBProgressHUD(self.view, @"请输入正确手机号");
    }
}

#pragma mark --  确认提交 手机号/推荐权限系数 网络请求

- (void)commitDataToServer{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                             //  @"CmdId":@"SaveSettings",
                                 @"sz_tel":self.phoneText.text,
                                 @"sz_bilv":self.beTitle
                                 };
    FMWeakSelf;
    
    NSString * testUrl = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/savepowfitsetliuer");

    [FMHTTPClient postPath:testUrl parameters:parameter completion:^(WebAPIResponse *response) {
        

 //   int timestamp = [[NSDate date] timeIntervalSince1970];
 //   NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
  //  NSString *tokenlow=[token lowercaseString];
  //  NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
  //                               @"appid":@"huiyuan",
   //                              @"shijian":[NSNumber numberWithInt:timestamp],
   //                              @"token":tokenlow,
     //                            @"sz_tel":self.phoneText.text,
       //                          @"sz_bilv":self.beTitle
         //                        };
 //   FMWeakSelf;
   // [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/savepowfitset" parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (!response.responseObject) {
            
            ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
        }else{
            
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSArray *dataArr = response.responseObject[@"data"];
                if ([dataArr isKindOfClass:[NSNull class]]){
                    
                }else{
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);

                    
                }
                
            }else{
                
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
                
            }
            
        }
        
    }];
}

#pragma mark --  UITableView 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

#pragma mark --  UITableView 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID1 = @"YYPermissionSettingCell";
    
    YYPermissionSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YYPermissionSettingCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataSource = self.jurisdictionArray;
    FMWeakSelf;
    cell.modelBlock = ^(NSString *title){
        weakSelf.beTitle = title;

    };
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 //   NSLog(@"%s",__func__);

    [tableView.tableHeaderView endEditing:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.jurisdictionArray.count) {
        return (int)ceilf(self.jurisdictionArray.count / 2) *60;
    }else{
    
        return 60;
    }
}
@end
