//
//  XZCommentAgainViewController.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZCommentAgainViewController.h"
#import "TZImagePickerController.h"
#import "XZTestCell.h"
#import "XZChoosePictureWayView.h"
#import "XZTextView.h"
#import "SignOnDeleteView.h"
#import "XZMyOrderTableViewController.h"
//
#import "FMShopCommentModel.h"
//
#import "XZCommentAgainTabBar.h" // tabBar
#import "XZMyOrderGoodsModel.h"

#define Size (KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0

@interface XZCommentAgainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate>
//@property (nonatomic, strong) XZCommentAgainView *commentAgain;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSString *imageFilePath;
// 提示框
@property (nonatomic, strong) SignOnDeleteView *signOn;
/** 评价内容 */
@property (nonatomic, strong) NSString *commentContent;
/** 评价图片 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 追加评价 */
@property (nonatomic, strong) XZTextView *textComment;
//
@property (nonatomic, strong) XZCommentAgainTabBar *tabBar;
/** 评价图片 */
@property (nonatomic, strong) UIView *viewPhoto;
//
@property (nonatomic, strong) UIView *viewBack;

@property (nonatomic, strong) UIScrollView *bottomScroll;

@end

@implementation XZCommentAgainViewController
// 传值model
- (void)setStatusModel:(FMShopCommentModel *)statusModel {
    _statusModel = statusModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabBar];
    [self settingNavTitle:@"我的评价"];
    [self createChildView];
    __weak typeof(self)weakSelf = self;
    // 返回
    self.navBackButtonRespondBlock = ^() {
        [weakSelf.textComment resignFirstResponder];
        [weakSelf didClickBackButton];
    };
}

- (void)createChildView {
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 150)];
    [self.bottomScroll addSubview:viewBack];
    self.viewBack = viewBack;
    
    /** 商品图片 */
    UIImageView *imgGoods = [[UIImageView alloc]init];
    [viewBack addSubview:imgGoods];
    [imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBack).offset(10);
        make.top.equalTo(viewBack).offset(10);
        make.size.equalTo(@(Size));
    }];
    
    /** 商品名 */
    UILabel *labelGoodsName = [[UILabel alloc] init];
    [viewBack addSubview:labelGoodsName];
    [labelGoodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods.mas_right).offset(10);
        make.right.equalTo(viewBack).offset(-10);
        make.top.equalTo(imgGoods.mas_top);
    }];
    labelGoodsName.font = [UIFont systemFontOfSize:15];
    labelGoodsName.textColor = [UIColor darkGrayColor];
    labelGoodsName.numberOfLines = 2;
    
    /** 商品的颜色、尺码 */
    UILabel *labelColorSize = [[UILabel alloc] init];
    [viewBack addSubview:labelColorSize];
    [labelColorSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods.mas_right).offset(10);
        make.right.equalTo(labelGoodsName);
        make.top.equalTo(labelGoodsName.mas_bottom).offset(5);
        make.bottom.equalTo(imgGoods);
    }];
    labelColorSize.font = [UIFont systemFontOfSize:15];
    labelColorSize.textColor = [UIColor lightGrayColor];

    // 追加评价提示
    UILabel *labelComentProfmpt = [[UILabel alloc] init];
    [viewBack addSubview:labelComentProfmpt];
    [labelComentProfmpt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods);
        make.top.equalTo(imgGoods.mas_bottom).offset(10);// 若显示数据，去掉此行
    }];
    labelComentProfmpt.text = @"追加评价";
    labelComentProfmpt.textColor = [UIColor darkGrayColor];
    
    /** 追加评价 */
    XZTextView *textComment = [[XZTextView alloc] init];
    [viewBack addSubview:textComment];
    [textComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods);
        make.right.equalTo(labelGoodsName);
        make.top.equalTo(labelComentProfmpt.mas_bottom).offset(5);
        make.height.equalTo(@(Size));
    }];
    textComment.font = [UIFont systemFontOfSize:15];
    textComment.placeholder = @"亲，请写下您的追评！";
    textComment.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    textComment.delegate = self;
    textComment.layer.borderWidth = 1.0f;
    self.textComment = textComment;
    
    /** 评价图片 */
    UIView *viewPhoto = [[UIView alloc] init];
    [viewBack addSubview:viewPhoto];
    [viewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods);
        make.top.equalTo(textComment.mas_bottom).offset(10);
        make.width.equalTo(@(KProjectScreenWidth - 20));
        make.height.equalTo(@((KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0));
    }];
    self.viewPhoto = viewPhoto;
    
    // collectionView图片
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewPhoto);
    }];
    
    /** 最下面的分割线 */
    UILabel *lineCoarse = [[UILabel alloc] init];
    [viewBack addSubview:lineCoarse];
    [lineCoarse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBack);
        make.top.equalTo(viewPhoto.mas_bottom).offset(10);
        make.width.equalTo(KProjectScreenWidth);
        make.height.equalTo(@10);
    }];
    lineCoarse.backgroundColor = XZColor(230, 235, 240);
    
    // 赋值   // 商品图片
    [imgGoods sd_setImageWithURL:self.statusModel.avatar placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    // 商品名称
    labelGoodsName.text = self.statusModel.name;
    // 商品的大小和颜色
    labelColorSize.text = self.statusModel.date;
}

// 提交评价的数据
- (void)putCommentDataToNetWork {
//    NSLog(@"订单数据%@=======================",self.commentContent);
    [self.view endEditing:YES];
    if (self.commentContent.length == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"请写下您的评价!");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary * parameter = @{@"goods_id":@"",
                                 @"product_id":self.statusModel.product_id,
                                 @"order_id":@"",
                                 @"comment":[NSString stringWithFormat:@"%@",self.commentContent],
                                 @"response_json":[NSNumber numberWithInt:1],
                                 @"zhuiping":@1,
                                 @"comment_id":self.statusModel.comment_id};
    
    NSString * httpUel = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/comment-toComment_client-discuss.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    __weak __typeof(&*self)weakSelf = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient startMultiPartUploadTaskWithURL:httpUel imagesArray:self.selectedPhotos parameterOfimages:@"file" parametersDict:parameter compressionRatio:1.0f succeedBlock:^(id operation, id responseObject) {
        
        [hud hide:YES];
        
        NSDictionary * data = (NSDictionary *)responseObject;
        NSNumber * statusNum = data[@"status"];
        if ([statusNum integerValue] == 0) {
            //上传成功
            [weakSelf.signOn showSignViewNoButtonWithTitle:@"提示" detail:@"追评成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.signOn hiddenSignView];
                // 返回
                [weakSelf sendCommentSucceed];
            });
        }else {
            //上传失败
             ShowAutoHideMBProgressHUD(weakSelf.view, @"评价失败");
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

// 点击了返回按钮
- (void)didClickBackButton {
    [self.signOn showSignViewWithTitle:@"提示" detail:@"亲,追加评价还未完成,您确定离开么？"];
    __weak typeof(self)weakSelf = self;
    // 点击确定按钮返回我的订单界面
    self.signOn.sureBlock = ^(UIButton *button) {
        [weakSelf.signOn removeFromSuperview];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

// 点击提交评价按钮
- (void)didClickCommentButton {
    // 提交评价的数据
    [self putCommentDataToNetWork];
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
    XZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentAgaincell" forIndexPath:indexPath];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"发表评价相机"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.deleteBtn.hidden = NO;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    cell.blockDelete = ^(UIButton *button) {
        [_selectedPhotos removeObjectAtIndex:indexPath.item];
        [_selectedAssets removeObjectAtIndex:indexPath.item];
        [weakSelf.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.textComment resignFirstResponder];
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
                if (indexPath.row == _selectedPhotos.count) { [self pickPhotoButtonClick:nil];}
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
        
        if (data) {
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image6.png"] contents:data attributes:nil];
            //得到选择后沙盒中图片的完整路径
            NSString * imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image6.png"];
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
    imagePickerVc.selectedAssets = _selectedAssets; // optional
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
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSString *contentString;
//    if (text.length == 0 ) {
//        if (textView.text.length > 0) {
//            contentString = [textView.text substringToIndex:textView.text.length - 1];
//        }else
//        {
//            contentString = nil;
//        }
//    }else{
//        contentString = [NSString stringWithFormat:@"%@%@",textView.text,text];
//    }
//    self.commentContent = contentString;
//    NSLog(@"textView:%@--------%@------%@",self.commentContent,contentString,textView.text);
//    return YES;
//}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.commentContent = textView.text;
}

#pragma mark ---- scroll的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.bottomScroll endEditing:YES];
}

#pragma mark ----- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Size, Size);
        flowLayout.minimumInteritemSpacing = 0.026 * KProjectScreenWidth;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[XZTestCell class] forCellWithReuseIdentifier:@"CommentAgaincell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.viewPhoto addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIScrollView *)bottomScroll {
    if (!_bottomScroll) {
        _bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 113)];
         _bottomScroll.delegate = self;
        _bottomScroll.contentSize = CGSizeMake(KProjectScreenWidth, KProjectScreenHeight + 70);
        _bottomScroll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomScroll];
    }
    return _bottomScroll;
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

// 提示框
- (SignOnDeleteView *)signOn {
    if (!_signOn) {
        _signOn = [[SignOnDeleteView alloc]init];
    }
    return _signOn;
}

- (XZCommentAgainTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[XZCommentAgainTabBar alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 113, KProjectScreenWidth, 49)];
        __weak typeof(self)weakSelf = self;
        // 发表评价
        _tabBar.blockCommentBtn = ^(UIButton *button){
            [weakSelf didClickCommentButton];
        };
    }
    return _tabBar;
}

@end
