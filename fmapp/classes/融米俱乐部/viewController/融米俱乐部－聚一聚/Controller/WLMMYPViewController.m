//
//  WLMMYPViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/7/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLMMYPViewController.h"
#import "QRCodeReaderViewController.h"
#import "FMKeyBoardNumberHeader.h"


@interface WLMMYPViewController ()<UITextFieldDelegate,QRCodeReaderDelegate>
@property(nonatomic,strong)UITextField *SZMTextField;
@property(nonatomic,strong)UILabel *uilabel;
@property(nonatomic,strong)UILabel *bottomLabel;
@end

@implementation WLMMYPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"密码验票"];
    [self createContentView];
    [self createRightBtn];
}

-(void)createContentView{

    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*329/590)];
    [imgV setImage:[UIImage imageNamed:@"8.png"]];
    imgV.userInteractionEnabled = YES;
    [self.view addSubview:imgV];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KProjectScreenWidth*329/590-40, KProjectScreenWidth, 15)];
    [bottomLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setText:[NSString stringWithFormat:@"已成功验票%@人",self.count]];
    [imgV addSubview:bottomLabel];
    self.bottomLabel = bottomLabel;
    
    UIView *wightView = [[UIView alloc]initWithFrame:CGRectMake(60, 60*KProjectScreenWidth/736, KProjectScreenWidth-120, 60)];
    [wightView setBackgroundColor:[UIColor whiteColor]];
    [wightView.layer setCornerRadius:30];
    [imgV addSubview:wightView];
    
    UITextField *SZMTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, KProjectScreenWidth-180, 60)];
    [SZMTextField setPlaceholder:@"请输入用户出示的数字码"];
    SZMTextField.textAlignment = NSTextAlignmentCenter;
    SZMTextField.keyboardType = UIKeyboardTypeNumberPad;
    [SZMTextField setFont:[UIFont systemFontOfSize:16]];
    if (self.view.frame.size.width<350) {
      [SZMTextField setFont:[UIFont systemFontOfSize:12]];
    }
    SZMTextField.delegate = self;
    [SZMTextField setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
    [wightView addSubview:SZMTextField];
    self.SZMTextField = SZMTextField;
    __weak __typeof(&*self)weakSelf = self;
    self.SZMTextField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    

    UIButton *beSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [beSureBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:0/255.0f green:60/255.0f blue:144/255.0f alpha:1])
                         forState:UIControlStateNormal];
    [beSureBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:0/255.0f green:60/255.0f blue:144/255.0f alpha:1])
                         forState:UIControlStateHighlighted];
    [beSureBtn setTitle:@"验票"
               forState:UIControlStateNormal];
    [beSureBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [beSureBtn setFrame:CGRectMake(30, KProjectScreenWidth*329/590+25, KProjectScreenWidth-60, 60)];
    [beSureBtn.layer setBorderWidth:0.5f];
    [beSureBtn.layer setCornerRadius:6.0f];
    [beSureBtn.layer setMasksToBounds:YES];
    beSureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [beSureBtn setBackgroundColor:[UIColor colorWithRed:0/255.0f green:60/255.0f blue:144/255.0f alpha:1]];
    [beSureBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [beSureBtn addTarget:self action:@selector(besureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beSureBtn];

}

-(void)createRightBtn{
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"扫码验票"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(callModalList)];
    
    rightButton.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void)keyBoardDown{

    [self.SZMTextField resignFirstResponder];
}

//扫码
-(void)callModalList{

    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];\
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        [wSelf.navigationController popViewControllerAnimated:YES];
//        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        [self.SZMTextField setText:resultAsString];
    }];
    
    //[self presentViewController:reader animated:YES completion:NULL];
    [self.navigationController pushViewController:reader animated:YES];


}

//验票
-(void)besureAction:(UIButton *)button{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    __weak __typeof(&*self)weakSelf = self;
    
    
    NSString *url = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/userchecticket";
    NSDictionary * parameter = @{
                                 @"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSString stringWithFormat:@"%d",timestamp],
                                 @"token":tokenlow,
                                 @"shuzima":self.SZMTextField.text
                                 };
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess)
        {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,@"验票成功");
            [self.bottomLabel setText:[NSString stringWithFormat:@"已成功验票%d人",(int)self.count+1]];
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            
        }
    }];


}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
