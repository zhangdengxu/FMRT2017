//
//  XZRongMiPersonalDataController.m
//  fmapp
//
//  Created by admin on 16/11/26.
//  Copyright © 2016年 yk. All rights reserved.
//  融米俱乐部个人资料

#import "XZRongMiPersonalDataController.h"
#import "SelectDressViewController.h" // 我的收货地址
#import "ChangeNameView.h"

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
// 用户头像
#define XZRongMiClubUserIconURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/commoninfochangliu"

@interface XZRongMiPersonalDataController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ChangeViewDelegate>
// 头像
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@property (nonatomic, strong) NSString *imageFilePath;
@property (nonatomic, strong) NSData *dataOne;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
// 昵称
@property (nonatomic, strong) UILabel *labelUserNickName;
// 是否请求头像数据
@property (nonatomic, assign) BOOL isRequestIcon;
@end

@implementation XZRongMiPersonalDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZBackGroundColor;
    //
    [self settingNavTitle:@"个人资料"];
    //
    [self createPersonaDataView];
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        // 请求用户头像
        [self getUserIconFromNetWork];
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
    }else { // 500 我的收货地址
        SelectDressViewController *address = [[SelectDressViewController alloc] init];
        address.naviTitleName = @"我的收货地址";
        [self.navigationController pushViewController:address animated:YES];
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
//        NSLog(@"上传头像======%@",response.responseObject);
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
        make.top.equalTo(weakSelf.view).offset(1);
        make.height.equalTo(@50);
    }];
    viewIcon.backgroundColor = [UIColor whiteColor];
    
    // "头像"
    [self createLabelWithSuperView:viewIcon leftView:viewIcon text:@"头像" color:[UIColor blackColor] isFirst:YES];
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
    UILabel *labelUserName = [self createLabelWithSuperView:viewUserName leftView:viewUserName text:@"用户名" color:[UIColor blackColor] isFirst:YES];
    // ”手机号“
    [self createLabelWithSuperView:viewUserName leftView:labelUserName text:[CurrentUserInformation sharedCurrentUserInfo].personName color:[UIColor darkGrayColor] isFirst:NO];
    
    // 昵称
    UIView *viewNickName = [[UIView alloc] init];
    [self.view addSubview:viewNickName];
    [viewNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewUserName.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewNickName.backgroundColor = [UIColor whiteColor];
    // ”昵称“
    UILabel *labelNickName =  [self createLabelWithSuperView:viewNickName leftView:viewNickName text:@"昵称" color:[UIColor blackColor] isFirst:YES];
   UILabel *labelUserNickName =  [self createLabelWithSuperView:viewNickName leftView:labelNickName text:@"" color:[UIColor darkGrayColor] isFirst:NO];
    self.labelUserNickName = labelUserNickName;
    // 箭头
    [self createArrowWithSuperView:viewNickName];
    // btnIcon
    [self createButtonWithSuperView:viewNickName btnTag:400];
    // 我的收货地址
    UIView *viewAddress = [[UIView alloc] init];
    [self.view addSubview:viewAddress];
    [viewAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(viewNickName.mas_bottom).offset(1);
        make.height.equalTo(@50);
    }];
    viewAddress.backgroundColor = [UIColor whiteColor];
    
    // ”我的收货地址“
    [self createLabelWithSuperView:viewAddress leftView:viewAddress text:@"我的收货地址" color:[UIColor blackColor] isFirst:YES];
    // 箭头
    [self createArrowWithSuperView:viewAddress];
    // btnIcon
    [self createButtonWithSuperView:viewAddress btnTag:500];
}

// 创建左侧label
- (UILabel *)createLabelWithSuperView:(UIView *)superV leftView:(UIView *)leftView text:(NSString *)text color:(UIColor *)color isFirst:(BOOL)isFirst {
    UILabel *label = [[UILabel alloc] init];
    [superV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isFirst) {
            make.left.equalTo(leftView).offset(10);
        }else{
            make.left.equalTo(leftView.mas_right).offset(10);
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
- (void)createButtonWithSuperView:(UIView *)superView btnTag:(NSInteger)btnTag {
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
