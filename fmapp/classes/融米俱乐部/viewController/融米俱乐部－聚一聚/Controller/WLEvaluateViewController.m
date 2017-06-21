//
//  WLEvaluateViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLEvaluateViewController.h"

@interface WLEvaluateViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *uilabel;
@property (nonatomic,strong) UITextView *detailEvaluate;//详细评论
@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation WLEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"我的评价"];
    [self createContentView];
}

-(void)createContentView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    
    [self.view addGestureRecognizer:tapGesture];

    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, KProjectScreenWidth-20, 200)];
    textview.backgroundColor=[UIColor whiteColor];
    textview.scrollEnabled = NO;
    textview.editable = YES;
    textview.delegate = self;
    textview.font=[UIFont fontWithName:@"Arial" size:18.0];
    textview.keyboardType = UIKeyboardTypeDefault;
    textview.layer.borderColor = [[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.1]CGColor];
    [textview.layer setMasksToBounds:YES];
    textview.layer.borderWidth = 1.5;
    textview.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:textview];
    self.detailEvaluate = textview;
    
    self.uilabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, textview.frame.size.width, 20)];
    self.uilabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.text = @"亲！请写下对我们的评价吧！";
    [self.view addSubview:self.uilabel];
    self.detailEvaluate = textview;
    
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-100, 185, 80, 20)];
    [self.numberLabel setTextAlignment:NSTextAlignmentRight];
    [self.numberLabel setTextColor:[UIColor grayColor]];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.numberLabel.text = @"0/140";
    [self.view addSubview:self.numberLabel];

    
    UIView *buttonView = [[UIView alloc]init];
    [buttonView setBackgroundColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    [self.view addSubview:buttonView];
    [buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textview.mas_bottom).offset(10);
        make.right.equalTo(textview.mas_right);
        make.width.equalTo(100);
        make.height.equalTo(50);
    }];


    UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [btnTextLabel setText:@"发表评价"];
    [btnTextLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnTextLabel setTextColor:[UIColor whiteColor]];
    [btnTextLabel setTextAlignment:NSTextAlignmentCenter];
    [buttonView addSubview:btnTextLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 100, 50)];
    [button addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button];
}


-(void)evaluateAction:(UIButton *)button{

    if (self.detailEvaluate.text.length>140) {
      
        ShowAutoHideMBProgressHUD(self.view,@"评论不超过140字");
    }else if (self.detailEvaluate.text.length == 0){
    
        ShowAutoHideMBProgressHUD(self.view,@"请输入评论");
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *string =[NSString stringWithFormat:@"%@/public/comment/publishComment",kXZTestEnvironment];
        

        
        //NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/java/public/comment/publishComment"];
        NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"comment":self.detailEvaluate.text,@"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
        __weak __typeof(&*self)weakSelf = self;

        [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response.code == WebAPIResponseCodeSuccess) {
//                NSLog(@"***********%@",response.responseObject);
                ShowAutoHideMBProgressHUD(weakSelf.view,@"评论成功");
                [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"评论失败");
            }

        }];

    }

}


-(void)delayMethod{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)Actiondo{

    [self.detailEvaluate resignFirstResponder];
}

#pragma mark ---- UITextView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.uilabel.text = @"亲！请写下对我们的评价吧！";
    }else{
        self.uilabel.text = @"";
    }
    [self.numberLabel setText:[NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length]];
    if (textView.text.length > 140) {
        [self.numberLabel setTextColor:[UIColor redColor]];
    }
    if (textView.text.length <= 140) {
        [self.numberLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //   限制苹果系统输入法  禁止输入表情
    
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
        
    }
    //禁止输入emoji表情
    if ([NSString stringContainsEmoji:text]) {
        
        return NO;
        
    }
    return YES;
    
}

@end
