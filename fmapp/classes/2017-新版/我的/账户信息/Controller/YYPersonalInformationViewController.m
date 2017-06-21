//
//  YYPersonalInformationViewController.m
//  fmapp
//
//  Created by yushibo on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//  账户信息 ---个人信息

#import "YYPersonalInformationViewController.h"
#import "SelectDressViewController.h" // 我的收货地址
#import "ChangeNameView.h"
#import "FMTieBankCardViewController.h"
#import "ShareViewController.h"

#import "RegexKitLite.h"
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
// 用户头像
#define XZRongMiClubUserIconURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/commoninfochangliu"
@interface YYPersonalInformationViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, ChangeViewDelegate>

// 头像
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic,strong) UIActionSheet *myActionSheet;
@property (nonatomic,copy) NSString *imageFilePath;
@property (nonatomic, strong) NSData *dataOne;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
// 昵称
@property (nonatomic, strong) UILabel *labelUserNickName;
// 是否请求头像数据
@property (nonatomic, assign) BOOL isRequestIcon;
/** 是否实名 显示 */
@property (nonatomic, strong) UILabel *labelUserReallyName;
/** 未实名箭头是否显示 */
@property (nonatomic, strong) UIImageView *jiantou;
/** 未实名点击button 是否显示 */
@property (nonatomic, strong) UIButton *shimingBtn;
@end

@implementation YYPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self settingNavTitle:@"个人信息"];
    //
    [self createPersonaDataView];
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        // 请求用户头像
        [self getUserIconFromNetWork];
    }
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [[CurrentUserInformation sharedCurrentUserInfo]checkUserInfoWithNetWork];
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
        
        NSString *originname = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
    //    NSLog(@"%@",originname);
        NSString *reallyName = [originname stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        
        self.labelUserReallyName.text = reallyName;
        self.labelUserReallyName.textColor = [HXColor colorWithHexString:@"#666666"];
        self.jiantou.hidden = YES;
        self.shimingBtn.hidden = YES;
        
        
    }else{

        self.labelUserReallyName.text = @"未实名 ";
        self.labelUserReallyName.textColor = [HXColor colorWithHexString:@"#ff6633"];
        self.jiantou.hidden = NO;
        self.shimingBtn.hidden = NO;

    }


}
#pragma mark ---- 请求用户头像数据
- (void)getUserIconFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"appid":@"huiyuan",
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient getPath:XZRongMiClubUserIconURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //        NSLog(@"个人资料头像数据----%@",response.responseObject);
        if (response.code == WebAPIResponseCodeFailed) {
            NSDictionary *data = response.responseObject[@"data"];
            NSString *userIcon = [NSString stringWithFormat:@"%@",data[@"avatar"]];
            [weakSelf.imgIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userIcon]] placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            weakSelf.labelUserNickName.text = [NSString stringWithFormat:@"%@",data[@"nickname"]];
        }
    }];
}

- (void)didClickButton:(UIButton *)button {
    if (button.tag == 300) { // 头像
        [self openMenu];
    }else if(button.tag == 400){ // 昵称
        //   变更昵称
        ChangeNameView *changeView = [[ChangeNameView alloc]init];
        changeView.delegate = self;
        [changeView showSignView];
    }else if(button.tag == 500){ // 500 我的收货地址
        SelectDressViewController *address = [[SelectDressViewController alloc] init];
        address.naviTitleName = @"我的收货地址";
        [self.navigationController pushViewController:address animated:YES];
    }else{ //600 实名认证
    
        FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
        tieBank.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tieBank animated:YES];

    }
}

#pragma mark ---- 改变昵称ChangeNameViewDelegate
-(void)ChangeNameViewDidChange:(ChangeNameView *)changeView WithContentString:(NSString *)text;
{
    // 修改本地存储的昵称
    [CurrentUserInformation sharedCurrentUserInfo].userName = [NSString stringWithFormat:@"%@",text];
    [CurrentUserInformation saveUserObjectWithUser:[CurrentUserInformation sharedCurrentUserInfo]];
    self.labelUserNickName.text = text;
}

#pragma mark ---- 打开相册
-(void)openMenu{
    //在这里呼出下方菜单按钮项
    _myActionSheet = [[UIActionSheet alloc]
                      
                      initWithTitle:nil
                      
                      delegate:self
                      
                      cancelButtonTitle:@"取消"
                      
                      destructiveButtonTitle:nil
                      
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    
    if (buttonIndex == _myActionSheet.cancelButtonIndex)
    {
        
    }
    switch (buttonIndex)
    {
        case 0:  // 打开照相机拍照
            [self takePhoto];
            break;
        case 1:  // 打开本地相册
            [self LocalPhoto];
            break;
    }
    
}

#pragma mark --- 拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    }else
    {
        Log(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark --- 打开本地相册
-(void)LocalPhoto
{
    self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        if (data) {
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image8.png"] contents:data attributes:nil];
            //得到选择后沙盒中图片的完整路径
            NSString *imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image8.png"];
            self.imageFilePath = imageFilePath;
            
        }
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        self.dataOne = data;
        /**
         *  图片上传服务器
         */
        [self upLoadImage:self.dataOne];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 上传头像
- (void)upLoadImage:(NSData *)data {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameters = @{
                                  @"appid":@"huiyuan",
                                  @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                  @"shijian":[NSNumber numberWithInt:timestamp],
                                  @"token":tokenlow
                                  };
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(&*self)weakSelf = self;
    [[HTTPClient sharedHTTPClient] postPath:kRongmiClub_UploadImage requestImageDataUpload:data imageType:fileName withName:@"avatarUpload" parameters:parameters completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    //    NSLog(@"上传头像======%@",response.responseObject);
        if (response.code == 1) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.responseObject];
            if (dic) {
                if ([dic[@"status"] integerValue] == 1) {
                    if (![dic[@"data"] isKindOfClass:[NSNull class]]) {
                        // 给当前页面头像赋值
                        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:weakSelf.imageFilePath];
                        weakSelf.imgIcon.image = savedImage;
                        // 处理本地图像，当在本机上再次在手势解锁界面可以更新成最新的头像
                        NSString *touxiangUrl = [NSString stringWithFormat:@"%@",dic[@"data"]];
                        if ([touxiangUrl hasPrefix:@"http://"]) {
                            NSString *touxiangSaved = [touxiangUrl substringFromIndex:7];
                            // 存储本地头像
                            [CurrentUserInformation sharedCurrentUserInfo].touxiangsde = [NSString stringWithFormat:@"%@",touxiangSaved];
                            [CurrentUserInformation saveUserObjectWithUser:[CurrentUserInformation sharedCurrentUserInfo]];
                        }
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"上传成功");
                    }
                }
            }
        }else{
            if (response.code == 0) {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"上传失败");
            }
        }
    }];
}

- (void)createPersonaDataView {
    [[UIBarButtonItem appearance] setTintColor:XZColor(51, 51, 51)];
    
    __weak __typeof(&*self)weakSelf = self;
    // 头像栏
    UIView *viewIcon = [[UIView alloc] init];
    [self.view addSubview:viewIcon];
    [viewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(@1);
        make.height.equalTo(@50);
    }];
    viewIcon.backgroundColor = [UIColor whiteColor];
    
    // "头像"
    [self createLabelWithSuperView:viewIcon leftView:viewIcon text:@"头像" color:[HXColor colorWithHexString:@"#333333"] isFirst:YES];
    // 箭头
    UIImageView *imgArrow = [self createArrowWithSuperView:viewIcon];
    // btnIcon
    [self createButtonWithSuperView:viewIcon btnTag:300];
    // 头像图片
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [viewIcon addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgArrow.mas_left).offset(-10);
        make.size.equalTo(@40);
        make.centerY.equalTo(viewIcon);
    }];
    self.imgIcon = imgIcon;
    imgIcon.layer.masksToBounds = YES;
    imgIcon.layer.cornerRadius = 20.0f;
    
    // 用户名
    UIView *viewUserName = [[UIView alloc] init];
    [self.view addSubview:viewUserName];
    [viewUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewIcon.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewUserName.backgroundColor = [UIColor whiteColor];
    // ”用户名“
   [self createLabelWithSuperView:viewUserName leftView:viewUserName text:@"用户名" color:[HXColor colorWithHexString:@"#333333"] isFirst:YES];
    
    NSString *user_name;
    
    // 判断是否为手机号
//    if ([self isPhoneNumber:[CurrentUserInformation sharedCurrentUserInfo].personName]) {
    if([[CurrentUserInformation sharedCurrentUserInfo].personName isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"]){

        user_name = [[CurrentUserInformation sharedCurrentUserInfo].personName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
    }else{
        
        user_name = [CurrentUserInformation sharedCurrentUserInfo].personName;
        
    }

    // ”用户名“
    [self createLabelWithSuperView:viewUserName leftView:viewUserName text:user_name color:[HXColor colorWithHexString:@"#666666"] isFirst:NO];
    
    // 手机号
    UIView *viewPhoneName = [[UIView alloc] init];
    [self.view addSubview:viewPhoneName];
    [viewPhoneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewUserName.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewPhoneName.backgroundColor = [UIColor whiteColor];
    // ”手机号“
    [self createLabelWithSuperView:viewPhoneName leftView:viewPhoneName text:@"手机号" color:[HXColor colorWithHexString:@"#333333"] isFirst:YES];
    NSString *originTel = [CurrentUserInformation sharedCurrentUserInfo].mobile;
    NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [self createLabelWithSuperView:viewPhoneName leftView:viewPhoneName text:tel color:[HXColor colorWithHexString:@"#666666"] isFirst:NO];

    /** 真实姓名专栏 */
    UIView *viewReallyName = [[UIView alloc] init];
    [self.view addSubview:viewReallyName];
    [viewReallyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewPhoneName.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewReallyName.backgroundColor = [UIColor whiteColor];
    // 真是姓名
    

    [self createLabelWithSuperView:viewReallyName leftView:viewReallyName text:@"真实姓名" color:[HXColor colorWithHexString:@"#333333"] isFirst:YES];
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
        
        NSString *originname = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
   //     NSLog(@"%@",originname);
        NSString *reallyName = [originname stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    
        UILabel *labelUserReallyName =  [self createLabelWithSuperView:viewReallyName leftView:viewReallyName text:reallyName color:[HXColor colorWithHexString:@"#666666"] isFirst:NO];
        self.labelUserReallyName = labelUserReallyName;
        
    }else{
        
        UIImageView *jiantou = [self createArrowWithSuperView:viewReallyName];
        self.jiantou = jiantou;
        UILabel *labelUserReallyName =  [self createLabelWithSuperView:viewReallyName leftView:jiantou text:@"未实名 " color:[HXColor colorWithHexString:@"#ff6633"] isFirst:NO];
        // btnIcon
        UIButton *shimingBtn = [self createButtonWithSuperView:viewReallyName btnTag:600];
        self.shimingBtn = shimingBtn;
        self.labelUserReallyName = labelUserReallyName;

    }

   
    

    
    // 我的收货地址
    UIView *viewAddress = [[UIView alloc] init];
    [self.view addSubview:viewAddress];
    [viewAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewReallyName.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewAddress.backgroundColor = [UIColor whiteColor];
    
    // ”我的收货地址“
    [self createLabelWithSuperView:viewAddress leftView:viewAddress text:@"我的地址" color:[HXColor colorWithHexString:@"#333333"] isFirst:YES];
    // 箭头
    [self createArrowWithSuperView:viewAddress];
    // btnIcon
    [self createButtonWithSuperView:viewAddress btnTag:500];
}
#pragma mark --  正则表达式判断是否是手机号

- (BOOL)isPhoneNumber:(NSString *)str {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    NSString * CT = @"^1((33|53|8|7[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
}

// 创建左侧与右侧label
- (UILabel *)createLabelWithSuperView:(UIView *)superV leftView:(UIView *)leftView text:(NSString *)text color:(UIColor *)color isFirst:(BOOL)isFirst {
    UILabel *label = [[UILabel alloc] init];
    [superV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isFirst) {
            make.left.equalTo(leftView).offset(10);
        }else{
            make.right.equalTo(leftView.mas_right).offset(-10);
        }
        make.centerY.equalTo(superV);
    }];
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = color;
    return label;
}

// 创建右侧箭头
- (UIImageView *)createArrowWithSuperView:(UIView *)superView {
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [superView addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView).offset(-10);
        make.centerY.equalTo(superView);
        make.width.equalTo(@(11 * 0.7));
        make.height.equalTo(@(20 * 0.7));
    }];
    imgArrow.image = [UIImage imageNamed:@"新版_右箭头_36"];
    return imgArrow;
}

// 创建button
- (UIButton *)createButtonWithSuperView:(UIView *)superView btnTag:(NSInteger)btnTag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = btnTag;
    return button;
}

#pragma mark --- imagePickerVc
- (UIImagePickerController *)imagePickerVc {
    if (!_imagePickerVc) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // 设置拍照后的图片可被编辑
        _imagePickerVc.allowsEditing = YES;
    }
    return _imagePickerVc;
}

@end
