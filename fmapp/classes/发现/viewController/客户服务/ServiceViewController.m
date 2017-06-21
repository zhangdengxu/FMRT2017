//
//  ServiceViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 15/12/28.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "ServiceViewController.h"
#import "WeiViewController.h"
//#import "TnesViewController.h"
#import "ShareViewController.h"
@interface ServiceViewController ()<UIScrollViewDelegate>
{
    
    UIScrollView *mainScrollView;
}
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"客户服务"];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];

    [self creatContentView];
}

-(void)creatContentView{

    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 700);
    
    [self.view addSubview:mainScrollView];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, KProjectScreenHeight/3.0f)];
    view.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:view];
//    创建头像图片
    NSArray *imgArr = [NSArray arrayWithObjects:@"微信客服_03.png",@"@融托金融_03.png",@"客户交流qq群_03.png",@"客户邮箱_03.png", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信客服:rongtuojinrong001",@"@融托金融",@"客户交流QQ群：188154837",@"客服邮箱：service@rongtuojinrong.com", nil];
    
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:(1000+i)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(helpingClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(15, 20+KProjectScreenHeight/12*i, KProjectScreenWidth-10, KProjectScreenHeight/12)];
        [mainScrollView addSubview:button];

        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, KProjectScreenHeight/12-26, KProjectScreenHeight/12-26)];
        [imgV setImage:[UIImage imageNamed:imgArr[i]]];
        [button addSubview:imgV];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenHeight/12-18, 0, KProjectScreenWidth-50, KProjectScreenHeight/12)];
        label.backgroundColor=[UIColor clearColor];
        label.text = titleArr[i];
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.8];
        
        label.font=[UIFont systemFontOfSize:16.0f];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight/12-0.5, KProjectScreenWidth-20, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
        [button addSubview:lineView];
        
        [button addSubview:label];
        if (i <= 2) {
            UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-40, (KProjectScreenHeight/12-14)/2, 10, 14)];
            arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
            [button addSubview:arrowImage];
        }
 
    }
    
    UIButton *teleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teleBtn setBackgroundImage:[UIImage imageNamed:@"客户电话_03.png"] forState:UIControlStateNormal];
    teleBtn.enabled = YES;
    [teleBtn addTarget:self action:@selector(delTelepjone) forControlEvents:UIControlEventTouchUpInside];
    [teleBtn setFrame:CGRectMake(40, 20+KProjectScreenHeight/3+40, KProjectScreenWidth-80, (KProjectScreenWidth-80)/3)];
    [mainScrollView addSubview:teleBtn];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setFrame:CGRectMake(0, KProjectScreenHeight-49-64, KProjectScreenWidth, 49)];
    [bottomButton addTarget:self action:@selector(delTelepjone) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 49)];
    label.text = @"拨打客服电话";
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [bottomButton addSubview:label];
    [mainScrollView addSubview:bottomButton];
    
}

-(void)helpingClick:(UIButton *)button{
    // 添加赋值的内容
    BOOL(^blockPasteBoard)(NSString *) = ^BOOL(NSString *pasteStr) {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        
        [pab setString:pasteStr];
        
        if (pab == nil) {
            return NO;
        }else
        {
            return YES;
        }
    };

    if (button.tag == 1000) {
        if (blockPasteBoard(@"rongtuojinrong001")) {
          
            WeiViewController *weVC = [[WeiViewController alloc]init];
            weVC.hidesBottomBarWhenPushed = YES;
            weVC.navTitle = @"微信客服";
            weVC.imgName = @"微信客服内容页_02.png";
            [self.navigationController pushViewController:weVC animated:YES];
        }
    }
    if (button.tag == 1001) {
        // 当前系统版本是8.0以上
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
            NSString *url = [NSString stringWithFormat:@"http://weibo.com/rongtuojinrong"];
            // @融托金融
            ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"@融托金融" AndWithShareUrl:url];
            shareVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shareVC animated:YES];

        }else { // 当前系统版本小于8.0
            if (blockPasteBoard(@"融托金融")) {
                WeiViewController *weVC = [[WeiViewController alloc]init];
                weVC.navTitle = @"@融托金融";
                weVC.imgName = @"新浪微博内容页_02.jpg";
                weVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:weVC animated:YES];
            }
        }
    }
    if (button.tag == 1002) {
        
        if (blockPasteBoard(@"188154837")) {
            WeiViewController *weVC = [[WeiViewController alloc]init];
            weVC.hidesBottomBarWhenPushed = YES;
            weVC.navTitle = @"QQ交流群";
            weVC.imgName = @"QQ交流群内容页_02.png";
            [self.navigationController pushViewController:weVC animated:YES];
        }
    }
}


-(void)delTelepjone{

    NSString *number = @"4008788686";
//     NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    
}

@end
