//
//  FMCanaelOrderShowView.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMCanaelOrderShowView.h"
#import "XZCancelOrderCell.h"

@interface FMCanaelOrderShowView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *cancelDataArr;

@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, weak) UIView       *cover;
// 当前点击的button
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, weak) UIView * whiteView;
@end

@implementation FMCanaelOrderShowView

- (instancetype)initWithCancelDataArr:(NSArray *)cannelArray
{
    self = [super init];
    if (self) {
        
        _cancelDataArr = cannelArray;
       
        UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.cover = cover;
        [self addSubview:cover];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.3;
        // tableView
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(20, 0.26 * KProjectScreenWidth, KProjectScreenWidth - 40, 360)];
        whiteView.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        self.whiteView  = whiteView;
        
        UITableView  *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, whiteView.frame.size.width, whiteView.frame.size.height - 60 - 50) style:UITableViewStylePlain];
        [whiteView addSubview:tableView];
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor lightGrayColor];
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self createViewHeaderView];
        [self createViewFooterView];
        

    }
    return self;
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.cancelDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZCancelOrderCell *cell = [XZCancelOrderCell cellCancelOrderWithTableView:tableView];
    cell.labelCancelInfo.text = self.cancelDataArr[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    // 只有一个button能点
    cell.blockSelectedBtn = ^(UIButton *button) {
        if (self.currentBtn != button) {
            self.currentBtn.selected = !self.currentBtn.selected;
            self.currentBtn = button;
            button.selected = YES;
        }else {
            self.currentBtn.selected = !self.currentBtn.selected;
        }
        [self buttonForRow:weakCell.labelCancelInfo.text];
    };
    if (indexPath.row == 0) {
        [cell selectedBtnAction:cell.btnSelected];
    }
        return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCancelOrderCell *cell = (XZCancelOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedBtnAction:cell.btnSelected];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 50;
    
}

-(void)createViewHeaderView
{
    // 头视图
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.whiteView.frame.size.width, 60)];
    UILabel *titleLabel = [[UILabel alloc]init];
    [header addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(20);
        make.centerY.equalTo(header.mas_centerY);
    }];
    titleLabel.text = @"请选择取消订单的理由";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =  XZColor(243, 105, 67);
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    // line
    UILabel *line = [[UILabel alloc]init];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left);
        make.bottom.equalTo(header.mas_bottom);
        make.height.equalTo(@2);
        make.width.equalTo(header.mas_width);
    }];
    line.backgroundColor =  XZColor(243, 105, 67);
    [self.whiteView addSubview:header];
}

-(void)createViewFooterView
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.whiteView.frame.size.height - 50, self.whiteView.frame.size.width, 50)];
    // line
    UILabel *lineTop = [[UILabel alloc]init];
    [footer addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left);
        make.top.equalTo(footer.mas_top);
        make.height.equalTo(@0.5);
        make.width.equalTo(footer.mas_width);
    }];
    lineTop.backgroundColor = [UIColor lightGrayColor];
    // 取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [footer addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left);
        make.top.equalTo(footer.mas_top).offset(0.5);
        make.height.equalTo(@49.5);
        make.right.equalTo(footer.mas_centerX).offset(-0.5);
    }];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:XZColor(29, 30, 31) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCabcelBtn:) forControlEvents:UIControlEventTouchUpInside];
    // line
    UILabel *line = [[UILabel alloc]init];
    [footer addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right);
        make.top.equalTo(cancelBtn.mas_top);
        make.height.equalTo(@50);
        make.width.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    // 确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [footer addSubview:sureBtn];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footer.mas_right);
        make.top.equalTo(footer.mas_top).offset(0.5);
        make.height.equalTo(@49.5);
        make.left.equalTo(footer.mas_centerX);
    }];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:XZColor(29, 30, 31) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whiteView addSubview:footer];
}


// 获取到用户取消订单的理由
-(void)buttonForRow:(NSString *)cancelInfo {
    Log(@"%@",cancelInfo);
    
}
// 点击确定按钮
- (void)didClickSureBtn:(UIButton *)button {
    if (self.blockSureBtn) {
        self.blockSureBtn(button);
    }
    [self hiddenSelfView];
}
// 点击取消按钮
- (void)didClickCabcelBtn:(UIButton *)button {
    [self hiddenSelfView];
}
-(void)showSelfView
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
}

-(void)hiddenSelfView
{
    [self.tableView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
