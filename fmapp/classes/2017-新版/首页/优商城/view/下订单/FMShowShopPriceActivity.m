//
//  FMShowShopPriceActivity.m
//  fmapp
//
//  Created by runzhiqiu on 16/7/18.
//  Copyright © 2016年 yk. All rights reserved.
//
#define WhiteViewHeighRadio 0.45

#import "FMShowShopPriceActivity.h"

@interface FMShowShopPriceActivity ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * whiteView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FMShowShopPriceActivity
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [keyWindow addSubview:self];
        
        [keyWindow bringSubviewToFront:self];
        
        [self createUItableView];
        
    }
    return self;
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
   
    self.whiteView.frame = CGRectMake(15, KProjectScreenHeight *  (1 - WhiteViewHeighRadio) * 0.5, KProjectScreenWidth - 30, KProjectScreenHeight * WhiteViewHeighRadio);
    
}

-(void)closeButtonOnClick
{
    [self hiddenSelectView];
}

-(void)hiddenSelectView;
{
    
    [self removeFromSuperview];
    
}
-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * flagPriceTableCell = @"flagPriceTableCellTegister";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:flagPriceTableCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:flagPriceTableCell];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    return cell;
}

-(void)changeActivityViewTitle:(NSString *)title andCloseTitle:(NSString *)closeTitle;
{
    self.titleLabel.text = title;
    [self.closeButton setTitle:closeTitle forState:UIControlStateNormal];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UIButton *)closeButton
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
-(UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, KProjectScreenWidth, KProjectScreenHeight * WhiteViewHeighRadio)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"会员价格";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    }
    return _titleLabel;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        
    }
    return _tableView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
