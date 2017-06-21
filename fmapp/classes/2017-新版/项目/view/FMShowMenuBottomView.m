//
//  FMShowMenuBottomView.m
//  fmapp
//
//  Created by runzhiqiu on 2017/5/9.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMShowMenuBottomView.h"

@interface FMShowMenuBottomView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton * backGroundView;

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation FMShowMenuBottomView

-(UIButton *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIButton    alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [_backGroundView addTarget:self action:@selector(backGroundViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.2]];
        [self addSubview:_backGroundView];
        
    }
    return _backGroundView;
}

-(void)backGroundViewButtonOnClick:(UIButton *)button
{
    [self menuViewHidden];
}

-(void)menuViewHidden;
{
    self.hidden = YES;
    if (self.closeBlock) {
        self.closeBlock();
    }
    
}
-(void)menuViewShow;
{
    self.hidden = NO;
}

-(instancetype)initWithFrameContent:(CGRect)frame WithMenuArray:(NSArray *)menuArray
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, KProjectScreenHeight)];
    if (self) {
        [self backGroundView];
        self.menuArray = menuArray;
        
        [self addSubview:self.tableView];
    }
    return self;

}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.menuArray.count * KDefaultMenuHeigh)];
        _tableView.tintColor = [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        

    }
    return _tableView;
}



#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.currentSelect = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 3点击没有颜色改变
    cell.selected = NO;
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
    
}

-(void)selectMenuIndex:(NSInteger )selectIndex;
{
    self.currentSelect = selectIndex;
    [self.tableView reloadData];
    
    
}
#pragma mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KDefaultMenuHeigh;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMenuRegister"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellMenuRegister"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.text = self.menuArray[indexPath.row];
    
    if (cell.textLabel.text == self.menuArray[self.currentSelect]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.textLabel setTextColor:[tableView tintColor]];
    }
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
