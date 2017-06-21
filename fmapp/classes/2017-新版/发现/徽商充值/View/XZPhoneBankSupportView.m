//
//  XZPhoneBankSupportView.m
//  fmapp
//
//  Created by admin on 2017/5/17.
//  Copyright © 2017年 yk. All rights reserved.
//  支持的手机银行

#import "XZPhoneBankSupportView.h"
#import "XZPhoneBankSupportCell.h"
#import "XZPhoneBankSupportModel.h"

@interface XZPhoneBankSupportView ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UIView *blackBg;
//
@property (nonatomic, strong) UIView *whiteBg;
//
@property (nonatomic, strong) UIWindow *window;
// 关闭按钮
@property (nonatomic, strong) UIButton *btnClosed;
//
@property (nonatomic, strong) UITableView *tableBankList;
//// 银行数据
//@property (nonatomic, strong) NSMutableArray *bankArr;

@end

@implementation XZPhoneBankSupportView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpPhoneBankSupportView];
//        [self setUpPhoneBankData];
    }
    return self;
}

- (void)setUpPhoneBankSupportView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.window = window;
    
    UIView *blackBg = [[UIView alloc] init];
    [window addSubview:blackBg];
    [blackBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    blackBg.backgroundColor = [UIColor blackColor];
    blackBg.alpha = 0.3;
    self.blackBg = blackBg;
    
    //
    UIView *whiteBg = [[UIView alloc] init];
    [window addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).offset(30);
        make.right.equalTo(window).offset(-30);
        make.centerY.equalTo(window);
        make.height.equalTo(KProjectScreenWidth);
    }];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.masksToBounds = YES;
    whiteBg.layer.cornerRadius = 5.0f;
    self.whiteBg = whiteBg;
    
    // 手机银行
    UILabel *lablePhoneBank = [[UILabel alloc] init];
    [whiteBg addSubview:lablePhoneBank];
    [lablePhoneBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteBg);
        make.top.equalTo(whiteBg).offset(20);
    }];
    lablePhoneBank.text = @"手机银行";
    lablePhoneBank.textColor = [HXColor colorWithHexString:@"0159d5"];
    
    // 左边线
    UILabel *lineLeft = [[UILabel alloc] init];
    [whiteBg addSubview:lineLeft];
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(10);
        make.centerY.equalTo(lablePhoneBank);
        make.right.equalTo(lablePhoneBank.mas_left).offset(-10);
        make.height.equalTo(@1);
    }];
    lineLeft.backgroundColor = [HXColor colorWithHexString:@"0159d5"];
    
    // 右边线
    UILabel *lineRight = [[UILabel alloc] init];
    [whiteBg addSubview:lineRight];
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteBg).offset(-10);
        make.centerY.equalTo(lablePhoneBank);
        make.left.equalTo(lablePhoneBank.mas_right).offset(10);
        make.height.equalTo(@1);
    }];
    lineRight.backgroundColor = [HXColor colorWithHexString:@"0159d5"];
    
    // 银行列表
    [whiteBg addSubview:self.tableBankList];
    [self.tableBankList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(20);
        make.right.equalTo(whiteBg).offset(-20);
        make.top.equalTo(lablePhoneBank.mas_bottom).offset(10);
        make.bottom.equalTo(whiteBg).offset(-30);
    }];
    
    // 关闭按钮
    UIButton *btnClosed = [UIButton buttonWithType:UIButtonTypeCustom];
    [window addSubview:btnClosed];
    [btnClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg.mas_bottom).offset(30);
        make.centerX.equalTo(window.mas_centerX);
        make.height.and.width.equalTo(50);
    }];
    [btnClosed setImage:[UIImage imageNamed:@"微商_弹窗_关闭"] forState:UIControlStateNormal];
    [btnClosed addTarget:self action:@selector(didClickClosedButton) forControlEvents:UIControlEventTouchUpInside];
    self.btnClosed = btnClosed;
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrBank.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPhoneBankSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneBankSupportCell"];
    if (!cell) {
        cell = [[XZPhoneBankSupportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhoneBankSupportCell"];
    }
    
    XZPhoneBankSupportModel *modelBank = self.arrBank[indexPath.row];
    cell.modelBank = modelBank;
    
    cell.blockBankButton = ^(UIButton *button) {
        NSURL *url;
        if (button.tag == 510) { // 左边
            if (modelBank.lianjie1.length > 0) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/",modelBank.lianjie1]];
                // 调起app
                if (![[UIApplication sharedApplication] openURL:url]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"需安装%@手机银行才能完成此操作",modelBank.name1] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }else { // 右边
            if (modelBank.lianjie2.length > 0) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/",modelBank.lianjie2]];
                // 调起app
                if (![[UIApplication sharedApplication] openURL:url]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"需安装%@手机银行才能完成此操作",modelBank.name2] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
        
//        [self didClickClosedButton];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

// 点击关闭按钮
- (void)didClickClosedButton {
    [self.blackBg removeFromSuperview];
    [self.whiteBg removeFromSuperview];
    [self.btnClosed removeFromSuperview];
    [self removeFromSuperview];
    if (self.blockClosed) {
        self.blockClosed();
    }
}

- (UITableView *)tableBankList {
    if (!_tableBankList) {
        _tableBankList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableBankList.delegate = self;
        _tableBankList.dataSource  = self;
        _tableBankList.backgroundColor = [UIColor whiteColor];
        _tableBankList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableBankList.showsVerticalScrollIndicator = NO;
    }
    return _tableBankList;
}

//- (NSMutableArray *)bankArr {
//    if (!_bankArr) {
//        _bankArr = [NSMutableArray array];
//    }
//    return _bankArr;
//}

- (void)setArrBank:(NSMutableArray *)arrBank {
    _arrBank = arrBank;
    [self.tableBankList reloadData];
}

//- (void)setUpPhoneBankData {    
//    __weak __typeof(&*self)weakSelf = self;
//    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/yinhangappios" parameters:nil completion:^(WebAPIResponse *response) {
//        
//        if (!response.responseObject) {
//            ShowAutoHideMBProgressHUD(weakSelf, @"请求数据失败!");
//        }
//        else {
//            if (response.code == WebAPIResponseCodeSuccess) {
//                
//                NSArray *dataArr = response.responseObject[@"data"];
//                if (dataArr.count > 0) {
//                    for (NSDictionary *dict in dataArr) {
//                        XZPhoneBankSupportModel *modelPhone = [[XZPhoneBankSupportModel alloc] init];
//                        [modelPhone setValuesForKeysWithDictionary:dict];
//                        [self.bankArr addObject:modelPhone];
//                    }
//                }
//            }
//        }
//    [self.tableBankList reloadData];
//    }];
//}
@end
