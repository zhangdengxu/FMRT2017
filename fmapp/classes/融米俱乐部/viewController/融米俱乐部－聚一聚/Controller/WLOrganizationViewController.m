//
//  WLOrganizationViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLOrganizationViewController.h"
#import "WLPublishSuccessViewController.h"
#import "WLJYJViewController.h"
#import "WLMMYPViewController.h"
#import "WLTheManageViewController.h"
#import "XZTextCommentView.h"
#import "FMDateSelectePickerView.h"
#import "FMKeyBoardNumberHeader.h"
#import "HTTPClient+Interaction.h"
#import "ShareViewController.h"
// 数据请求
#import "XZPublishModel.h" // model
#import "Fm_Tools.h"

#import "XZActivityModel.h"
#define dressBtnTag 1000

/** 修改活动信息之后，点击”发布“ */
#define kEditPartyURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/editepartyinfo"
/** 请求数据 */
#define kGetPartyURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/getpartyinfo"

@interface WLOrganizationViewController ()<UIScrollViewDelegate,UITextFieldDelegate,FMDateSelectePickerViewDelegate,UITextViewDelegate>

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIImageView *JinanImgV;
@property(nonatomic,strong)UIImageView *LiaochengImgV;
@property(nonatomic,strong)UITextView *detailActivity;//活动详情
@property(nonatomic,strong)UITextField *shangXianText;//人数上限
//@property(nonatomic,strong)UITextField *nameText;//姓名
//@property(nonatomic,strong)UITextField *mobileText;//手机号
@property(nonatomic,strong)NSString *startTime;//开始时间
@property(nonatomic,strong)NSString *endTime;//结束时间
@property(nonatomic,strong)NSString *address;//活动地点
@property(nonatomic,strong)UITextField *startTX;//开始时间
@property(nonatomic,strong)UITextField *endTX;//结束时间
@property(nonatomic,strong)UIButton *tongyiBtn;//已阅读按钮
@property (nonatomic, strong) FMDateSelectePickerView *dateView;
@property(nonatomic,assign)BOOL isStart;
/** 活动主题 */
@property (nonatomic, strong) UITextField *zhuTiText;
// model
@property (nonatomic, strong) XZPublishModel *modelPublish;

@end

@implementation WLOrganizationViewController

- (XZPublishModel *)modelPublish {
    if (!_modelPublish) {
        _modelPublish = [[XZPublishModel alloc]init];
    }
    return _modelPublish;
}

- (FMDateSelectePickerView *)dateView{
    
    if (!_dateView) {
        
        _dateView =[[FMDateSelectePickerView alloc]initWithFrame:CGRectMake(0,KProjectScreenHeight-200,KProjectScreenWidth, 200)];
        _dateView.delegate = self;
        _dateView.curDate=[NSDate date];
    }
    return _dateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self settingNavTitle:@"组织聚会"];
    [self createContentView];
    [self.view addSubview:self.dateView];
    if (self.pid) { // 请求数据
        [self createRightBtnWithTitle:@"修改"];
        [self GetPartyDataFromNetWork];
    }else {
        self.modelPublish.party_address = @"济南";
        [self createRightBtnWithTitle:@"发布"];
    }
}

#pragma mark --- 请求数据
- (void)GetPartyDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"pid":[NSString stringWithFormat:@"%@",self.pid]
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kGetPartyURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                [self.modelPublish setValuesForKeysWithDictionary:dataDict];
                [self assignmentToViewWithModel:self.modelPublish];
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
        }
    }];
}

//选择日期代理方法
-(void)didFinishPickView:(NSString *)date{
    
    if (date == nil) {

    }else{
        if (self.isStart) {
          
            [self.startTX setText:date];
            
            // 活动开始时间
            self.modelPublish.party_startime = [self changeDateFomatterWithDate:date];
            self.startTime = date;
            [self endTimeSelect];

            }else{
        
                if (self.dateView.tag == 1000) {
                    self.endTime = date;
                
                    // 活动结束时间
                    self.modelPublish.party_endtime = [self changeDateFomatterWithDate:date];
                    int a = [self compareDate:self.startTime withDate:self.endTime];
                    if (a==1) {
                     
                        [self.startTX setText:[NSString stringWithFormat:@"%@--%@",[self.startTime substringFromIndex:5],[self.endTime substringFromIndex:5]]];
                    }else{
                    
                      ShowAutoHideMBProgressHUD(self.view,@"请选择正确时间");
                    }
                    
                }else{
                    // 报名截止
                    self.modelPublish.party_enrolltime = [self changeDateFomatterWithDate:date];
                    [self.endTX setText:date];
                    
                }
        }
    }
}

- (NSString *)changeDateFomatterWithDate:(NSString *)date {
    NSString *timeStr = [NSString stringWithFormat:@"%@",date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *dateValue = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateValue timeIntervalSince1970]];
    return timeSp;
}

-(void)endTimeSelect{

    [self.view endEditing:YES];
    [self.dateView hiddenPickerView];
    
    self.isStart = NO;
    self.dateView.curDate = [NSDate date];
    self.dateView.title = @"活动结束时间";
    self.dateView.tag = 1000;
    self.dateView.titleBackgroundColor = KDefaultOrBackgroundColor;
    self.dateView.titleColor = [UIColor blueColor];
    self.dateView.cancelButtonTintColor = kColorTextColorClay;
    self.dateView.sureButtonTintColor = kColorTextColorClay;
    [self.dateView showInView:self.view];

}

-(void)createContentView{

    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,950);
    [self.view addSubview:mainScrollView];
    self.mainScrollView = mainScrollView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [self.mainScrollView addGestureRecognizer:tapGesture];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, 50)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
    [label1 setText:@"活动主题："];
    [label1 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [label1 setFont:[UIFont boldSystemFontOfSize:15]];
    [view1 addSubview:label1];
    
    UITextField *zhuTiText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-110, 50)];
    zhuTiText.borderStyle = UITextBorderStyleNone;
    self.zhuTiText = zhuTiText;
    self.zhuTiText.tag = 100;
    self.zhuTiText.delegate = self;
    [view1 addSubview:zhuTiText];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 90, KProjectScreenWidth, 100)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:view2];
    
    for (int i = 0; i<2; i++) {
        
        UILabel *label1 = [[UILabel alloc]init];

        [label1 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
        [label1 setFont:[UIFont boldSystemFontOfSize:15]];
        
        UITextField *zhuTiText = [[UITextField alloc]init];
        zhuTiText.borderStyle = UITextBorderStyleNone;
        zhuTiText.enabled = NO;
        
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
       
        if (i==0) {
            [label1 setText:@"活动时间："];
            [label1 setFrame:CGRectMake(10, 0, 100, 50)];
            
            [zhuTiText setFrame:CGRectMake(80, 0, self.view.frame.size.width-110, 50)];
            [timeBtn setFrame:CGRectMake(80, 0, self.view.frame.size.width-110, 50)];
            [timeBtn addTarget:self action:@selector(timeSelect) forControlEvents:UIControlEventTouchUpInside];
            self.startTX = zhuTiText;
        }else{
            [label1 setText:@"报名截止："];
            [label1 setFrame:CGRectMake(10, 50, 100, 50)];
            [zhuTiText setFrame:CGRectMake(80, 50, self.view.frame.size.width-110, 50)];
            [timeBtn setFrame:CGRectMake(80, 50, self.view.frame.size.width-110, 50)];
            [timeBtn addTarget:self action:@selector(timeStop) forControlEvents:UIControlEventTouchUpInside];
            self.endTX = zhuTiText;
        }
        [view2 addSubview:label1];
        [view2 addSubview:zhuTiText];
        [view2 addSubview:timeBtn];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [view2 addSubview:lineView];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 210, KProjectScreenWidth, 50)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:view3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
    [label3 setText:@"活动地点："];
    [label3 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [label3 setFont:[UIFont boldSystemFontOfSize:15]];
    [view3 addSubview:label3];
    
    for (int i=0; i<2; i++) {
        
        UIButton *dressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dressBtn setFrame:CGRectMake(KProjectScreenWidth/3*(i+1), 0, KProjectScreenWidth/3, 50)];
        [dressBtn setTag:dressBtnTag+i];
        [dressBtn addTarget:self action:@selector(dressSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [view3 addSubview:dressBtn];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 50)];
        [nameLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
        if (i==0) {
            
            UIImageView *JinanImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 17, 16, 16)];
            [JinanImageV setImage:[UIImage imageNamed:@"25.png"]];
            [dressBtn addSubview:JinanImageV];
            self.JinanImgV = JinanImageV;
        
            [nameLabel setText:@"济南"];
            
        }else{
        
            UIImageView *LiaochengImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 17, 16, 16)];
            [LiaochengImageV setImage:[UIImage imageNamed:@"26.png"]];
            [dressBtn addSubview:LiaochengImageV];
            self.LiaochengImgV = LiaochengImageV;
            
            [nameLabel setText:@"聊城"];
        }
        [dressBtn addSubview:nameLabel];
    }
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 260, 100, 70)];
    [label4 setText:@"活动详情："];
    [label4 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [label4 setFont:[UIFont boldSystemFontOfSize:15]];
    [mainScrollView addSubview:label4];
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 330, KProjectScreenWidth, 150)];
    textview.backgroundColor=[UIColor whiteColor];
    textview.scrollEnabled = NO;
    textview.editable = YES;
    textview.font=[UIFont fontWithName:@"Arial" size:18.0];
    textview.keyboardType = UIKeyboardTypeDefault;
    textview.dataDetectorTypes = UIDataDetectorTypeAll;
    [mainScrollView addSubview:textview];
    self.detailActivity = textview;
    self.detailActivity.delegate = self;

    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 500, KProjectScreenWidth, 50)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:view4];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
    [label5 setText:@"人数上限："];
    [label5 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [label5 setFont:[UIFont boldSystemFontOfSize:15]];
    [view4 addSubview:label5];
    
    UITextField *shangXianText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-110, 50)];
    shangXianText.borderStyle = UITextBorderStyleNone;
    shangXianText.keyboardType = UIKeyboardTypeNumberPad;
     __weak __typeof(&*self)weakSelf = self;
    shangXianText.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    shangXianText.delegate = self;
    [view4 addSubview:shangXianText];
    shangXianText.tag = 104;
    self.shangXianText = shangXianText;
    self.shangXianText.delegate = self;
//暂时去掉 最后一个View
//    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 570, KProjectScreenWidth, 150)];
//    [view5 setBackgroundColor:[UIColor whiteColor]];
//    [mainScrollView addSubview:view5];
//    
//    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth, 50)];
//    [label6 setText:@"设置报名者必填项"];
//    [label6 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
//    [label6 setFont:[UIFont boldSystemFontOfSize:15]];
//    [view5 addSubview:label6];
//    
//    UIImageView *starImagV = [[UIImageView alloc]initWithFrame:CGRectMake(133, 17, 16, 16)];
//    [starImagV setImage:[UIImage imageNamed:@"29.png"]];
//    [view5 addSubview:starImagV];
//    
//    for (int i = 0; i<2; i++) {
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49+50*i, KProjectScreenWidth, 1)];
//        [lineView setBackgroundColor:KDefaultOrBackgroundColor];
//        [view5 addSubview:lineView];
//        
//        UIImageView *nameImagV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15+50*(i+1), 20, 20)];
//        
//        UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(40, 50*(i+1), 100, 50)];
//        [label7 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
//        [label7 setFont:[UIFont boldSystemFontOfSize:15]];
//        
//        UITextField *bitianText = [[UITextField alloc]initWithFrame:CGRectMake(80, 50*(i+1), self.view.frame.size.width-110, 50)];
//        bitianText.delegate = self;
//        bitianText.borderStyle = UITextBorderStyleNone;
//
//        if (i == 0) {
//           
//            [nameImagV setImage:[UIImage imageNamed:@"27.png"]];
//            [label7 setText:@"姓名"];
//            self.nameText = bitianText;
//        }else{
//        
//            [nameImagV setImage:[UIImage imageNamed:@"28.png"]];
//            [label7 setText:@"手机"];
//            bitianText.keyboardType = UIKeyboardTypePhonePad;
//            self.mobileText = bitianText;
//        }
//        
//        [view5 addSubview:nameImagV];
//        [view5 addSubview:label7];
//        [view5 addSubview:bitianText];
//        
//    }
    
    UIButton *tongyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tongyiBtn setFrame:CGRectMake(10, 595, 24, 24)];
    [tongyiBtn setImage:[UIImage imageNamed:@"30.png"] forState:UIControlStateNormal];
    [tongyiBtn setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateSelected];
    [tongyiBtn setSelected:YES];
    [tongyiBtn addTarget:self action:@selector(tongyiAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:tongyiBtn];
    self.tongyiBtn = tongyiBtn;
    
    UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 590, 80, 34)];
    [lastLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [lastLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [lastLabel setText:@"同意"];
    [mainScrollView addSubview:lastLabel];
    
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setFrame:CGRectMake(80, 590, 187, 34)];
    [lastBtn addTarget:self action:@selector(clubAction) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:lastBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 34)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    [titleLabel setText:@"《聚一聚服务协议》"];
    [lastBtn addSubview:titleLabel];
}

-(void)keyBoardDown
{
    [self.view endEditing:YES];
}
//右侧发布按钮
-(void)createRightBtnWithTitle:(NSString *)title {
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:title
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(publishAction)];
    
    rightButton.tintColor=[HXColor colorWithHexString:@"#333333"];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

//无功能的发布按钮
-(void)createTheRightBtnWithTitle:(NSString *)title {
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:title
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:nil];
    
    rightButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

#pragma mark --- 发布数据请求
-(void)publishAction{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter;
    NSString *string;
    if (self.pid) {
        if (self.modelPublish.party_theme.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动主题");
            return;
        }else if (self.modelPublish.party_startime.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动开始时间");
            return;
        }else if (self.modelPublish.party_endtime.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动结束时间");
            return;
        }else if (self.modelPublish.party_enrolltime.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写报名截止时间");
            return;
        }else if (self.modelPublish.party_info.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动详情");
            return;
        }else if (self.modelPublish.party_number.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写人数上限");
            return;
        }else if (self.modelPublish.party_address.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动地点");
            return;
        }else if (!self.tongyiBtn.selected){
            ShowAutoHideMBProgressHUD(self.view,@"请同意《聚一聚服务协议》");
            return;
        }
        
        string = kEditPartyURL;
        parameter = @{
                     @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                     @"appid":@"huiyuan",
                     @"shijian":[NSNumber numberWithInt:timestamp],
                     @"token":tokenlow,
                     @"pid":[NSString stringWithFormat:@"%@",self.pid],
                     @"party_theme":self.modelPublish.party_theme,
                     @"party_startime":self.modelPublish.party_startime,
                     @"party_endtime":self.modelPublish.party_endtime,
                     @"party_enrolltime":self.modelPublish.party_enrolltime,
                     @"party_address":self.modelPublish.party_address,
                     @"party_info":self.modelPublish.party_info,
                     @"party_number":self.modelPublish.party_number
                     };
    }else {
        if (self.zhuTiText.text.length == 0) {
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动主题");
            return;
        }else if (self.startTime.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动开始时间");
            return;
        }else if (self.endTime.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动结束时间");
            return;
        }else if (self.endTX.text.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动截止时间");
            return;
        }else if (self.detailActivity.text.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动详情");
            return;
        }else if (self.shangXianText.text.length == 0){
            ShowAutoHideMBProgressHUD(self.view,@"请填写活动人数上限");
            return;
        }else if (!self.tongyiBtn.selected) {
            ShowAutoHideMBProgressHUD(self.view,@"请同意《聚一聚服务协议》");
            return;
        }
        string = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/addpartyinfo";

        parameter = @{
                      @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"party_theme":self.zhuTiText.text,
                      @"party_startime":[self changeDateFomatterWithDate:self.startTime],
                      @"party_endtime":[self changeDateFomatterWithDate:self.endTime],
                      @"party_enrolltime":[self changeDateFomatterWithDate:self.endTX.text],
                      @"party_address":self.modelPublish.party_address,
                      @"party_info":self.detailActivity.text,
                      @"party_number":self.shangXianText.text
                      };
//        [self createTheRightBtnWithTitle:@"发布"];
    }
    __weak __typeof(&*self)weakSelf = self;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
//        [self createRightBtnWithTitle:@"发布"];
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                if (self.pid) { // 修改
                    NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                    if ([status isEqualToString:@"0"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);

                   }
                }else {
                    NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                    if ([status isEqualToString:@"0"]) {
//                        [self.navigationController popViewControllerAnimated:YES];
//                        跳转到分享
                        NSDictionary *dataDic = response.responseObject[@"data"];
                        XZActivityModel *modelActivity = [[XZActivityModel alloc]init];
                        [modelActivity setValuesForKeysWithDictionary:dataDic];
//                        WLPublishSuccessViewController *vc = [[WLPublishSuccessViewController alloc]init];
//                        vc.hasManage = YES;
//                        vc.modelActivity = modelActivity;
                        WLTheManageViewController *theManager = [[WLTheManageViewController alloc] init];
                        [self.navigationController pushViewController:theManager animated:YES];
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"发布成功");
                    } else {
                        ShowAutoHideMBProgressHUD(weakSelf.view,[response.responseObject objectForKey:@"msg"]);
                    }

                    
                }
               
            }
           
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
        }
        
    }];

}

//活动时间
-(void)timeSelect{

    [self.view endEditing:YES];
    self.isStart = YES;
    self.dateView.curDate = [NSDate date];
    [self.dateView showInView:self.view];
    self.dateView.titleBackgroundColor = KDefaultOrBackgroundColor;
    self.dateView.cancelButtonTintColor = kColorTextColorClay;
    self.dateView.sureButtonTintColor = kColorTextColorClay;
    self.dateView.title = @"活动开始时间";
    self.dateView.titleColor = [UIColor redColor];

}

//报名截止
-(void)timeStop{

    [self.view endEditing:YES];
    self.isStart = NO;
    self.dateView.curDate = [NSDate date];
    self.dateView.title = @"报名截止时间";
    self.dateView.titleBackgroundColor = KDefaultOrBackgroundColor;
    self.dateView.titleColor = kColorTextColorClay;
    self.dateView.cancelButtonTintColor = kColorTextColorClay;
    self.dateView.sureButtonTintColor = kColorTextColorClay;
    self.dateView.tag = 10000;
    [self.dateView showInView:self.view];

}

-(void)dressSelectAction:(UIButton *)button{

    if (button.tag == dressBtnTag) {
        
        [self.JinanImgV setImage:[UIImage imageNamed:@"25.png"]];
        [self.LiaochengImgV setImage:[UIImage imageNamed:@"26.png"]];
        self.modelPublish.party_address = @"济南";
    }else{
    
        [self.LiaochengImgV setImage:[UIImage imageNamed:@"25.png"]];
        [self.JinanImgV setImage:[UIImage imageNamed:@"26.png"]];
        self.modelPublish.party_address = @"聊城";
    }

}

//限制只能输入数字
- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9.]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

//同意
-(void)tongyiAction:(UIButton *)button{

    button.selected =! button.selected;
}

//《聚一聚服务协议》
-(void)clubAction{

    ShareViewController *webView=[[ShareViewController alloc]initWithTitle:@"聚一聚服务协议" AndWithShareUrl:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/juyijuxieyi"];
    [self.navigationController pushViewController:webView animated:YES];

}

#pragma UIScroViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    [self.view endEditing:YES];
    
}

#pragma mark ---- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.dateView hiddenPickerView];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == self.mobileText || textField == self.shangXianText) {
//       
//        return [self validateNumberByRegExp:string];
//    }
    
    NSString * contentString;
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
    if (contentString != nil ) {
        if (textField.tag == 100) { // 活动主题
            self.modelPublish.party_theme = contentString;
        }else if (textField.tag == 104) { // 人数上限
            self.modelPublish.party_number = contentString;
        }
    }
    return YES;
}

#pragma mark ---- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.dateView hiddenPickerView];
    CGPoint position = CGPointMake(0, 270);
    
    [self.mainScrollView setContentOffset:position animated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * contentString;
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
    if (contentString != nil ) {
        self.modelPublish.party_info = contentString;
    }
    
    return YES;
}

-(void)Actiondo{
    
    [self.view endEditing:YES];
}

#pragma mark ---- 给页面赋值
- (void)assignmentToViewWithModel:(XZPublishModel *)model {
    _modelPublish = model;
    self.zhuTiText.text = [NSString stringWithFormat:@"%@",model.party_theme];
    NSString *startTime = [Fm_Tools getTotalTimeFromString:[NSString stringWithFormat:@"%@",model.party_startime]];
    NSString *endTime = [Fm_Tools getTotalTimeFromString:[NSString stringWithFormat:@"%@",model.party_endtime]];
    NSString *subString1 = [startTime substringWithRange:NSMakeRange(5, startTime.length - 5)];
    NSString *subString2 = [endTime substringWithRange:NSMakeRange(5, endTime.length - 5)];
    self.startTX.text = [NSString stringWithFormat:@"%@--%@",subString1,subString2];
    NSString *enrollTime = [Fm_Tools getTotalTimeFromString:[NSString stringWithFormat:@"%@",model.party_enrolltime]];
    self.endTX.text = enrollTime;
    if ([model.party_address isEqualToString:@"济南"]) {
        [self.JinanImgV setImage:[UIImage imageNamed:@"25.png"]];
        [self.LiaochengImgV setImage:[UIImage imageNamed:@"26.png"]];
    }else {
        [self.JinanImgV setImage:[UIImage imageNamed:@"26.png"]];
        [self.LiaochengImgV setImage:[UIImage imageNamed:@"25.png"]];
    }
    self.detailActivity.text = [NSString stringWithFormat:@"%@",model.party_info];
    self.shangXianText.text = [NSString stringWithFormat:@"%@",model.party_number];
}


-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default:
        break;
    }
    return ci;
}

@end
