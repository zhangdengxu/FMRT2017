//
//  XZPublishCommentViewController.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 yuyang. All rights reserved.
//


#import "XZPublishCommentViewController.h"
#import "XZPublishCommentView.h"
#import "TZImagePickerController.h"
#import "XZTestCell.h"
#import "XZChoosePictureWayView.h"
#import "TZAssetModel.h"
#import "XZTextView.h"
#import "AXRatingView.h"
#import "SignOnDeleteView.h"
// 提交订单

//#import "AFNetworking.h"

#import "XZMyOrderGoodsModel.h"
#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"
#import "FMRTWellStoreViewController.h"

@interface XZPublishCommentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,FMMessageAlterViewDelegate>
@property (nonatomic, strong) XZPublishCommentView *comment;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSString *imageFilePath;
/** 评价内容 */
@property (nonatomic, strong) NSString *commentContent;
@end

@implementation XZPublishCommentViewController
-(void)setSendModel:(XZMyOrderGoodsModel *)sendModel
{
    _sendModel = sendModel;
}

- (void)loadView {
    [super loadView];
    self.comment = [[XZPublishCommentView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.comment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comment.collectionView.dataSource = self;
    self.comment.collectionView.delegate = self;
    [self.comment.collectionView registerClass:[XZTestCell class] forCellWithReuseIdentifier:@"PublishComment"];
    __weak typeof(self)weakSelf = self;
    self.comment.blockCommentBtn = ^(UIButton *button) {
        if (button.tag == 207) {
            
            [weakSelf didClickCommentButton];
        }else {
            [weakSelf didClickAnonymousCommentButton:button];
        }
    };
    // 设置textView的代理
    self.comment.textComment.delegate = self;
    [self settingNavTitle:@"我的评价"];
    // 返回
    self.navBackButtonRespondBlock = ^() {
        [weakSelf.comment.textComment resignFirstResponder];
        [weakSelf didClickBackButton];
    };
    //创建右上角消息按钮
    [self setNavItemsWithButton];
}

// 点击了返回按钮
- (void)didClickBackButton {
    
    SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
    [signOn showSignViewWithTitle:@"提示" detail:@"亲,追加评价还未完成,您确定离开么？"];
    __weak typeof(self)weakSelf = self;
    // 点击确定按钮返回我的订单界面
    signOn.sureBlock = ^(UIButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

// 给图片赋值
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.comment.sendModel = self.sendModel;
}

#pragma mark --- 点击了按钮
// 点击发表评价按钮
- (void)didClickCommentButton {
    if (self.commentContent.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请写下您的评价!");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary *parameter = @{@"goods_id":self.sendModel.gid,
                                 @"product_id":self.sendModel.product_id,
                                 @"order_id":self.sendModel.order_id,
                                 @"point_type[1][point]":[NSNumber numberWithInt:(int)self.comment.halfStepRatingView.value],
                                 @"point_type[2][point]":[NSNumber numberWithInt:(int)self.comment.speedView.value],
                                 @"point_type[3][point]":[NSNumber numberWithInt:(int)self.comment.serviceView.value],
                                 @"comment":[NSString stringWithFormat:@"%@",self.commentContent],
                                 @"response_json":[NSNumber numberWithInt:1]};
    
    NSString * httpUel = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/comment-toComment_client-discuss.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    __weak __typeof(&*self)weakSelf = self;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient startMultiPartUploadTaskWithURL:httpUel imagesArray:self.selectedPhotos parameterOfimages:@"file" parametersDict:parameter compressionRatio:1.0f succeedBlock:^(id operation, id responseObject) {
        
        [hud hide:YES];
        Log(@"评价失败%@",responseObject);
        NSDictionary * data = (NSDictionary *)responseObject;
        NSNumber * statusNum = data[@"status"];
        if ([statusNum integerValue] == 0) {
            //上传成功
            SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
            [signOn showSignViewNoButtonWithTitle:@"提示" detail:@"评价成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [signOn hiddenSignView];
                // 返回
                [weakSelf sendCommentSucceed];
            });
        }else
        {
            //上传失败
            ShowAutoHideMBProgressHUD(self.view, @"评价失败");
        }
        
    } failedBlock:^(id operation, NSError *error) {
        [hud hide:YES];
        ShowAutoHideMBProgressHUD(weakSelf.view, @"评价失败");
        
    } uploadProgressBlock:^(float uploadPercent, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

-(void)sendCommentSucceed
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击了匿名评价
- (void)didClickAnonymousCommentButton:(UIButton *)button {
    Log(@"匿名评价,%d",button.selected);
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count < 3) {
        return self.selectedPhotos.count + 1;
    }else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishComment" forIndexPath:indexPath];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"发表评价相机"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
    }else {
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.deleteBtn.hidden = NO;
    }
    __weak __typeof(&*self)weakSelf = self;
    cell.blockDelete = ^(UIButton *button) {
        [_selectedPhotos removeObjectAtIndex:indexPath.item];
        [_selectedAssets removeObjectAtIndex:indexPath.item];
        [weakSelf.comment.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [self.comment.textComment resignFirstResponder];
    __weak typeof(self)weakSelf = self;
    if (self.selectedPhotos.count < 3) {
        XZChoosePictureWayView *choosePicture = [[XZChoosePictureWayView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [choosePicture setWayViewWithFirstButtonTitle:@"拍照" secondButtonTitle:@"相册" withLabelPrompt:[NSString stringWithFormat:@"亲，您还可以上传%ld张图片",(long)(3 - self.selectedPhotos.count)]];
        [self.view addSubview:choosePicture];
        __weak typeof(choosePicture)weakCP = choosePicture;
        choosePicture.blockChoosePictureBtn = ^(UIButton * button) {
            if (button.tag == 301) {
                [self takePicture];
                [weakCP removeFromSuperview];
            }else if (button.tag == 302) {
                if (indexPath.row == _selectedPhotos.count) { [self pickPhotoButtonClick:nil];}
                [weakCP removeFromSuperview];
            }else {
                [weakCP removeFromSuperview];
            }
        };
    }else {
        // 提示请删除一张再重新选;
        ShowAutoHideMBProgressHUD(weakSelf.view,@"请删除一张再重新选");
    }
}

// 拍照
- (void)takePicture {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerVc = [[UIImagePickerController alloc] init];
        self.imagePickerVc.delegate = self;
        // 设置拍照后的图片可被编辑
        self.imagePickerVc.allowsEditing = YES;
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    }else
    {
        Log(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
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
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image3.png"] contents:data attributes:nil];
            //得到选择后沙盒中图片的完整路径
            NSString * imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image3.png"];
            self.imageFilePath = imageFilePath;
        }
        //处理本地图像
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:self.imageFilePath];
        [_selectedPhotos addObject:savedImage];
        [self.comment.collectionView reloadData];
        [self.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }
}

// 取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 点击从相册选择图片
- (void)pickPhotoButtonClick:(UIButton *)sender {
    NSInteger maxCount;
    if (self.selectedPhotos.count == 0) {
        maxCount = 3;
    }else {
        maxCount = 3 - self.selectedPhotos.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.selectedAssets = _selectedAssets; // optional
    // You can get the photos by block, the same as by delegate.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    [self.comment.collectionView reloadData];
//    NSLog(@"%@",_selectedPhotos);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *contentString;
    if (text.length == 0 ) {
        if (textView.text.length > 0) {
            contentString = [textView.text substringToIndex:textView.text.length - 1];
        }else
        {
            contentString = nil;
        }
    }else{
        contentString = [NSString stringWithFormat:@"%@%@",textView.text,text];
    }
    
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
//    //禁止输入emoji表情
//    if ([NSString stringContainsEmoji:text]) {
//        return NO;
//    }
    
    self.commentContent = contentString;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.commentContent = textView.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setNavItemsWithButton {
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame =CGRectMake(0, 0, 30, 30);
    [messageButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(moreItemAction:) forControlEvents: UIControlEventTouchUpInside];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame =CGRectMake(0, 0, 30, 30);
    [editButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(searchItemAction:) forControlEvents: UIControlEventTouchUpInside];
    editButton.hidden = YES;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    [self.navigationItem setRightBarButtonItems:@[navItem,titleItem] animated:YES];
}

- (void)searchItemAction:(UIButton *)sender {
    Log(@"点击了搜索按钮");
}

- (void)moreItemAction:(UIButton *)sender {
    FMMessageModel *one = [[FMMessageModel alloc] initWithTitle:@"消息" imageName:@"优商城消息-消息04" isShowRed:NO];
    FMMessageModel *two = [[FMMessageModel alloc] initWithTitle:@"首页" imageName:@"优商城消息-消息03"  isShowRed:NO];
    NSArray * dataArr = @[one, two];
    
    __block  FMMessageAlterView * messageAlter = [[FMMessageAlterView alloc] initWithDataArray:dataArr origin:CGPointMake(KProjectScreenWidth - 15, 64) width:100 height:40 direction:kFMMessageAlterViewDirectionRight];
    messageAlter.delegate = self;
    messageAlter.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        messageAlter = nil;
    };
    [messageAlter pop];
}

- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row == 0) {
        
        WLMessageViewController *wlVc = [[WLMessageViewController alloc]init];
        wlVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wlVc animated:YES];
    }else
    {
        FMRTWellStoreViewController * rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
        }
    }
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

@end

