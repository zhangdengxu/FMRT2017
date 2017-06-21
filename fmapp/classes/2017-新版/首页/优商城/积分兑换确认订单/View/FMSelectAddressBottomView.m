//
//  FMSelectAddressBottomView.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/27.
//  Copyright © 2016年 yk. All rights reserved.
//  配送方式

#define WhiteViewHeighRadio 0.55

#import "FMSelectAddressBottomView.h"
#import "XZDistributionCell.h"
#import "XZConfirmOrderModel.h"
#import "XZShoppingOrderAddressModel.h"

@interface FMSelectAddressBottomView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
// 当前页面选中的model
@property (nonatomic, strong) XZConfirmOrderModel *modelConfirm;
@end

@implementation FMSelectAddressBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUItableView];
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)setArrDistribution:(NSMutableArray *)arrDistribution {
    _arrDistribution = arrDistribution;
    self.dataSource = arrDistribution;
    [self.tableView reloadData];
    
    XZConfirmOrderModel *model;
    for (int i = 0; i < self.arrDistribution.count;i++) {
        model = self.arrDistribution[i];
        if ([model.isdefault integerValue] == 1) { // 如果有默认的申通
            self.modelConfirm = model;
//            NSLog(@"当前选中的model-========%@----%d",self.modelConfirm.dt_name,i);
            return;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZDistributionCell * cell = [XZDistributionCell cellDistributionWithTableView:tableView];
     XZConfirmOrderModel *modelConfirm = self.dataSource[indexPath.row];
    cell.modelConfirm = modelConfirm;
    __weak __typeof(&*self)weakSelf = self;
    cell.blockDistributionBtn = ^(UIButton *button){
        modelConfirm.isSelectedCell = YES;
        for (XZConfirmOrderModel *model in self.dataSource) {
            if (![model.dt_name isEqualToString:modelConfirm.dt_name]) {
                model.isSelectedCell = NO;
            }
        }
        [weakSelf.tableView reloadData];
        weakSelf.modelConfirm = modelConfirm;
    };
    return cell;
}

- (void)changeActivityViewTitle:(NSString *)title andCloseTitle:(NSString *)closeTitle;
{
    self.titleLabel.text = title;
    [self.closeButton setTitle:closeTitle forState:UIControlStateNormal];
}

-(void)createUItableView
{
    self.backgroundColor = [UIColor colorWithHexString:@"1e1e1e" alpha:0.6];
    
    [self addSubview: self.whiteView];
    CGFloat titleHeigh = 50;
    if (KProjectScreenWidth == 320) {
        titleHeigh = 35;
    }
    
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_top).offset(8);
        make.height.equalTo(titleHeigh);
        make.centerX.equalTo(self.whiteView.mas_centerX);
    }];
    
    UIView * lineViewTop = [[UIView alloc]init];
    lineViewTop.backgroundColor = [UIColor lightGrayColor];
    [self.whiteView addSubview:lineViewTop];
    [lineViewTop makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.whiteView.mas_left).offset(10);
        make.right.equalTo(self.whiteView.mas_right).offset(-10);
        make.height.equalTo(@0.5);
    }];
    
    
    [self.whiteView addSubview:self.closeButton];
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(10);
        make.right.equalTo(self.whiteView.mas_right).offset(-10);
        make.bottom.equalTo(self.whiteView.mas_bottom);
        make.height.equalTo(titleHeigh);
        
    }];
    
    UIView * lineViewBottom = [[UIView alloc]init];
    lineViewBottom.backgroundColor = [UIColor lightGrayColor];
    [self.whiteView addSubview:lineViewBottom];
    [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.closeButton.mas_top).offset(-5);
        make.left.equalTo(self.whiteView.mas_left).offset(10);
        make.right.equalTo(self.whiteView.mas_right).offset(-10);
        make.height.equalTo(@0.5);
    }];
    
    [self.whiteView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewTop.mas_bottom).offset(5);
        make.left.equalTo(self.whiteView.mas_left).offset(10);
        make.right.equalTo(self.whiteView.mas_right).offset(-10);
        make.bottom.equalTo(lineViewBottom.mas_top).offset(-5);
        
    }];
    
}

-(void)showActivity;
{
    self.whiteView.frame = CGRectMake(0, KProjectScreenHeight, KProjectScreenWidth, KProjectScreenHeight * WhiteViewHeighRadio);
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteView.frame = CGRectMake(0, KProjectScreenHeight * (1 - WhiteViewHeighRadio), KProjectScreenWidth, KProjectScreenHeight * WhiteViewHeighRadio);
    }];
    
}

// 点击关闭按钮
-(void)closeButtonOnClick
{
    [self hiddenSelectView];
    for (XZConfirmOrderModel *model in self.dataSource) {
        if (model.isSelectedCell == YES) {
            self.modelConfirm = model;
        }
    }
    if (self.blockDidClickClosed) {
        self.blockDidClickClosed(self.modelConfirm);
    }
}

-(void)hiddenSelectView;
{
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteView.frame = CGRectMake(0, KProjectScreenHeight, KProjectScreenWidth, KProjectScreenHeight * WhiteViewHeighRadio);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeButton addTarget:self action:@selector(closeButtonOnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, KProjectScreenWidth, KProjectScreenHeight * WhiteViewHeighRadio)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"请选择配送方式";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

@end
