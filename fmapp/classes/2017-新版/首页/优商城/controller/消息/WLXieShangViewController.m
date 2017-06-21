//
//  WLXieShangViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/1/7.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLXieShangViewController.h"
#import "XMRightImageButton.h"
#import "XZPublishCommentView.h"
#import "TZImagePickerController.h"
#import "XZTestCell.h"
#import "XZChoosePictureWayView.h"
#import "TZAssetModel.h"
#import "XZTextView.h"
#import "AXRatingView.h"
#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"
#import "FMRTWellStoreViewController.h"

@interface WLXieShangViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,FMMessageAlterViewDelegate>

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIView *bjView1;
@property(nonatomic,strong)UIButton *currentSelectButton;
@property(nonatomic,strong)UILabel *labelNumber;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;//金额和数量
@property(nonatomic,strong)UILabel *receveLabel;//退款金额
@property(nonatomic,strong)UITextField *textField0;//快递公司
@property(nonatomic,strong)UITextField *textField;//运单单号
@property(nonatomic,strong)UITextField *textField1;//运费
@property (nonatomic,strong)UIActionSheet * myActionSheet;
@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic,copy) NSString *imageFilePath;
@end

@implementation WLXieShangViewController

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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"协商退款退货"];
    [self createContentView];
    [self setNavItemsWithButton];
}

-(void)createContentView{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight-100)];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 667);
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [self.mainScrollView addSubview:lineView];
    
    UIView *bjView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 1, KProjectScreenWidth, 70)];
    [bjView1 setBackgroundColor:[UIColor whiteColor]];
    [self.mainScrollView addSubview:bjView1];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 69, KProjectScreenWidth, 1)];
    [lineView1 setBackgroundColor:KDefaultOrBackgroundColor];
    [bjView1 addSubview:lineView1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, KProjectScreenWidth-15, 15)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setText:@"服务类型"];
    [bjView1 addSubview:titleLabel];
    self.bjView1 = bjView1;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [self.bjView1 addGestureRecognizer:tapGesture];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"快递公司",@"运单单号",@"运费", nil];
    NSArray *contentArr = [NSArray arrayWithObjects:@"退货运费由您来承担，请不要使用平邮或到付",@"请准确填写运单号，如填写错误将影响退货补贴发放",@"请根据实际运费填写，超过10元需上传凭证", nil];
    for (int i = 0; i<3; i++) {
        
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 71+100*i, KProjectScreenWidth, 100)];
        [bjView setBackgroundColor:[UIColor whiteColor]];
        [self.mainScrollView addSubview:bjView];
        [bjView addGestureRecognizer:tapGesture];
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
        [bjView addGestureRecognizer:tapGesture1];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, KProjectScreenWidth-15, 15)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setText:titleArr[i]];
        [bjView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, KProjectScreenWidth-15, 15)];
        [contentLabel setFont:[UIFont systemFontOfSize:10]];
        [contentLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
        [contentLabel setText:contentArr[i]];
        [bjView addSubview:contentLabel];
        if (i == 0) {
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, 110, 30)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.returnKeyType =UIReturnKeyDone;
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.delegate = self;
            [bjView addSubview:textField];
            self.textField0 = textField;
        }
        if (i == 1) {
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, KProjectScreenWidth/2, 30)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.returnKeyType =UIReturnKeyDone;
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.delegate = self;
            [bjView addSubview:textField];
            self.textField = textField;
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, KProjectScreenWidth, 1)];
            [lineView setBackgroundColor:KDefaultOrBackgroundColor];
            [bjView addSubview:lineView];

        }
        if (i == 2) {
            
            UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, 70, 30)];
            textField1.borderStyle = UITextBorderStyleRoundedRect;
            textField1.returnKeyType =UIReturnKeyDone;
            textField1.backgroundColor = [UIColor clearColor];
            textField1.font = [UIFont boldSystemFontOfSize:12];
            textField1.tag = 10000;
            textField1.keyboardType = UIKeyboardTypeDecimalPad;
            [bjView addSubview:textField1];
            self.textField1 = textField1;
            
            UILabel *littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 45, KProjectScreenWidth-15, 15)];
            [littleLabel setFont:[UIFont systemFontOfSize:13]];
            [littleLabel setText:@"元"];
            [bjView addSubview:littleLabel];

        }
        
    }
    [self createBJsubViews];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 371, KProjectScreenWidth, 126)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.mainScrollView addSubview:bottomView];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, KProjectScreenWidth-15, 15)];
    [titleLabel2 setFont:[UIFont systemFontOfSize:14]];
    [titleLabel2 setText:@"上传图片"];
    [bottomView addSubview:titleLabel2];

    /** 评价collectionView */
    UIView *viewPhoto = [[UIView alloc]init];
    [bottomView addSubview:viewPhoto];
    [viewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.top.equalTo(titleLabel2.mas_bottom).offset(10);
        make.width.equalTo(@(KProjectScreenWidth - 20));
        make.height.equalTo(@((KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat size2 = (KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0;
    flowLayout.itemSize = CGSizeMake(size2, size2);
    flowLayout.minimumInteritemSpacing = 0.026 * KProjectScreenWidth;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [viewPhoto addSubview:self.collectionView];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XZTestCell class] forCellWithReuseIdentifier:@"AfterSalesCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPhoto.mas_left);
        make.top.equalTo(viewPhoto.mas_top);
        make.width.equalTo(viewPhoto.mas_width);
        make.height.equalTo(viewPhoto.mas_height);
    }];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *lastLabel = [[UILabel alloc]init];
    lastLabel.font = [UIFont systemFontOfSize:12];
    lastLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    lastLabel.text = @"上传凭证最多1张，每张大小不超过3M";
    [bottomView addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.width.equalTo(viewPhoto.mas_width);
        make.height.equalTo(@(20));
    }];
    
    
    
    UIView *btnContentView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight-108, KProjectScreenWidth, 45)];
    btnContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnContentView];
    
    UIButton *requestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestBtn setFrame:CGRectMake(0, 0, KProjectScreenWidth, 44)];
    [requestBtn setBackgroundColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    [requestBtn addTarget:self action:@selector(theRequestAction) forControlEvents:UIControlEventTouchUpInside];
    requestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [requestBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    requestBtn.titleLabel.textColor = [UIColor whiteColor];
    [btnContentView addSubview:requestBtn];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//提交申请
-(void)theRequestAction{
    
    if (self.textField0.text.length == 0) {
        ShowAutoHideMBProgressHUD(self.navigationController.view,@"请填写快递公司");
        return;
    }
    if (self.textField.text.length == 0) {
        ShowAutoHideMBProgressHUD(self.navigationController.view,@"请填写运单单号");
        return;
    }
    if (self.textField1.text.length == 0) {
        ShowAutoHideMBProgressHUD(self.navigationController.view,@"请填写运费");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"aftersale_id":self.model.aftersale_id,
                                 @"com":self.textField0.text,
                                 @"nu":self.textField.text,
                                 @"fee":self.textField1.text};
    
    NSString * httpUel = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-process_info_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSData * dataImage = [NSData data];
    if (self.selectedPhotos.count > 0) {
        UIImage * imagePhoto = self.selectedPhotos[0];
        dataImage = UIImageJPEGRepresentation(imagePhoto, 1.0f);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:httpUel requestImageDataUpload:dataImage imageType:fileName withName:@"file" parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess){
            ShowAutoHideMBProgressHUD(weakSelf.navigationController.view,@"申请成功");
            [weakSelf performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.navigationController.view,@"申请失败");
        }
    }];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Actiondo{
    
    [self.view endEditing:YES];
    
}

-(void)createBJsubViews{
    NSArray *buttonTitleArr = [NSArray arrayWithObjects:@"退货退款", nil];
    
    for (int j = 0; j<buttonTitleArr.count; j++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15+(50+10)*j, 35, 70, 20)];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [XZColor(230, 235, 240) CGColor];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1]] forState:UIControlStateSelected];
        [button setTitle:buttonTitleArr[j] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTag:j];
        [self.bjView1 addSubview:button];
        if (j == 0) {
            self.currentSelectButton = button;
            button.selected = YES;
        }
    }
}

-(void)buttonAction:(UIButton *)button{
    
    if (self.currentSelectButton != button) {
        self.currentSelectButton.selected = !self.currentSelectButton.selected;
    }
}

-(UIImage *)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - collectionView data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AfterSalesCell" forIndexPath:indexPath];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"售后相机.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
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
    
    [self.view endEditing:YES];
    
    if (self.selectedPhotos.count < 1) {
        XZChoosePictureWayView *choosePicture = [[XZChoosePictureWayView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        //        choosePicture.labelPrompt.text = [NSString stringWithFormat:@"亲，您还可以上传%ld张图片",(long)(3 - self.selectedPhotos.count)];
        [choosePicture setWayViewWithFirstButtonTitle:@"拍照" secondButtonTitle:@"相册" withLabelPrompt:[NSString stringWithFormat:@"亲，您可以上传1张图片"]];
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
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image5.png"] contents:data attributes:nil];
            //得到选择后沙盒中图片的完整路径
            NSString * imageFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image5.png"];
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
        maxCount = 1;
    }else {
        maxCount = 0;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.selectedAssets = _selectedAssets;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}



#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.textField1) {
        return [self validateNumber:string];
    }else if (textField == self.textField){
        return [self valithedateNumber:string];
    }else{
        return YES;
    }
}
/**
 *只能输入数字和小数点
 */
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
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
- (BOOL)valithedateNumber:(NSString*)number {
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

@end
