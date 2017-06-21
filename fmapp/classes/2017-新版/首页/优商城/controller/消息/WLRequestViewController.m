//
//  WLRequestViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLRequestViewController.h"
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
#import "FMKeyBoardNumberHeader.h"

@interface WLRequestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,FMMessageAlterViewDelegate>

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIView *bjView1;
@property(nonatomic,strong)UIButton *currentSelectButton;
@property(nonatomic,strong)UILabel *labelNumber;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;//金额和数量
@property(nonatomic,strong)UILabel *receveLabel;//退款金额
@property(nonatomic,strong)UITextField *textField;//退款金额
@property(nonatomic,strong)UITextField *textField1;//问题描述
@property (nonatomic,strong)UIActionSheet * myActionSheet;
@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,strong) UIImagePickerController *imagePickerVc;
@property (nonatomic,copy) NSString *imageFilePath;
@property (nonatomic,strong) NSString *refundAmount;
@property (nonatomic,strong)NSString *type;

@end

@implementation WLRequestViewController

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

    [self settingNavTitle:@"申请售后"];
    [self createContentView];
    [self getTuiKuanEDu];
    [self setNavItemsWithButton];
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


-(void)createContentView{

    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight-100)];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 667);
    self.mainScrollView.delegate = self;

    [self.view addSubview:self.mainScrollView];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 75, 75)];
    [imageV sd_setImageWithURL:(NSURL *)self.model.thumbnail_pic];
    [self.mainScrollView addSubview:imageV];
    
    NSString *text2 = self.model.name;
    CGSize size = CGSizeMake(KProjectScreenWidth-130,40);
    CGSize labelsize = [text2 sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailLabel.text = [NSString stringWithFormat:@"%@",text2];
    detailLabel.font = [UIFont systemFontOfSize:14.0f];
    [detailLabel setNumberOfLines:0];
    detailLabel.frame=CGRectMake(100, 13, KProjectScreenWidth-130, labelsize.height);
    [self.mainScrollView addSubview:detailLabel];
    self.nameLabel = detailLabel;
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, KProjectScreenWidth-115, 15)];
    priceLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [priceLabel setFont:[UIFont boldSystemFontOfSize:13]];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f 数量：%@",[self.model.price floatValue],self.model.quantity];
    [self.mainScrollView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, KProjectScreenWidth, 6)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [self.mainScrollView addSubview:lineView];
    
    UIView *bjView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 111, KProjectScreenWidth, 70)];
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

    NSArray *titleArr = [NSArray arrayWithObjects:@"申请数量",@"退款金额（原支付返还）",@"问题描述", nil];
    for (int i = 0; i<3; i++) {
       
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 181+70*i, KProjectScreenWidth, 70)];
        [bjView setBackgroundColor:[UIColor whiteColor]];
        [self.mainScrollView addSubview:bjView];
        [bjView addGestureRecognizer:tapGesture];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, KProjectScreenWidth, 1)];
        [lineView setBackgroundColor:KDefaultOrBackgroundColor];
        [bjView addSubview:lineView];
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
        [bjView addGestureRecognizer:tapGesture1];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, KProjectScreenWidth-15, 15)];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:titleArr[i]];
        [bjView addSubview:titleLabel];
        if (i == 0) {
           
            // 加按钮
            UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(75, 35, 30, 20)];
            [bjView addSubview:addBtn];

            [addBtn setTitle:@"+" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(didClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
            addBtn.backgroundColor = XZColor(222, 230, 237);
            // 数量label
            UILabel *labelNumber = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 30, 20)];
            [bjView addSubview:labelNumber];

            labelNumber.font = [UIFont systemFontOfSize:15];
            labelNumber.textAlignment = NSTextAlignmentCenter;
            labelNumber.text = [NSString stringWithFormat:@"1"];
            self.labelNumber = labelNumber;
            // 减按钮
            UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, 30, 20)];
            [bjView addSubview:reduceBtn];
            [reduceBtn setTitle:@"－" forState:UIControlStateNormal];
            reduceBtn.backgroundColor = XZColor(222, 230, 237);
            [reduceBtn addTarget:self action:@selector(didClickReduceBtn:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (i == 1) {
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, KProjectScreenWidth-30, 30)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.returnKeyType =UIReturnKeyDone;
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.placeholder = [NSString stringWithFormat:@"￥%.2f",[self.model.price floatValue]];

            textField.textColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1];
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.delegate = self;
            [bjView addSubview:textField];
            __weak __typeof(&*self)weakSelf = self;
            self.textField = textField;
            self.textField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
                [weakSelf keyBoardDown];
            }];
            
            NSString *vStr = titleLabel.text;
            NSString *vDStr=@"（原支付返还）";
            NSRange range=[vStr rangeOfString:vDStr];
            NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:vStr];
            [mstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
            [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            titleLabel.attributedText=mstr;

        }
        if (i == 2) {
            
            
            UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, KProjectScreenWidth-30, 30)];
            textField1.borderStyle = UITextBorderStyleRoundedRect;
            textField1.returnKeyType =UIReturnKeyDone;
            textField1.backgroundColor = [UIColor clearColor];
            textField1.font = [UIFont boldSystemFontOfSize:12];
            textField1.placeholder = @"  请再次描述详细问题";
            textField1.tag = 10000;
            [bjView addSubview:textField1];
            self.textField1 = textField1;

        }
  
    }
    [self createBJsubViews];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 391, KProjectScreenWidth, 126)];
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

-(void)keyBoardDown{

    [self.textField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//提交申请
-(void)theRequestAction{

    if (self.textField.text.length <= 1) {
        ShowAutoHideMBProgressHUD(self.navigationController.view,@"请填写退款金额");
        return;
    }
    if (self.textField1.text.length == 0) {
       ShowAutoHideMBProgressHUD(self.navigationController.view,@"请填写退换货理由");
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter;
    NSString *urlString;
    if ([self.tag isEqualToString:@"1"]) {
        //售后申请修改
        urlString = @"https://www.rongtuojinrong.com/qdy/wap/member-process_update_client.html";
        parameter = @{[NSString stringWithFormat:@"product_bn[%@]",self.model.product_id]:self.model.bn,
                      [NSString stringWithFormat:@"product_name[%@]",self.model.product_id]:self.model.name,[NSString stringWithFormat:@"product_nums[%@]",self.model.product_id]:self.labelNumber.text,[NSString stringWithFormat:@"product_price[%@]",self.model.product_id]:[self.textField.text substringFromIndex:1],@"order_id":self.model.order_id,@"content":self.textField1.text,@"aftersale_id":self.model.aftersale_id,@"type":self.type};
    }else{
        //售后申请
        urlString = @"https://www.rongtuojinrong.com/qdy/wap/member-aftersales_client.html";
        parameter = @{[NSString stringWithFormat:@"product_bn[%@]",self.model.product_id]:self.model.bn,
                      [NSString stringWithFormat:@"product_name[%@]",self.model.product_id]:self.model.name,[NSString stringWithFormat:@"product_nums[%@]",self.model.product_id]:self.labelNumber.text,[NSString stringWithFormat:@"product_price[%@]",self.model.product_id]:[self.textField.text substringFromIndex:1],@"order_id":self.model.order_id,@"content":self.textField1.text,@"type":self.type};
    }
    NSString * httpUel = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",urlString,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
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
            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
            NSString *backStr = [dic objectForKey:@"afterSaleID"];
            if (self.buttonSpread) {
                self.buttonSpread(backStr);
            }
            [weakSelf performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.navigationController.view,@"申请失败");
//            NSLog(@"%@",[response.responseObject objectForKey:@"msg"]);
        }
    }];
}

//获取退款额度
-(void)getTuiKuanEDu{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"order_id":self.model.order_id,@"product_id":self.model.product_id,@"nums":self.labelNumber.text};
    
    NSString * httpUel = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-aftersales_amount_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:httpUel parameters:parameter completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSString *refundAmount = [NSString stringWithFormat:@"0"];
            if (response.code == WebAPIResponseCodeSuccess){
                NSDictionary *data = response.responseObject[@"data"];
                refundAmount = [data objectForKey:@"amount"];
                self.refundAmount = refundAmount;
                self.textField.text = [NSString stringWithFormat:@"￥%.2f",[refundAmount floatValue]];
                [self.textField setPlaceholder:[NSString stringWithFormat:@"￥%.2f",[refundAmount floatValue]]];
            }else
            {
                
                ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
                
            }
        });
    }];
}


-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Actiondo{

    [self.view endEditing:YES];

}

-(void)createBJsubViews{
    NSArray *buttonTitleArr = [NSArray arrayWithObjects:@"退货",@"退款", nil];

    for (int j = 0; j<buttonTitleArr.count; j++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15+(50+10)*j, 35, 50, 20)];
        button.layer.borderWidth = 1;
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 230/255.0f, 235/255.0f, 240/255.0f, 1 });
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
        if (self.model.orderStatusFM<40) {
            if (j == 0) {
                self.currentSelectButton = button;
                button.selected = YES;
                self.type = @"tuihuo";
            }
        }else{
            if (j == 1) {
                self.currentSelectButton = button;
                button.selected = YES;
                self.type = @"tuikuan";
            }

        }
    }
}

// 点击加号按钮
- (void)didClickAddBtn:(UIButton *)button {

    if (([self.labelNumber.text intValue] + 1 ) <= [self.model.quantity intValue]) {
        self.labelNumber.text = [NSString stringWithFormat:@"%d",[self.labelNumber.text intValue] + 1];
    }else{
        self.labelNumber.text = [NSString stringWithFormat:@"%@",self.model.quantity];
    }
    [self getTuiKuanEDu];
}
// 点击减号按钮
- (void)didClickReduceBtn:(UIButton *)button {
    if (([self.labelNumber.text integerValue] - 1 ) >= 1) {
        self.labelNumber.text = [NSString stringWithFormat:@"%d",[self.labelNumber.text intValue] - 1];
    }else{
        self.labelNumber.text = [NSString stringWithFormat:@"1"];
    }
    [self getTuiKuanEDu];
}

-(void)buttonAction:(UIButton *)button{
    if (button.tag == 0) {
        self.type = @"tuihuo";
    }else{
        self.type = @"tuikuan";
    }
    if (self.currentSelectButton != button) {
        self.currentSelectButton.selected = !self.currentSelectButton.selected;
        self.currentSelectButton = button;
        button.selected = YES;
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
//    self.textField.text = @"￥";
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    NSString *jineStr = [self.textField.text substringFromIndex:1];
    CGFloat jineF = [jineStr floatValue];
    if (jineF>[self.model.price floatValue]*[self.labelNumber.text intValue]) {
        
        ShowAutoHideMBProgressHUD(self.navigationController.view,@"退款金额不能大于商品价格");
        self.textField.text = [NSString stringWithFormat:@"￥%.2f",[self.model.price floatValue]*[self.labelNumber.text intValue]];
        
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.textField.text.length == 1) {
//        NSLog(@"%@",string);
        if (string.length>0) {
            return [self validateNumber:string];
        }else{
            return NO;
        }
    }
    if (self.textField.text.length == 0) {
       self.textField.text = @"￥";
    }
    return [self validateNumber:string];
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


@end
