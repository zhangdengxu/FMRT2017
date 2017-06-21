//
//  XZPublishBaskNewController.m
//  fmapp
//
//  Created by admin on 16/10/28.
//  Copyright © 2016年 yk. All rights reserved.
//  晒单:发表晒单数据

#import "XZPublishBaskNewController.h"
#import "XZTextView.h"
#import "XZTestCell.h"
#import "TZImagePickerController.h"
#import "XZChoosePictureWayView.h"
#import "NSString+Extension.h"


#define kXZBaskOrderUrl [NSString stringWithFormat:@"%@/public/newon/comment/publishComment",kXZTestEnvironment]
//@"http://114.55.115.60:18080/public/newon/comment/publishComment"

@interface XZPublishBaskNewController ()<UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
/** 白色视图 */
@property (nonatomic, strong) UIView *viewWhite;
/** 点击输入标题 */
@property (nonatomic, strong) UITextField *textInputTitle;
/** 评论内容 */
@property (nonatomic, strong) XZTextView *textContent;
/** 晒单图片 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 晒单图片数组 */
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSString *imageFilePath;
/** 晒单题目 */
@property (nonatomic, strong) NSString *titleBaskOrder;
/** 晒单内容 */
@property (nonatomic, strong) NSString *content;
// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XZPublishBaskNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZColor(229, 233, 242);
    //
    [self settingNavTitle:@"晒单"];
    //
    [self createPublishBaskChildView];
    
}

// 点击确认按钮
- (void)didiClickSureButton {
    if (self.titleBaskOrder.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请填写标题");
        return;
    }else if (self.content.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请填写内容");
        return;
    }else if (self.selectedPhotos.count == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请上传图片");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"record_id":self.lucky_record,
                                 @"title":[NSString stringWithFormat:@"%@",self.titleBaskOrder],
                                 @"content":[NSString stringWithFormat:@"%@",self.content],
                                 };
    __weak __typeof(&*self)weakSelf = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient startMultiPartUploadTaskWithURL:kXZBaskOrderUrl imagesArray:self.selectedPhotos imgs:@"imgs" parameterOfimages:@"imgs" parametersDict:parameter compressionRatio:0.85f succeedBlock:^(id operation, id responseObject) {
        [hud hide:YES];
        NSDictionary *data = (NSDictionary *)responseObject;
        NSNumber *statusNum = data[@"status"];
        if ([statusNum integerValue] == 0) {
            //上传成功
            ShowAutoHideMBProgressHUD(weakSelf.view, @"晒单成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            //上传失败
            ShowAutoHideMBProgressHUD(weakSelf.view, @"晒单失败");
        }
        
    } failedBlock:^(id operation, NSError *error) {
        [hud hide:YES];
        ShowAutoHideMBProgressHUD(weakSelf.view, @"晒单失败");
        
    } uploadProgressBlock:^(float uploadPercent, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
}

#pragma mark ----  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self.view endEditing:YES];
    }
}

#pragma mark ---- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *contentString;
    if (string.length == 0 ) {
        if (textField.text.length > 0) {
            contentString = [textField.text substringToIndex:textField.text.length - 1];
        }else
        {
            contentString = nil;
        }
    }else{
        contentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    
    
    //   限制苹果系统输入法  禁止输入表情
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
        
    }
    
    //禁止输入emoji表情
    
    if ([NSString stringContainsEmoji:string]) {
        
        return NO;
        
    }
    
    self.titleBaskOrder = contentString;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleBaskOrder = textField.text;
}

#pragma mark ---- UITextViewDelegate
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
    
    
    //   限制苹果系统输入法  禁止输入表情
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
        
    }
    
    //禁止输入emoji表情
    
    if ([NSString stringContainsEmoji:text]) {
        
        return NO;
        
    }
    self.content = contentString;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.content = textView.text;
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.selectedPhotos.count > 3) {
//        return 3;
//    }
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishBaskNewcell" forIndexPath:indexPath];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.textContent resignFirstResponder];
    __weak typeof(self)weakSelf = self;
    if (self.selectedPhotos.count < 3) {
        XZChoosePictureWayView *choosePicture = [[XZChoosePictureWayView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [choosePicture setWayViewWithFirstButtonTitle:@"拍照" secondButtonTitle:@"相册" withLabelPrompt:[NSString stringWithFormat:@"亲，您还可以上传%ld张图片",(long)(3 - self.selectedPhotos.count)]];
        [self.view addSubview:choosePicture];
        __weak typeof(choosePicture)weakCP = choosePicture;
        choosePicture.blockChoosePictureBtn = ^(UIButton * button) {
            if (button.tag == 301) { // 拍照
                [self takePicture];
                [weakCP removeFromSuperview];
            }else if (button.tag == 302) { // 相册
                if (indexPath.row == _selectedPhotos.count) {
                    [self pickPhotoButtonClick:nil];}
                [weakCP removeFromSuperview];
            }else { // 取消
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
//        NSLog(@"data=============%@",data);
        if (data) {
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image7.png"] contents:data attributes:nil];
            //得到选择后沙盒中图片的完整路径
            NSString * imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image7.png"];
            self.imageFilePath = imageFilePath;
        }
        //处理本地图像
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:self.imageFilePath];
        [_selectedPhotos addObject:savedImage];
        [self.collectionView reloadData];
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
    imagePickerVc.selectedAssets = _selectedAssets;
    // optional
    // You can get the photos by block, the same as by delegate.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    [self.collectionView reloadData];
//    NSLog(@"photos-------%@selectedPhotos-------%@",photos,self.selectedPhotos);
}

#pragma mark ---- 懒加载
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

// 创建子视图
- (void)createPublishBaskChildView {
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.backgroundColor = XZColor(229, 233, 242);
    scrollView.contentSize = CGSizeMake(KProjectScreenWidth - 40, KProjectScreenHeight + 50);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /** 白色视图 */
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 290)];
    [scrollView addSubview:viewWhite];
    viewWhite.backgroundColor = [UIColor whiteColor];
    self.viewWhite = viewWhite;
    
    /** 点击输入标题 */
    UITextField *textInputTitle = [[UITextField alloc] init];
    [viewWhite addSubview:textInputTitle];
    [textInputTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWhite.mas_left); // .offset(10)
        make.top.equalTo(viewWhite.mas_top);
        make.right.equalTo(viewWhite).offset(-10);
        make.height.equalTo(@50);
    }];
    self.textInputTitle = textInputTitle;
    textInputTitle.delegate = self;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = XZColor(153, 153, 153);
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    textInputTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题" attributes:attrs];
    //    textInputTitle.backgroundColor = [UIColor whiteColor];
    // 左侧10个间距
    CGRect frame = textInputTitle.frame;
    frame.size.width = 10;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textInputTitle.leftViewMode = UITextFieldViewModeAlways;
    textInputTitle.leftView = leftview;
    
    UILabel *line1 = [[UILabel alloc] init];
    [viewWhite addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWhite);
        make.right.equalTo(viewWhite);
        make.top.equalTo(textInputTitle.bottom);
        make.height.equalTo(@0.5);
    }];
    line1.backgroundColor = KDefaultOrBackgroundColor;
    
    /** 评论内容*/
    XZTextView *textContent = [[XZTextView alloc]init];
    [scrollView addSubview:textContent];
    [textContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textInputTitle);
        make.right.equalTo(textInputTitle);
        make.top.equalTo(line1.mas_bottom);
        make.height.equalTo(@120);
    }];
    textContent.font = [UIFont systemFontOfSize:15];
    textContent.placeholder = @"文字内容";
    self.textContent = textContent;
    textContent.delegate = self;
    textContent.color = XZColor(153, 153, 153);
    //    textContent.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    UILabel *line2 = [[UILabel alloc] init];
    [viewWhite addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWhite);
        make.right.equalTo(viewWhite);
        make.top.equalTo(textContent.bottom);
        make.height.equalTo(@0.5);
    }];
    line2.backgroundColor = KDefaultOrBackgroundColor;
    
    
    CGFloat size = (KProjectScreenWidth - 60 - KProjectScreenWidth * 0.08) / 3.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(size, size);
    flowLayout.minimumInteritemSpacing = 0.026 * KProjectScreenWidth;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [viewWhite addSubview:self.collectionView];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textContent).offset(10);
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.right.equalTo(textContent);
        make.height.equalTo(size);
    }];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[XZTestCell class] forCellWithReuseIdentifier:@"PublishBaskNewcell"];
    
    // 晒单按钮
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollView addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewWhite);
        make.top.equalTo(viewWhite.mas_bottom).offset(25);
        make.height.equalTo(@35);
        make.width.equalTo(@200);
    }];
    [btnSure setTitle:@"立即晒单" forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSure setBackgroundColor:XZColor(0, 102, 204)];
    [btnSure.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [btnSure addTarget:self action:@selector(didiClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}



@end
